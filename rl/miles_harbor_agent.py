"""Official Miles custom-agent and reward hooks for the V3 Harbor service.

This module deliberately has no :mod:`miles` import.  Miles loads ``run`` via
``--custom-agent-function-path`` and ``reward_func`` via ``--custom-rm-path``;
both functions use only the documented, duck-typed plugin contracts.

All policy-model requests still go through the session-scoped ``base_url``
provided by Miles.  Consequently Miles' session server remains the sole owner
of TITO token IDs, masks, and rollout log probabilities.
"""

from __future__ import annotations

import asyncio
import hashlib
import logging
import os
from collections.abc import Mapping
from typing import Any
from urllib.parse import urlsplit, urlunsplit

import httpx

logger = logging.getLogger(__name__)

_ACTIVE_INSTANCE_IDS: set[str] = set()


class InfrastructureError(RuntimeError):
    """A rollout failed outside the policy/verifier reward contract."""


def _session_api_base(base_url: str) -> str:
    """Return the OpenAI-compatible ``.../v1`` URL for a Miles session."""
    base_url = base_url.rstrip("/")
    if not base_url:
        raise ValueError("Miles supplied an empty session base_url")
    if not base_url.endswith("/v1"):
        base_url += "/v1"

    external_host = os.getenv("MILES_ROUTER_EXTERNAL_HOST", "").strip()
    if not external_host:
        return base_url

    parsed_external = urlsplit(
        external_host if "://" in external_host else f"//{external_host}"
    )
    external_netloc = parsed_external.netloc or parsed_external.path
    if ":" not in external_netloc and urlsplit(base_url).port is not None:
        external_netloc = f"{external_netloc}:{urlsplit(base_url).port}"

    parsed = urlsplit(base_url)
    return urlunsplit((parsed.scheme, external_netloc, parsed.path, "", ""))


def build_run_request(
    *,
    base_url: str,
    prompt: Any,
    request_kwargs: Mapping[str, Any] | None,
    metadata: Mapping[str, Any] | None,
) -> dict[str, Any]:
    """Build the narrow request accepted by :mod:`rl.miles_harbor_server`.

    Dataset metadata is intentionally allowlisted instead of copied wholesale;
    task contents and all E2B deployment settings stay server-side.
    """
    metadata = metadata or {}
    task_name = metadata.get("task_name")
    if not isinstance(task_name, str) or not task_name.strip():
        raise ValueError("sample metadata must contain a non-empty task_name")
    if isinstance(prompt, str):
        instruction = prompt
    elif (
        isinstance(prompt, list)
        and len(prompt) == 1
        and isinstance(prompt[0], Mapping)
        and prompt[0].get("role") == "user"
        and isinstance(prompt[0].get("content"), str)
    ):
        instruction = prompt[0]["content"]
    else:
        raise ValueError("prompt must be a string or one user-message list")

    request: dict[str, Any] = {
        "task_name": task_name,
        "instruction_sha256": hashlib.sha256(instruction.encode("utf-8")).hexdigest(),
        "base_url": _session_api_base(base_url),
        "model": os.getenv(
            "CODEPROVER_MILES_MODEL_NAME",
            os.getenv("AGENT_MODEL_NAME", "model"),
        ),
        "sampling_params": dict(request_kwargs or {}),
    }
    for key in (
        "max_seq_len",
        "session_server_id",
        "session_server_instance_id",
    ):
        value = metadata.get(key)
        if value is not None:
            request[key] = value
    return request


def _infra_metadata(kind: str, message: str) -> dict[str, Any]:
    return {
        "exit_status": "infra_error",
        "infra_error": {
            "type": kind,
            "message": message[:1000],
        },
    }


async def _post_json(url: str, payload: dict[str, Any]) -> dict[str, Any]:
    timeout = float(os.getenv("CODEPROVER_AGENT_HTTP_TIMEOUT_SEC", "7200"))
    headers: dict[str, str] = {}
    admin_secret = os.getenv(
        "CODEPROVER_HARBOR_ADMIN_SECRET", os.getenv("HARBOR_ADMIN_SECRET", "")
    )
    if admin_secret:
        headers["Authorization"] = f"Bearer {admin_secret}"

    async with httpx.AsyncClient(timeout=timeout) as client:
        response = await client.post(url, json=payload, headers=headers)
        response.raise_for_status()
        data = response.json()
    if not isinstance(data, dict):
        raise TypeError("Harbor server returned a non-object JSON response")
    return data


