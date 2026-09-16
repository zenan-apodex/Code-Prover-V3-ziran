#!/usr/bin/env python3
"""Code-Prover-V3 grader for *repo*-flavor tasks (leancodeprover repo-v1.x).

Task contract (release README / per-task Instruction.md): a task is a
self-contained lake project; the agent may edit ONLY the interiors of
`-- === BEGIN: <name> (editable) ===` regions. Everything else (frozen spec
surface, `(provided)` regions, lakefile, toolchain) is treated as restored
before grading. `lake build <lib>` must succeed and every spec in task.json
must be axiom-clean; sorry/sorryAx/admit/native_decide/axioms are rejected.

The marker/seal layer below is a faithful port of the producer's
spec-judge implementation (Code-Prover-Formalization/spec-judge/src/
spec_judge/lean.py: BEGIN_RE/END_RE, marker_regions,
blank_editable_interiors, compute_seal, verify_seal) so seal verification
is byte-exact against the shipped seal.json.

Grading splices the agent's editable interiors into the PRISTINE tree
(tests/pristine/), so tampering outside editable regions can never change
what is proved; it additionally zeroes spec_intact, mirroring mainline
discipline. reward = 1.0 iff all five sub-checks pass:

  sorry_free ∧ spec_intact ∧ forbidden_free ∧ compiled ∧ axioms_ok
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
import traceback
from dataclasses import dataclass
from pathlib import Path

# ---- faithful port of spec_judge.lean marker/seal layer --------------------

BEGIN_RE = re.compile(
    r"^--\s*===\s*BEGIN:\s*(?P<name>\S+)\s*\((?P<kind>editable|provided)\)\s*===\s*$"
)
END_RE = re.compile(r"^--\s*===\s*END:\s*(?P<name>\S+)\s*===\s*$")


class LeanSourceError(ValueError):
    pass


@dataclass(frozen=True)
class MarkerRegion:
    name: str
    kind: str
    begin: int
    end: int
    interior: str


def marker_regions(text: str) -> list[MarkerRegion]:
    lines = text.splitlines()
    regions: list[MarkerRegion] = []
    active: tuple[str, str, int] | None = None
    names: set[str] = set()
    for index, line in enumerate(lines):
        begin = BEGIN_RE.match(line)
        end = END_RE.match(line)
        if begin:
            if active is not None:
                raise LeanSourceError(f"nested marker at line {index + 1}")
            name = begin.group("name")
            if name in names:
                raise LeanSourceError(f"duplicate marker {name}")
            active = (name, begin.group("kind"), index)
            continue
        if end:
            if active is None or active[0] != end.group("name"):
                raise LeanSourceError(
                    f"unmatched END marker {end.group('name')} at line {index + 1}")
            name, kind, begin_index = active
            regions.append(MarkerRegion(
                name=name, kind=kind, begin=begin_index, end=index,
                interior="\n".join(lines[begin_index + 1:index])))
            names.add(name)
            active = None
    if active is not None:
        raise LeanSourceError(f"unterminated marker {active[0]}")
    return regions


def blank_editable_interiors(text: str) -> str:
    lines = text.splitlines()
    regions = marker_regions(text)
    by_begin = {r.begin: r for r in regions if r.kind == "editable"}
    out: list[str] = []
    index = 0
    while index < len(lines):
        region = by_begin.get(index)
        if region is None:
            out.append(lines[index]); index += 1
            continue
        out.extend((lines[region.begin], f"<<slot {region.name}>>", lines[region.end]))
        index = region.end + 1
    return "\n".join(out)


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def compute_seal(project: Path) -> dict:
    files: dict[str, str] = {}
    for path in sorted(project.rglob("*.lean")):
        if any(p in {".lake", "build", ".git"} for p in path.relative_to(project).parts):
            continue
        rel = path.relative_to(project).as_posix()
        files[rel] = sha256_text(blank_editable_interiors(
            path.read_text(encoding="utf-8", errors="replace")))
    for name in ("lakefile.toml", "lakefile.lean", "lean-toolchain"):
        path = project / name
        if path.exists():
            files[name] = hashlib.sha256(path.read_bytes()).hexdigest()
    return {"files": files}


def verify_seal(project: Path, expected: dict) -> list[str]:
    try:
        actual = compute_seal(project)
    except LeanSourceError as error:
        return [f"marker: {error}"]
    failures: list[str] = []
    expected_files = expected.get("files", {})
    for rel, digest in expected_files.items():
        path = project / rel
        if not path.exists():
            failures.append(f"missing sealed file: {rel}")
        elif actual["files"].get(rel) != digest:
            failures.append(f"modified outside editable body: {rel}")
    extras = sorted(set(actual["files"]) - set(expected_files))
    failures.extend(f"unsealed source file: {rel}" for rel in extras)
    return failures

# ---- grading ----------------------------------------------------------------

# Forbidden inside editable interiors (contract is stricter than mainline;
# these tokens have no legitimate use inside a value/proof hole).
_FORBIDDEN = [
    (re.compile(r"\bsorryAx\b"), "sorryAx"),
    (re.compile(r"\badmit\b"), "admit"),
    (re.compile(r"\bnative_decide\b"), "native_decide"),
    (re.compile(r"^\s*(private\s+|protected\s+|unsafe\s+)*axiom\b", re.M), "axiom declaration"),
    (re.compile(r"^\s*(private\s+|protected\s+)*opaque\b", re.M), "opaque declaration"),
    (re.compile(r"\bunsafe\s+(def|theorem|abbrev|instance)\b"), "unsafe declaration"),
    (re.compile(r"\bLean\.Elab\b|^\s*open\s+Lean\b|\belab\s|\bmacro_rules\b|\binitialize\b", re.M),
     "metaprogramming"),
]
_SORRY = re.compile(r"\bsorry\b")

ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
_RE_AXIOM_LINE = re.compile(r"'([^']+)' depends on axioms: \[([^\]]*)\]")
_RE_NO_AXIOMS = re.compile(r"'([^']+)' does not depend on any axioms")


def splice_file(pristine_text: str, agent_regions: dict[str, MarkerRegion]):
    """Rebuild a file from the pristine skeleton with the agent's editable
    interiors. Returns (merged_text, interiors, missing_names)."""
    lines = pristine_text.splitlines()
    regions = marker_regions(pristine_text)
    by_begin = {r.begin: r for r in regions if r.kind == "editable"}
    out: list[str] = []
    interiors: list[str] = []
    missing: list[str] = []
    index = 0
    while index < len(lines):
        region = by_begin.get(index)
        if region is None:
            out.append(lines[index]); index += 1
            continue
        agent_r = agent_regions.get(region.name)
        if agent_r is not None and agent_r.kind == "editable":
            body = agent_r.interior
        else:
            body = region.interior
            missing.append(region.name)
        interiors.append(body)
        out.append(lines[region.begin])
        if body:
            out.append(body)
        out.append(lines[region.end])
        index = region.end + 1
    return "\n".join(out) + "\n", interiors, missing


def run(cmd, cwd, timeout):
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--agent-dir", default="/task")
    ap.add_argument("--pristine", default="/tests/pristine")
    ap.add_argument("--task-json", default="/tests/task.json")
    ap.add_argument("--seal", default="/tests/seal.json")
    ap.add_argument("--out-dir", default="/logs/verifier")
    ap.add_argument("--build-timeout", type=int, default=1500)
    args = ap.parse_args()

    out_dir = Path(args.out_dir); out_dir.mkdir(parents=True, exist_ok=True)
    sub = {"sorry_free": 0.0, "spec_intact": 0.0, "forbidden_free": 0.0,
           "compiled": 0.0, "axioms_ok": 0.0}
    details: dict = {}

    def emit(reward: float) -> int:
        (out_dir / "reward.json").write_text(json.dumps(
            {"reward": reward, **sub}, indent=2) + "\n")
        (out_dir / "grade_details.json").write_text(
            json.dumps(details, indent=2, default=str) + "\n")
        print(json.dumps({"reward": reward, **sub}))
        return 0

    try:
        task = json.loads(Path(args.task_json).read_text())
        seal = json.loads(Path(args.seal).read_text())
        pristine = Path(args.pristine)
        agent = Path(args.agent_dir)

        # ---- spec_intact: producer-exact seal verification on agent tree ----
        failures = verify_seal(agent, seal)
        details["seal_failures"] = failures
        sub["spec_intact"] = 1.0 if not failures else 0.0

        # ---- agent editable interiors, per sealed file ----
        agent_regions_by_file: dict[str, dict[str, MarkerRegion]] = {}
        for rel in seal.get("files", {}):
            if not rel.endswith(".lean"):
                continue
            p = agent / rel
            if not p.is_file():
                continue
            try:
                agent_regions_by_file[rel] = {
                    r.name: r for r in marker_regions(
                        p.read_text(encoding="utf-8", errors="replace"))}
            except LeanSourceError as exc:
                details.setdefault("marker_violations", []).append(f"{rel}: {exc}")

        # ---- splice merged tree ----
        build_dir = Path(tempfile.mkdtemp(prefix="grade_repo_", dir="/tmp"))
        all_interiors: list[str] = []
        all_missing: list[str] = []
        for src in sorted(pristine.rglob("*")):
            rel = src.relative_to(pristine)
            dst = build_dir / rel
            if src.is_dir():
                dst.mkdir(parents=True, exist_ok=True); continue
            dst.parent.mkdir(parents=True, exist_ok=True)
            rel_s = rel.as_posix()
            if rel_s.endswith(".lean"):
                merged, interiors, missing = splice_file(
                    src.read_text(encoding="utf-8"),
                    agent_regions_by_file.get(rel_s, {}))
                dst.write_text(merged, encoding="utf-8")
                all_interiors += interiors
                all_missing += [f"{rel_s}:{m}" for m in missing]
            else:
                shutil.copy2(src, dst)
        if all_missing:
            details["unfilled_editable"] = all_missing

        joined = "\n".join(all_interiors)
        sub["sorry_free"] = 1.0 if not _SORRY.search(joined) else 0.0
        hits = [reason for pat, reason in _FORBIDDEN if pat.search(joined)]
        details["forbidden_hits"] = hits
        sub["forbidden_free"] = 0.0 if hits else 1.0

        # ---- build ----
        lib = task["lib"]
        try:
            proc = run(["lake", "build", lib], build_dir, args.build_timeout)
            details["build_tail"] = (proc.stdout + proc.stderr)[-2000:]
            compiled = proc.returncode == 0
        except subprocess.TimeoutExpired:
            details["build_tail"] = f"lake build timed out after {args.build_timeout}s"
            compiled = False
        sub["compiled"] = 1.0 if compiled else 0.0

        # ---- axiom probe over every spec from task.json ----
        specs = task.get("specs") or []
        if compiled and specs:
            probe = build_dir / "AxiomProbe.lean"
            probe.write_text(
                f"import {lib}\n" + "".join(f"#print axioms {s}\n" for s in specs),
                encoding="utf-8")
            try:
                pr = run(["lake", "env", "lean", str(probe)], build_dir, args.build_timeout)
                out = pr.stdout + "\n" + pr.stderr
                details["axiom_probe_tail"] = out[-2000:]
                report: dict[str, list[str]] = {}
                for m in _RE_AXIOM_LINE.finditer(out):
                    report[m.group(1)] = [a.strip() for a in m.group(2).split(",") if a.strip()]
                for m in _RE_NO_AXIOMS.finditer(out):
                    report[m.group(1)] = []
                bad = {k: v for k, v in report.items() if not set(v) <= ALLOWED_AXIOMS}
                missing = [s for s in specs if s not in report]
                errors = [l for l in out.splitlines() if re.search(r"\berror\b\s*:", l)]
                details["axiom_report"] = report
                if bad: details["bad_axioms"] = bad
                if missing: details["specs_missing_from_probe"] = missing
                sub["axioms_ok"] = 1.0 if (pr.returncode == 0 and not bad
                                           and not missing and not errors) else 0.0
            except subprocess.TimeoutExpired:
                details["axiom_probe_tail"] = "axiom probe timed out"
        elif compiled and not specs:
            sub["axioms_ok"] = 1.0

        reward = 1.0 if all(v == 1.0 for v in sub.values()) else 0.0
        return emit(reward)
    except Exception:
        details["crash"] = traceback.format_exc()
        return emit(0.0)


if __name__ == "__main__":
    sys.exit(main())
