#!/usr/bin/env python3
"""Attest and materialize the frozen 44-instance Vero proof campaign.

The source checkout is untrusted input.  Before emitting a descriptor or any
Harbor task this tool verifies the exact upstream Git revision, clean checkout,
ordered config selection, exclusions, Lean toolchain, manifests, and native
proof-mode support.  Generated task views are intentionally written under the
already-ignored ``tasks/_campaign_views`` tree by default.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import asdict, dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from vero.harbor_grade import snapshot_sha256  # noqa: E402
from tools.benchmark_paths import BenchmarkPathError, resolve_source  # noqa: E402


CAMPAIGN_NAME = "vero-proof-44"
UPSTREAM_URL = "https://github.com/sunblaze-ucb/vero.git"
UPSTREAM_REVISION = "64d5a8fb827a489b82119f667b6b54322a70e538"
UPSTREAM_TREE = "802f54c76b7d2d0fe00f983481964a326b961238"
LEAN_TOOLCHAIN = "leanprover/lean4:v4.29.1"
LEAN_VERSION = "4.29.1"
EXPECTED_COUNT = 44
EXPECTED_ORDERED_IDS_SHA256 = (
    "9c33b9dfb611908854b6a0e5ab16f41de00ed38b306bceb40cc20630faa05317"
)
EXCLUDED_IDS = ("bankledger", "tiny_unsat")
EXCLUDED_ROLES = {
    "bankledger": "canonical_exemplar",
    "tiny_unsat": "test_fixture",
}
BASE_IMAGE = "lizenan1995/code-prover-lean:latest"
DEFAULT_DESCRIPTOR = Path("migration/v2/vero-proof-44.json")
DEFAULT_OUTPUT = Path("tasks/_campaign_views/vero-proof-44")


class MigrationError(RuntimeError):
    """A frozen Vero input or generated Harbor invariant did not match."""


def _source_root(explicit: Path | None) -> Path:
    try:
        return resolve_source("vero", explicit)
    except BenchmarkPathError as exc:
        raise MigrationError(str(exc)) from exc


@dataclass(frozen=True)
class SourceTask:
    id: str
    config_path: str
    benchmark_path: str
    manifest_benchmark_id: str
    root_package: str
    snapshot_sha256: str


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise MigrationError(message)


def _git(root: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(root), *args],
        check=False,
        capture_output=True,
        text=True,
        timeout=30,
    )
    if result.returncode != 0:
        raise MigrationError(
            f"git {' '.join(args)} failed for {root}: {result.stderr.strip()}"
        )
    return result.stdout.strip()


def ordered_ids_sha256(ids: list[str] | tuple[str, ...]) -> str:
    return hashlib.sha256(("\n".join(ids) + "\n").encode()).hexdigest()


def _top_level_scalar(text: str, key: str, path: Path) -> str:
    match = re.search(rf"^{re.escape(key)}:\s*([^#\s]+)\s*(?:#.*)?$", text, re.M)
    if match is None:
        raise MigrationError(f"missing top-level {key!r} in {path}")
    return match.group(1).strip("'\"")


def _load_object(path: Path) -> dict:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise MigrationError(f"cannot read JSON object {path}: {exc}") from exc
    _require(isinstance(value, dict), f"expected JSON object: {path}")
    return value


def audit_upstream(vero_root: Path, *, require_clean: bool = True) -> list[SourceTask]:
    """Return the exact ordered 44-task source plan, or fail before writing."""
    vero_root = vero_root.resolve()
    _require((vero_root / ".git").exists(), f"not a Vero Git checkout: {vero_root}")
    _require(
        _git(vero_root, "rev-parse", "HEAD") == UPSTREAM_REVISION,
        f"Vero checkout is not at frozen revision {UPSTREAM_REVISION}",
    )
    _require(
        _git(vero_root, "rev-parse", "HEAD^{tree}") == UPSTREAM_TREE,
        "Vero commit tree does not match the frozen upstream tree",
    )
    origin = _git(vero_root, "remote", "get-url", "origin")
    _require(origin == UPSTREAM_URL, f"unexpected Vero origin: {origin}")
    if require_clean:
        _require(
            not _git(vero_root, "status", "--porcelain", "--untracked-files=all"),
            f"Vero checkout must be clean: {vero_root}",
        )

    configs = sorted((vero_root / "conf" / "benchmark").glob("*.yaml"))
    _require(
        len(configs) == EXPECTED_COUNT + len(EXCLUDED_IDS), "Vero config count changed"
    )
    selected: list[SourceTask] = []
    excluded: dict[str, str] = {}
    seen: set[str] = set()
    for config in configs:
        text = config.read_text(encoding="utf-8")
        source_id = _top_level_scalar(text, "id", config)
        benchmark_relative = _top_level_scalar(text, "path", config)
        default_mode = _top_level_scalar(text, "default_mode", config)
        _require(source_id not in seen, f"duplicate Vero config id: {source_id}")
        seen.add(source_id)
        benchmark_dir = (vero_root / benchmark_relative).resolve()
        _require(
            benchmark_dir.is_relative_to(vero_root),
            f"benchmark escapes Vero root: {benchmark_relative}",
        )
        _require(
            benchmark_dir.is_dir(), f"benchmark path is missing: {benchmark_relative}"
        )
        if source_id in EXCLUDED_IDS:
            excluded[source_id] = benchmark_relative
            continue

        # The formal campaign forces proof mode for every real instance.  In
        # particular, verified_ironkv's upstream default is codeproof; it must
        # not silently change this campaign's track.
        _require(default_mode in {"proof", "codeproof"}, f"bad mode in {config}")
        manifest = _load_object(benchmark_dir / "manifest.json")
        _require(
            manifest.get("lean_version") == LEAN_VERSION,
            f"Lean version changed for {source_id}",
        )
        modes = manifest.get("modes_supported")
        _require(
            isinstance(modes, list) and "proof" in modes,
            f"proof mode is unavailable for {source_id}",
        )
        root_package = manifest.get("root_package")
        benchmark_id = manifest.get("benchmark_id")
        _require(
            isinstance(root_package, str) and root_package,
            f"bad root package: {source_id}",
        )
        _require(
            isinstance(benchmark_id, str) and benchmark_id,
            f"bad manifest id: {source_id}",
        )
        toolchain = (
            (benchmark_dir / "lean-toolchain").read_text(encoding="utf-8").strip()
        )
        _require(toolchain == LEAN_TOOLCHAIN, f"Lean toolchain changed for {source_id}")
        selected.append(
            SourceTask(
                id=source_id,
                config_path=config.relative_to(vero_root).as_posix(),
                benchmark_path=Path(benchmark_relative).as_posix(),
                manifest_benchmark_id=benchmark_id,
                root_package=root_package,
                snapshot_sha256=snapshot_sha256(vero_root, benchmark_relative),
            )
        )

    _require(set(excluded) == set(EXCLUDED_IDS), "required Vero exclusions changed")
    _require(
        excluded["bankledger"] == "reference/BankLedger",
        "bankledger is no longer the canonical exemplar",
    )
    _require(
        excluded["tiny_unsat"] == "tests/fixtures/tiny_unsat",
        "tiny_unsat is no longer the test fixture",
    )
    ids = [task.id for task in selected]
    _require(len(ids) == EXPECTED_COUNT, "real Vero instance count is not 44")
    _require(
        ordered_ids_sha256(ids) == EXPECTED_ORDERED_IDS_SHA256,
        "ordered real Vero IDs changed",
    )
    return selected


def build_descriptor(tasks: list[SourceTask]) -> dict:
    ids = [task.id for task in tasks]
    _require(len(ids) == EXPECTED_COUNT, "descriptor requires exactly 44 tasks")
    _require(
        ordered_ids_sha256(ids) == EXPECTED_ORDERED_IDS_SHA256,
        "descriptor task order does not match the frozen campaign",
    )
    return {
        "schema_version": 1,
        "kind": "v2_migrated_benchmark_campaign",
        "name": CAMPAIGN_NAME,
        "source": {
            "upstream_url": UPSTREAM_URL,
            "upstream_revision": UPSTREAM_REVISION,
            "upstream_tree": UPSTREAM_TREE,
            "v2_registry": "benchmarks/campaigns/formal-benchmark-campaign-v1.campaign.json",
            "selection": "lexically ordered conf/benchmark/*.yaml IDs, excluding bankledger exemplar and tiny_unsat fixture",
        },
        "track": "proof",
        "lean_toolchain": LEAN_TOOLCHAIN,
        "dataset_identity": {
            "independent_campaign": True,
            "not_a_substitute_for": "tasks/verobench_124",
        },
        "task_count": EXPECTED_COUNT,
        "ordered_ids": ids,
        "ordered_ids_sha256": EXPECTED_ORDERED_IDS_SHA256,
        "excluded": [
            {"id": source_id, "role": EXCLUDED_ROLES[source_id]}
            for source_id in EXCLUDED_IDS
        ],
        "grader": {
            "adapter": "vero/harbor_grade.py",
            "native_lifecycle": [
                "schema_driven_extract",
                "fresh_render_from_frozen_benchmark",
                "fresh_harness_build",
                "per_theorem_axiom_audit",
                "native_spec_aggregation",
            ],
            "fail_closed": True,
        },
        "harbor": {
            "schema_version": "1.3",
            "default_materialized_view": DEFAULT_OUTPUT.as_posix(),
            "base_image": BASE_IMAGE,
        },
        "tasks": {task.id: asdict(task) for task in tasks},
    }


def verify_descriptor(path: Path) -> dict:
    payload = _load_object(path)
    _require(payload.get("schema_version") == 1, "unsupported Vero descriptor schema")
    _require(payload.get("name") == CAMPAIGN_NAME, "Vero descriptor name changed")
    _require(payload.get("track") == "proof", "Vero campaign is not proof mode")
    _require(
        payload.get("lean_toolchain") == LEAN_TOOLCHAIN, "Vero Lean toolchain changed"
    )
    _require(
        payload.get("dataset_identity")
        == {
            "independent_campaign": True,
            "not_a_substitute_for": "tasks/verobench_124",
        },
        "the 44-instance Vero campaign must not be replaced by verobench_124",
    )
    _require(payload.get("task_count") == EXPECTED_COUNT, "Vero task count changed")
    source = payload.get("source", {})
    _require(source.get("upstream_url") == UPSTREAM_URL, "Vero upstream URL changed")
    _require(
        source.get("upstream_revision") == UPSTREAM_REVISION,
        "Vero upstream revision changed",
    )
    _require(source.get("upstream_tree") == UPSTREAM_TREE, "Vero upstream tree changed")
    ids = payload.get("ordered_ids")
    _require(isinstance(ids, list), "Vero ordered_ids is missing")
    _require(
        len(ids) == EXPECTED_COUNT and len(set(ids)) == EXPECTED_COUNT, "bad Vero IDs"
    )
    _require(
        ordered_ids_sha256(ids) == EXPECTED_ORDERED_IDS_SHA256,
        "Vero ordered IDs/hash mismatch",
    )
    _require(
        not (set(ids) & set(EXCLUDED_IDS)), "excluded Vero fixture/exemplar leaked"
    )
    excluded = payload.get("excluded")
    _require(
        excluded
        == [
            {"id": source_id, "role": EXCLUDED_ROLES[source_id]}
            for source_id in EXCLUDED_IDS
        ],
        "Vero exclusion evidence changed",
    )
    grader = payload.get("grader", {})
    _require(grader.get("adapter") == "vero/harbor_grade.py", "native adapter changed")
    _require(grader.get("fail_closed") is True, "Vero grader must fail closed")
    _require(
        grader.get("native_lifecycle")
        == [
            "schema_driven_extract",
            "fresh_render_from_frozen_benchmark",
            "fresh_harness_build",
            "per_theorem_axiom_audit",
            "native_spec_aggregation",
        ],
        "Vero native grading lifecycle changed",
    )
    tasks = payload.get("tasks")
    _require(
        isinstance(tasks, dict) and list(tasks) == ids, "Vero task map/order changed"
    )
    for source_id, task in tasks.items():
        _require(
            isinstance(task, dict) and task.get("id") == source_id,
            f"bad task: {source_id}",
        )
        _require(
            re.fullmatch(r"[0-9a-f]{64}", str(task.get("snapshot_sha256", "")))
            is not None,
            f"bad native snapshot digest: {source_id}",
        )
    return payload


def _task_toml(source_id: str) -> str:
    return f'''schema_version = "1.3"

[task]
name = "codeprover/vero-proof-44/{source_id}"
description = "Vero repository-level proof task: {source_id}"
keywords = ["lean4", "repository-level", "vero", "proof"]

[metadata]
source_id = "vero/{source_id}"
source_dataset = "vero-proof-44"
upstream_revision = "{UPSTREAM_REVISION}"
lean_toolchain = "{LEAN_TOOLCHAIN}"

[agent]
timeout_sec = 3600.0

[verifier]
timeout_sec = 7200.0

[environment]
build_timeout_sec = 7200.0

[[environment.mcp_servers]]
name = "lean-lsp"
transport = "stdio"
command = "/usr/local/bin/lean-mcp"
'''


def _instruction(source_id: str) -> str:
    return f"""Solve the frozen Vero proof-mode instance `{source_id}` in `/task`.