async def run(
    base_url: str,
    prompt: Any,
    request_kwargs: dict[str, Any] | None = None,
    metadata: dict[str, Any] | None = None,
    **kwargs: Any,
) -> dict[str, Any]:
    """Run one CodeProver task through the external V3 Harbor service.

    The prompt content is not sent: only its SHA-256 is used to prove it is the
    same canonical instruction as the safely resolved Harbor task directory.
    """
    del kwargs
    try:
        request = build_run_request(
            base_url=base_url,
            prompt=prompt,
            request_kwargs=request_kwargs,
            metadata=metadata,
        )
    except Exception as exc:  # malformed data is not a reward-zero episode
        return _infra_metadata(type(exc).__name__, str(exc))

    instance_id = request.get("session_server_instance_id")
    if isinstance(instance_id, str) and instance_id:
        _ACTIVE_INSTANCE_IDS.add(instance_id)

    server_url = os.getenv(
        "CODEPROVER_AGENT_SERVER_URL",
        os.getenv("AGENT_SERVER_URL", "http://127.0.0.1:11000"),
    ).rstrip("/")
    try:
        response = await _post_json(f"{server_url}/run", request)
    except asyncio.CancelledError:
        # Do not defeat Miles' cancellation semantics.  Ask Harbor to release
        # the E2B sandbox first, then propagate cancellation to the generator.
        if isinstance(instance_id, str) and instance_id:
            try:
                await asyncio.wait_for(
                    _post_json(
                        f"{server_url}/flush",
                        {"session_server_instance_ids": [instance_id]},
                    ),
                    timeout=10,
                )
            except BaseException:  # best-effort cleanup while already cancelling
                logger.warning("Failed to flush cancelled V3 Harbor trial", exc_info=True)
        raise
    except Exception as exc:  # network/server faults must never become reward 0
        logger.exception("V3 Harbor rollout request failed for %s", request["task_name"])
        return _infra_metadata(type(exc).__name__, str(exc))
    finally:
        if isinstance(instance_id, str):
            _ACTIVE_INSTANCE_IDS.discard(instance_id)

    result: dict[str, Any] = {
        "exit_status": response.get("exit_status", ""),
        "eval_report": response.get("eval_report", {}),
        "agent_metrics": response.get("agent_metrics", {}),
    }
    if "reward" in response:
        result["reward"] = response["reward"]
    if response.get("infra_error") is not None:
        result["infra_error"] = response["infra_error"]
    if "reward" not in result and "infra_error" not in result:
        result.update(_infra_metadata("MissingReward", "Harbor response omitted reward"))
    return result


def _sample_reward(sample: Any) -> float:
    metadata = getattr(sample, "metadata", None)
    if not isinstance(metadata, Mapping):
        raise InfrastructureError("sample metadata is missing or is not a mapping")
    if metadata.get("infra_error") is not None:
        raise InfrastructureError(f"rollout infrastructure error: {metadata['infra_error']!r}")
    if "reward" not in metadata:
        raise InfrastructureError("successful rollout metadata omitted reward")
    try:
        return float(metadata["reward"])
    except (TypeError, ValueError) as exc:
        raise InfrastructureError(
            f"rollout reward is not numeric: {metadata['reward']!r}"
        ) from exc


