#!/usr/bin/env python3
"""Replay the frozen 500-task VeriSoftBench campaign as Harbor tasks.

The committed migration evidence is lightweight.  Materialization requires a
separate upstream release checkout, whose dataset and native evaluator files
are hash-attested before any output is written.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from tools.benchmark_paths import BenchmarkPathError, resolve_source  # noqa: E402

CAMPAIGN = "formal-benchmark-campaign-v1"
UPSTREAM_REVISION = "0c3d7931433bfa5dfa5c04259e6660cf62f178c8"
UPSTREAM_URL = "https://github.com/utopia-group/VeriSoftBench.git"
TASK_COUNT = 500
ORDERED_IDS_SHA256 = "e198818c87e533b7ab0c72b1ccf0888c7a849d936e10ced3fa3be16544deaf2c"
DATASET_SHA256 = "ea584250021fbfaddc060834be2e05b9b2fae4f720c770a9932c71d039a50961"
REPOS_SHA256 = "c9cc7cb9650c482d81ee78d7f704c61d0d6073418064d11c55674938f35760de"
REGISTRY_SHA256 = "19b313cca1207d8aa3223d8e84f158414aaa637ab66a864dc325927a8d21382d"
DESCRIPTOR = REPO_ROOT / "migration/v2/verisoftbench-500.json"
REPO_PINS = REPO_ROOT / "migration/v2/verisoftbench-repos.json"
DEFAULT_OUT = REPO_ROOT / "tasks/_campaign_views/verisoftbench-500"
DEFAULT_IMAGE = "verisoftbench/harbor-native:0c3d7931433b"

NATIVE_FILES = {
    "evaluate.py": "7e0710aa5b85476441faaf8602048967daa8db352af13cafb240bdcd8f25ea82",
    "core/evaluator.py": "708181ee3efa160550b46b5dcec19064442f459d5a978cf12d6d7beb2c82a297",
    "core/lean_interface.py": "0bf2c702853193dc07630742345f4d3c1b76b43445cc3a19618a38c020b9df97",
    "prompts/prompt_builder.py": "05953b167eabcd62f2ca2a1a15bfdbd0ef87ab601ecffce9b9b06da139bf7f2c",
    "prompts/templates/init.txt": "bc3740f835bec2eadb6b93b567f28e59e0a0f4767f643657346fb3ba1532057f",
    "prompts/templates/user.txt": "a74ce7eab8b5b22806fb059f4178b426620b3eb8debb19381d75c3317267c96a",
    "prompts/templates/examples/e1.txt": "81e155b909602295a2bb8e1444109844d55a2989ccf66e44490ec8ad84f8da64",
    "utils/utils.py": "36d5dd02674b1a3427d76987b84be23fbbdb7ba54746ed104585a7248c3f6d68",
    "analysis/identifier_extractor.py": "e65dc29c281834e352a88247a504d4e9ceafb259995e7720dbabaa2d9e2c1cea",
    "analysis/scope_tracker.py": "afca95881420ab8ab356820a3767c620ee4bc1ab0d0362145eed9acbe0df4e49",
    "analysis/lean_patterns.py": "7f516f14e661404054436296987879040ea5a27f10474d285517111ebbb2fd76",
}


class MigrationError(RuntimeError):
    """A frozen campaign invariant did not match."""


def _source_release(explicit: Path | None) -> Path:
    try:
        return resolve_source("verisoftbench", explicit)
    except BenchmarkPathError as exc:
        raise MigrationError(str(exc)) from exc


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    try:
        return sha256_bytes(path.read_bytes())
    except OSError as exc:
        raise MigrationError(f"cannot read {path}: {exc}") from exc


def load_json(path: Path) -> dict:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise MigrationError(f"cannot read JSON {path}: {exc}") from exc
    if not isinstance(value, dict):
        raise MigrationError(f"expected JSON object: {path}")
    return value


def require(condition: bool, message: str) -> None:
    if not condition:
        raise MigrationError(message)


def _dataset_records(release: Path) -> list[tuple[bytes, dict]]:
    dataset = release / "data/verisoftbench.jsonl"
    require(
        sha256_file(dataset) == DATASET_SHA256, "VeriSoftBench dataset hash mismatch"
    )
    records: list[tuple[bytes, dict]] = []
    for line_no, raw in enumerate(dataset.read_bytes().splitlines(), start=1):
        if not raw.strip():
            continue
        try:
            value = json.loads(raw)
        except json.JSONDecodeError as exc:
            raise MigrationError(f"bad dataset JSON at line {line_no}: {exc}") from exc
        require(isinstance(value, dict), f"dataset line {line_no} is not an object")
        records.append((raw, value))
    ids = [str(item[1].get("id")) for item in records]
    require(len(records) == TASK_COUNT, "VeriSoftBench does not contain 500 records")
    require(
        ids == [str(i) for i in range(1, TASK_COUNT + 1)],
        "task IDs are not ordered 1..500",
    )
    require(
        sha256_bytes(("\n".join(ids) + "\n").encode()) == ORDERED_IDS_SHA256,
        "ordered task ID hash mismatch",
    )
    return records


def _validate_release(release: Path, registry: Path | None = None) -> tuple[list, dict]:
    require(release.is_dir(), f"source release missing: {release}")
    require(
        sha256_file(release / "repos.json") == REPOS_SHA256, "repos.json hash mismatch"
    )
    for rel, expected in NATIVE_FILES.items():
        require(
            sha256_file(release / rel) == expected,
            f"native evaluator hash mismatch: {rel}",
        )
    if registry is not None:
        require(
            sha256_file(registry) == REGISTRY_SHA256, "campaign registry hash mismatch"
        )
        campaign = load_json(registry)
        item = campaign.get("benchmarks", {}).get("verisoftbench", {})
        require(item.get("revision") == UPSTREAM_REVISION, "upstream revision mismatch")
        require(
            item.get("record_count") == TASK_COUNT, "campaign record count mismatch"
        )
        require(
            item.get("ordered_ids_sha256") == ORDERED_IDS_SHA256,
            "campaign ID hash mismatch",
        )
        require(item.get("track") == "filtered_context", "campaign track mismatch")
        require(
            item.get("grader") == "VeriSoftBench evaluate.py native compile checker",
            "campaign grader mismatch",
        )
    records = _dataset_records(release)
    repos = load_json(release / "repos.json")
    pins = repos.get("repos")
    require(isinstance(pins, dict) and len(pins) == 23, "expected 23 repository pins")
    used = {entry["lean_root"] for _, entry in records}
    require(used == set(pins), "dataset repositories and repos.json differ")
    for name, pin in pins.items():
        require(isinstance(pin, dict), f"bad repository pin: {name}")
        require(
            re.fullmatch(r"[0-9a-f]{40}", str(pin.get("commit", ""))) is not None,
            f"bad commit pin: {name}",
        )
        require(
            str(pin.get("lean_toolchain", "")).startswith("leanprover/lean4:"),
            f"bad toolchain pin: {name}",
        )
    return records, repos


def _v2_paths(v2_root: Path) -> tuple[Path, Path]:
    return (
        v2_root / "benchmarks/VeriSoftBench",
        v2_root / "benchmarks/campaigns/formal-benchmark-campaign-v1.campaign.json",
    )


def build_descriptor(records: list[tuple[bytes, dict]], repos: dict) -> dict:
    tasks = {}
    for raw, entry in records:
        task_id = str(entry["id"])
        tasks[task_id] = {
            "id": entry["id"],
            "thm_name": entry["thm_name"],
            "lean_root": entry["lean_root"],
            "rel_path": entry["rel_path"],
            "category": entry.get("category"),
            "record_sha256": sha256_bytes(raw),
        }
    return {
        "schema_version": 1,
        "kind": "v2_migrated_native_benchmark_campaign",
        "name": "verisoftbench-filtered-context-500",
        "campaign": CAMPAIGN,
        "upstream_url": UPSTREAM_URL,
        "upstream_revision": UPSTREAM_REVISION,
        "track": "filtered_context",
        "native_fix_enabled": False,
        "leaderboard_comparable": False,
        "task_count": TASK_COUNT,
        "ordered_ids_sha256": ORDERED_IDS_SHA256,
        "dataset_sha256": DATASET_SHA256,
        "repos_sha256": REPOS_SHA256,
        "repository_count": len(repos["repos"]),
        "registry_sha256": REGISTRY_SHA256,
        "native_files": NATIVE_FILES,
        "materialization": {
            "default_path": "tasks/_campaign_views/verisoftbench-500",
            "base_image": DEFAULT_IMAGE,
            "source_payload_committed": False,
            "requires_external_native_image": True,
        },
        "tasks": tasks,
    }


def verify_descriptor(
    descriptor_path: Path = DESCRIPTOR, repo_pins_path: Path = REPO_PINS
) -> dict:
    payload = load_json(descriptor_path)
    require(payload.get("schema_version") == 1, "descriptor schema mismatch")
    require(payload.get("campaign") == CAMPAIGN, "descriptor campaign mismatch")
    require(
        payload.get("upstream_revision") == UPSTREAM_REVISION,
        "descriptor revision mismatch",
    )
    require(payload.get("track") == "filtered_context", "descriptor track mismatch")
    require(
        payload.get("native_fix_enabled") is False, "native fix must remain disabled"
    )
    require(payload.get("task_count") == TASK_COUNT, "descriptor task count mismatch")
    require(
        payload.get("dataset_sha256") == DATASET_SHA256,
        "descriptor dataset hash mismatch",
    )
    require(
        payload.get("repos_sha256") == REPOS_SHA256, "descriptor repos hash mismatch"
    )
    require(
        payload.get("native_files") == NATIVE_FILES,
        "descriptor native file hashes mismatch",
    )
    tasks = payload.get("tasks")
    require(
        isinstance(tasks, dict) and len(tasks) == TASK_COUNT,
        "descriptor must map 500 tasks",
    )
    ids = list(tasks)
    require(
        ids == [str(i) for i in range(1, TASK_COUNT + 1)],
        "descriptor IDs not ordered 1..500",
    )
    require(
        sha256_bytes(("\n".join(ids) + "\n").encode()) == ORDERED_IDS_SHA256,
        "descriptor ID hash mismatch",
    )
    require(
        sha256_file(repo_pins_path) == REPOS_SHA256, "committed repo pins hash mismatch"
    )
    repos = load_json(repo_pins_path).get("repos")
    require(
        isinstance(repos, dict) and len(repos) == 23,
        "committed repo pin count mismatch",
    )
    require(
        {item["lean_root"] for item in tasks.values()} == set(repos),
        "descriptor repositories differ from pins",
    )
    for task_id, item in tasks.items():
        require(
            item.get("id") == int(task_id), f"descriptor task ID mismatch: {task_id}"
        )
        require(
            re.fullmatch(r"[0-9a-f]{64}", str(item.get("record_sha256", "")))
            is not None,
            f"bad record hash: {task_id}",
        )
    return payload


def cmd_capture(args: argparse.Namespace) -> int:
    release, registry = _v2_paths(args.v2_root)
    records, repos = _validate_release(release, registry)
    descriptor = build_descriptor(records, repos)
    args.descriptor.parent.mkdir(parents=True, exist_ok=True)
    args.repo_pins.parent.mkdir(parents=True, exist_ok=True)
    args.descriptor.write_text(
        json.dumps(descriptor, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    # Preserve the exact upstream bytes: the campaign binds this SHA.
    args.repo_pins.write_bytes((release / "repos.json").read_bytes())
    verify_descriptor(args.descriptor, args.repo_pins)
    print(f"captured {TASK_COUNT} VeriSoftBench tasks and 23 repository pins")
    return 0


def cmd_verify(args: argparse.Namespace) -> int:
    payload = verify_descriptor(args.descriptor, args.repo_pins)
    if args.source_release:
        records, repos = _validate_release(args.source_release)
        require(
            build_descriptor(records, repos) == payload,
            "source release differs from committed descriptor",
        )
    print(
        f"verified {payload['task_count']} frozen VeriSoftBench tasks ({payload['track']})"
    )
    return 0


def _load_prompt_builder(release: Path):
    # The native prompt module uses absolute package imports.  Clear any stale
    # modules so tests/replays cannot accidentally borrow another checkout.
    for name in list(sys.modules):
        if (
            name == "prompts"
            or name.startswith("prompts.")
            or name == "utils"
            or name.startswith("utils.")
            or name == "config"
            or name.startswith("config.")
        ):
            del sys.modules[name]
    sys.path.insert(0, str(release))
    try:
        from prompts.prompt_builder import PromptBuilder  # type: ignore
    except Exception as exc:
        raise MigrationError(f"cannot import frozen prompt builder: {exc}") from exc
    return PromptBuilder(release / "prompts/templates", mode="filtered_context")


def _task_name(entry: dict) -> str:
    stem = re.sub(r"[^A-Za-z0-9._-]", "_", entry["thm_name"])[-72:]
    return f"verisoftbench__{int(entry['id']):03d}__{stem}"


def _write_task(
    root: Path, raw: bytes, entry: dict, descriptor: dict, repos_path: Path, image: str
) -> None:
    name = _task_name(entry)
    task = root / name
    (task / "environment").mkdir(parents=True)
    (task / "tests").mkdir()
    (task / "solution").mkdir()
    builder = _write_task.prompt_builder
    system = builder.retrive_sys_prompt()
    user = builder.build_user_prompt(entry, mode="filtered_context")
    instruction = (
        system.rstrip()
        + "\n\n"
        + user.rstrip()
        + "\n\n### Harbor delivery\nWrite the complete tagged response to `/task/answer.txt`. "
        "Do not modify `/workspace/lean_repos`; the native verifier compiles the answer after the agent phase.\n"
    )
    (task / "instruction.md").write_text(instruction, encoding="utf-8")
    (task / "task.toml").write_text(
        "\n".join(
            [
                'schema_version = "1.3"',
                "",
                "[task]",
                f'name = "codeprover/{name.lower()}"',
                f'description = "VeriSoftBench native filtered-context task {entry["id"]}"',
                'keywords = ["lean4", "software-verification", "verisoftbench"]',
                "",
                "[metadata]",
                f'source_id = "verisoftbench/{entry["id"]}"',
                'source_dataset = "verisoftbench_500"',
                f'source_revision = "{UPSTREAM_REVISION}"',
                f"repository = {json.dumps(entry['lean_root'])}",
                'track = "filtered_context"',
                "",
                "[agent]",
                "timeout_sec = 3600.0",
                "",
                "[verifier]",
                "timeout_sec = 3600.0",
                "",
                "[environment]",
                "build_timeout_sec = 1800.0",
                "",
            ]
        ),
        encoding="utf-8",
    )
    (task / "environment/Dockerfile").write_text(
        f"FROM {image}\nWORKDIR /task\n", encoding="utf-8"
    )
    (task / "tests/entry.json").write_bytes(raw + b"\n")
    attestation = {
        "schema_version": 1,
        "campaign": CAMPAIGN,
        "upstream_revision": UPSTREAM_REVISION,
        "repos_sha256": REPOS_SHA256,
        "native_files": NATIVE_FILES,
        "task": descriptor["tasks"][str(entry["id"])],
    }
    (task / "tests/attestation.json").write_text(
        json.dumps(attestation, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    shutil.copy2(repos_path, task / "tests/repos.json")
    shutil.copy2(REPO_ROOT / "verisoft/harbor_grade.py", task / "tests/grade.py")
    (task / "tests/test.sh").write_text(
        "#!/bin/sh\nset -u\nmkdir -p /logs/verifier\npython3 /tests/grade.py --out-dir /logs/verifier\nexit 0\n",
        encoding="utf-8",
    )
    (task / "tests/test.sh").chmod(0o755)
    answer = (
        "<lean4_invented_lemmas>\n\n</lean4_invented_lemmas>\n\n"
        "<lean4_proof>\n"
        + entry["ground_truth_proof"].strip().removeprefix(":=").lstrip()
        + "\n</lean4_proof>\n"
    )
    encoded = base64.b64encode(answer.encode()).decode("ascii")
    (task / "solution/solve.sh").write_text(
        "#!/bin/sh\npython3 -c 'import base64; from pathlib import Path; "
        + f'Path("/task/answer.txt").write_bytes(base64.b64decode("{encoded}"))'
        + "'\n",
        encoding="utf-8",
    )
    (task / "solution/solve.sh").chmod(0o755)


_write_task.prompt_builder = None


def cmd_materialize(args: argparse.Namespace) -> int:
    args.source_release = _source_release(args.source_release)
    descriptor = verify_descriptor(args.descriptor, args.repo_pins)
    records, repos = _validate_release(args.source_release)
    require(
        build_descriptor(records, repos) == descriptor,
        "source release differs from committed descriptor",
    )
    selected = records[: args.limit or None]
    require(selected, "materialization selected no tasks")
    if args.out.exists() and not args.force:
        raise MigrationError(f"output exists (pass --force): {args.out}")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    tmp = Path(tempfile.mkdtemp(prefix=f".{args.out.name}-", dir=args.out.parent))
    try:
        _write_task.prompt_builder = _load_prompt_builder(args.source_release)
        for raw, entry in selected:
            _write_task(tmp, raw, entry, descriptor, args.repo_pins, args.image)
        task_hashes = {_task_name(entry): sha256_bytes(raw) for raw, entry in selected}
        manifest = {
            "schema_version": 1,
            "kind": "harbor_native_campaign_view",
            "name": "verisoftbench-500",
            "task_count": len(selected),
            "full_campaign_task_count": TASK_COUNT,
            "track": "filtered_context",
            "upstream_revision": UPSTREAM_REVISION,
            "tasks": task_hashes,
        }
        (tmp / "manifest.json").write_text(
            json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
        )
        if args.out.exists():
            shutil.rmtree(args.out)
        os.replace(tmp, args.out)
    finally:
        if tmp.exists():
            shutil.rmtree(tmp)
    print(
        f"materialized {len(selected)} Harbor-native VeriSoftBench task(s) at {args.out}"
    )
    return 0


def cmd_image_context(args: argparse.Namespace) -> int:
    args.source_release = _source_release(args.source_release)
    _validate_release(args.source_release)
    if args.out.exists() and not args.force:
        raise MigrationError(f"output exists (pass --force): {args.out}")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    tmp = Path(tempfile.mkdtemp(prefix=f".{args.out.name}-", dir=args.out.parent))
    try:
        shutil.copytree(
            args.source_release,
            tmp,
            dirs_exist_ok=True,
            ignore=shutil.ignore_patterns(
                ".git", "results", "debug", "prompts/full_limited", "docs"
            ),
        )
        build_script = tmp / "scripts/build_repo.sh"
        text = build_script.read_text(encoding="utf-8")
        needle = (
            'git checkout --quiet "${REPO_COMMIT}"\n    # Remove .git to save space'
        )
        replacement = (
            'git checkout --quiet "${REPO_COMMIT}"\n'
            "    ACTUAL_COMMIT=$(git rev-parse HEAD)\n"
            '    if [ "${ACTUAL_COMMIT}" != "${REPO_COMMIT}" ]; then\n'
            '        echo "ERROR: checkout revision mismatch for ${REPO_NAME}"\n'
            "        exit 1\n"
            "    fi\n"
            '    printf "%s\\n" "${ACTUAL_COMMIT}" > "${REPO_OUT}/.verisoftbench-source-revision"\n'
            "    # Remove .git to save space"
        )
        require(
            needle in text, "cannot add source revision attestation to build_repo.sh"
        )
        build_script.write_text(text.replace(needle, replacement, 1), encoding="utf-8")
        dockerfile = tmp / "Dockerfile"
        dockerfile.write_text(
            dockerfile.read_text(encoding="utf-8")
            + "\n# Harbor adapter: retain the frozen native evaluator in the image.\n"
            + "COPY . /opt/verisoftbench\n"
            + "ENV PYTHONPATH=/opt/verisoftbench\n"
            + f'LABEL org.codeprover.verisoftbench.revision="{UPSTREAM_REVISION}"\n',
            encoding="utf-8",
        )
        (tmp / ".dockerignore").write_text(
            ".git\nresults\ndebug\ndocs\nprompts/full_limited\n", encoding="utf-8"
        )
        if args.out.exists():
            shutil.rmtree(args.out)
        os.replace(tmp, args.out)
    finally:
        if tmp.exists():
            shutil.rmtree(tmp)
    print(f"wrote attested native image context to {args.out}")
    print(f"build: docker build -t {args.image} {args.out}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)

    capture = sub.add_parser("capture", help="capture frozen evidence from V2")
    capture.add_argument("--v2-root", type=Path, required=True)
    capture.add_argument("--descriptor", type=Path, default=DESCRIPTOR)
    capture.add_argument("--repo-pins", type=Path, default=REPO_PINS)
    capture.set_defaults(func=cmd_capture)

    verify = sub.add_parser("verify", help="verify committed evidence")
    verify.add_argument("--descriptor", type=Path, default=DESCRIPTOR)
    verify.add_argument("--repo-pins", type=Path, default=REPO_PINS)
    verify.add_argument("--source-release", type=Path)
    verify.set_defaults(func=cmd_verify)

    materialize = sub.add_parser("materialize", help="generate Harbor task view")
    materialize.add_argument("--source-release", type=Path)
    materialize.add_argument("--descriptor", type=Path, default=DESCRIPTOR)
    materialize.add_argument("--repo-pins", type=Path, default=REPO_PINS)
    materialize.add_argument("--out", type=Path, default=DEFAULT_OUT)
    materialize.add_argument("--image", default=DEFAULT_IMAGE)
    materialize.add_argument("--limit", type=int, default=0)
    materialize.add_argument("--force", action="store_true")
    materialize.set_defaults(func=cmd_materialize)

    image = sub.add_parser(
        "image-context", help="prepare pinned native image build context"
    )
    image.add_argument("--source-release", type=Path)
    image.add_argument("--out", type=Path, required=True)
    image.add_argument("--image", default=DEFAULT_IMAGE)
    image.add_argument("--force", action="store_true")
    image.set_defaults(func=cmd_image_context)

    args = parser.parse_args()
    try:
        return args.func(args)
    except MigrationError as exc:
        print(f"FATAL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
