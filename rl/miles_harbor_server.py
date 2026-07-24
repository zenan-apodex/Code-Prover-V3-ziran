"""FastAPI service running V3's Harbor agent on the Aliyun SG E2B backend.

The server is deployment glue, not a second agent implementation.  Each
request is converted to a normal Harbor ``TrialConfig``.  ``Trial.create``
selects ``SingleStepTrial`` for CodeProver tasks and owns the complete E2B
lifecycle, QwenNativeAgent execution, verifier, and sandbox teardown.

No credential is accepted over HTTP or embedded here.  Aliyun E2B keys are
resolved by ``tools.aliyun_clusters.configure_env`` from the process env.
"""

from __future__ import annotations

import asyncio
import hashlib
import hmac
import os
import re
import time
import uuid
from dataclasses import dataclass
from pathlib import Path
from typing import Any
from urllib.parse import urlsplit

from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel, ConfigDict, Field

app = FastAPI(title="CodeProver V3 Miles Harbor adapter")

_ACTIVE_TRIALS: dict[str, set[asyncio.Task[Any]]] = {}
_RUN_SEMAPHORE: asyncio.Semaphore | None = None
_SAFE_NAME_RE = re.compile(r"[^A-Za-z0-9_.-]+")
_INFRA_STOP_REASONS = frozenset({"request_transport_error", "request_rejected_400"})


class RunRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    task_name: str = Field(min_length=1, max_length=500)
    instruction_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    base_url: str = Field(min_length=1, max_length=2000)
    model: str = Field(default="model", min_length=1, max_length=500)
    sampling_params: dict[str, Any] = Field(default_factory=dict)
    max_seq_len: int | None = Field(default=None, gt=0)
    session_server_id: str | None = None
    session_server_instance_id: str | None = None


class FlushRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    session_server_instance_ids: list[str] = Field(default_factory=list)


@dataclass(frozen=True)
class ServerSettings:
    tasks_dir: Path
    trials_dir: Path
    e2b_cluster: str
    e2b_template: str
    e2b_image: str
    sandbox_timeout_sec: int
    claim_timeout_sec: int
    wait_ready_timeout_sec: int
    agent_timeout_sec: float
    model_request_timeout_sec: float
    verifier_timeout_sec: float
    max_api_calls: int
    context_soft_limit_tokens: int
    save_transcript: bool
    max_concurrent: int

    @classmethod
    def from_env(cls) -> "ServerSettings":
        tasks_dir = os.getenv("CODEPROVER_TASKS_DIR")
        image = os.getenv("CODEPROVER_E2B_IMAGE")
        if not tasks_dir:
            raise RuntimeError("CODEPROVER_TASKS_DIR is required")
        if not image:
            raise RuntimeError("CODEPROVER_E2B_IMAGE is required")
        return cls(
            tasks_dir=Path(tasks_dir),
            trials_dir=Path(os.getenv("CODEPROVER_TRIALS_DIR", "jobs/miles-harbor")),
            e2b_cluster=os.getenv("CODEPROVER_E2B_CLUSTER", "sg"),
            e2b_template=os.getenv(
                "CODEPROVER_E2B_TEMPLATE", "zenan-allow-internet"
            ),
            e2b_image=image,
            sandbox_timeout_sec=int(
                os.getenv("CODEPROVER_E2B_SANDBOX_TIMEOUT_SEC", "7200")
            ),
            claim_timeout_sec=int(
                os.getenv("CODEPROVER_E2B_CLAIM_TIMEOUT_SEC", "540")
            ),
            wait_ready_timeout_sec=int(
                os.getenv("CODEPROVER_E2B_WAIT_READY_TIMEOUT_SEC", "540")
            ),
            agent_timeout_sec=float(
                os.getenv("CODEPROVER_AGENT_TIMEOUT_SEC", "5400")
            ),
            model_request_timeout_sec=float(
                os.getenv("CODEPROVER_MODEL_REQUEST_TIMEOUT_SEC", "1800")
            ),
            verifier_timeout_sec=float(
                os.getenv("CODEPROVER_VERIFIER_TIMEOUT_SEC", "1800")
            ),
            max_api_calls=int(os.getenv("CODEPROVER_AGENT_MAX_API_CALLS", "64")),
            context_soft_limit_tokens=int(
                os.getenv("CODEPROVER_CONTEXT_SOFT_LIMIT_TOKENS", "100000")
            ),
            save_transcript=os.getenv("CODEPROVER_SAVE_TRANSCRIPT", "1") != "0",
            max_concurrent=max(1, int(os.getenv("CODEPROVER_AGENT_MAX_CONCURRENT", "8"))),
        )


