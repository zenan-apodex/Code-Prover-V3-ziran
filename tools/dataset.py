#!/usr/bin/env python3
"""Code-Prover-V3 dataset tool — Harbor task directories are the ONLY format.

A dataset is a directory whose immediate children are Harbor task dirs:

    tasks/<dataset>/<task_id>/
    ├── task.toml              # name, timeouts, MCP server, metadata
    ├── instruction.md         # self-contained agent instruction (generated)
    ├── environment/
    │   ├── Dockerfile         # FROM <base image>; COPY task.lean
    │   └── task.lean          # the spec-only Lean source — THE source of truth
    └── tests/                 # injected after the agent phase (tamper-proof)
        ├── test.sh            # verifier entrypoint   (copied from verifier/)
        ├── grade.py           # 4-way grader          (copied from verifier/)
        ├── original.lean      # pristine spec         (= environment/task.lean)
        └── task_file.txt      # container path of the file to grade

Everything except environment/task.lean and [metadata] is GENERATED and can be
rebuilt at any time with `refresh` — fix a grader bug once in verifier/, then
refresh every dataset. The spec source is never touched by refresh.

Commands:
    make --from-lean-dir DIR   OUT     one task per *.lean file in DIR
    refresh DATASET [DATASET...]       regenerate all derived files in place
    validate DATASET [DATASET...]      structural + marker sanity checks
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sys
import tomllib
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
VERIFIER_DIR = HERE.parent / "verifier"

DEFAULT_IMAGE = "code-prover-lean:latest"
LEAN_PROFILE = "lean4.28-mathlib4.28"
MANIFEST_NAME = "manifest.json"
DEFAULT_AGENT_TIMEOUT = 3600.0
DEFAULT_VERIFIER_TIMEOUT = 1800.0

AUTONOMOUS_SUFFIX = (
    "You are running unattended: never stop to ask for confirmation, and keep "
    "iterating until every criterion is met or your session is terminated."
)

INSTRUCTION_TEMPLATE = """\
Solve the Lean 4 verification task at `{task_path}`.

The file is a specification with `sorry` placeholders: a function definition
(the *code* sorry) and/or a correctness theorem (the *proof* sorry). Your job
is to replace every `sorry` so that the file compiles cleanly.

## THE ONE RULE

**Never modify the specification. Never.** Preconditions, postconditions,
function signatures, theorem statements, imports, and every `-- !benchmark`
marker line are read-only and verified byte-for-byte after you finish. In
particular:

- NEVER rewrite the whole file — make surgical edits inside the editable
  regions only (use `Edit` or `lean_replace_sorry`, never `Write`);
- put ALL helper definitions and lemmas INSIDE a `*_aux` region — a helper
  placed outside the markers fails the task even if the proof is correct;
- do not reformat, re-indent, or "clean up" any read-only line — even a
  single added or removed space fails the byte-for-byte check;
- do not insert `set_option`, `instance`, `open`, or attributes outside
  the editable regions;
- if your code needs a definition that only appears LATER in the file (e.g.
  a postcond helper defined below your editable region), do NOT move it up —
  duplicate the logic under a NEW name inside your editable region;
- if a read-only function is awkward to prove about (few Mathlib lemmas),
  do NOT swap it for an "equivalent" one (e.g. `eraseDups` -> `dedup`) —
  prove a bridging lemma in a `*_aux` region instead.

## Self-check protocol (mandatory)

As your VERY FIRST action run `cp {task_path} /tmp/task-orig.lean`. Before
you consider the task done, run `diff /tmp/task-orig.lean {task_path}` and
verify that EVERY changed hunk lies strictly between a
`-- !benchmark @start` and `-- !benchmark @end` line of an editable region
(`code`, `proof`, `solution_aux`, `code_aux`, `proof_aux`). If any hunk
touches a line outside those regions, restore that line byte-for-byte from
`/tmp/task-orig.lean` and redo the change legally. A perfect proof with one
stray edit outside the editable regions scores ZERO.

## Success criteria (graded automatically after you finish)

1. `lake env lean {task_path}` (run from `/task`) reports zero errors;
2. no `sorry` remains anywhere in the file;
3. every theorem depends only on the standard axioms
   (`propext`, `Classical.choice`, `Quot.sound`) — check with
   `#print axioms <theoremName>`;
