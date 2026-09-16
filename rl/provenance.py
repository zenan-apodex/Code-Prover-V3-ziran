"""Small, dependency-free provenance helpers for Code-Prover RL datasets."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def task_provenance(task_dir: Path) -> dict[str, str]:
    instruction = task_dir / "instruction.md"
    task_file = task_dir / "environment" / "task.lean"
    tests_dir = task_dir / "tests"
    test_hash = hashlib.sha256()
    for path in sorted(p for p in tests_dir.rglob("*") if p.is_file()):
        test_hash.update(path.relative_to(tests_dir).as_posix().encode("utf-8"))
        test_hash.update(b"\0")
        test_hash.update(path.read_bytes())
        test_hash.update(b"\0")
    return {
        "instruction_sha256": sha256_file(instruction),
        "task_sha256": sha256_file(task_file),
        "tests_sha256": test_hash.hexdigest(),
    }


def prompt_record(task_dir: Path) -> dict:
    return {
        "prompt": (task_dir / "instruction.md").read_text(encoding="utf-8"),
        "metadata": {"task_name": task_dir.name, **task_provenance(task_dir)},
    }


def resolve_task_dir(metadata: dict, task_root: Path) -> Path:
    """Resolve a flat or multi-root task record without escaping task_root."""
    task_name = metadata.get("task_name")
    if not isinstance(task_name, str) or not task_name or Path(task_name).name != task_name:
        raise ValueError("invalid metadata.task_name")
    root = task_root.resolve()
    configured = metadata.get("task_dir")
    if configured is not None:
        if not isinstance(configured, str) or not configured:
            raise ValueError("invalid metadata.task_dir")
        task_dir = Path(configured).resolve()
        if task_dir.name != task_name:
            raise ValueError("metadata.task_dir does not match metadata.task_name")
    else:
        task_dir = (root / task_name).resolve()
    try:
        task_dir.relative_to(root)
    except ValueError as exc:
        raise ValueError("metadata.task_dir is outside the configured task root") from exc
    return task_dir


def prompt_instruction(prompt) -> str:
    """Extract the exact user instruction from supported Miles prompt forms."""
    if isinstance(prompt, str):
        return prompt
    if (
        isinstance(prompt, list)
        and len(prompt) == 1
        and isinstance(prompt[0], dict)
        and prompt[0].get("role") == "user"
        and isinstance(prompt[0].get("content"), str)
    ):
        return prompt[0]["content"]
    raise ValueError("prompt must be a string or one user message")


def validate_prompt_data(path: Path, task_root: Path) -> int:
    """Validate every prompt against the exact task bytes it names."""
    count = 0
    seen: set[str] = set()
    for line_number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not raw.strip():
            continue
        record = json.loads(raw)
        metadata = record.get("metadata") or {}
        task_name = metadata.get("task_name")
        try:
            task_dir = resolve_task_dir(metadata, task_root)
        except ValueError as exc:
            raise ValueError(f"{path}:{line_number}: {exc}") from exc
        if task_name in seen:
            raise ValueError(f"{path}:{line_number}: duplicate task_name {task_name!r}")
        seen.add(task_name)
        expected = prompt_record(task_dir)
        try:
            instruction = prompt_instruction(record.get("prompt"))
        except ValueError as exc:
            raise ValueError(f"{path}:{line_number}: {exc}") from exc
        if instruction != expected["prompt"]:
            raise ValueError(f"{path}:{line_number}: prompt differs from {task_name}/instruction.md")
        if "instruction" in metadata and metadata["instruction"] != expected["prompt"]:
            raise ValueError(f"{path}:{line_number}: metadata.instruction provenance mismatch")
        for key, value in expected["metadata"].items():
            if metadata.get(key) != value:
                raise ValueError(f"{path}:{line_number}: metadata.{key} provenance mismatch")
        count += 1
    if count == 0:
        raise ValueError(f"{path}: no prompt records")
    return count