def resolve_task_dir(tasks_dir: Path, task_name: str) -> Path:
    """Resolve a possibly nested task name without allowing root escape."""
    if not task_name or "\x00" in task_name or Path(task_name).is_absolute():
        raise ValueError("task_name must be a non-empty relative path")
    root = tasks_dir.expanduser().resolve()
    candidate = (root / task_name).resolve()
    try:
        candidate.relative_to(root)
    except ValueError as exc:
        raise ValueError("task_name escapes CODEPROVER_TASKS_DIR") from exc
    if not candidate.is_dir():
        raise FileNotFoundError(f"Harbor task directory not found: {task_name}")
    return candidate


def _validate_session_url(base_url: str) -> str:
    parsed = urlsplit(base_url.rstrip("/"))
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        raise ValueError("base_url must be an HTTP(S) URL")
    url = base_url.rstrip("/")
    return url if url.endswith("/v1") else f"{url}/v1"


def verify_instruction_sha256(task_dir: Path, expected: str) -> None:
    instruction_path = task_dir / "instruction.md"
    if not instruction_path.is_file():
        raise FileNotFoundError(f"Harbor task is missing instruction.md: {task_dir.name}")
    actual = hashlib.sha256(instruction_path.read_bytes()).hexdigest()
    if not hmac.compare_digest(actual, expected):
        raise ValueError(
            "Miles prompt does not match the canonical Harbor instruction.md"
        )


def build_agent_kwargs(request: RunRequest, settings: ServerSettings) -> dict[str, Any]:
    """Translate official Miles sampling kwargs to QwenNativeAgent kwargs."""
    sampling = dict(request.sampling_params)
    max_tokens = int(sampling.pop("max_tokens", 24576))
    temperature = float(sampling.pop("temperature", 0.6))
    for key in ("model", "messages"):
        sampling.pop(key, None)
    return {
        "api_base": _validate_session_url(request.base_url),
        # QwenNativeAgent resolves this indirection at runtime and falls back
        # to dummy, so the persisted Harbor config never contains a secret.
        "api_key": "$CODEPROVER_MILES_API_KEY",
        "max_api_calls": settings.max_api_calls,
        "max_tokens": max_tokens,
        "temperature": temperature,
        # A full 8192-token response can exceed QwenNativeAgent's generic
        # 600-second default at single-request decode throughput.  Retrying a
        # timed-out Miles request rolls back and regenerates the same TITO
        # turn, wasting both GPU time and the external E2B lease.
        "request_timeout": settings.model_request_timeout_sec,
        "context_soft_limit_tokens": min(
            settings.context_soft_limit_tokens,
            request.max_seq_len or settings.context_soft_limit_tokens,
        ),
        # Context reset breaks the append-only history required for TITO merge.
        "enable_compaction": False,
        # A length-truncated completion has no terminal <|im_end|>.  Appending
        # another role after it would create a structurally invalid TITO
        # sequence, so the Miles path ends that trajectory immediately.
        "stop_on_length": True,
        "save_transcript": settings.save_transcript,
        "extra_request_fields": sampling,
    }


def build_environment_kwargs(settings: ServerSettings) -> dict[str, Any]:
    return {
        "generic_template": settings.e2b_template,
        "aliyun_cluster": settings.e2b_cluster,
        "aliyun_image": settings.e2b_image,
        "sandbox_timeout_sec": settings.sandbox_timeout_sec,
        "claim_timeout_sec": settings.claim_timeout_sec,
        "wait_ready_timeout_sec": settings.wait_ready_timeout_sec,
    }


def _safe_exception(kind: str, message: str) -> dict[str, str]:
    return {"type": kind, "message": message[:1000]}


def _result_payload(result: Any, elapsed: float) -> dict[str, Any]:
    exception = getattr(result, "exception_info", None)
    if exception is not None:
        return {
            "exit_status": "infra_error",
            "infra_error": _safe_exception(
                getattr(exception, "exception_type", type(exception).__name__),
                getattr(exception, "exception_message", str(exception)),
            ),
            "agent_metrics": {"total_time": elapsed},
        }

    verifier_result = getattr(result, "verifier_result", None)
    rewards = getattr(verifier_result, "rewards", None)
    if not isinstance(rewards, dict) or "reward" not in rewards:
        return {
            "exit_status": "infra_error",
            "infra_error": _safe_exception(
                "MissingVerifierReward", "Harbor verifier did not produce rewards.reward"
            ),
            "agent_metrics": {"total_time": elapsed},
        }

    agent_context = getattr(result, "agent_result", None)
    context_metadata = getattr(agent_context, "metadata", None) or {}
    stop_reason = context_metadata.get("stop_reason")
    if stop_reason in _INFRA_STOP_REASONS:
        return {
            "exit_status": "infra_error",
            "infra_error": _safe_exception(
                "ModelTransportError", f"QwenNativeAgent stopped: {stop_reason}"
            ),
            "agent_metrics": {"total_time": elapsed, **context_metadata},
        }

    metrics: dict[str, Any] = {
        "total_time": elapsed,
        "n_input_tokens": getattr(agent_context, "n_input_tokens", None),
        "n_output_tokens": getattr(agent_context, "n_output_tokens", None),
        **context_metadata,
    }
    metrics = {key: value for key, value in metrics.items() if value is not None}
    return {
        "reward": float(rewards["reward"]),
        "exit_status": "completed",
        "eval_report": rewards,
        "agent_metrics": metrics,
    }


