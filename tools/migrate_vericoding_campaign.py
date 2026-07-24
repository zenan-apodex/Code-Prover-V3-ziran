#!/usr/bin/env python3
"""Migrate and attest the frozen V2 Vericoding Lean 4.28 campaign.

The V2 campaign selects 2,012 tasks from the larger 6,368-task V3
``vericoding_lean`` dataset.  Of those selected tasks, 138 have a V2
manifest-bound Lean 4.28 compatibility overlay.  The canonical V3 dataset is
kept pristine: this tool writes a stable descriptor and materializes an ignored
campaign view on demand.  Unchanged tasks are symlinked into the view, while
the 138 overlay tasks are copied and patched there.

The source V2 checkout is treated as an untrusted input: all frozen counts and
hashes are checked before a view is written.  ``verify`` needs only committed
descriptor/evidence by default; pass ``--dataset`` to additionally audit a
local pristine canonical V3 dataset.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import shutil
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
BENCHMARK_NAME = "vericoding"
DATASET_NAME = "vericoding_lean"
LEAN_PROFILE = "lean4.28-mathlib4.28"
EXPECTED_UPSTREAM_REVISION = "387cd69996792d452ead7b0460f36ee4c5cdd148"
EXPECTED_SELECTION_COUNT = 2012
EXPECTED_SELECTION_SHA256 = (
    "0e38d8be5be248004e327d0fb9343518fb00715b6a9b28919c09ff05cb3fa7b0"
)
EXPECTED_SELECTION_CSV_SHA256 = (
    "bbfa7a3554f18f65effd9b0bf7abcdba860e73df3ac75d5a80cea593dc6cbabb"
)
EXPECTED_OVERLAY_COUNT = 138
EXPECTED_OVERLAY_MANIFEST_SHA256 = (
    "091cc6f3a8e26eb0a0e47ce31e4d4cf22ebb8f7558b1fc8d20b92d8301ad5950"
)
EXPECTED_PRE_MIGRATION_DATASET_SHA256 = (
    "77703fc08764334229b52a2a7e429949cd8eb42ad326e485d0e9da16439ccdf8"
)
EXPECTED_CANONICAL_TASK_COUNT = 6368
EXPECTED_CANONICAL_SELECTED_CONTENT_SHA256 = (
    "81aa51ac3e11874f6908f4d7ebb81d78290452ce00793a0765532a832416ca0b"
)
EXPECTED_FINAL_SELECTED_CONTENT_SHA256 = (
    "94ea94d3eba2e0da47a6c9c430d5eeaa228fe7b128c262bf57469c31e616017e"
)
EXPECTED_VIEW_CONTENT_SHA256 = (
    "6b0e33b3d7e0afece0381dcb1be26b675915f2fa0d2783f22195c57fab6ff656"
)
EXCLUDED_SOURCES = {"verina", "clever", "fvapps"}


class MigrationError(RuntimeError):
    """A frozen input or V3 invariant did not match."""


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def _load_json(path: Path) -> dict:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise MigrationError(f"cannot read JSON {path}: {exc}") from exc
    if not isinstance(value, dict):
        raise MigrationError(f"expected a JSON object: {path}")
    return value


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise MigrationError(message)


def _selected_rows(csv_path: Path) -> list[dict[str, str]]:
    _require(
        sha256_file(csv_path) == EXPECTED_SELECTION_CSV_SHA256,
        f"selection CSV hash mismatch: {csv_path}",
    )
    with csv_path.open(newline="", encoding="utf-8") as handle:
        rows = [
            row
            for row in csv.DictReader(handle)
            if row["language"] == "lean"
            and row["qa-issue"] == "0"
            and row["source"] not in EXCLUDED_SOURCES
        ]
    ids = [row["id"] for row in rows]
    ordered_hash = sha256_bytes(("\n".join(ids) + "\n").encode())
    _require(len(rows) == EXPECTED_SELECTION_COUNT, "selected task count is not 2,012")
    _require(
        ordered_hash == EXPECTED_SELECTION_SHA256,
        "ordered selected task IDs do not match the frozen campaign",
    )
    return rows


def _task_index(dataset: Path) -> dict[str, tuple[Path, str]]:
    index: dict[str, tuple[Path, str]] = {}
    for task_toml in sorted(dataset.glob("*/task.toml")):
        try:
            data = tomllib.loads(task_toml.read_text(encoding="utf-8"))
        except (OSError, tomllib.TOMLDecodeError) as exc:
            raise MigrationError(f"cannot parse {task_toml}: {exc}") from exc
        metadata = data.get("metadata", {})
        _require(
            metadata.get("source_dataset") == DATASET_NAME,
            f"unexpected source_dataset in {task_toml}",
        )
        source_id = metadata.get("source_id")
        _require(
            isinstance(source_id, str) and source_id.startswith("vericoding/"),
            f"unexpected source_id in {task_toml}",
        )
        source_tail = source_id.split("/", 1)[1]
        benchmark_id = source_tail.split("_", 1)[0]
        _require(benchmark_id not in index, f"duplicate Vericoding ID: {benchmark_id}")
        index[benchmark_id] = (task_toml.parent, source_id)
    return index


def _semantic_lines(source: str) -> list[str]:
    """Normalize only V3 exporter layout changes, not Lean expressions."""
    values = []
    for line in source.splitlines():
        stripped = line.rstrip()
        if not stripped or stripped == "import Mathlib":
            continue
        if stripped.startswith("-- <vc-") and stripped.endswith(">"):
            continue
        values.append(stripped)
    return values


def _v3_source(v2_source: str) -> str:
    """Wrap a V2 spec and normalize non-semantic trailing whitespace."""
    normalized = "\n".join(
        line.rstrip() for line in v2_source.rstrip("\n").splitlines()
    )
    return "import Mathlib\n\n" + normalized + "\n"


def _validate_v2_inputs(v2_root: Path) -> tuple[list[dict[str, str]], dict, dict]:
    campaign_path = (
        v2_root / "benchmarks/campaigns/formal-benchmark-campaign-v1.campaign.json"
    )
    campaign = _load_json(campaign_path)
    _require(campaign.get("name") == CAMPAIGN_NAME, "campaign name mismatch")
    entry = campaign.get("benchmarks", {}).get(BENCHMARK_NAME, {})
    _require(
        entry.get("revision") == EXPECTED_UPSTREAM_REVISION,
        "Vericoding upstream revision mismatch",
    )
    _require(
        entry.get("record_count") == EXPECTED_SELECTION_COUNT, "record count mismatch"
    )
    _require(
        entry.get("ordered_ids_sha256") == EXPECTED_SELECTION_SHA256,
        "campaign selected-ID hash mismatch",
    )
    aligned = entry.get("lean_tracks", {}).get("aligned-lean428", {})
    _require(
        aligned.get("overlay_count") == EXPECTED_OVERLAY_COUNT, "overlay count mismatch"
    )
    _require(
        aligned.get("migration_manifest_sha256") == EXPECTED_OVERLAY_MANIFEST_SHA256,
        "campaign overlay manifest hash mismatch",
    )

    benchmark_root = v2_root / "benchmarks/vericoding-benchmark"
    rows = _selected_rows(benchmark_root / "vericoding_benchmark_v1.csv")
    overlay_path = (
        v2_root
        / "benchmarks/compatibility/vericoding-benchmark/lean428/migration-manifest.json"
    )
    _require(
        sha256_file(overlay_path) == EXPECTED_OVERLAY_MANIFEST_SHA256,
        f"overlay manifest hash mismatch: {overlay_path}",
    )
    overlay = _load_json(overlay_path)
    _require(
        overlay.get("task_count") == EXPECTED_OVERLAY_COUNT,
        "overlay task count mismatch",
    )
    tasks = overlay.get("tasks")
    _require(
        isinstance(tasks, dict) and len(tasks) == EXPECTED_OVERLAY_COUNT,
        "bad overlay tasks",
    )
    selected_ids = {row["id"] for row in rows}
    _require(set(tasks) <= selected_ids, "overlay contains a task outside the campaign")
    for benchmark_id, item in tasks.items():
        _require(isinstance(item, dict), f"bad overlay entry: {benchmark_id}")
        original = benchmark_root / str(item.get("original_path"))
        replacement = (
            v2_root
            / "benchmarks/compatibility/vericoding-benchmark"
            / str(item.get("overlay_path"))
        )
        _require(
            sha256_file(original) == item.get("original_sha256"),
            f"original spec hash mismatch: {benchmark_id}",
        )
        _require(
            sha256_file(replacement) == item.get("overlay_sha256"),
            f"overlay spec hash mismatch: {benchmark_id}",
        )
    return rows, overlay, campaign


def _preflight(
    v2_root: Path, dataset: Path
) -> tuple[list[dict[str, str]], dict, dict, dict[str, tuple[Path, str]]]:
    rows, overlay, campaign = _validate_v2_inputs(v2_root)
    index = _task_index(dataset)
    selected_ids = [row["id"] for row in rows]
    missing = [
        benchmark_id for benchmark_id in selected_ids if benchmark_id not in index
    ]
    _require(not missing, f"V3 dataset is missing campaign tasks: {missing[:5]}")

    manifest = _load_json(dataset / dataset_tool.MANIFEST_NAME)
    _require(manifest.get("name") == DATASET_NAME, "V3 dataset manifest name mismatch")
    _require(manifest.get("lean_profile") == LEAN_PROFILE, "V3 Lean profile mismatch")
    _require(
        manifest.get("content_sha256") == EXPECTED_PRE_MIGRATION_DATASET_SHA256,
        "canonical V3 dataset is not the pinned pristine dataset",
    )
    manifest_issues = dataset_tool.manifest_issues(dataset)
    _require(
        not manifest_issues,
        f"V3 dataset does not match its manifest: {manifest_issues[:3]}",
    )
    manifest_tasks = manifest.get("tasks", {})
    for benchmark_id, item in overlay["tasks"].items():
        task_dir, _ = index[benchmark_id]
        current = (task_dir / "environment/task.lean").read_text(encoding="utf-8")
        original = (
            v2_root / "benchmarks/vericoding-benchmark" / item["original_path"]
        ).read_text(encoding="utf-8")
        replacement = (
            v2_root
            / "benchmarks/compatibility/vericoding-benchmark"
            / item["overlay_path"]
        ).read_text(encoding="utf-8")
        _require(
            _semantic_lines(current) == _semantic_lines(original),
            f"canonical V3 task diverged from the V2 original: {benchmark_id}",
        )
        _require(
            _semantic_lines(current) != _semantic_lines(replacement),
            f"overlay does not change the canonical V3 task: {benchmark_id}",
        )
        mirror = (task_dir / "tests/original.lean").read_text(encoding="utf-8")
        _require(mirror == current, f"verifier mirror mismatch: {benchmark_id}")
        _require(
            manifest_tasks.get(task_dir.name) == sha256_bytes(current.encode()),
            f"dataset manifest mismatch before migration: {benchmark_id}",
        )
    return rows, overlay, campaign, index


def _campaign_descriptor(
    *,
    rows: list[dict[str, str]],
    overlay: dict,
    campaign: dict,
    dataset: Path,
    index: dict[str, tuple[Path, str]],
    compatibility_root: Path,
    source_manifest_file: str,
    registry_file: str,
    registry_sha256: str,
) -> dict:
    dataset_manifest = _load_json(dataset / dataset_tool.MANIFEST_NAME)
    task_hashes = dataset_manifest["tasks"]
    selected: dict[str, dict[str, object]] = {}
    for row in rows:
        task_dir, source_id = index[row["id"]]
        overlay_item = overlay["tasks"].get(row["id"])
        final_spec_sha256 = task_hashes[task_dir.name]
        if overlay_item is not None:
            # The V2 manifest binds the source bytes.  The V3 view wraps those
            # bytes deterministically with its Mathlib import.
            final_spec_sha256 = sha256_bytes(
                _v3_source(
                    (compatibility_root / overlay_item["overlay_path"]).read_text(
                        encoding="utf-8"
                    )
                ).encode()
            )
        selected[row["id"]] = {
            "task_name": task_dir.name,
            "source_id": source_id,
            "source": row["source"],
            "source_record_id": row["source-id"],
            "spec_sha256": final_spec_sha256,
            "lean428_overlay": overlay_item is not None,
        }
        if overlay_item is not None:
            selected[row["id"]]["source_overlay_sha256"] = overlay_item[
                "overlay_sha256"
            ]
    canonical_selected_content_hash = sha256_bytes(
        "".join(
            f"{benchmark_id} {item['task_name']} {task_hashes[item['task_name']]}\n"
            for benchmark_id, item in selected.items()
        ).encode()
    )
    selected_content_hash = sha256_bytes(
        "".join(
            f"{benchmark_id} {item['task_name']} {item['spec_sha256']}\n"
            for benchmark_id, item in selected.items()
        ).encode()
    )
    view_content_hash = sha256_bytes(
        "".join(
            f"{item['task_name']} {item['spec_sha256']}\n"
            for item in sorted(selected.values(), key=lambda value: value["task_name"])
        ).encode()
    )
    entry = campaign["benchmarks"][BENCHMARK_NAME]
    return {
        "schema_version": 1,
        "kind": "v2_migrated_benchmark_campaign",
        "name": "vericoding-aligned-lean428-2012",
        "source_campaign": {
            "name": campaign["name"],
            "upstream_url": entry["upstream_url"],
            "upstream_revision": entry["revision"],
            "selection": entry["selection"],
            "ordered_ids_sha256": EXPECTED_SELECTION_SHA256,
            "selection_csv_sha256": EXPECTED_SELECTION_CSV_SHA256,
            "registry_file": registry_file,
            "registry_sha256": registry_sha256,
            "overlay_manifest_file": source_manifest_file,
            "overlay_manifest_sha256": EXPECTED_OVERLAY_MANIFEST_SHA256,
        },
        "track": entry["track"],
        "lean_profile": LEAN_PROFILE,
        "leaderboard_comparable": False,
        "task_count": EXPECTED_SELECTION_COUNT,
        "overlay_task_count": EXPECTED_OVERLAY_COUNT,
        "dataset": {
            "path": f"tasks/{dataset.name}",
            "task_count": dataset_manifest["task_count"],
            "content_sha256": dataset_manifest["content_sha256"],
            "canonical_selected_content_sha256": canonical_selected_content_hash,
            "selected_content_sha256": selected_content_hash,
            "view_content_sha256": view_content_hash,
        },
        "tasks": selected,
    }


def apply_migration(
    v2_root: Path,
    dataset: Path,
    descriptor_out: Path,
    source_manifest_out: Path,
    registry_out: Path,
) -> dict:
    _require(
        source_manifest_out.parent == descriptor_out.parent
        and registry_out.parent == descriptor_out.parent,
        "descriptor and copied V2 source artifacts must share one directory",
    )
    rows, overlay, campaign, index = _preflight(v2_root, dataset)
    compatibility_root = v2_root / "benchmarks/compatibility/vericoding-benchmark"
    source_manifest_input = compatibility_root / "lean428/migration-manifest.json"
    registry_input = (
        v2_root / "benchmarks/campaigns/formal-benchmark-campaign-v1.campaign.json"
    )
    source_manifest_out.parent.mkdir(parents=True, exist_ok=True)
    registry_out.parent.mkdir(parents=True, exist_ok=True)
    source_manifest_out.write_bytes(source_manifest_input.read_bytes())
    registry_out.write_bytes(registry_input.read_bytes())
    descriptor = _campaign_descriptor(
        rows=rows,
        overlay=overlay,
        campaign=campaign,
        dataset=dataset,
        index=index,
        compatibility_root=compatibility_root,
        source_manifest_file=source_manifest_out.name,
        registry_file=registry_out.name,
        registry_sha256=sha256_file(registry_input),
    )
    descriptor_out.parent.mkdir(parents=True, exist_ok=True)
    descriptor_out.write_text(
        json.dumps(descriptor, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    verify_descriptor(descriptor_out, dataset)
    return descriptor


def verify_descriptor(descriptor_path: Path, dataset: Path | None = None) -> dict:
    descriptor = _load_json(descriptor_path)
    _require(descriptor.get("schema_version") == 1, "unsupported descriptor schema")
    _require(
        descriptor.get("kind") == "v2_migrated_benchmark_campaign",
        "unexpected descriptor kind",
    )
    _require(
        descriptor.get("name") == "vericoding-aligned-lean428-2012",
        "unexpected descriptor name",
    )
    _require(
        descriptor.get("task_count") == EXPECTED_SELECTION_COUNT, "task count mismatch"
    )
    _require(
        descriptor.get("overlay_task_count") == EXPECTED_OVERLAY_COUNT,
        "overlay task count mismatch",
    )
    _require(descriptor.get("lean_profile") == LEAN_PROFILE, "Lean profile mismatch")
    _require(
        descriptor.get("leaderboard_comparable") is False,
        "migrated campaign must remain non-comparable",
    )
    source = descriptor.get("source_campaign", {})
    _require(source.get("name") == CAMPAIGN_NAME, "source campaign name mismatch")
    _require(
        source.get("upstream_revision") == EXPECTED_UPSTREAM_REVISION,
        "descriptor upstream revision mismatch",
    )
    _require(
        source.get("ordered_ids_sha256") == EXPECTED_SELECTION_SHA256,
        "descriptor selected-ID hash mismatch",
    )
    _require(
        source.get("overlay_manifest_sha256") == EXPECTED_OVERLAY_MANIFEST_SHA256,
        "descriptor overlay hash mismatch",
    )
    overlay_file = source.get("overlay_manifest_file")
    registry_file = source.get("registry_file")
    _require(isinstance(overlay_file, str), "descriptor overlay file missing")
    _require(isinstance(registry_file, str), "descriptor registry file missing")
    _require(
        sha256_file(descriptor_path.parent / overlay_file)
        == EXPECTED_OVERLAY_MANIFEST_SHA256,
        "committed source overlay manifest hash mismatch",
    )
    _require(
        sha256_file(descriptor_path.parent / registry_file)
        == source.get("registry_sha256"),
        "committed campaign registry hash mismatch",
    )
    source_overlay = _load_json(descriptor_path.parent / overlay_file)
    source_overlay_tasks = source_overlay.get("tasks")
    _require(
        isinstance(source_overlay_tasks, dict)
        and len(source_overlay_tasks) == EXPECTED_OVERLAY_COUNT,
        "committed source overlay task map mismatch",
    )
    registry = _load_json(descriptor_path.parent / registry_file)
    _require(registry.get("name") == CAMPAIGN_NAME, "committed campaign name mismatch")
    registry_entry = registry.get("benchmarks", {}).get(BENCHMARK_NAME, {})
    _require(
        registry_entry.get("revision") == EXPECTED_UPSTREAM_REVISION,
        "committed campaign revision mismatch",
    )
    _require(
        registry_entry.get("ordered_ids_sha256") == EXPECTED_SELECTION_SHA256,
        "committed campaign selected-ID hash mismatch",
    )
    bound_dataset = descriptor.get("dataset", {})
    _require(
        bound_dataset.get("path") == "tasks/vericoding_lean",
        "descriptor canonical dataset path mismatch",
    )
    _require(
        bound_dataset.get("task_count") == EXPECTED_CANONICAL_TASK_COUNT,
        "descriptor canonical dataset task count mismatch",
    )
    _require(
        bound_dataset.get("content_sha256") == EXPECTED_PRE_MIGRATION_DATASET_SHA256,
        "descriptor canonical dataset content hash mismatch",
    )
    _require(
        bound_dataset.get("canonical_selected_content_sha256")
        == EXPECTED_CANONICAL_SELECTED_CONTENT_SHA256,
        "descriptor canonical selected campaign hash mismatch",
    )
    _require(
        bound_dataset.get("selected_content_sha256")
        == EXPECTED_FINAL_SELECTED_CONTENT_SHA256,
        "descriptor final selected campaign hash mismatch",
    )
    _require(
        bound_dataset.get("view_content_sha256") == EXPECTED_VIEW_CONTENT_SHA256,
        "descriptor materialized view hash mismatch",
    )
    current = dataset_tool.build_manifest(dataset) if dataset is not None else None
    if current is not None:
        _require(
            current["content_sha256"] == EXPECTED_PRE_MIGRATION_DATASET_SHA256,
            "canonical dataset is not the pinned pristine dataset",
        )
        _require(
            current["content_sha256"] == bound_dataset.get("content_sha256"),
            "descriptor canonical dataset content hash mismatch",
        )
        _require(
            current["task_count"] == bound_dataset.get("task_count"),
            "descriptor canonical dataset task count mismatch",
        )
    tasks = descriptor.get("tasks")
    _require(
        isinstance(tasks, dict) and len(tasks) == EXPECTED_SELECTION_COUNT,
        "bad task map",
    )
    ordered_ids_hash = sha256_bytes(("\n".join(tasks) + "\n").encode())
    _require(
        ordered_ids_hash == EXPECTED_SELECTION_SHA256, "task map order/IDs changed"
    )
    overlays = 0
    for benchmark_id, item in tasks.items():
        _require(isinstance(item, dict), f"bad task entry: {benchmark_id}")
        task_name = item.get("task_name")
        _require(isinstance(task_name, str), f"missing task name: {benchmark_id}")
        if current is not None:
            _require(
                task_name in current["tasks"], f"task missing on disk: {task_name}"
            )
            task_dir = dataset / task_name
            _require(
                (task_dir / "environment/task.lean").read_bytes()
                == (task_dir / "tests/original.lean").read_bytes(),
                f"verifier mirror mismatch: {benchmark_id}",
            )
        if item.get("lean428_overlay") is True:
            overlays += 1
            _require(
                benchmark_id in source_overlay_tasks,
                f"overlay task missing from source manifest: {benchmark_id}",
            )
            _require(
                item.get("source_overlay_sha256")
                == source_overlay_tasks[benchmark_id].get("overlay_sha256"),
                f"V2 source overlay binding changed: {benchmark_id}",
            )
            if current is not None:
                _require(
                    current["tasks"][task_name] != item.get("spec_sha256"),
                    f"overlay unexpectedly matches canonical spec: {benchmark_id}",
                )
        elif current is not None:
            _require(
                current["tasks"][task_name] == item.get("spec_sha256"),
                f"unchanged task spec hash mismatch: {benchmark_id}",
            )
    _require(
        overlays == EXPECTED_OVERLAY_COUNT, "descriptor overlay membership changed"
    )
    _require(
        {
            benchmark_id
            for benchmark_id, item in tasks.items()
            if item.get("lean428_overlay") is True
        }
        == set(source_overlay_tasks),
        "descriptor/source overlay membership mismatch",
    )
    if current is not None:
        canonical_selected_hash = sha256_bytes(
            "".join(
                f"{benchmark_id} {item['task_name']} "
                f"{current['tasks'][item['task_name']]}\n"
                for benchmark_id, item in tasks.items()
            ).encode()
        )
        _require(
            canonical_selected_hash
            == bound_dataset.get("canonical_selected_content_sha256"),
            "canonical selected campaign content hash mismatch",
        )
    final_selected_hash = sha256_bytes(
        "".join(
            f"{benchmark_id} {item['task_name']} {item['spec_sha256']}\n"
            for benchmark_id, item in tasks.items()
        ).encode()
    )
    _require(
        final_selected_hash == bound_dataset.get("selected_content_sha256"),
        "final selected campaign content hash mismatch",
    )
    _require(
        final_selected_hash == EXPECTED_FINAL_SELECTED_CONTENT_SHA256,
        "frozen final selected campaign content hash mismatch",
    )
    view_hash = sha256_bytes(
        "".join(
            f"{item['task_name']} {item['spec_sha256']}\n"
            for item in sorted(tasks.values(), key=lambda value: value["task_name"])
        ).encode()
    )
    _require(
        view_hash == bound_dataset.get("view_content_sha256"),
        "materialized view content hash mismatch",
    )
    _require(
        view_hash == EXPECTED_VIEW_CONTENT_SHA256,
        "frozen materialized view content hash mismatch",
    )
    return descriptor


def materialize_campaign(
    descriptor_path: Path, dataset: Path, v2_root: Path, output: Path
) -> tuple[dict, dict]:
    descriptor = verify_descriptor(descriptor_path, dataset)
    rows, overlay, _campaign, index = _preflight(v2_root, dataset)
    _require(
        [row["id"] for row in rows] == list(descriptor["tasks"]),
        "local V2 selection does not match the committed descriptor",
    )
    for row in rows:
        item = descriptor["tasks"][row["id"]]
        task_dir, source_id = index[row["id"]]
        _require(task_dir.name == item["task_name"], f"task name changed: {row['id']}")
        _require(source_id == item["source_id"], f"source ID changed: {row['id']}")
        _require(row["source"] == item["source"], f"source changed: {row['id']}")
        _require(
            row["source-id"] == item["source_record_id"],
            f"source record ID changed: {row['id']}",
        )

    _require(not output.exists(), f"materialized campaign already exists: {output}")
    _require(
        output.resolve() != dataset.resolve(), "output must not replace the dataset"
    )
    _require(
        dataset.resolve() not in output.resolve().parents,
        "output must not be nested inside the canonical dataset",
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = Path(
        tempfile.mkdtemp(prefix=f".{output.name}.", dir=str(output.parent.resolve()))
    )
    compatibility_root = v2_root / "benchmarks/compatibility/vericoding-benchmark"
    try:
        for benchmark_id, item in descriptor["tasks"].items():
            task_name = item["task_name"]
            source = (dataset / task_name).resolve()
            destination = temporary / task_name
            if item["lean428_overlay"]:
                shutil.copytree(source, destination)
                overlay_item = overlay["tasks"][benchmark_id]
                replacement = (
                    compatibility_root / overlay_item["overlay_path"]
                ).read_text(encoding="utf-8")
                migrated = _v3_source(replacement)
                _require(
                    sha256_bytes(migrated.encode()) == item["spec_sha256"],
                    f"materialized overlay hash mismatch: {benchmark_id}",
                )
                (destination / "environment/task.lean").write_text(
                    migrated, encoding="utf-8"
                )
                (destination / "tests/original.lean").write_text(
                    migrated, encoding="utf-8"
                )
            else:
                relative_source = os.path.relpath(source, start=temporary)
                destination.symlink_to(relative_source, target_is_directory=True)
        manifest = dataset_tool.write_manifest(temporary)
        manifest["name"] = descriptor["name"]
        (temporary / dataset_tool.MANIFEST_NAME).write_text(
            json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        _require(
            manifest["task_count"] == EXPECTED_SELECTION_COUNT,
            "materialized campaign task count mismatch",
        )
        _require(
            manifest["content_sha256"] == descriptor["dataset"]["view_content_sha256"],
            "materialized campaign content hash mismatch",
        )
        final_selected_hash = sha256_bytes(
            "".join(
                f"{benchmark_id} {item['task_name']} "
                f"{manifest['tasks'][item['task_name']]}\n"
                for benchmark_id, item in descriptor["tasks"].items()
            ).encode()
        )
        _require(
            final_selected_hash == descriptor["dataset"]["selected_content_sha256"],
            "materialized final selection content hash mismatch",
        )
        (temporary / "materialization.json").write_text(
            json.dumps(
                {
                    "schema_version": 1,
                    "campaign": descriptor["name"],
                    "descriptor_sha256": sha256_file(descriptor_path),
                    "source_root": str(v2_root),
                    "upstream_revision": EXPECTED_UPSTREAM_REVISION,
                    "selection_csv_sha256": EXPECTED_SELECTION_CSV_SHA256,
                    "overlay_manifest_sha256": EXPECTED_OVERLAY_MANIFEST_SHA256,
                    "canonical_dataset_content_sha256": descriptor["dataset"][
                        "content_sha256"
                    ],
                    "selected_content_sha256": final_selected_hash,
                    "view_content_sha256": manifest["content_sha256"],
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
    return descriptor, manifest


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    apply = sub.add_parser(
        "apply", help="attest the pristine dataset and write code-only metadata"
    )
    apply.add_argument("--v2-root", type=Path)
    apply.add_argument("--dataset", type=Path, default=Path("tasks/vericoding_lean"))
    apply.add_argument(
        "--descriptor-out",
        type=Path,
        default=Path("migration/v2/vericoding-aligned-lean428-2012.json"),
    )
    apply.add_argument(
        "--source-manifest-out",
        type=Path,
        default=Path("migration/v2/vericoding-lean428-source-manifest.json"),
    )
    apply.add_argument(
        "--registry-out",
        type=Path,
        default=Path("migration/v2/formal-benchmark-campaign-v1.campaign.json"),
    )
    verify = sub.add_parser(
        "verify", help="verify the committed V3 campaign descriptor"
    )
    verify.add_argument(
        "--dataset",
        type=Path,
        help="optionally audit a local pristine canonical dataset",
    )
    verify.add_argument(
        "--descriptor",
        type=Path,
        default=Path("migration/v2/vericoding-aligned-lean428-2012.json"),
    )
    materialize = sub.add_parser(
        "materialize", help="create an ignored 2,012-task Harbor dataset view"
    )
    materialize.add_argument("--v2-root", type=Path)
    materialize.add_argument(
        "--dataset", type=Path, default=Path("tasks/vericoding_lean")
    )
    materialize.add_argument(
        "--descriptor",
        type=Path,
        default=Path("migration/v2/vericoding-aligned-lean428-2012.json"),
    )
    materialize.add_argument(
        "--output",
        type=Path,
    )
    return parser


def main() -> int:
    args = _parser().parse_args()
    materialized: tuple[Path, dict] | None = None
    try:
        if args.command == "apply":
            v2_root = benchmark_paths.resolve_source("vericoding", args.v2_root)
            payload = apply_migration(
                v2_root,
                args.dataset.resolve(),
                args.descriptor_out.resolve(),
                args.source_manifest_out.resolve(),
                args.registry_out.resolve(),
            )
        elif args.command == "verify":
            payload = verify_descriptor(
                args.descriptor.resolve(),
                args.dataset.resolve() if args.dataset is not None else None,
            )
        else:
            v2_root = benchmark_paths.resolve_source("vericoding", args.v2_root)
            output = (
                args.output.resolve()
                if args.output is not None
                else benchmark_paths.default_view("vericoding")
            )
            payload, view_manifest = materialize_campaign(
                args.descriptor.resolve(), args.dataset.resolve(), v2_root, output
            )
            materialized = (output, view_manifest)
    except (
        benchmark_paths.BenchmarkPathError,
        MigrationError,
        OSError,
        KeyError,
    ) as exc:
        print(f"FATAL: {exc}", file=sys.stderr)
        return 1
    summary = {
        "name": payload["name"],
        "task_count": payload["task_count"],
        "overlay_task_count": payload["overlay_task_count"],
        "dataset_content_sha256": payload["dataset"]["content_sha256"],
        "selected_content_sha256": payload["dataset"]["selected_content_sha256"],
    }
    if materialized is not None:
        summary["materialized_path"] = str(materialized[0])
        summary["view_content_sha256"] = materialized[1]["content_sha256"]
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
