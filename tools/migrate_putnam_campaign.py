#!/usr/bin/env python3
"""Attest and locally materialize the frozen V2 PutnamBench Lean-4.28 track.

PutnamBench's official Lean sources contain an answer ``abbrev`` for 346
tasks.  The benchmark's proof-only track deterministically substitutes that
published answer into the theorem statement and removes the abbrev, leaving
one proof ``sorry``.  This tool reproduces that rewrite and wraps only the
proof hole in V3 verifier markers.

The V2 checkout is an untrusted, read-only input.  ``materialize`` fails closed
on the campaign registry, upstream Git revision, ordered task IDs, source and
rewritten content hashes, rewrite script, and the aligned Lean 4.28 Lake
evidence *before* writing an ignored local Harbor dataset view.  ``verify``
needs only the small committed descriptor and evidence; generated tasks are
never required in Git.
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
import tomllib
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from tools import benchmark_paths  # noqa: E402
from tools import dataset as dataset_tool  # noqa: E402


CAMPAIGN_NAME = "formal-benchmark-campaign-v1"
BENCHMARK_NAME = "putnambench"
DATASET_NAME = "putnambench_672"
DESCRIPTOR_NAME = "putnambench-aligned-lean428-672"
LEAN_PROFILE = "lean4.28-mathlib4.28"
EXPECTED_UPSTREAM_REVISION = "a23d8e6d4e9e3418fd78f76de7bfcb9414cbfd39"
EXPECTED_TASK_COUNT = 672
EXPECTED_ORDERED_IDS_SHA256 = (
    "2decb1f22757d868241e6f0f31a09c2c70beec9e9fe7353f0b529f6223a460e7"
)
EXPECTED_SOURCE_CONTENT_SHA256 = (
    "033f9ed20393e9c16ee4ad86ddc7a151e0c1e859aeb79eff1374e817d2494a9a"
)
EXPECTED_REWRITTEN_CONTENT_SHA256 = (
    "a72e9042bdb7d8c36bf40d7f2543a0586c83000aa869b52b105ea8efa0aef2f1"
)
EXPECTED_REGISTRY_SHA256 = (
    "19b313cca1207d8aa3223d8e84f158414aaa637ab66a864dc325927a8d21382d"
)
EXPECTED_REWRITE_SCRIPT_SHA256 = (
    "093b598c8b47ad8da0708788fc4a82f325529eae10c80cf353a8854a128ccd68"
)
EXPECTED_LAKE_MANIFEST_SHA256 = (
    "b9eeecc255e70766072eef4c3558d97afef7dc694026b3c12d2bca693e582b53"
)
EXPECTED_LAKEFILE_SHA256 = (
    "9b5ab1b893bca717b7582cfe31bfd39233665325f30658f61e20462831caad7a"
)
EXPECTED_TOOLCHAIN_SHA256 = (
    "db7bb24b756d745bbde83fe92718b51bd3625dae3701ba0f598d0eedcd3f3028"
)
EXPECTED_MATHLIB_REVISION = "8f9d9cff6bd728b17a24e163c9402775d9e6a365"
EXPECTED_FINAL_AUDIT_SHA256 = (
    "db3254b6bc5db03cc57059c0990eacf131ec39248770c760c53e84b3d7b2f9be"
)
EXPECTED_DATASET_CONTENT_SHA256 = (
    "b4feea21ab7b0c5fa6726687938e7ca18495aaa466ad481f46308a7cfb9bd294"
)
DEFAULT_DESCRIPTOR = Path("migration/v2/putnambench-aligned-lean428-672.json")
DEFAULT_OUTPUT = benchmark_paths.default_view("putnambench")
DEFAULT_MATERIALIZED_VIEW = DEFAULT_OUTPUT.relative_to(REPO_ROOT)

_ABBREV_RE = re.compile(r".*?:\s*(.*)\s*:=\s*sorry\n")
_START_MARKER = "-- !benchmark @start proof"
_END_MARKER = "-- !benchmark @end proof"


class MigrationError(RuntimeError):
    """A frozen input or V3 invariant did not match."""


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    try:
        return sha256_bytes(path.read_bytes())
    except OSError as exc:
        raise MigrationError(f"cannot read {path}: {exc}") from exc


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise MigrationError(message)


def _load_json(path: Path) -> dict:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise MigrationError(f"cannot read JSON {path}: {exc}") from exc
    _require(isinstance(value, dict), f"expected a JSON object: {path}")
    return value


def _git_head(repo: Path) -> str:
    try:
        result = subprocess.run(
            ["git", "-C", str(repo), "rev-parse", "HEAD"],
            check=True,
            capture_output=True,
            text=True,
            timeout=30,
        )
    except (OSError, subprocess.CalledProcessError, subprocess.TimeoutExpired) as exc:
        raise MigrationError(
            f"cannot resolve upstream Git revision at {repo}: {exc}"
        ) from exc
    return result.stdout.strip()


def _content_hash(items: list[tuple[str, bytes]]) -> str:
    return sha256_bytes(
        "".join(
            f"{task_id} {sha256_bytes(content)}\n" for task_id, content in items
        ).encode()
    )


def _ordered_ids_hash(task_ids: list[str]) -> str:
    return sha256_bytes(("\n".join(task_ids) + "\n").encode())


def rewrite_numeric_answer(source: str) -> str:
    """Reproduce PutnamBench ``rewrite_solutions.py`` without writing V2.

    The deliberately narrow parser matches the frozen upstream script.  Any
    future source shape change fails instead of inventing a new statement.
    """
    lines = source.splitlines(keepends=True)
    solutions: dict[str, tuple[str, str]] = {}
    for index, line in enumerate(lines):
        if "abbrev" not in line:
            continue
        words = line.split(" ")
        try:
            name = words[words.index("abbrev") + 1].strip()
        except (ValueError, IndexError) as exc:
            raise MigrationError(
                f"cannot parse solution abbrev: {line.rstrip()}"
            ) from exc
        _require(index + 1 < len(lines), f"missing published answer after {name}")
        answer_line = lines[index + 1]
        _require("--" in answer_line, f"missing published answer comment after {name}")
        answer = answer_line.split("--", 1)[1].strip().replace("\n", "")
        match = _ABBREV_RE.fullmatch(line)
        _require(match is not None, f"cannot parse solution type for {name}")
        if answer.startswith("(") and answer.endswith(")"):
            answer = answer[1:-1]
        # The frozen generated campaign strips the capture's trailing space
        # before formatting the replacement (the checked-in script's greedy
        # regex otherwise retains the space immediately before ``:=``).
        solutions[name] = (answer, match.group(1).strip())

    output: list[str] = []
    for line in lines:
        if "abbrev" in line:
            continue
        for name, (answer, answer_type) in solutions.items():
            if name in line:
                line = line.replace(name, f"(({answer}) : {answer_type} )")
        output.append(line)
    return "".join(output)


def add_proof_markers(rewritten: str) -> str:
    """Wrap the one proof hole while leaving every proposition token intact."""
    _require(
        _START_MARKER not in rewritten, "source unexpectedly already has proof markers"
    )
    lines = rewritten.splitlines(keepends=True)
    candidates = [(index, line) for index, line in enumerate(lines) if "sorry" in line]
    _require(
        len(candidates) == 1, "rewritten Putnam task must contain exactly one sorry"
    )
    index, line = candidates[0]
    _require(line.count("sorry") == 1, "proof line contains multiple sorry tokens")
    prefix, suffix = line.split("sorry", 1)
    _require(not suffix.strip(), "unexpected content after proof sorry")
    if not prefix.strip():
        indent = prefix
        replacement = [
            f"{indent}{_START_MARKER}\n",
            f"{indent}sorry\n",
            f"{indent}{_END_MARKER}\n",
        ]
    else:
        _require(prefix.rstrip().endswith(":="), "sorry is not a theorem proof body")
        statement_prefix = prefix.rstrip()
        replacement = [
            f"{statement_prefix}\n",
            f"  {_START_MARKER}\n",
            "  sorry\n",
            f"  {_END_MARKER}\n",
        ]
    return "".join(lines[:index] + replacement + lines[index + 1 :])


def readonly_projection(source: str) -> str:
    """Return the verifier-equivalent read-only projection for one proof marker."""
    lines = source.splitlines(keepends=True)
    output: list[str] = []
    inside = False
    starts = ends = 0
    for line in lines:
        if line.strip() == _START_MARKER:
            _require(not inside, "nested proof marker")
            inside = True
            starts += 1
            output.append(line)
            output.append("__CODE_PROVER_EDITABLE_SECTION__:proof\n")
        elif line.strip() == _END_MARKER:
            _require(inside, "proof end marker without start")
            inside = False
            ends += 1
            output.append(line)
        elif not inside:
            output.append(line)
    _require(
        not inside and starts == ends == 1, "expected exactly one proof marker pair"
    )
    return "".join(output)


def _source_records(source_dir: Path) -> list[tuple[str, bytes, bytes, bytes]]:
    files = sorted(source_dir.glob("*.lean"))
    task_ids = [path.stem for path in files]
    _require(len(files) == EXPECTED_TASK_COUNT, "Putnam source count is not 672")
    _require(
        _ordered_ids_hash(task_ids) == EXPECTED_ORDERED_IDS_SHA256,
        "ordered Putnam IDs do not match the frozen campaign",
    )
    source_items = [(path.stem, path.read_bytes()) for path in files]
    _require(
        _content_hash(source_items) == EXPECTED_SOURCE_CONTENT_SHA256,
        "official Putnam source content hash mismatch",
    )

    records = []
    rewritten_items = []
    for task_id, source_bytes in source_items:
        try:
            source = source_bytes.decode("utf-8")
        except UnicodeDecodeError as exc:
            raise MigrationError(f"source is not UTF-8: {task_id}") from exc
        rewritten = rewrite_numeric_answer(source).encode()
        task_spec = add_proof_markers(rewritten.decode()).encode()
        rewritten_items.append((task_id, rewritten))
        records.append((task_id, source_bytes, rewritten, task_spec))
    _require(
        _content_hash(rewritten_items) == EXPECTED_REWRITTEN_CONTENT_SHA256,
        "numeric-answer rewrite content hash mismatch",
    )
    return records


def _validate_lake_evidence(
    compat_dir: Path,
    *,
    lake_manifest_name: str = "lake-manifest.json",
    lakefile_name: str = "lakefile.lean",
    toolchain_name: str = "lean-toolchain",
) -> dict[str, Path]:
    paths = {
        "lake_manifest": compat_dir / lake_manifest_name,
        "lakefile": compat_dir / lakefile_name,
        "toolchain": compat_dir / toolchain_name,
    }
    expected = {
        "lake_manifest": EXPECTED_LAKE_MANIFEST_SHA256,
        "lakefile": EXPECTED_LAKEFILE_SHA256,
        "toolchain": EXPECTED_TOOLCHAIN_SHA256,
    }
    for name, path in paths.items():
        _require(sha256_file(path) == expected[name], f"Lean 4.28 {name} hash mismatch")
    manifest = _load_json(paths["lake_manifest"])
    packages = manifest.get("packages")
    _require(isinstance(packages, list), "bad Lean 4.28 Lake manifest")
    mathlib = next(
        (
            item
            for item in packages
            if isinstance(item, dict) and item.get("name") == "mathlib"
        ),
        None,
    )
    _require(isinstance(mathlib, dict), "mathlib missing from Lean 4.28 Lake manifest")
    _require(
        mathlib.get("inputRev") == "v4.28.0", "mathlib input revision is not v4.28.0"
    )
    _require(
        mathlib.get("rev") == EXPECTED_MATHLIB_REVISION,
        "mathlib resolved revision mismatch",
    )
    _require(
        paths["toolchain"].read_text(encoding="utf-8").strip()
        == "leanprover/lean4:v4.28.0",
        "Lean toolchain is not v4.28.0",
    )
    return paths


def _validate_v2(
    v2_root: Path,
) -> tuple[list[tuple[str, bytes, bytes, bytes]], dict, dict[str, Path]]:
    upstream = v2_root / "benchmarks/PutnamBench"
    _require(
        _git_head(upstream) == EXPECTED_UPSTREAM_REVISION,
        "Putnam upstream revision mismatch",
    )
    registry_path = (
        v2_root / "benchmarks/campaigns/formal-benchmark-campaign-v1.campaign.json"
    )
    _require(
        sha256_file(registry_path) == EXPECTED_REGISTRY_SHA256,
        "campaign registry hash mismatch",
    )
    registry = _load_json(registry_path)
    _require(registry.get("name") == CAMPAIGN_NAME, "campaign name mismatch")
    entry = registry.get("benchmarks", {}).get(BENCHMARK_NAME, {})
    _require(
        entry.get("revision") == EXPECTED_UPSTREAM_REVISION,
        "registry revision mismatch",
    )
    _require(
        entry.get("record_count") == EXPECTED_TASK_COUNT, "registry task count mismatch"
    )
    _require(
        entry.get("ordered_ids_sha256") == EXPECTED_ORDERED_IDS_SHA256,
        "registry ordered-ID hash mismatch",
    )
    aligned = entry.get("lean_tracks", {}).get("aligned-lean428", {})
    _require(
        aligned.get("overlay_count") == 0,
        "Putnam Lean 4.28 track unexpectedly has overlays",
    )
    _require(
        aligned.get("final_audit") == "672/672", "Putnam Lean 4.28 audit is incomplete"
    )
    _require(
        aligned.get("final_audit_sha256") == EXPECTED_FINAL_AUDIT_SHA256,
        "Putnam Lean 4.28 audit hash mismatch",
    )
    _require(
        aligned.get("lake_manifest_sha256") == EXPECTED_LAKE_MANIFEST_SHA256,
        "registry Lake manifest hash mismatch",
    )
    rewrite_script = upstream / "lean4/scripts/rewrite_solutions.py"
    _require(
        sha256_file(rewrite_script) == EXPECTED_REWRITE_SCRIPT_SHA256,
        "numeric-answer rewrite script hash mismatch",
    )
    records = _source_records(upstream / "lean4/src")
    evidence = _validate_lake_evidence(
        v2_root / "benchmarks/compatibility/PutnamBench/lean428"
    )
    evidence["registry"] = registry_path
    return records, registry, evidence


def _task_metadata(task_dir: Path) -> dict:
    try:
        return tomllib.loads((task_dir / "task.toml").read_text(encoding="utf-8"))
    except (OSError, tomllib.TOMLDecodeError) as exc:
        raise MigrationError(f"cannot parse {task_dir / 'task.toml'}: {exc}") from exc


def _descriptor_artifact(descriptor_path: Path, filename: object, label: str) -> Path:
    _require(isinstance(filename, str) and filename, f"descriptor {label} missing")
    path = (descriptor_path.parent / filename).resolve()
    _require(
        path.parent == descriptor_path.parent.resolve(),
        f"descriptor {label} must be a sibling artifact",
    )
    return path


def _require_digest(value: object, label: str) -> str:
    _require(
        isinstance(value, str)
        and len(value) == 64
        and all(character in "0123456789abcdef" for character in value),
        f"bad SHA-256 digest: {label}",
    )
    return value


def _hash_task_digests(tasks: dict, field: str) -> str:
    return sha256_bytes(
        "".join(
            f"{task_id} {_require_digest(item.get(field), f'{task_id}.{field}')}\n"
            for task_id, item in tasks.items()
        ).encode()
    )


def _dataset_content_hash(tasks: dict) -> str:
    return sha256_bytes(
        "".join(
            f"{task_id} {_require_digest(tasks[task_id].get('spec_sha256'), f'{task_id}.spec_sha256')}\n"
            for task_id in sorted(tasks)
        ).encode()
    )


def verify_descriptor(descriptor_path: Path) -> dict:
    """Verify only committed Putnam descriptor and provenance evidence."""
    descriptor = _load_json(descriptor_path)
    _require(descriptor.get("schema_version") == 1, "unsupported descriptor schema")
    _require(
        descriptor.get("kind") == "v2_migrated_benchmark_campaign",
        "descriptor kind mismatch",
    )
    _require(descriptor.get("name") == DESCRIPTOR_NAME, "descriptor name mismatch")
    _require(
        descriptor.get("task_count") == EXPECTED_TASK_COUNT,
        "descriptor task count mismatch",
    )
    _require(
        descriptor.get("statement_overlay_count") == 0, "unexpected statement overlays"
    )
    _require(descriptor.get("lean_profile") == LEAN_PROFILE, "Lean profile mismatch")
    _require(descriptor.get("track") == "proof-only", "Putnam track mismatch")
    _require(
        descriptor.get("leaderboard_comparable") is False,
        "aligned Putnam track must not claim leaderboard comparability",
    )
    source = descriptor.get("source_campaign", {})
    _require(source.get("name") == CAMPAIGN_NAME, "source campaign name mismatch")
    _require(
        source.get("upstream_revision") == EXPECTED_UPSTREAM_REVISION,
        "descriptor upstream revision mismatch",
    )
    _require(
        source.get("ordered_ids_sha256") == EXPECTED_ORDERED_IDS_SHA256,
        "descriptor ordered-ID hash mismatch",
    )
    _require(
        source.get("source_content_sha256") == EXPECTED_SOURCE_CONTENT_SHA256,
        "descriptor source content hash mismatch",
    )
    _require(
        source.get("rewritten_content_sha256") == EXPECTED_REWRITTEN_CONTENT_SHA256,
        "descriptor rewritten content hash mismatch",
    )
    _require(
        source.get("rewrite_script_sha256") == EXPECTED_REWRITE_SCRIPT_SHA256,
        "descriptor rewrite script hash mismatch",
    )
    _require(
        source.get("registry_sha256") == EXPECTED_REGISTRY_SHA256,
        "descriptor registry hash mismatch",
    )

    registry_path = _descriptor_artifact(
        descriptor_path, source.get("registry_file"), "registry file"
    )
    _require(
        sha256_file(registry_path) == EXPECTED_REGISTRY_SHA256,
        "committed registry hash mismatch",
    )
    registry = _load_json(registry_path)
    _require(registry.get("name") == CAMPAIGN_NAME, "committed campaign name mismatch")
    entry = registry.get("benchmarks", {}).get(BENCHMARK_NAME, {})
    _require(
        source.get("upstream_url") == entry.get("upstream_url"),
        "descriptor upstream URL mismatch",
    )
    _require(
        source.get("selection") == entry.get("selection"),
        "descriptor selection mismatch",
    )
    _require(
        entry.get("revision") == EXPECTED_UPSTREAM_REVISION,
        "committed registry revision mismatch",
    )
    _require(
        entry.get("record_count") == EXPECTED_TASK_COUNT,
        "committed registry count mismatch",
    )
    _require(
        entry.get("ordered_ids_sha256") == EXPECTED_ORDERED_IDS_SHA256,
        "committed registry ordered-ID hash mismatch",
    )
    _require(entry.get("track") == "proof-only", "committed registry track mismatch")
    aligned = entry.get("lean_tracks", {}).get("aligned-lean428", {})
    _require(aligned.get("overlay_count") == 0, "committed registry overlay mismatch")
    _require(
        aligned.get("lake_manifest_sha256") == EXPECTED_LAKE_MANIFEST_SHA256,
        "committed registry Lake hash mismatch",
    )
    _require(aligned.get("final_audit") == "672/672", "committed audit incomplete")
    _require(
        aligned.get("final_audit_sha256") == EXPECTED_FINAL_AUDIT_SHA256,
        "committed audit hash mismatch",
    )
    _require(
        aligned.get("leaderboard_comparable") is False,
        "committed aligned track comparability mismatch",
    )

    lake = descriptor.get("lean428_evidence", {})
    evidence_expected = {
        "toolchain": EXPECTED_TOOLCHAIN_SHA256,
        "lakefile": EXPECTED_LAKEFILE_SHA256,
        "lake_manifest": EXPECTED_LAKE_MANIFEST_SHA256,
    }
    for name, expected_hash in evidence_expected.items():
        filename = lake.get(f"{name}_file")
        _require(
            lake.get(f"{name}_sha256") == expected_hash,
            f"descriptor {name} hash mismatch",
        )
        _require(
            sha256_file(_descriptor_artifact(descriptor_path, filename, f"{name} file"))
            == expected_hash,
            f"committed {name} hash mismatch",
        )
    _require(
        lake.get("mathlib_revision") == EXPECTED_MATHLIB_REVISION,
        "mathlib evidence mismatch",
    )
    _require(
        lake.get("baseline_audit") == "672/672", "baseline audit evidence mismatch"
    )
    _require(
        lake.get("baseline_audit_sha256") == EXPECTED_FINAL_AUDIT_SHA256,
        "baseline audit hash mismatch",
    )
    _validate_lake_evidence(
        descriptor_path.parent,
        lake_manifest_name=str(lake["lake_manifest_file"]),
        lakefile_name=str(lake["lakefile_file"]),
        toolchain_name=str(lake["toolchain_file"]),
    )

    dataset = descriptor.get("dataset", {})
    _require(
        dataset.get("default_materialized_view")
        == DEFAULT_MATERIALIZED_VIEW.as_posix(),
        "default materialized Putnam view mismatch",
    )
    _require(
        dataset.get("content_sha256") == EXPECTED_DATASET_CONTENT_SHA256,
        "descriptor dataset content hash mismatch",
    )
    tasks = descriptor.get("tasks")
    _require(
        isinstance(tasks, dict) and len(tasks) == EXPECTED_TASK_COUNT, "bad task map"
    )
    _require(
        _ordered_ids_hash(list(tasks)) == EXPECTED_ORDERED_IDS_SHA256,
        "descriptor task order/IDs changed",
    )
    for task_id, item in tasks.items():
        _require(isinstance(item, dict), f"bad task entry: {task_id}")
        _require(item.get("task_name") == task_id, f"task name mismatch: {task_id}")
        _require(
            item.get("source_id") == f"putnambench/{task_id}",
            f"source ID mismatch: {task_id}",
        )
        for field in (
            "official_source_sha256",
            "rewritten_source_sha256",
            "readonly_projection_sha256",
            "spec_sha256",
        ):
            _require_digest(item.get(field), f"{task_id}.{field}")
    _require(
        _hash_task_digests(tasks, "official_source_sha256")
        == EXPECTED_SOURCE_CONTENT_SHA256,
        "source task hash aggregate mismatch",
    )
    _require(
        _hash_task_digests(tasks, "rewritten_source_sha256")
        == EXPECTED_REWRITTEN_CONTENT_SHA256,
        "rewritten task hash aggregate mismatch",
    )
    _require(
        _dataset_content_hash(tasks) == EXPECTED_DATASET_CONTENT_SHA256,
        "task spec hash aggregate mismatch",
    )
    return descriptor


def _validate_records_against_descriptor(
    records: list[tuple[str, bytes, bytes, bytes]], descriptor: dict
) -> None:
    tasks = descriptor["tasks"]
    _require(
        len(records) == EXPECTED_TASK_COUNT, "audited Putnam record count mismatch"
    )
    _require(
        [record[0] for record in records] == list(tasks),
        "audited Putnam task order differs from descriptor",
    )
    for task_id, source, rewritten, task_spec in records:
        item = tasks[task_id]
        _require(
            sha256_bytes(source) == item["official_source_sha256"],
            f"audited official source differs from descriptor: {task_id}",
        )
        _require(
            sha256_bytes(rewritten) == item["rewritten_source_sha256"],
            f"audited rewrite differs from descriptor: {task_id}",
        )
        _require(
            sha256_bytes(task_spec) == item["spec_sha256"],
            f"generated task differs from descriptor: {task_id}",
        )
        try:
            projection = readonly_projection(task_spec.decode()).encode()
        except UnicodeDecodeError as exc:
            raise MigrationError(f"generated task is not UTF-8: {task_id}") from exc
        _require(
            sha256_bytes(projection) == item["readonly_projection_sha256"],
            f"generated read-only projection differs from descriptor: {task_id}",
        )


def verify_materialized_dataset(descriptor: dict, dataset: Path) -> dict:
    """Validate a generated local view, including every verifier mirror."""
    current = dataset_tool.build_manifest(dataset)
    _require(
        current["task_count"] == EXPECTED_TASK_COUNT, "dataset task count mismatch"
    )
    _require(
        current["content_sha256"] == descriptor["dataset"]["content_sha256"],
        "dataset content hash mismatch",
    )
    _require(not dataset_tool.manifest_issues(dataset), "dataset manifest mismatch")
    tasks = descriptor["tasks"]
    _require(set(current["tasks"]) == set(tasks), "materialized task IDs mismatch")
    for task_id, item in tasks.items():
        task_dir = dataset / task_id
        task_spec = (task_dir / "environment/task.lean").read_bytes()
        _require(
            sha256_bytes(task_spec) == item["spec_sha256"],
            f"task spec mismatch: {task_id}",
        )
        _require(
            current["tasks"].get(task_id) == item["spec_sha256"],
            f"manifest task mismatch: {task_id}",
        )
        _require(
            (task_dir / "tests/original.lean").read_bytes() == task_spec,
            f"verifier mirror mismatch: {task_id}",
        )
        metadata = _task_metadata(task_dir).get("metadata", {})
        _require(
            metadata.get("source_dataset") == DATASET_NAME,
            f"source dataset mismatch: {task_id}",
        )
        _require(
            metadata.get("source_id") == f"putnambench/{task_id}",
            f"task metadata mismatch: {task_id}",
        )
        try:
            projection = readonly_projection(task_spec.decode()).encode()
        except UnicodeDecodeError as exc:
            raise MigrationError(f"task spec is not UTF-8: {task_id}") from exc
        _require(
            sha256_bytes(projection) == item["readonly_projection_sha256"],
            f"read-only statement projection mismatch: {task_id}",
        )
    return current


def materialize_campaign(
    v2_root: Path, descriptor_path: Path, output: Path
) -> tuple[dict, dict]:
    """Audit frozen source, then atomically create an ignored local dataset."""
    descriptor = verify_descriptor(descriptor_path)
    records, _registry, _evidence = _validate_v2(v2_root)
    _validate_records_against_descriptor(records, descriptor)
    _require(not output.exists(), f"materialized output already exists: {output}")

    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = Path(tempfile.mkdtemp(prefix=f".{output.name}.", dir=output.parent))
    try:
        for task_id, _source, _rewritten, task_spec in records:
            dataset_tool.write_task(
                temporary / task_id,
                task_id=task_id,
                source_id=f"putnambench/{task_id}",
                lean_source=task_spec.decode(),
                dataset_name=DATASET_NAME,
            )
        manifest = dataset_tool.write_manifest(temporary)
        # The temporary directory name is intentionally random.  Record the
        # stable local-view name before the atomic rename.
        manifest["name"] = output.name
        (temporary / dataset_tool.MANIFEST_NAME).write_text(
            json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        verified_manifest = verify_materialized_dataset(descriptor, temporary)
        _require(
            verified_manifest["content_sha256"] == EXPECTED_DATASET_CONTENT_SHA256,
            "generated Putnam content hash mismatch",
        )
        temporary.rename(output)
    finally:
        if temporary.exists():
            shutil.rmtree(temporary)
    return descriptor, manifest


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    materialize = sub.add_parser(
        "materialize", help="audit V2 and create an ignored 672-task local view"
    )
    roots = materialize.add_mutually_exclusive_group()
    roots.add_argument(
        "--v2-root",
        type=Path,
        help="read-only Code-Prover-V2 checkout containing benchmark evidence",
    )
    roots.add_argument(
        "--source-root",
        type=Path,
        help="alias for --v2-root",
    )
    materialize.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    materialize.add_argument("--descriptor", type=Path, default=DEFAULT_DESCRIPTOR)
    verify = sub.add_parser(
        "verify", help="verify committed descriptor/evidence without local task data"
    )
    verify.add_argument(
        "--descriptor",
        type=Path,
        default=DEFAULT_DESCRIPTOR,
    )
    return parser


def main() -> int:
    args = _parser().parse_args()
    materialized: tuple[Path, dict] | None = None
    try:
        if args.command == "materialize":
            source_root = benchmark_paths.resolve_source(
                BENCHMARK_NAME, args.v2_root or args.source_root
            )
            payload, manifest = materialize_campaign(
                source_root,
                args.descriptor.resolve(),
                args.output.resolve(),
            )
            materialized = (args.output.resolve(), manifest)
        else:
            payload = verify_descriptor(args.descriptor.resolve())
    except (MigrationError, OSError, KeyError, ValueError) as exc:
        print(f"FATAL: {exc}", file=sys.stderr)
        return 1
    summary = {
        "name": payload["name"],
        "task_count": payload["task_count"],
        "statement_overlay_count": payload["statement_overlay_count"],
        "dataset_content_sha256": payload["dataset"]["content_sha256"],
    }
    if materialized is not None:
        summary["materialized_path"] = str(materialized[0])
        summary["materialized_content_sha256"] = materialized[1]["content_sha256"]
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
