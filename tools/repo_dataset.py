"""Convert a leancodeprover repo-v1.x release (problems/<task_id>/ trees) into
Harbor task dirs — the *repo* flavor (multi-file lake project, spec-judge
editable/provided markers, graded by verifier/grade_repo.py).

    python3 tools/repo_dataset.py make \
        /mnt/VerifiableAILab/ziran.yang/shared/datas/leancodeprover/releases/repo-v1.1 \
        data/repo-v1.1-20260804/tasks [--limit N] [--labels template_core ...]

Layout per task (mirrors math/coding tasks so harbor + distill_ops work):
    task.toml                 flavor "repo"; metadata: capability label, lang, lib
    instruction.md            harness preamble + release Instruction.md verbatim
    environment/Dockerfile    FROM code-prover-lean:latest; COPY tree/ /task/
    environment/tree/**       the problem tree (what the agent sees at /task)
    tests/test.sh             runs grade_repo.py (agent tree vs pristine)
    tests/grade_repo.py       vendored copy of verifier/grade_repo.py
    tests/task.json seal.json pristine/**

The verifier splices the agent's editable interiors into tests/pristine/, so
the agent cannot influence grading by touching anything else.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DEFAULT_IMAGE = "code-prover-lean:latest"
SKIP_PARTS = {".lake", "build", ".git", "__pycache__"}

TEST_SH = """#!/bin/bash
# Code-Prover-V3 Harbor verifier entrypoint (repo flavor).
# Harbor uploads tests/ to /tests AFTER the agent phase; grade_repo.py splices
# the agent's editable interiors into /tests/pristine and grades the result.
set -u
mkdir -p /logs/verifier
export PATH="/root/.elan/bin:/usr/local/bin:$PATH"
python3 /tests/grade_repo.py \\
  --agent-dir /task \\
  --pristine /tests/pristine \\
  --task-json /tests/task.json \\
  --seal /tests/seal.json \\
  --out-dir /logs/verifier
# grade_repo.py writes reward.json in every path (incl. its crash handler);
# exit 0 so Harbor reads the reward instead of a verifier exception.
exit 0
"""

INSTRUCTION_PREAMBLE = """\
# Lean 4 repo verification task

The lake project is at `/task` (already your working directory). Build with
`lake build {lib}` — it must succeed with the toolchain already installed in
this container (no network needed).

You may edit ONLY the interiors of `-- === BEGIN: <name> (editable) ===`
regions. Everything else — `(provided)` regions, spec surface, lakefile,
toolchain — is restored from a pristine copy before grading, so changes
there cannot help (they only zero your integrity score). Do not add or
rename files. `sorry`, `sorryAx`, `admit`, `native_decide`, new axioms and
declaration-injecting metaprogramming are all rejected by the grader.

The original task instructions follow.

---

"""


def task_toml(task_id: str, label: str, lang: str, lib: str, upstream: str,
              agent_timeout: float, verifier_timeout: float) -> str:
    return f"""schema_version = "1.3"

[task]
name = "codeprover/{task_id}"
description = "Lean 4 repo verification task {task_id}"
keywords = ["lean4", "theorem-proving", "code-prover", "repo"]

[metadata]
source_id = "{task_id}"
source_dataset = "repo-v1.1"
task_flavor = "repo"
capability_label = "{label}"
lang = "{lang}"
lib = "{lib}"
upstream = "{upstream}"

[agent]
timeout_sec = {agent_timeout}

[verifier]
timeout_sec = {verifier_timeout}