4. the specification is untouched: you may ONLY edit the contents of the
   `-- !benchmark @start/@end` regions named `code`, `proof`, `solution_aux`,
   `code_aux`, and `proof_aux`. Everything else — imports, marker lines,
   preconditions, postconditions, signatures, theorem statements — is
   compared byte-for-byte against the original and any change fails the task;
5. no forbidden construct anywhere in the file: `axiom`, `constant`,
   `opaque`, `unsafe` declarations and the negation workflow
   (`negation` / `negate_goal` / `Tacs.Negate`) all fail the task.

## Rules and hints

- If the statement seems false, try harder to prove it — disproving is not
  an option (see criterion 5).
- Prefer simple, structurally recursive implementations using List/Array
  operations with known Mathlib lemmas over clever imperative code —
  you must also prove the postcondition about it.
- Mathlib (~100K theorems) is preloaded; search it before hand-rolling
  proofs. Decompose hard goals into `private lemma`s inside the `*_aux`
  regions.
- The `lean-lsp` MCP tools (e.g. `lean_diagnostic_messages`, `lean_goal`,
  `lean_multi_attempt`) give fast feedback without full recompiles; use them
  after every edit. `lake env lean {task_path}` is the ground truth.

{suffix}
"""

TASK_TOML_TEMPLATE = """\
schema_version = "1.3"

[task]
name = "{org}/{task_name}"
description = {description}
keywords = ["lean4", "theorem-proving", "code-prover"]

[metadata]
source_id = {source_id}
source_dataset = {source_dataset}

[agent]
timeout_sec = {agent_timeout}

[verifier]
timeout_sec = {verifier_timeout}

[environment]
build_timeout_sec = 1800.0