First read `/task/INSTRUCTION.md`; it is the upstream Vero instruction generated
for this exact benchmark. Work only in the marker slots it declares editable.
The reference implementation is supplied: for every spec, fill exactly one of
its `prove_*` or `disprove_*` proof bodies.

The hidden Harbor verifier uses upstream Vero at `{UPSTREAM_REVISION}`. It
extracts the expected slots from your workspace, discards edits outside that
schedule by rendering a fresh project from the frozen benchmark, builds the
fresh Harness, and performs Vero's per-theorem axiom audit. The task passes only
when all native spec results pass. Do not modify `/opt/vero`.
"""


def _dockerfile(task: dict) -> str:
    benchmark = task["benchmark_path"]
    root_package = task["root_package"]
    return f'''FROM {BASE_IMAGE}

RUN git clone {UPSTREAM_URL} /opt/vero \\
 && git -C /opt/vero checkout --detach {UPSTREAM_REVISION} \\
 && test "$(git -C /opt/vero rev-parse HEAD)" = "{UPSTREAM_REVISION}" \\
 && test "$(git -C /opt/vero rev-parse HEAD^{{tree}})" = "{UPSTREAM_TREE}"

RUN python3 -m pip install --no-cache-dir jinja2==3.1.6 loguru==0.7.2

RUN test "$(cat /opt/vero/{benchmark}/lean-toolchain)" = "{LEAN_TOOLCHAIN}" \\
 && cd /opt/vero/{benchmark} \\
 && lake update \\
 && lake build {root_package}.Harness

RUN PYTHONPATH=/opt/vero/src python3 -c "from pathlib import Path; from vero.generation.sandbox import create_sandbox; create_sandbox(Path('/opt/vero/{benchmark}'), Path('/task'), mode='proof')" \\
 && cd /task \\
 && lake build {root_package}.Harness
'''


def _test_shell(task: dict) -> str:
    return f"""#!/bin/bash