async def run_harbor_trial(
    request: RunRequest, settings: ServerSettings | None = None
) -> dict[str, Any]:
    settings = settings or ServerSettings.from_env()
    task_dir = resolve_task_dir(settings.tasks_dir, request.task_name)
    verify_instruction_sha256(task_dir, request.instruction_sha256)

    # Imports remain local so path-safety and request-contract tests do not
    # require Harbor/E2B, and importing this ASGI app never creates a sandbox.
    from harbor.models.trial.config import (
        AgentConfig,
        EnvironmentConfig,
        TaskConfig,
        TrialConfig,
        VerifierConfig,
    )
    from harbor.trial.trial import Trial

    task_label = _SAFE_NAME_RE.sub("-", request.task_name).strip("-.")[-32:]
    trial_name = f"miles-{task_label or 'task'}-{uuid.uuid4().hex[:10]}"
    config = TrialConfig(
        task=TaskConfig(path=task_dir),
        trial_name=trial_name,
        trials_dir=settings.trials_dir,
        agent=AgentConfig(
            import_path="rl.miles_qwen_session_agent:MilesSessionQwenNativeAgent",
            model_name=request.model,
            override_timeout_sec=settings.agent_timeout_sec,
            kwargs=build_agent_kwargs(request, settings),
        ),
        environment=EnvironmentConfig(
            import_path="tools.e2b_env:ACRE2BEnvironment",
            delete=True,
            kwargs=build_environment_kwargs(settings),
        ),
        verifier=VerifierConfig(override_timeout_sec=settings.verifier_timeout_sec),
    )

    started = time.monotonic()
    trial = await Trial.create(config)
    # CodeProver task directories are single-step; assert the contract so a
    # dataset drift cannot silently select a different training lifecycle.
    from harbor.trial.single_step import SingleStepTrial

    if not isinstance(trial, SingleStepTrial):
        raise TypeError(f"CodeProver task is not single-step: {request.task_name}")
    result = await trial.run()
    return _result_payload(result, time.monotonic() - started)


def _register(instance_id: str | None, task: asyncio.Task[Any]) -> None:
    if instance_id:
        _ACTIVE_TRIALS.setdefault(instance_id, set()).add(task)


def _unregister(instance_id: str | None, task: asyncio.Task[Any]) -> None:
    if not instance_id:
        return
    tasks = _ACTIVE_TRIALS.get(instance_id)
    if tasks is None:
        return
    tasks.discard(task)
    if not tasks:
        _ACTIVE_TRIALS.pop(instance_id, None)


def _check_admin(authorization: str | None) -> None:
    secret = os.getenv(
        "CODEPROVER_HARBOR_ADMIN_SECRET", os.getenv("HARBOR_ADMIN_SECRET", "")
    )
    if not secret:
        return
    expected = f"Bearer {secret}"
    if authorization is None or not hmac.compare_digest(authorization, expected):
        raise HTTPException(status_code=403, detail="invalid admin authorization")


@app.get("/health")
async def health() -> dict[str, Any]:
    return {
        "status": "ok",
        "active_trials": sum(len(tasks) for tasks in _ACTIVE_TRIALS.values()),
    }


@app.post("/run")
async def run_endpoint(
    request: RunRequest,
    authorization: str | None = Header(default=None),
) -> dict[str, Any]:
    global _RUN_SEMAPHORE
    _check_admin(authorization)
    current = asyncio.current_task()
    assert current is not None
    _register(request.session_server_instance_id, current)
    try:
        settings = ServerSettings.from_env()
        if _RUN_SEMAPHORE is None:
            _RUN_SEMAPHORE = asyncio.Semaphore(settings.max_concurrent)
        async with _RUN_SEMAPHORE:
            return await run_harbor_trial(request, settings)
    except asyncio.CancelledError:
        raise
    except Exception as exc:
        return {
            "exit_status": "infra_error",
            "infra_error": _safe_exception(type(exc).__name__, str(exc)),
            "agent_metrics": {},
        }
    finally:
        _unregister(request.session_server_instance_id, current)


@app.post("/flush")
async def flush_endpoint(
    request: FlushRequest,
    authorization: str | None = Header(default=None),
) -> dict[str, int]:
    _check_admin(authorization)
    tasks = {
        task
        for instance_id in request.session_server_instance_ids
        for task in _ACTIVE_TRIALS.get(instance_id, set())
        if not task.done()
    }
    for task in tasks:
        task.cancel()
    if tasks:
        await asyncio.gather(*tasks, return_exceptions=True)
    return {"cancelled": len(tasks)}