[[environment.mcp_servers]]
name = "lean-lsp"
transport = "stdio"
command = "/usr/local/bin/lean-mcp"
"""

DOCKERFILE_TEMPLATE = """\
FROM {image}
COPY task.lean /task/{lean_name}
"""


def toml_str(s: str) -> str:
    return json.dumps(s, ensure_ascii=False)


def sanitize_id(raw: str) -> str:
    flat = raw.replace("/", "__").replace("\\", "__")
    return re.sub(r"[^A-Za-z0-9._-]", "_", flat)


def write_task(
    task_dir: Path,
    *,
    task_id: str,
    source_id: str,
    lean_source: str,
    dataset_name: str,
    org: str = "codeprover",
    image: str = DEFAULT_IMAGE,
    agent_timeout: float = DEFAULT_AGENT_TIMEOUT,
    verifier_timeout: float = DEFAULT_VERIFIER_TIMEOUT,
) -> None:
    """Write one complete task dir. The single generation primitive — used by
    `make`, `refresh`, and (via import) any pipeline export."""
    lean_name = f"{task_id}.lean"
    container_path = f"/task/{lean_name}"

    (task_dir / "environment").mkdir(parents=True, exist_ok=True)
    (task_dir / "tests").mkdir(parents=True, exist_ok=True)

    (task_dir / "instruction.md").write_text(
        INSTRUCTION_TEMPLATE.format(task_path=container_path, suffix=AUTONOMOUS_SUFFIX),
        encoding="utf-8",
    )
    (task_dir / "task.toml").write_text(
        TASK_TOML_TEMPLATE.format(
            org=org,
            task_name=task_id.lower()[:80],
            description=toml_str(f"Lean 4 verification task {source_id}"),
            source_id=toml_str(source_id),
            source_dataset=toml_str(dataset_name),
            agent_timeout=float(agent_timeout),
            verifier_timeout=float(verifier_timeout),
        ),
        encoding="utf-8",
    )
    (task_dir / "environment" / "Dockerfile").write_text(
        DOCKERFILE_TEMPLATE.format(image=image, lean_name=lean_name), encoding="utf-8"
    )
    (task_dir / "environment" / "task.lean").write_text(lean_source, encoding="utf-8")

    tests = task_dir / "tests"
    shutil.copy2(VERIFIER_DIR / "test.sh", tests / "test.sh")
    shutil.copy2(VERIFIER_DIR / "grade.py", tests / "grade.py")
    (tests / "original.lean").write_text(lean_source, encoding="utf-8")
    (tests / "task_file.txt").write_text(container_path + "\n", encoding="utf-8")
    (tests / "test.sh").chmod(0o755)


# ---------------------------------------------------------------- make ------


def iter_lean_dir(src: Path):
    for f in sorted(src.rglob("*.lean")):
        rel = f.relative_to(src).with_suffix("")
        yield str(rel), f.read_text(encoding="utf-8")


def cmd_make(args) -> int:
    out: Path = args.out
    if out.exists():
        if not args.force:
            print(f"FATAL: {out} exists — pass --force to rebuild.", file=sys.stderr)
            return 1
        shutil.rmtree(out)
    out.mkdir(parents=True)

    records = iter_lean_dir(args.from_lean_dir)

    n = 0
    for source_id, lean_source in records:
        task_id = sanitize_id(source_id)
        write_task(
            out / task_id,
            task_id=task_id,
            source_id=source_id,
            lean_source=lean_source,
            dataset_name=out.name,
            org=args.org,
            image=args.image,
            agent_timeout=args.agent_timeout,
            verifier_timeout=args.verifier_timeout,
        )
        n += 1
        if args.limit and n >= args.limit:
            break
    m = write_manifest(out)
    print(f"Wrote {n} task(s) to {out} (content_sha256={m['content_sha256'][:16]}…)")
    print(f"Run:  harbor run -p {out} -a claude-code -m <model> -n 8")
    return 0


# ------------------------------------------------------------- refresh ------


def cmd_refresh(args) -> int:
    total = 0
    for ds in args.datasets:
        for task_dir in sorted(p for p in ds.iterdir() if p.is_dir()):
            spec = task_dir / "environment" / "task.lean"
            toml_path = task_dir / "task.toml"
            if not spec.is_file() or not toml_path.is_file():
                print(f"skip {task_dir} (not a task dir)", file=sys.stderr)
                continue
            old = tomllib.loads(toml_path.read_text(encoding="utf-8"))
            meta = old.get("metadata", {})
            write_task(
                task_dir,
                task_id=task_dir.name,
                source_id=meta.get("source_id", task_dir.name),
                lean_source=spec.read_text(encoding="utf-8"),
                dataset_name=meta.get("source_dataset", ds.name),
                org=old.get("task", {}).get("name", "codeprover/x").split("/")[0],
                image=args.image or _dockerfile_image(task_dir),
                agent_timeout=args.agent_timeout
                or old.get("agent", {}).get("timeout_sec", DEFAULT_AGENT_TIMEOUT),
                verifier_timeout=args.verifier_timeout
                or old.get("verifier", {}).get("timeout_sec", DEFAULT_VERIFIER_TIMEOUT),
            )
            total += 1
    print(f"Refreshed {total} task(s)")
    return 0


def _dockerfile_image(task_dir: Path) -> str:
    df = task_dir / "environment" / "Dockerfile"
    if df.is_file():
        m = re.search(r"^FROM\s+(\S+)", df.read_text(encoding="utf-8"), re.MULTILINE)
        if m:
            return m.group(1)
    return DEFAULT_IMAGE


# ------------------------------------------------------------ manifest ------


def _sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_manifest(ds: Path) -> dict:
    """Content manifest for a dataset: per-task sha256 of the SPEC SOURCE
    (environment/task.lean) plus an aggregate content hash. Derived files
    (tests/, instruction, Dockerfile) are deliberately excluded — `refresh`
    rewrites them without changing what the dataset *is*."""
    tasks: dict[str, str] = {}
    for task_dir in sorted(p for p in ds.iterdir() if p.is_dir()):
        spec = task_dir / "environment" / "task.lean"
        if spec.is_file():
            tasks[task_dir.name] = _sha256_file(spec)
    agg = hashlib.sha256(
        "".join(f"{k} {v}\n" for k, v in sorted(tasks.items())).encode()
    ).hexdigest()
    return {
        "schema_version": 1,
        "name": ds.name,
        "task_count": len(tasks),
        "content_sha256": agg,
        "lean_profile": LEAN_PROFILE,
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "tasks": tasks,
    }


def write_manifest(ds: Path) -> dict:
    m = build_manifest(ds)
    (ds / MANIFEST_NAME).write_text(
        json.dumps(m, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    return m


def manifest_issues(ds: Path) -> list[str]:
    """Fail-closed spec-content check against the dataset's manifest.json."""
    mp = ds / MANIFEST_NAME
    if not mp.is_file():
        return [f"{ds}: manifest.json missing (run: dataset.py manifest {ds})"]
    try:
        m = json.loads(mp.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [f"{ds}: manifest.json unparseable: {exc}"]
    current = build_manifest(ds)
    issues = []
    expected = m.get("tasks") or {}
    missing = sorted(set(expected) - set(current["tasks"]))
    extra = sorted(set(current["tasks"]) - set(expected))
    if missing:
        issues.append(f"{ds}: {len(missing)} task(s) in manifest but absent: {missing[:5]}")
    if extra:
        issues.append(f"{ds}: {len(extra)} task(s) on disk but not in manifest: {extra[:5]}")
    changed = sorted(
        t for t in set(expected) & set(current["tasks"]) if expected[t] != current["tasks"][t]
    )
    if changed:
        issues.append(f"{ds}: {len(changed)} task spec(s) changed vs manifest: {changed[:5]}")
    if not issues and m.get("content_sha256") != current["content_sha256"]:
        issues.append(f"{ds}: content_sha256 mismatch")
    return issues


def cmd_manifest(args) -> int:
    for ds in args.datasets:
        m = write_manifest(ds)
        print(f"{ds}: {m['task_count']} task(s), content_sha256={m['content_sha256'][:16]}…")
    return 0


# ------------------------------------------------------------ validate ------

REQUIRED = [
    "task.toml",
    "instruction.md",
    "environment/Dockerfile",
    "environment/task.lean",
    "tests/test.sh",
    "tests/grade.py",
    "tests/original.lean",
    "tests/task_file.txt",
]


def cmd_validate(args) -> int:
    grader_ref = (VERIFIER_DIR / "grade.py").read_bytes()
    bad = 0
    n = 0
    for ds in args.datasets:
        for issue in manifest_issues(ds):
            bad += 1
            print(f"INVALID {issue}", file=sys.stderr)
        for task_dir in sorted(p for p in ds.iterdir() if p.is_dir()):
            n += 1
            errs = [rel for rel in REQUIRED if not (task_dir / rel).is_file()]
            if not errs:
                spec = (task_dir / "environment" / "task.lean").read_text(encoding="utf-8")
                if (task_dir / "tests" / "original.lean").read_text(encoding="utf-8") != spec:
                    errs.append("tests/original.lean != environment/task.lean")
                if "sorry" not in spec:
                    errs.append("spec has no sorry")
                if (task_dir / "tests" / "grade.py").read_bytes() != grader_ref:
                    errs.append("tests/grade.py is stale (run refresh)")
                try:
                    tomllib.loads((task_dir / "task.toml").read_text(encoding="utf-8"))
                except tomllib.TOMLDecodeError as exc:
                    errs.append(f"task.toml parse error: {exc}")
            if errs:
                bad += 1
                print(f"INVALID {task_dir}: {'; '.join(errs)}", file=sys.stderr)
    print(f"{n - bad}/{n} task(s) valid")
    return 1 if bad else 0


# ---------------------------------------------------------------- main ------


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    sub = ap.add_subparsers(dest="cmd", required=True)

    mk = sub.add_parser("make", help="generate a dataset of Harbor task dirs")
    mk.add_argument("--from-lean-dir", type=Path, required=True,
                    help="one task per *.lean file (recursive)")
    mk.add_argument("out", type=Path, help="output dataset dir")
    mk.add_argument("--org", default="codeprover")
    mk.add_argument("--image", default=DEFAULT_IMAGE)
    mk.add_argument("--agent-timeout", type=float, default=DEFAULT_AGENT_TIMEOUT)
    mk.add_argument("--verifier-timeout", type=float, default=DEFAULT_VERIFIER_TIMEOUT)
    mk.add_argument("--limit", type=int, default=0)
    mk.add_argument("--force", action="store_true")
    mk.set_defaults(func=cmd_make)

    rf = sub.add_parser(
        "refresh",
        help="regenerate all derived files (grader, instruction, Dockerfile, "
        "task.toml) in place; spec source and metadata are preserved",
    )
    rf.add_argument("datasets", nargs="+", type=Path)
    rf.add_argument("--image", default=None, help="override base image")
    rf.add_argument("--agent-timeout", type=float, default=None)
    rf.add_argument("--verifier-timeout", type=float, default=None)
    rf.set_defaults(func=cmd_refresh)

    mf = sub.add_parser("manifest", help="(re)write a dataset's manifest.json "
                        "(per-task spec sha256 + aggregate content hash)")
    mf.add_argument("datasets", nargs="+", type=Path)
    mf.set_defaults(func=cmd_manifest)

    va = sub.add_parser("validate", help="structural sanity checks for datasets "
                        "(fail-closed against manifest.json)")
    va.add_argument("datasets", nargs="+", type=Path)
    va.set_defaults(func=cmd_validate)

    args = ap.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
