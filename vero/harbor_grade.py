#!/usr/bin/env python3
"""Harbor adapter for the frozen Vero proof campaign.

This file is copied into each task's hidden ``tests/`` directory.  It does not
reimplement Vero's semantics: after checking the immutable runtime snapshot it
uses Vero's own schema-driven extractor and fresh-render evaluator.  Every
error is fail-closed and still produces Harbor's ``reward.json`` contract.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
import traceback
from pathlib import Path


IGNORED_DIRS = {".git", ".lake", "__pycache__", "build"}


def _snapshot_files(runtime: Path, benchmark_relative: str) -> list[Path]:
    roots = [
        runtime / "src" / "vero",
        runtime / "templates",
        runtime / benchmark_relative,
    ]
    files: list[Path] = []
    for root in roots:
        if not root.is_dir():
            raise RuntimeError(f"frozen Vero snapshot path is missing: {root}")
        for path in root.rglob("*"):
            if path.is_file() and not any(part in IGNORED_DIRS for part in path.parts):
                files.append(path)
    pyproject = runtime / "pyproject.toml"
    if not pyproject.is_file():
        raise RuntimeError(f"frozen Vero metadata is missing: {pyproject}")
    files.append(pyproject)
    return sorted(set(files), key=lambda path: path.relative_to(runtime).as_posix())


def snapshot_sha256(runtime: Path, benchmark_relative: str) -> str:
    """Hash the exact native runtime/template/benchmark bytes used to grade."""
    digest = hashlib.sha256()
    for path in _snapshot_files(runtime, benchmark_relative):
        relative = path.relative_to(runtime).as_posix().encode()
        payload = path.read_bytes()
        digest.update(len(relative).to_bytes(8, "big"))
        digest.update(relative)
        digest.update(len(payload).to_bytes(8, "big"))
        digest.update(payload)
    return digest.hexdigest()


def _git_value(runtime: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(runtime), *args],
        check=False,
        capture_output=True,
        text=True,
        timeout=30,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"cannot attest frozen Vero checkout ({' '.join(args)}): "
            f"{result.stderr.strip()}"
        )
    return result.stdout.strip()


def attest_runtime(
    runtime: Path,
    benchmark_relative: str,
    expected_revision: str,
    expected_snapshot_sha256: str,
) -> None:
    actual_revision = _git_value(runtime, "rev-parse", "HEAD")
    if actual_revision != expected_revision:
        raise RuntimeError(
            f"Vero revision mismatch: expected {expected_revision}, got {actual_revision}"
        )
    actual_snapshot = snapshot_sha256(runtime, benchmark_relative)
    if actual_snapshot != expected_snapshot_sha256:
        raise RuntimeError(
            "Vero native runtime/benchmark snapshot mismatch: "
            f"expected {expected_snapshot_sha256}, got {actual_snapshot}"
        )


def _write_reward(out_dir: Path, reward: float, details: dict) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    metrics = {
        "reward": float(reward),
        "native_build_ok": float(bool(details.get("build_ok"))),
        "native_all_specs_passed": float(bool(details.get("all_specs_passed"))),
        "runtime_attested": float(bool(details.get("runtime_attested"))),
    }
    (out_dir / "reward.json").write_text(json.dumps(metrics, indent=2) + "\n")
    (out_dir / "grade_details.json").write_text(
        json.dumps(details, indent=2, ensure_ascii=False, default=str) + "\n"
    )


def grade(args: argparse.Namespace) -> dict:
    runtime = args.runtime.resolve()
    benchmark_dir = (runtime / args.benchmark_relative).resolve()
    sandbox_dir = args.sandbox.resolve()
    out_dir = args.out_dir.resolve()
    if not sandbox_dir.is_dir():
        raise RuntimeError(f"agent sandbox is missing: {sandbox_dir}")
    attest_runtime(
        runtime,
        args.benchmark_relative,
        args.expected_revision,
        args.expected_snapshot_sha256,
    )

    # Import only after attestation.  The package is the exact pinned upstream
    # implementation, not a forked or simplified V3 verifier.
    sys.path.insert(0, str(runtime / "src"))
    from vero.evaluation.runner import run_evaluation
    from vero.generation.benchmark import Benchmark
    from vero.generation.extractor import extract

    bench = Benchmark(benchmark_dir)
    if bench.lean_version != "4.29.1":
        raise RuntimeError(f"unexpected benchmark Lean version: {bench.lean_version}")
    if "proof" not in bench.modes_supported:
        raise RuntimeError("benchmark no longer supports the frozen proof track")

    artifact = extract(sandbox_dir, bench, mode="proof")
    evaluation = run_evaluation(
        benchmark_dir=benchmark_dir,
        artifact=artifact,
        mode="proof",
        eval_sandbox_dir=out_dir / "fresh_eval_sandbox",
        report_dir=out_dir / "native_report",
        lake_timeout=args.lake_timeout,
    )
    report = evaluation.report
    total_specs = int(report.summary.total_specs)
    passed_specs = int(report.summary.passed_specs)
    all_specs_passed = total_specs > 0 and passed_specs == total_specs
    solved = bool(report.build_ok and all_specs_passed)
    return {
        "benchmark_id": bench.benchmark_id,
        "mode": "proof",
        "runtime_attested": True,
        "build_ok": bool(report.build_ok),
        "all_specs_passed": all_specs_passed,
        "total_specs": total_specs,
        "passed_specs": passed_specs,
        "native_report_json": str(evaluation.json_path),
        "native_report_markdown": str(evaluation.md_path),
        "reward": 1.0 if solved else 0.0,
    }


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runtime", type=Path, default=Path("/opt/vero"))
    parser.add_argument("--benchmark-relative", required=True)
    parser.add_argument("--sandbox", type=Path, default=Path("/task"))
    parser.add_argument("--expected-revision", required=True)
    parser.add_argument("--expected-snapshot-sha256", required=True)
    parser.add_argument("--out-dir", type=Path, default=Path("/logs/verifier"))
    parser.add_argument("--lake-timeout", type=int, default=3600)
    return parser


def main() -> int:
    args = _parser().parse_args()
    try:
        details = grade(args)
    except Exception as exc:  # Harbor must receive reward.json on every path.
        details = {
            "reward": 0.0,
            "runtime_attested": False,
            "build_ok": False,
            "all_specs_passed": False,
            "error": str(exc),
            "traceback": traceback.format_exc(),
        }
    _write_reward(args.out_dir.resolve(), float(details["reward"]), details)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