[environment]
build_timeout_sec = 1800.0
"""


def copy_tree(src: Path, dst: Path) -> None:
    for p in sorted(src.rglob("*")):
        rel = p.relative_to(src)
        if any(part in SKIP_PARTS for part in rel.parts):
            continue
        d = dst / rel
        if p.is_dir():
            d.mkdir(parents=True, exist_ok=True)
        else:
            d.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(p, d)


def write_repo_task(out_dir: Path, problem: Path, label: str, image: str,
                    grader_src: Path, agent_timeout: float,
                    verifier_timeout: float) -> None:
    task = json.loads((problem / "task.json").read_text())
    task_id = task["id"]
    out_dir.mkdir(parents=True, exist_ok=True)

    (out_dir / "task.toml").write_text(task_toml(
        task_id, label, task.get("lang", ""), task["lib"],
        task.get("upstream", ""), agent_timeout, verifier_timeout))

    instr = (problem / "Instruction.md").read_text(encoding="utf-8")
    (out_dir / "instruction.md").write_text(
        INSTRUCTION_PREAMBLE.format(lib=task["lib"]) + instr, encoding="utf-8")

    env = out_dir / "environment"
    tree = env / "tree"
    if tree.exists():
        shutil.rmtree(tree)
    copy_tree(problem, tree)
    # Instruction/task metadata don't belong in the agent's project dir
    for extra in ("Instruction.md", "task.json", "seal.json"):
        p = tree / extra
        if p.exists():
            p.unlink()
    (env / "Dockerfile").write_text(
        f"FROM {image}\nCOPY tree/ /task/\nWORKDIR /task\n")

    tests = out_dir / "tests"
    pristine = tests / "pristine"
    if pristine.exists():
        shutil.rmtree(pristine)
    tests.mkdir(parents=True, exist_ok=True)
    copy_tree(tree, pristine)
    shutil.copy2(problem / "task.json", tests / "task.json")
    shutil.copy2(problem / "seal.json", tests / "seal.json")
    shutil.copy2(grader_src, tests / "grade_repo.py")
    ts = tests / "test.sh"
    ts.write_text(TEST_SH)
    ts.chmod(0o755)


def write_repo_manifest(ds: Path) -> dict:
    tasks: dict[str, str] = {}
    for task_dir in sorted(p for p in ds.iterdir() if p.is_dir()):
        seal = task_dir / "tests" / "seal.json"
        if seal.is_file():
            tasks[task_dir.name] = hashlib.sha256(seal.read_bytes()).hexdigest()
    agg = hashlib.sha256(
        "".join(f"{k} {v}\n" for k, v in sorted(tasks.items())).encode()
    ).hexdigest()
    m = {
        "schema_version": 1,
        "name": ds.name,
        "task_count": len(tasks),
        "content_sha256": agg,
        "lean_profile": "lean4.28-repo",
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "tasks": tasks,
    }
    (ds / "manifest.json").write_text(json.dumps(m, indent=2) + "\n")
    return m


def cmd_make(args) -> int:
    release = args.release
    problems = release / "problems"
    labels: dict[str, str] = {}
    lbl_file = release / "release-labels.jsonl"
    if lbl_file.is_file():
        for line in open(lbl_file, encoding="utf-8"):
            rec = json.loads(line)
            labels[rec["task_id"]] = rec.get("capability_label", "")

    grader_src = REPO / "verifier" / "grade_repo.py"
    out: Path = args.out
    out.mkdir(parents=True, exist_ok=True)

    n = skipped = 0
    for problem in sorted(p for p in problems.iterdir() if p.is_dir()):
        label = labels.get(problem.name, "")
        if args.labels and label not in args.labels:
            skipped += 1
            continue
        write_repo_task(out / problem.name, problem, label, args.image,
                        grader_src, args.agent_timeout, args.verifier_timeout)
        n += 1
        if n % 500 == 0:
            print(f"  {n}", flush=True)
        if args.limit and n >= args.limit:
            break
    m = write_repo_manifest(out)
    print(f"Wrote {n} task(s) to {out} ({skipped} label-filtered, "
          f"content_sha256={m['content_sha256'][:16]}…)")
    return 0


def cmd_manifest(args) -> int:
    m = write_repo_manifest(args.dataset)
    print(f"{args.dataset}: {m['task_count']} tasks, "
          f"content_sha256={m['content_sha256'][:16]}…")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(required=True)

    mk = sub.add_parser("make", help="convert a repo release into Harbor task dirs")
    mk.add_argument("release", type=Path, help="release root (contains problems/)")
    mk.add_argument("out", type=Path, help="output dataset dir")
    mk.add_argument("--image", default=DEFAULT_IMAGE)
    mk.add_argument("--labels", nargs="+", default=None,
                    help="only include these capability labels")
    mk.add_argument("--agent-timeout", type=float, default=3600.0)
    mk.add_argument("--verifier-timeout", type=float, default=1800.0)
    mk.add_argument("--limit", type=int, default=0)
    mk.set_defaults(func=cmd_make)

    mf = sub.add_parser("manifest", help="(re)write a repo dataset manifest.json")
    mf.add_argument("dataset", type=Path)
    mf.set_defaults(func=cmd_manifest)

    args = ap.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