def _mark_sample_aborted(sample: Any, error: InfrastructureError) -> float:
    """Expose an infrastructure failure to Miles' group filter.

    Miles drops a generation task whose group reward hook raises, then asks the
    data source for a replacement. For a persistent E2B outage that becomes an
    unbounded, billable retry loop. Returning a placeholder reward only after
    marking the sample aborted lets reward dispatch finish; the required
    ``fail_on_infrastructure`` filter below then terminates the rollout before
    this sample can reach training.
    """
    metadata = getattr(sample, "metadata", None)
    if isinstance(metadata, dict) and metadata.get("infra_error") is None:
        metadata["infra_error"] = {
            "type": type(error).__name__,
            "message": str(error)[:1000],
        }

    status_enum = getattr(type(sample), "Status", None)
    aborted = getattr(status_enum, "ABORTED", None)
    if aborted is not None:
        sample.status = aborted
    logger.error("Rejecting V3 Harbor rollout as infrastructure failure: %s", error)
    return 0.0


async def reward_func(
    args: Any,
    samples: Any | list[Any],
    **kwargs: Any,
) -> float | list[float]:
    """Read verifier rewards and mark infrastructure faults for filtering."""
    del args, kwargs
    if isinstance(samples, list):
        rewards: list[float] = []
        for sample in samples:
            try:
                rewards.append(_sample_reward(sample))
            except InfrastructureError as exc:
                rewards.append(_mark_sample_aborted(sample, exc))
        return rewards
    try:
        return _sample_reward(samples)
    except InfrastructureError as exc:
        return _mark_sample_aborted(samples, exc)


def fail_on_infrastructure(args: Any, samples: list[Any], **kwargs: Any) -> bool:
    """Fail on the first bad group instead of buying replacement episodes.

    Use this as ``--dynamic-sampling-filter-path`` and keep
    ``--over-sampling-batch-size`` equal to ``--rollout-batch-size``. A real
    verifier reward of zero remains valid. ABORTED or infra-marked samples and
    strict TITO mismatches trip the circuit; Miles' documented non-severe
    ``assistant_text`` mismatch remains diagnostic-only.
    """
    del args, kwargs

    def flatten(values: list[Any]):
        for value in values:
            if isinstance(value, list):
                yield from flatten(value)
            else:
                yield value

    failures: list[str] = []
    for sample in flatten(samples):
        metadata = getattr(sample, "metadata", None)
        if isinstance(metadata, Mapping):
            if metadata.get("infra_error") is not None:
                failures.append(repr(metadata["infra_error"]))
                continue
            # Miles classifies assistant-text drift as non-severe: assistant
            # tokens come directly from SGLang's pretokenized response and can
            # legitimately differ from a canonical chat-template re-render
            # (notably when a length-truncated response ends inside <think>).
            # Keep failing closed for every other or malformed mismatch type.
            mismatches = metadata.get("tito_session_mismatch")
            strict_mismatches = (
                [
                    mismatch
                    for mismatch in mismatches
                    if not (
                        isinstance(mismatch, Mapping)
                        and mismatch.get("type") == "assistant_text"
                    )
                ]
                if isinstance(mismatches, list)
                else mismatches
            )
            if strict_mismatches:
                failures.append(
                    f"strict tito_session_mismatch: {strict_mismatches!r}"
                )
                continue
        status = getattr(sample, "status", None)
        if getattr(status, "value", status) == "aborted":
            failures.append("sample status is aborted")
    if failures:
        raise InfrastructureError(
            "V3 Harbor infrastructure circuit opened; refusing automatic "
            f"replacement episodes: {failures[0]}"
        )
    return True


async def abort(args: Any) -> None:
    """Cancel in-flight Harbor trials during Miles oversampling teardown."""
    instance_ids = set(_ACTIVE_INSTANCE_IDS)
    arg_instance_id = getattr(args, "session_server_instance_id", None)
    if isinstance(arg_instance_id, str) and arg_instance_id:
        instance_ids.add(arg_instance_id)
    if not instance_ids:
        return

    server_url = os.getenv(
        "CODEPROVER_AGENT_SERVER_URL",
        os.getenv("AGENT_SERVER_URL", "http://127.0.0.1:11000"),
    ).rstrip("/")
    try:
        await _post_json(
            f"{server_url}/flush",
            {"session_server_instance_ids": sorted(instance_ids)},
        )
    except Exception:
        # Miles' abort hook is best-effort; local TITO/SGLang abort must proceed.
        logger.warning("Failed to flush V3 Harbor trials", exc_info=True)
