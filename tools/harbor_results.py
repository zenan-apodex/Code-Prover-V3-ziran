#!/usr/bin/env python3
"""Fail-closed CodeProver summaries for Harbor job directories.

The tool intentionally imports no Harbor internals.  It consumes Harbor's
persisted ``lock.json`` plan and per-trial ``result.json`` records, then joins
them to V3 task manifests.  The behavior is migrated from the observed strict
pass@k and provenance contracts in Code-Prover-V2 commits:

* a531eda76deb80c412df6c84266fad9585d9c13c
* 3b3a08b50c2ca395991ddd182161bed550694da1
* eb911977ad5817e316100192d49fcda9efede14c

Official observed pass@k is emitted only when every planned attempt is
scoreable.  Missing, infrastructure, malformed, or inconsistent attempts stay
visible and only contribute to the separately named provisional lower bound.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import os
import subprocess
import sys
import tomllib
from collections import Counter, defaultdict
from datetime import datetime
from itertools import combinations
from pathlib import Path
from typing import Any, Iterable


SCHEMA_VERSION = "code-prover-harbor-summary/v1"
TRIAL_SCHEMA_VERSION = "code-prover-harbor-trial/v1"
SUPPORTED_HARBOR_VERSIONS = frozenset({"0.20.0"})
REQUIRED_REWARDS = (
    "reward",
    "sorry_free",
    "spec_intact",
    "forbidden_free",
    "compiled",
    "axioms_ok",
)
SENSITIVE_FRAGMENTS = (
    "key",
    "token",
    "secret",
    "password",
    "auth",
    "credential",
)


class ReportError(RuntimeError):
    """A malformed or ambiguous input that cannot be summarized safely."""


def _canonical_bytes(value: object) -> bytes:
    return json.dumps(
        value,
        ensure_ascii=False,
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")


def _canonical_sha256(value: object) -> str:
    return hashlib.sha256(_canonical_bytes(value)).hexdigest()


def _sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _file_reference(path: Path) -> dict[str, Any]:
    resolved = path.resolve()
    try:
        data = resolved.read_bytes()
    except OSError:
        return {"path": str(resolved), "exists": False}
    return {
        "path": str(resolved),
        "exists": True,
        "byte_size": len(data),
        "sha256": _sha256_bytes(data),
    }


def _read_json(path: Path, inputs: list[dict[str, Any]]) -> dict[str, Any]:
    reference = _file_reference(path)
    inputs.append(reference)
    if not reference["exists"]:
        raise ReportError(f"required JSON file is missing: {path}")
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise ReportError(f"cannot parse JSON object {path}: {exc}") from exc
    if not isinstance(payload, dict):
        raise ReportError(f"JSON root must be an object: {path}")
    return payload


def _optional_json(
    path: Path,
    inputs: list[dict[str, Any]],
) -> tuple[dict[str, Any] | None, str | None]:
    reference = _file_reference(path)
    inputs.append(reference)
    if not reference["exists"]:
        return None, "missing"
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError):
        return None, "malformed"
    if not isinstance(payload, dict):
        return None, "not_object"
    return payload, None


def _source_git_state(module_file: str | os.PathLike[str] = __file__) -> dict[str, Any]:
    """Attest the checkout providing this tracked module, never the caller cwd."""
    module_path = Path(module_file).resolve()
    try:
        root_text = subprocess.run(
            ["git", "-C", str(module_path.parent), "rev-parse", "--show-toplevel"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()
        root = Path(root_text)
        subprocess.run(
            ["git", "-C", str(root), "ls-files", "--error-unmatch", str(module_path)],
            check=True,
            capture_output=True,
            text=True,
        )
        relative_module = module_path.relative_to(root)
        subprocess.run(
            [
                "git",
                "-C",
                str(root),
                "cat-file",
                "-e",
                f"HEAD:{relative_module.as_posix()}",
            ],
            check=True,
            capture_output=True,
            text=True,
        )
        commit = subprocess.run(
            ["git", "-C", str(root), "rev-parse", "HEAD"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout.strip()
        status = subprocess.run(
            [
                "git",
                "-C",
                str(root),
                "status",
                "--porcelain",
                "--untracked-files=normal",
            ],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
    except (OSError, subprocess.SubprocessError):
        return {"commit": None, "dirty": None, "root": None}
    return {"commit": commit, "dirty": bool(status.strip()), "root": str(root)}


def _issue(
    issues: list[dict[str, Any]],
    code: str,
    message: str,
    *,
    severity: str = "error",
    trial_name: str | None = None,
    task_key: str | None = None,
) -> None:
    row: dict[str, Any] = {"code": code, "severity": severity, "message": message}
    if trial_name is not None:
        row["trial_name"] = trial_name
    if task_key is not None:
        row["task_key"] = task_key
    issues.append(row)


def _redact(value: object, *, key: str = "") -> object:
    lowered = key.lower()
    if key and any(fragment in lowered for fragment in SENSITIVE_FRAGMENTS):
        return "<redacted>"
    if isinstance(value, dict):
        return {str(k): _redact(v, key=str(k)) for k, v in value.items()}
    if isinstance(value, list):
        return [_redact(item) for item in value]
    return value


def _agent_config_identity(raw: object) -> tuple[str, dict[str, Any]]:
    config = raw if isinstance(raw, dict) else {}
    normalized = {
        "name": config.get("name"),
        "import_path": config.get("import_path"),
        "model_name": config.get("model_name"),
        "skills": config.get("skills") or [],
        "resume_trajectory": bool(config.get("resume_trajectory", False)),
        "kwargs": _redact(config.get("kwargs") or {}),
    }
    return _canonical_sha256(normalized), normalized


def _number(value: object) -> float | None:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        return None
    result = float(value)
    return result if math.isfinite(result) else None


def _integer(value: object) -> int | None:
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        return None
    return value


def _parse_datetime(value: object) -> datetime | None:
    if not isinstance(value, str) or not value:
        return None
    text = value[:-1] + "+00:00" if value.endswith("Z") else value
    try:
        return datetime.fromisoformat(text)
    except ValueError:
        return None


def _duration(started: object, finished: object) -> float | None:
    start = _parse_datetime(started)
    finish = _parse_datetime(finished)
    if start is None or finish is None:
        return None
    if (start.tzinfo is None) != (finish.tzinfo is None):
        return None
    seconds = (finish - start).total_seconds()
    return round(seconds, 6) if seconds >= 0 else None


def _phase_timings(result: dict[str, Any]) -> dict[str, float | None]:
    output: dict[str, float | None] = {}
    for name in ("environment_setup", "agent_setup", "agent_execution", "verifier"):
        phase = result.get(name)
        if isinstance(phase, dict):
            output[name] = _duration(phase.get("started_at"), phase.get("finished_at"))
        else:
            output[name] = None
    return output


def _agent_contexts(result: dict[str, Any]) -> list[dict[str, Any]]:
    context = result.get("agent_result")
    if isinstance(context, dict):
        return [context]
    contexts: list[dict[str, Any]] = []
    steps = result.get("step_results")
    if isinstance(steps, list):
        for step in steps:
            if isinstance(step, dict) and isinstance(step.get("agent_result"), dict):
                contexts.append(step["agent_result"])
    return contexts


def _sum_optional(
    contexts: list[dict[str, Any]], field: str, cast: str
) -> int | float | None:
    values: list[int | float] = []
    for context in contexts:
        raw = context.get(field)
        value = _integer(raw) if cast == "int" else _number(raw)
        if value is not None:
            values.append(value)
    if not values:
        return None
    return sum(values)


def _usage(result: dict[str, Any]) -> dict[str, int | float | None]:
    contexts = _agent_contexts(result)
    inclusive = _sum_optional(contexts, "n_input_tokens", "int")
    cache = _sum_optional(contexts, "n_cache_tokens", "int")
    output = _sum_optional(contexts, "n_output_tokens", "int")
    cost = _sum_optional(contexts, "cost_usd", "float")
    cache_for_math = int(cache or 0)
    exclusive = (
        max(int(inclusive) - cache_for_math, 0) if inclusive is not None else None
    )
    total = (
        exclusive + cache_for_math + int(output or 0) if exclusive is not None else None
    )
    return {
        "input_tokens_including_cache": inclusive,
        "cache_tokens": cache,
        "input_tokens_excluding_cache": exclusive,
        "output_tokens": output,
        "total_tokens": total,
        "cost_usd": cost,
    }


def _classify_rewards(
    embedded: object,
    raw: dict[str, Any] | None,
    raw_error: str | None,
    exception: object,
) -> tuple[str, str, dict[str, float] | None, list[str]]:
    reasons: list[str] = []
    if isinstance(exception, dict):
        return "infra_error", "non_attempt", None, ["exception_info_present"]
    embedded_rewards = embedded if isinstance(embedded, dict) else None
    if embedded_rewards is None:
        return "incomplete", "missing", None, ["embedded_rewards_missing"]
    if raw_error is not None:
        return "inconsistent", "non_attempt", None, [f"raw_reward_{raw_error}"]
    if raw != embedded_rewards:
        return "inconsistent", "non_attempt", None, ["embedded_raw_reward_mismatch"]
    if _number(embedded_rewards.get("grader_error")) not in (None, 0.0):
        return "infra_error", "non_attempt", None, ["grader_error"]
    normalized: dict[str, float] = {}
    for key in REQUIRED_REWARDS:
        value = _number(embedded_rewards.get(key))
        if value is None or value not in (0.0, 1.0):
            reasons.append(f"invalid_or_missing_reward:{key}")
        else:
            normalized[key] = value
    if reasons:
        return "inconsistent", "non_attempt", None, reasons
    headline = normalized["reward"]
    checks_pass = all(normalized[key] == 1.0 for key in REQUIRED_REWARDS[1:])
    if headline == 1.0 and not checks_pass:
        return "inconsistent", "non_attempt", None, ["headline_submetric_mismatch"]
    if headline == 0.0 and checks_pass:
        return "inconsistent", "non_attempt", None, ["headline_submetric_mismatch"]
    return (
        "scored",
        "verified_solved" if headline == 1.0 else "failed",
        normalized,
        [],
    )


def _task_metadata(
    task_path: Path,
    source: str,
    task_name: str,
    inputs: list[dict[str, Any]],
    issues: list[dict[str, Any]],
) -> dict[str, Any]:
    fallback_key = f"{source}/{task_name}"
    task_toml = task_path / "task.toml"
    task_ref = _file_reference(task_toml)
    inputs.append(task_ref)
    source_id = task_name
    source_dataset = source
    if task_ref["exists"]:
        try:
            payload = tomllib.loads(task_toml.read_text(encoding="utf-8"))
            metadata = payload.get("metadata") if isinstance(payload, dict) else None
            if isinstance(metadata, dict):
                if isinstance(metadata.get("source_id"), str) and metadata["source_id"]:
                    source_id = metadata["source_id"]
                if (
                    isinstance(metadata.get("source_dataset"), str)
                    and metadata["source_dataset"]
                ):
                    source_dataset = metadata["source_dataset"]
        except (OSError, UnicodeError, tomllib.TOMLDecodeError) as exc:
            _issue(
                issues,
                "task_toml_invalid",
                f"cannot parse {task_toml}: {exc}",
                task_key=fallback_key,
            )
    else:
        _issue(
            issues, "task_toml_missing", f"missing {task_toml}", task_key=fallback_key
        )

    manifest_path = task_path.parent / "manifest.json"
    manifest, manifest_error = _optional_json(manifest_path, inputs)
    manifest_spec_sha = None
    manifest_content_sha = None
    lean_profile = None
    if manifest_error is not None:
        _issue(
            issues,
            "dataset_manifest_unavailable",
            f"dataset manifest {manifest_path} is {manifest_error}",
            task_key=fallback_key,
        )
    else:
        tasks = manifest.get("tasks") if manifest else None
        if isinstance(tasks, dict) and isinstance(tasks.get(task_path.name), str):
            manifest_spec_sha = tasks[task_path.name]
        else:
            _issue(
                issues,
                "manifest_task_missing",
                f"{task_path.name!r} missing from {manifest_path}",
                task_key=fallback_key,
            )
        manifest_content_sha = manifest.get("content_sha256") if manifest else None
        lean_profile = manifest.get("lean_profile") if manifest else None

    spec_path = task_path / "environment" / "task.lean"
    spec_ref = _file_reference(spec_path)
    inputs.append(spec_ref)
    spec_sha = spec_ref.get("sha256") if spec_ref["exists"] else None
    if manifest_spec_sha is None or spec_sha != manifest_spec_sha:
        _issue(
            issues,
            "spec_manifest_mismatch",
            f"spec hash {spec_sha!r} does not match manifest {manifest_spec_sha!r}",
            task_key=fallback_key,
        )
    return {
        "key": f"{source_dataset}/{source_id}",
        "source_dataset": source_dataset,
        "source_id": source_id,
        "path": str(task_path),
        "dataset_content_sha256": manifest_content_sha,
        "spec_sha256": spec_sha,
        "lean_profile": lean_profile,
    }


def _plan(
    lock: dict[str, Any],
) -> tuple[dict[tuple[str, str, str], dict[str, Any]], str | None]:
    harbor = lock.get("harbor")
    harbor_version = harbor.get("version") if isinstance(harbor, dict) else None
    trials = lock.get("trials")
    if not isinstance(trials, list) or not trials:
        raise ReportError("job lock has no non-empty trials plan")
    groups: dict[tuple[str, str, str], dict[str, Any]] = {}
    for index, row in enumerate(trials):
        if not isinstance(row, dict) or not isinstance(row.get("task"), dict):
            raise ReportError(f"job lock trial {index} is malformed")
        task = row["task"]
        name = task.get("name")
        source = task.get("source")
        digest = task.get("digest")
        path = task.get("path")
        if not all(
            isinstance(value, str) and value for value in (name, source, digest, path)
        ):
            raise ReportError(f"job lock trial {index} has incomplete task identity")
        agent_key, agent_config = _agent_config_identity(row.get("agent"))
        key = (source, name, agent_key)
        existing = groups.setdefault(
            key,
            {
                "source": source,
                "task_name": name,
                "task_digest": digest,
                "task_path": path,
                "agent_config_sha256": agent_key,
                "agent_config": agent_config,
                "planned_attempts": 0,
            },
        )
        if existing["task_digest"] != digest or existing["task_path"] != path:
            raise ReportError(
                f"ambiguous task identity in job lock for {source}/{name}"
            )
        existing["planned_attempts"] += 1
    return groups, harbor_version


def _trial_directories(job_dir: Path) -> list[Path]:
    directories: list[Path] = []
    for child in sorted(job_dir.iterdir(), key=lambda path: path.name):
        if not child.is_dir() or child.name.startswith("."):
            continue
        if any(
            (child / name).exists()
            for name in ("result.json", "lock.json", "config.json")
        ):
            directories.append(child)
    return directories


def _normalize_trial(
    trial_dir: Path,
    result: dict[str, Any],
    trial_lock: dict[str, Any] | None,
    trial_lock_error: str | None,
    plan_groups: dict[tuple[str, str, str], dict[str, Any]],
    repo_root: Path,
    inputs: list[dict[str, Any]],
    issues: list[dict[str, Any]],
) -> tuple[dict[str, Any], tuple[str, str, str] | None]:
    trial_name = result.get("trial_name")
    task_name_raw = result.get("task_name")
    source = result.get("source")
    if not isinstance(trial_name, str) or not trial_name:
        trial_name = trial_dir.name
        _issue(
            issues,
            "trial_name_missing",
            "result has no trial_name",
            trial_name=trial_name,
        )
    if (
        not isinstance(task_name_raw, str)
        or not task_name_raw
        or not isinstance(source, str)
        or not source
    ):
        raise ReportError(f"trial {trial_name} has incomplete task identity")
    task_basename = task_name_raw.rsplit("/", 1)[-1]
    config = result.get("config") if isinstance(result.get("config"), dict) else {}
    config_task = config.get("task") if isinstance(config.get("task"), dict) else {}
    raw_task_path = config_task.get("path")
    if not isinstance(raw_task_path, str) or not raw_task_path:
        task_id = result.get("task_id")
        raw_task_path = task_id.get("path") if isinstance(task_id, dict) else None
    task_path = (
        Path(raw_task_path)
        if isinstance(raw_task_path, str)
        else Path("tasks") / source / task_basename
    )
    if not task_path.is_absolute():
        task_path = (repo_root / task_path).resolve()

    agent_key, planned_agent = _agent_config_identity(config.get("agent"))
    plan_key = (source, task_basename, agent_key)
    plan_row = plan_groups.get(plan_key)
    if plan_row is None:
        _issue(
            issues,
            "trial_not_in_plan",
            "trial identity does not match any job lock entry",
            trial_name=trial_name,
            task_key=f"{source}/{task_basename}",
        )
    elif trial_lock_error is not None:
        _issue(
            issues,
            "trial_lock_unavailable",
            f"trial lock is {trial_lock_error}",
            trial_name=trial_name,
            task_key=f"{source}/{task_basename}",
        )
    elif trial_lock is not None:
        lock_task = (
            trial_lock.get("task") if isinstance(trial_lock.get("task"), dict) else {}
        )
        if lock_task.get("digest") != plan_row["task_digest"]:
            _issue(
                issues,
                "trial_lock_digest_mismatch",
                "trial lock task digest differs from job plan",
                trial_name=trial_name,
                task_key=f"{source}/{task_basename}",
            )

    task = _task_metadata(task_path, source, task_basename, inputs, issues)
    task["plan_identity_sha256"] = _canonical_sha256(plan_key) if plan_row else None
    task["harbor_checksum"] = result.get("task_checksum")
    task["harbor_lock_digest"] = plan_row["task_digest"] if plan_row else None
    task["harbor_path"] = raw_task_path

    verifier = result.get("verifier_result")
    embedded_rewards = verifier.get("rewards") if isinstance(verifier, dict) else None
    raw_reward, raw_reward_error = _optional_json(
        trial_dir / "verifier" / "reward.json", inputs
    )
    status, attempt_state, rewards, reasons = _classify_rewards(
        embedded_rewards,
        raw_reward,
        raw_reward_error,
        result.get("exception_info"),
    )
    if plan_row is None or trial_lock_error is not None:
        status, attempt_state = "inconsistent", "non_attempt"
    if reasons:
        _issue(
            issues,
            "trial_unscoreable",
            ", ".join(reasons),
            severity="warning" if status in {"infra_error", "incomplete"} else "error",
            trial_name=trial_name,
            task_key=task["key"],
        )

    details_ref = _file_reference(trial_dir / "verifier" / "grade_details.json")
    inputs.append(details_ref)
    agent_info = (
        result.get("agent_info") if isinstance(result.get("agent_info"), dict) else {}
    )
    model_info = (
        agent_info.get("model_info")
        if isinstance(agent_info.get("model_info"), dict)
        else {}
    )
    runtime_agent = {
        "name": agent_info.get("name"),
        "version": agent_info.get("version"),
        "model": model_info.get("name"),
        "provider": model_info.get("provider"),
        "protocol": None,
        "config_sha256": _canonical_sha256(_redact(config.get("agent") or {})),
        "planned_config_sha256": agent_key,
    }
    contexts = _agent_contexts(result)
    for context in contexts:
        metadata = context.get("metadata")
        if isinstance(metadata, dict) and isinstance(metadata.get("protocol"), str):
            runtime_agent["protocol"] = metadata["protocol"]
            break
    arm_identity = {
        "source": source,
        "agent_name": runtime_agent["name"],
        "model": runtime_agent["model"],
        "planned_config_sha256": agent_key,
    }
    arm_id = _canonical_sha256(arm_identity)[:16]
    timing = {
        "started_at": result.get("started_at"),
        "finished_at": result.get("finished_at"),
        "duration_seconds": _duration(
            result.get("started_at"), result.get("finished_at")
        ),
        "phases_seconds": _phase_timings(result),
    }
    row = {
        "schema_version": TRIAL_SCHEMA_VERSION,
        "job_id": config.get("job_id"),
        "task": task,
        "trial": {
            "id": result.get("id"),
            "name": trial_name,
            "status": status,
            "attempt_state": attempt_state,
        },
        "arm": {"id": arm_id, "identity": arm_identity},
        "agent": runtime_agent,
        "rewards": rewards,
        "grade_details": details_ref,
        "usage": _usage(result),
        "timing": timing,
        "exception": result.get("exception_info")
        if isinstance(result.get("exception_info"), dict)
        else None,
        "result_config_sha256": _canonical_sha256(_redact(config)),
    }
    return row, plan_key if plan_row is not None else None


def _nearest_rank(values: Iterable[float], quantile: float) -> float | None:
    ordered = sorted(values)
    if not ordered:
        return None
    index = max(math.ceil(quantile * len(ordered)) - 1, 0)
    return round(ordered[index], 6)


def _distribution(rows: list[dict[str, Any]], path: tuple[str, ...]) -> dict[str, Any]:
    values: list[float] = []
    for row in rows:
        value: object = row
        for part in path:
            value = value.get(part) if isinstance(value, dict) else None
        number = _number(value)
        if number is not None:
            values.append(number)
    total = round(sum(values), 6) if len(values) == len(rows) else None
    return {
        "available": len(values),
        "expected": len(rows),
        "total": total,
        "p50": _nearest_rank(values, 0.5),
        "p90": _nearest_rank(values, 0.9),
    }


def _summarize_arm(
    arm_id: str,
    rows: list[dict[str, Any]],
    expected_by_task: dict[str, int],
    arm_identity: dict[str, Any],
) -> dict[str, Any]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in rows:
        grouped[row["task"]["key"]].append(row)
    problems: list[dict[str, Any]] = []
    passed = 0
    complete_count = 0
    state_counts: Counter[str] = Counter()
    all_task_keys = sorted(set(grouped) | set(expected_by_task))
    for task_key in all_task_keys:
        task_rows = grouped.get(task_key, [])
        expected = expected_by_task.get(task_key, 0)
        states = [row["trial"]["attempt_state"] for row in task_rows]
        state_counts.update(states)
        scoreable = sum(state in {"verified_solved", "failed"} for state in states)
        task_complete = (
            expected > 0 and len(task_rows) == expected and scoreable == expected
        )
        task_passed = any(state == "verified_solved" for state in states)
        complete_count += int(task_complete)
        passed += int(task_passed)
        problems.append(
            {
                "task_key": task_key,
                "expected_attempts": expected,
                "observed_attempts": len(task_rows),
                "scoreable_attempts": scoreable,
                "complete": task_complete,
                "strict_pass_at_k": task_passed,
                "passed_attempt_ids": sorted(
                    row["trial"]["name"]
                    for row in task_rows
                    if row["trial"]["attempt_state"] == "verified_solved"
                ),
                "attempt_states": {
                    row["trial"]["name"]: row["trial"]["attempt_state"]
                    for row in sorted(task_rows, key=lambda item: item["trial"]["name"])
                },
            }
        )
    task_count = len(problems)
    complete = task_count > 0 and complete_count == task_count
    fraction = passed / task_count if task_count else 0.0
    k_values = sorted(set(expected_by_task.values()))
    return {
        "arm_id": arm_id,
        "identity": arm_identity,
        "k": k_values[0] if len(k_values) == 1 else None,
        "uniform_k": len(k_values) == 1,
        "expected_problems": task_count,
        "complete_problems": complete_count,
        "strict_passed_problems": passed,
        "complete": complete,
        "pass_at_k": fraction if complete else None,
        "pass_at_k_percent": round(fraction * 100, 4) if complete else None,
        "provisional_pass_at_k_lower_bound": fraction,
        "attempt_states": dict(sorted(state_counts.items())),
        "distributions": {
            "walltime_seconds": _distribution(rows, ("timing", "duration_seconds")),
            "input_tokens_excluding_cache": _distribution(
                rows, ("usage", "input_tokens_excluding_cache")
            ),
            "cache_tokens": _distribution(rows, ("usage", "cache_tokens")),
            "output_tokens": _distribution(rows, ("usage", "output_tokens")),
            "total_tokens": _distribution(rows, ("usage", "total_tokens")),
            "cost_usd": _distribution(rows, ("usage", "cost_usd")),
        },
        "problems": problems,
    }


def _paired(
    arms: list[dict[str, Any]], rows_by_arm: dict[str, list[dict[str, Any]]]
) -> list[dict[str, Any]]:
    comparisons: list[dict[str, Any]] = []
    for left, right in combinations(arms, 2):
        if left["identity"]["source"] != right["identity"]["source"]:
            continue
        left_rows = rows_by_arm[left["arm_id"]]
        right_rows = rows_by_arm[right["arm_id"]]
        left_checksums = {
            row["task"]["key"]: row["task"]["spec_sha256"] for row in left_rows
        }
        right_checksums = {
            row["task"]["key"]: row["task"]["spec_sha256"] for row in right_rows
        }
        reasons: list[str] = []
        if set(left_checksums) != set(right_checksums):
            reasons.append("task_set_mismatch")
        for task_key in sorted(set(left_checksums) & set(right_checksums)):
            if left_checksums[task_key] != right_checksums[task_key]:
                reasons.append(f"spec_sha256_mismatch:{task_key}")
        comparable = not reasons
        outcomes = {"both": 0, "left_only": 0, "right_only": 0, "neither": 0}
        if comparable:
            left_pass = {
                row["task_key"]: row["strict_pass_at_k"] for row in left["problems"]
            }
            right_pass = {
                row["task_key"]: row["strict_pass_at_k"] for row in right["problems"]
            }
            for task_key in sorted(left_pass):
                key = (
                    "both"
                    if left_pass[task_key] and right_pass[task_key]
                    else "left_only"
                    if left_pass[task_key]
                    else "right_only"
                    if right_pass[task_key]
                    else "neither"
                )
                outcomes[key] += 1
        complete = comparable and left["complete"] and right["complete"]
        comparisons.append(
            {
                "left_arm_id": left["arm_id"],
                "right_arm_id": right["arm_id"],
                "comparable": comparable,
                "complete": complete,
                "reasons": reasons,
                "outcomes": outcomes if comparable else None,
                "pass_at_k_delta_right_minus_left": (
                    round(right["pass_at_k"] - left["pass_at_k"], 8)
                    if complete
                    else None
                ),
            }
        )
    return comparisons


def _payload_sha256(summary: dict[str, Any]) -> str:
    payload = copy.deepcopy(summary)
    attestation = payload.get("attestation")
    if isinstance(attestation, dict):
        attestation.pop("payload_sha256", None)
    return _canonical_sha256(payload)


def _jsonl_bytes(rows: list[dict[str, Any]]) -> bytes:
    return b"".join(_canonical_bytes(row) + b"\n" for row in rows)


def _atomic_write(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.tmp-{os.getpid()}")
    temporary.write_bytes(data)
    temporary.replace(path)


def summarize(
    job_dir: Path, tasks_root: Path, out_dir: Path
) -> tuple[dict[str, Any], int]:
    job_dir = job_dir.resolve()
    repo_root = tasks_root.resolve().parent
    inputs: list[dict[str, Any]] = []
    issues: list[dict[str, Any]] = []
    job_config = _read_json(job_dir / "config.json", inputs)
    job_lock = _read_json(job_dir / "lock.json", inputs)
    job_result = _read_json(job_dir / "result.json", inputs)
    plan_groups, harbor_version = _plan(job_lock)
    if harbor_version not in SUPPORTED_HARBOR_VERSIONS:
        _issue(
            issues,
            "unsupported_harbor_version",
            f"job lock Harbor version {harbor_version!r} is not in the verified set "
            f"{sorted(SUPPORTED_HARBOR_VERSIONS)!r}",
        )

    rows: list[dict[str, Any]] = []
    observed_by_plan: Counter[tuple[str, str, str]] = Counter()
    seen_trial_ids: set[str] = set()
    seen_trial_names: set[str] = set()
    top_job_id = job_result.get("id")
    for trial_dir in _trial_directories(job_dir):
        result, result_error = _optional_json(trial_dir / "result.json", inputs)
        trial_lock, trial_lock_error = _optional_json(trial_dir / "lock.json", inputs)
        _optional_json(trial_dir / "config.json", inputs)
        if result_error is not None:
            _issue(
                issues,
                "trial_result_unavailable",
                f"{trial_dir / 'result.json'} is {result_error}",
                severity="warning" if result_error == "missing" else "error",
                trial_name=trial_dir.name,
            )
            continue
        assert result is not None
        trial_id = result.get("id")
        trial_name = result.get("trial_name")
        if isinstance(trial_id, str):
            if trial_id in seen_trial_ids:
                raise ReportError(f"duplicate trial id {trial_id}")
            seen_trial_ids.add(trial_id)
        if isinstance(trial_name, str):
            if trial_name in seen_trial_names:
                raise ReportError(f"duplicate trial name {trial_name}")
            seen_trial_names.add(trial_name)
        row, plan_key = _normalize_trial(
            trial_dir,
            result,
            trial_lock,
            trial_lock_error,
            plan_groups,
            repo_root,
            inputs,
            issues,
        )
        if top_job_id is not None and row["job_id"] != top_job_id:
            row["trial"]["status"] = "inconsistent"
            row["trial"]["attempt_state"] = "non_attempt"
            _issue(
                issues,
                "job_id_mismatch",
                "trial config job_id differs from job result id",
                trial_name=row["trial"]["name"],
                task_key=row["task"]["key"],
            )
        rows.append(row)
        if plan_key is not None:
            observed_by_plan[plan_key] += 1

    # Create explicit missing attempts from the immutable lock plan.
    observed_arm_by_agent: dict[
        tuple[str, str], tuple[str, dict[str, Any], dict[str, Any]]
    ] = {}
    for row in rows:
        key = (row["arm"]["identity"]["source"], row["agent"]["planned_config_sha256"])
        observed_arm_by_agent.setdefault(
            key, (row["arm"]["id"], row["arm"]["identity"], row["agent"])
        )
    for plan_key, planned in sorted(plan_groups.items()):
        missing = planned["planned_attempts"] - observed_by_plan[plan_key]
        if missing < 0:
            _issue(
                issues,
                "extra_attempts",
                f"observed {-missing} attempts beyond the lock plan",
                task_key=f"{planned['source']}/{planned['task_name']}",
            )
            continue
        for index in range(1, missing + 1):
            agent_key = planned["agent_config_sha256"]
            observed_arm = observed_arm_by_agent.get((planned["source"], agent_key))
            if observed_arm is None:
                arm_identity = {
                    "source": planned["source"],
                    "agent_name": planned["agent_config"].get("name")
                    or planned["agent_config"].get("import_path"),
                    "model": planned["agent_config"].get("model_name"),
                    "planned_config_sha256": agent_key,
                }
                arm_id = _canonical_sha256(arm_identity)[:16]
                agent = {
                    "name": arm_identity["agent_name"],
                    "version": None,
                    "model": arm_identity["model"],
                    "provider": None,
                    "protocol": None,
                    "config_sha256": None,
                    "planned_config_sha256": agent_key,
                }
            else:
                arm_id, arm_identity, observed_agent = observed_arm
                agent = dict(observed_agent)
            task_path = Path(planned["task_path"])
            if not task_path.is_absolute():
                task_path = (repo_root / task_path).resolve()
            task = _task_metadata(
                task_path,
                planned["source"],
                planned["task_name"],
                inputs,
                issues,
            )
            task["harbor_checksum"] = None
            task["harbor_lock_digest"] = planned["task_digest"]
            task["harbor_path"] = planned["task_path"]
            task["plan_identity_sha256"] = _canonical_sha256(plan_key)
            missing_name = f"missing:{task['key']}:{index}"
            rows.append(
                {
                    "schema_version": TRIAL_SCHEMA_VERSION,
                    "job_id": top_job_id,
                    "task": task,
                    "trial": {
                        "id": None,
                        "name": missing_name,
                        "status": "incomplete",
                        "attempt_state": "missing",
                    },
                    "arm": {"id": arm_id, "identity": arm_identity},
                    "agent": agent,
                    "rewards": None,
                    "grade_details": {"path": None, "exists": False},
                    "usage": {
                        "input_tokens_including_cache": None,
                        "cache_tokens": None,
                        "input_tokens_excluding_cache": None,
                        "output_tokens": None,
                        "total_tokens": None,
                        "cost_usd": None,
                    },
                    "timing": {
                        "started_at": None,
                        "finished_at": None,
                        "duration_seconds": None,
                        "phases_seconds": {},
                    },
                    "exception": None,
                    "result_config_sha256": None,
                }
            )
            _issue(
                issues,
                "planned_attempt_missing",
                "job lock planned an attempt with no result",
                severity="warning",
                trial_name=missing_name,
                task_key=task["key"],
            )

    rows.sort(
        key=lambda row: (
            row["arm"]["id"],
            row["task"]["key"],
            str(row["timing"]["started_at"] or ""),
            row["trial"]["name"],
        )
    )
    rows_by_arm: dict[str, list[dict[str, Any]]] = defaultdict(list)
    expected_by_arm_task: dict[str, dict[str, int]] = defaultdict(dict)
    for row in rows:
        rows_by_arm[row["arm"]["id"]].append(row)
        expected_by_arm_task[row["arm"]["id"]][row["task"]["key"]] = 0
    for plan_key, planned in plan_groups.items():
        plan_identity_sha256 = _canonical_sha256(plan_key)
        matching = [
            row
            for row in rows
            if row["task"].get("plan_identity_sha256") == plan_identity_sha256
        ]
        if not matching:
            _issue(
                issues,
                "plan_group_unmapped",
                "could not map a job-lock plan group to normalized trials",
                task_key=f"{planned['source']}/{planned['task_name']}",
            )
            continue
        arm_ids = {row["arm"]["id"] for row in matching}
        task_keys = {row["task"]["key"] for row in matching}
        if len(arm_ids) != 1 or len(task_keys) != 1:
            _issue(
                issues,
                "plan_group_ambiguous",
                "one job-lock plan group mapped to multiple arms or task keys",
                task_key=f"{planned['source']}/{planned['task_name']}",
            )
            continue
        arm_id = next(iter(arm_ids))
        task_key = next(iter(task_keys))
        expected_by_arm_task[arm_id][task_key] = planned["planned_attempts"]

    arms = [
        _summarize_arm(
            arm_id,
            arm_rows,
            expected_by_arm_task[arm_id],
            arm_rows[0]["arm"]["identity"],
        )
        for arm_id, arm_rows in sorted(rows_by_arm.items())
    ]
    paired = _paired(arms, rows_by_arm)

    stats = job_result.get("stats") if isinstance(job_result.get("stats"), dict) else {}
    n_total_trials = _integer(job_result.get("n_total_trials"))
    completed = _integer(stats.get("n_completed_trials"))
    pending = _integer(stats.get("n_pending_trials"))
    running = _integer(stats.get("n_running_trials"))
    observed_real = sum(row["trial"]["id"] is not None for row in rows)
    structural_complete = (
        job_result.get("finished_at") is not None
        and n_total_trials == len(job_lock["trials"])
        and completed == observed_real
        and pending == 0
        and running == 0
    )
    if not structural_complete:
        _issue(
            issues,
            "job_progress_mismatch",
            "job result counts/lifecycle do not match lock plan and discovered trials",
            severity="warning",
        )

    source_state = _source_git_state()
    if source_state["commit"] is None:
        _issue(
            issues,
            "source_unattestable",
            "running summary code is not a tracked Git source",
        )
    all_complete = (
        structural_complete and bool(arms) and all(arm["complete"] for arm in arms)
    )
    issues = list({_canonical_sha256(issue): issue for issue in issues}.values())
    no_errors = not any(issue["severity"] == "error" for issue in issues)
    complete = all_complete and no_errors
    issues.sort(
        key=lambda row: (
            row["severity"],
            row["code"],
            row.get("task_key", ""),
            row.get("trial_name", ""),
        )
    )
    trials_bytes = _jsonl_bytes(rows)
    issues_bytes = _jsonl_bytes(issues)
    unique_inputs = {
        (
            reference.get("path"),
            reference.get("sha256"),
            reference.get("exists"),
        ): reference
        for reference in inputs
        if reference.get("path") is not None
    }
    input_rows = sorted(unique_inputs.values(), key=lambda row: str(row.get("path")))
    summary: dict[str, Any] = {
        "schema_version": SCHEMA_VERSION,
        "job": {
            "id": top_job_id,
            "name": job_config.get("job_name") or job_dir.name,
            "path": str(job_dir),
            "harbor_version": harbor_version,
            "finished_at": job_result.get("finished_at"),
            "n_total_trials": n_total_trials,
            "structural_complete": structural_complete,
        },
        "complete": complete,
        "score_semantics": (
            "Observed strict pass@k: a problem passes iff at least one of its k planned attempts "
            "has reward=1 and all five CodeProver verifier submetrics=1. Official pass@k is null "
            "unless every planned attempt is scoreable; provisional lower bound remains separate."
        ),
        "arms": arms,
        "paired": paired,
        "issue_counts": dict(
            sorted(Counter(issue["severity"] for issue in issues).items())
        ),
        "outputs": {
            "trials_jsonl": {
                "sha256": _sha256_bytes(trials_bytes),
                "record_count": len(rows),
            },
            "issues_jsonl": {
                "sha256": _sha256_bytes(issues_bytes),
                "record_count": len(issues),
            },
        },
        "attestation": {
            "source": source_state,
            "input_files": input_rows,
            "payload_sha256": None,
        },
    }
    summary["attestation"]["payload_sha256"] = _payload_sha256(summary)
    summary_bytes = (
        json.dumps(summary, ensure_ascii=False, indent=2, sort_keys=True).encode(
            "utf-8"
        )
        + b"\n"
    )
    _atomic_write(out_dir / "trials.jsonl", trials_bytes)
    _atomic_write(out_dir / "issues.jsonl", issues_bytes)
    _atomic_write(out_dir / "summary.json", summary_bytes)
    return summary, 0 if complete else 2


def verify(report_path: Path) -> list[str]:
    try:
        report = json.loads(report_path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        return [f"cannot read report: {exc}"]
    if not isinstance(report, dict):
        return ["report root is not an object"]
    errors: list[str] = []
    expected_payload = report.get("attestation", {}).get("payload_sha256")
    if expected_payload != _payload_sha256(report):
        errors.append("summary payload_sha256 mismatch")
    for reference in report.get("attestation", {}).get("input_files", []):
        if not isinstance(reference, dict) or not isinstance(
            reference.get("path"), str
        ):
            errors.append("malformed input file reference")
            continue
        actual = _file_reference(Path(reference["path"]))
        if actual.get("exists") != reference.get("exists") or actual.get(
            "sha256"
        ) != reference.get("sha256"):
            errors.append(f"input changed: {reference['path']}")
    for name, key in (
        ("trials.jsonl", "trials_jsonl"),
        ("issues.jsonl", "issues_jsonl"),
    ):
        reference = report.get("outputs", {}).get(key, {})
        actual = _file_reference(report_path.parent / name)
        if not actual.get("exists") or actual.get("sha256") != reference.get("sha256"):
            errors.append(f"output changed: {report_path.parent / name}")
    return errors


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    summarize_parser = subparsers.add_parser(
        "summarize", help="summarize one Harbor job"
    )
    summarize_parser.add_argument("job_dir", type=Path)
    summarize_parser.add_argument("--tasks-root", type=Path, default=Path("tasks"))
    summarize_parser.add_argument("--out-dir", type=Path)
    summarize_parser.add_argument(
        "--allow-incomplete",
        action="store_true",
        help="return zero for incomplete reports without changing null official metrics",
    )
    verify_parser = subparsers.add_parser(
        "verify", help="rehash a generated report and its inputs"
    )
    verify_parser.add_argument("report", type=Path)
    return parser


def main() -> int:
    args = _parser().parse_args()
    if args.command == "verify":
        errors = verify(args.report.resolve())
        if errors:
            for error in errors:
                print(error, file=sys.stderr)
            return 1
        print(f"verified {args.report}")
        return 0
    job_dir = args.job_dir.resolve()
    out_dir = args.out_dir.resolve() if args.out_dir else job_dir / "audit"
    try:
        summary, exit_code = summarize(job_dir, args.tasks_root, out_dir)
    except ReportError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    print(
        f"wrote {out_dir / 'summary.json'}: complete={summary['complete']} "
        f"arms={len(summary['arms'])} issues={sum(summary['issue_counts'].values())}"
    )
    return 0 if args.allow_incomplete and exit_code == 2 else exit_code


if __name__ == "__main__":
    raise SystemExit(main())