set -u
mkdir -p /logs/verifier
export PATH="/root/.elan/bin:/usr/local/bin:$PATH"
python3 /tests/grade.py \\
  --runtime /opt/vero \\
  --benchmark-relative {task["benchmark_path"]} \\
  --sandbox /task \\
  --expected-revision {UPSTREAM_REVISION} \\
  --expected-snapshot-sha256 {task["snapshot_sha256"]} \\
  --out-dir /logs/verifier \\
  --lake-timeout 3600
exit 0
"""


def materialize(descriptor_path: Path, vero_root: Path, output: Path) -> dict:
    descriptor = verify_descriptor(descriptor_path)
    audited = build_descriptor(audit_upstream(vero_root))
    _require(
        audited == descriptor, "live Vero source does not match committed descriptor"
    )
    _require(not output.exists(), f"materialized Vero view already exists: {output}")
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = Path(
        tempfile.mkdtemp(prefix=f".{output.name}.", dir=output.parent.resolve())
    )
    try:
        grader = (REPO_ROOT / "vero" / "harbor_grade.py").read_bytes()
        for source_id, task in descriptor["tasks"].items():
            task_dir = temporary / source_id
            (task_dir / "environment").mkdir(parents=True)
            (task_dir / "tests").mkdir()
            (task_dir / "task.toml").write_text(_task_toml(source_id), encoding="utf-8")
            (task_dir / "instruction.md").write_text(
                _instruction(source_id), encoding="utf-8"
            )
            (task_dir / "environment" / "Dockerfile").write_text(
                _dockerfile(task), encoding="utf-8"
            )
            test_script = task_dir / "tests" / "test.sh"
            test_script.write_text(_test_shell(task), encoding="utf-8")
            test_script.chmod(0o755)
            (task_dir / "tests" / "grade.py").write_bytes(grader)
        (temporary / "materialization.json").write_text(
            json.dumps(
                {
                    "schema_version": 1,
                    "campaign": CAMPAIGN_NAME,
                    "descriptor_sha256": hashlib.sha256(
                        descriptor_path.read_bytes()
                    ).hexdigest(),
                    "task_count": EXPECTED_COUNT,
                    "ordered_ids_sha256": EXPECTED_ORDERED_IDS_SHA256,
                    "generated": True,
                    "git_tracked": False,
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        temporary.rename(output)
    finally:
        if temporary.exists():
            shutil.rmtree(temporary)
    return descriptor


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    capture = sub.add_parser(
        "capture", help="audit upstream and write the frozen descriptor"
    )
    capture.add_argument("--vero-root", type=Path)
    capture.add_argument("--descriptor-out", type=Path, default=DEFAULT_DESCRIPTOR)
    verify = sub.add_parser("verify", help="verify the committed descriptor")
    verify.add_argument("--descriptor", type=Path, default=DEFAULT_DESCRIPTOR)
    make = sub.add_parser("materialize", help="generate the ignored Harbor task view")
    make.add_argument("--vero-root", type=Path)
    make.add_argument("--descriptor", type=Path, default=DEFAULT_DESCRIPTOR)
    make.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    return parser


def main() -> int:
    args = _parser().parse_args()
    try:
        if args.command == "capture":
            target = args.descriptor_out.resolve()
            _require(not target.exists(), f"descriptor already exists: {target}")
            payload = build_descriptor(audit_upstream(_source_root(args.vero_root)))
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(
                json.dumps(payload, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
            verify_descriptor(target)
        elif args.command == "verify":
            payload = verify_descriptor(args.descriptor.resolve())
        else:
            payload = materialize(
                args.descriptor.resolve(),
                _source_root(args.vero_root),
                args.output.resolve(),
            )
    except (MigrationError, OSError, KeyError, subprocess.SubprocessError) as exc:
        print(f"FATAL: {exc}", file=sys.stderr)
        return 1
    print(
        json.dumps(
            {
                "name": payload["name"],
                "task_count": payload["task_count"],
                "ordered_ids_sha256": payload["ordered_ids_sha256"],
                "lean_toolchain": payload["lean_toolchain"],
            },
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
