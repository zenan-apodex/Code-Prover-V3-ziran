#!/usr/bin/env python3
"""Code-Prover-V3 verifier: grade a solved Lean 4 spec task inside a Harbor container.

Runs as ``/tests/grade.py`` after the agent phase (Harbor uploads ``tests/`` only
then, so the agent can never see or tamper with the grader or the pristine spec).

solved == 1.0  iff  ALL of:
  1. sorry_free     — no ``sorry`` token outside comments (V2 sorry_analyzer semantics);
  2. spec_intact    — byte-exact read-only projection match against the pristine
                      ``/tests/original.lean``: only the bodies of the 5 editable
                      marker sections (solution_aux/code_aux/code/proof_aux/proof)
                      may differ; imports, markers, signatures, pre/postconditions
                      and theorem statements are read-only (semantics ported from
                      mainline V2 ``core/benchmark_integrity.py``);
  3. forbidden_free — no forbidden construct in the final source (``axiom``,
                      ``constant``, ``opaque``, ``unsafe``, negation workflow),
                      comment/string-stripped scan (ported from mainline V2
                      ``acceptance_audit._FORBIDDEN_SOURCE_PATTERNS``);
  4. compiled       — ``lake env lean`` on the final file reports zero errors;
  5. axioms_ok      — every theorem present in the ORIGINAL spec depends only on
                      the standard axioms (propext, Classical.choice, Quot.sound).
                      ``sorryAx`` or any custom axiom fails this.

Output contract (Harbor): a flat float dict at /logs/verifier/reward.json, where
``reward`` is the headline 0/1 and the five sub-checks ride along as sub-metrics.
Detailed diagnostics go to grade_details.json next to it.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile

STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}

# Marker sections the agent IS allowed to edit — matches mainline V2
# EDITABLE_BENCHMARK_SECTIONS exactly. Note: `import` is READ-ONLY.
EDITABLE_BENCHMARK_SECTIONS = frozenset(
    {"solution_aux", "code_aux", "code", "proof_aux", "proof"}
)

_START_RE = re.compile(r"^\s*-- !benchmark @start\s+([A-Za-z0-9_./:-]+)\b")
_END_RE = re.compile(r"^\s*-- !benchmark @end\s+([A-Za-z0-9_./:-]+)\b")
_RE_SORRY = re.compile(r"\bsorry\b")
_RE_BLOCK_COMMENT = re.compile(r"/-.*?-/", re.DOTALL)
_RE_LINE_COMMENT = re.compile(r"--.*$", re.MULTILINE)
_RE_STRING = re.compile(r'"(?:\\.|[^"\\])*"')
_RE_THEOREM = re.compile(r"^\s*(?:private\s+)?theorem\s+([A-Za-z_][A-Za-z0-9_'.]*)", re.MULTILINE)
_RE_AXIOM_LINE = re.compile(r"'([^']+)'\s+depends on axioms:\s*\[([^\]]*)\]")
_RE_NO_AXIOMS = re.compile(r"'([^']+)'\s+does not depend on any axioms")

# (pattern, reason) pairs — ported verbatim from mainline acceptance_audit.
FORBIDDEN_SOURCE_PATTERNS = (
    (re.compile(r"\baxiom\s+"), "custom axiom declaration"),
    (re.compile(r"\bconstant\s+"), "constant declaration"),
    (re.compile(r"\bopaque\s+"), "opaque declaration"),
    (re.compile(r"\bunsafe\s+"), "unsafe declaration"),
    (re.compile(r"\bnegation\b|Tacs\.Negate|negate_goal"), "negation workflow"),
)


def find_sorries(text: str) -> list[int]:
    """1-based line numbers of ``sorry`` outside comments (V2 semantics)."""
    cleaned = _RE_BLOCK_COMMENT.sub(lambda m: "\n" * m.group().count("\n"), text)
    hits = []
    for i, line in enumerate(cleaned.splitlines()):
        if _RE_SORRY.search(_RE_LINE_COMMENT.sub("", line)):
            hits.append(i + 1)
    return hits


def _readonly_projection(source: str) -> tuple[str, str | None]:
    """Byte-exact read-only projection — ported from mainline V2
    ``core/benchmark_integrity.py``. Editable section bodies are replaced by a
    sentinel; every other byte (including marker lines) is kept verbatim.
    Returns (projection, error): error is set on malformed marker structure
    (nesting, mismatched or dangling start/end)."""
    lines = source.splitlines(keepends=True)
    projected: list[str] = []
    current_section: str | None = None
    current_editable = False

    for line in lines:
        start_match = _START_RE.match(line)
        end_match = _END_RE.match(line)
        if start_match:
            if current_section is not None:
                return "", f"nested benchmark marker in section `{current_section}`"
            current_section = start_match.group(1)
            current_editable = current_section in EDITABLE_BENCHMARK_SECTIONS
            projected.append(line)
            if current_editable:
                projected.append(f"__CODE_PROVER_EDITABLE_SECTION__:{current_section}\n")
            continue
        if end_match:
            end_section = end_match.group(1)
            if current_section is None:
                return "", f"benchmark end marker without start: `{end_section}`"
            if end_section != current_section:
                return "", (
                    f"benchmark marker mismatch: `{current_section}` ended by `{end_section}`"
                )
            current_section = None
            current_editable = False
            projected.append(line)
            continue
        if current_editable:
            continue
        projected.append(line)

    if current_section is not None:
        return "", f"benchmark start marker without end: `{current_section}`"
    return "".join(projected), None


# Punctuation that is ALWAYS a token separator in Lean 4 — spacing around it
# can never change parsing. Deliberately excludes operators like `-`/`*`
# (where `f -1` vs `f - 1` differ semantically).
_SAFE_PUNCT = re.compile(r"\s*([:,()\[\]{}⟨⟩])\s*")


def _ws_normalize(projection: str) -> list[str]:
    """Lexically-safe whitespace normal form of a read-only projection:
    per line, strip + collapse whitespace runs + drop spaces around
    token-separator punctuation; blank lines dropped. Two projections with
    equal normal forms differ only in semantically-inert whitespace."""
    out = []
    for ln in projection.splitlines():
        ln = re.sub(r"\s+", " ", ln.strip())
        ln = _SAFE_PUNCT.sub(r"\1", ln)
        if ln:
            out.append(ln)
    return out


def check_spec_intact(original: str, final: str, *, strict_bytes: bool = False) -> dict:
    """Mainline check_benchmark_integrity semantics, plus a diagnostic diff.

    By default a byte-exact mismatch is forgiven iff the projections are equal
    under the lexically-safe whitespace normal form (mode
    "whitespace_normalized"); pass strict_bytes=True for the mainline
    byte-exact behaviour."""
    original_has = "-- !benchmark @start" in original
    final_has = "-- !benchmark @start" in final
    if not original_has and not final_has:
        # Non-Verina dataset without markers: nothing enforceable.
        return {"ok": True, "checked": False, "reason": "no benchmark markers in original"}
    if original_has != final_has:
        return {"ok": False, "checked": True,
                "reason": "benchmark markers were added or removed"}

    orig_proj, orig_err = _readonly_projection(original)
    if orig_err:
        return {"ok": False, "checked": True, "reason": f"original: {orig_err}"}
    final_proj, final_err = _readonly_projection(final)
    if final_err:
        return {"ok": False, "checked": True, "reason": final_err}
    if orig_proj == final_proj:
        return {"ok": True, "checked": True, "mode": "byte_exact"}
    if not strict_bytes and _ws_normalize(orig_proj) == _ws_normalize(final_proj):
        return {"ok": True, "checked": True, "mode": "whitespace_normalized"}

    # First divergent line for the report (projection is byte-exact).
    diff = None
    for i, (a, b) in enumerate(zip(orig_proj.splitlines(), final_proj.splitlines())):
        if a != b:
            diff = {"line": i + 1, "expected": a, "actual": b}
            break
    if diff is None:
        diff = {
            "expected_lines": len(orig_proj.splitlines()),
            "actual_lines": len(final_proj.splitlines()),
        }
    return {
        "ok": False,
        "checked": True,
        "reason": "read-only benchmark text changed; only editable section bodies may differ",
        "first_divergence": diff,
    }


def find_forbidden_constructs(text: str) -> list[dict]:
    """Comment/string-stripped scan for forbidden constructs — ported from
    mainline V2 ``acceptance_audit._forbidden_source_construct_issues``."""
    cleaned = _RE_BLOCK_COMMENT.sub(lambda m: "\n" * m.group().count("\n"), text)
    issues: list[dict] = []
    for line_no, line in enumerate(cleaned.splitlines(), start=1):
        code_only = _RE_LINE_COMMENT.sub("", line)
        code_only = _RE_STRING.sub('""', code_only)
        if not code_only.strip():
            continue
        for pattern, reason in FORBIDDEN_SOURCE_PATTERNS:
            if pattern.search(code_only):
                issues.append({"reason": reason, "line": line_no})
                break
    return issues


def compile_and_check_axioms(
    final_text: str, theorem_names: list[str], project_dir: str, timeout: int
) -> dict:
    """One ``lake env lean`` run: compile the final file with ``#print axioms``
    appended for every theorem the original spec declares."""
    probe = final_text.rstrip() + "\n\n"
    for name in theorem_names:
        probe += f"#print axioms {name}\n"
    with tempfile.NamedTemporaryFile(
        "w", suffix=".lean", dir="/tmp", delete=False, encoding="utf-8"
    ) as fh:
        fh.write(probe)
        probe_path = fh.name
    try:
        proc = subprocess.run(
            ["lake", "env", "lean", probe_path],
            cwd=project_dir,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        return {"compiled": False, "axioms_ok": False, "error": f"lean timed out after {timeout}s"}
    finally:
        try:
            os.unlink(probe_path)
        except OSError:
            pass

    out = (proc.stdout or "") + "\n" + (proc.stderr or "")
    # `#print axioms` output is informational; errors carry "error:" markers.
    error_lines = [ln for ln in out.splitlines() if re.search(r"\berror\b\s*:", ln)]
    compiled = proc.returncode == 0 and not error_lines

    axiom_report: dict[str, list[str]] = {}
    for m in _RE_AXIOM_LINE.finditer(out):
        axiom_report[m.group(1)] = [a.strip() for a in m.group(2).split(",") if a.strip()]
    for m in _RE_NO_AXIOMS.finditer(out):
        axiom_report.setdefault(m.group(1), [])

    bad_axioms: dict[str, list[str]] = {}
    missing = []
    for name in theorem_names:
        reported = [k for k in axiom_report if k == name or k.endswith("." + name)]
        if not reported:
            missing.append(name)
            continue
        for key in reported:
            extra = [a for a in axiom_report[key] if a not in STANDARD_AXIOMS]
            if extra:
                bad_axioms[key] = extra
    axioms_ok = compiled and not bad_axioms and not missing
    return {
        "compiled": compiled,
        "axioms_ok": axioms_ok,
        "errors": error_lines[:20],
        "axiom_report": axiom_report,
        "bad_axioms": bad_axioms,
        "missing_axiom_report": missing,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--task-file", required=True, help="the agent-edited .lean file")
    ap.add_argument("--original", required=True, help="pristine spec copy in /tests")
    ap.add_argument("--project-dir", default="/task")
    ap.add_argument("--out-dir", default="/logs/verifier")
    ap.add_argument("--lean-timeout", type=int, default=1200)
    ap.add_argument("--strict-bytes", action="store_true",
                    help="mainline byte-exact spec comparison (no whitespace forgiveness)")
    args = ap.parse_args()

    os.makedirs(args.out_dir, exist_ok=True)
    details: dict = {"task_file": args.task_file}
    checks = {
        "sorry_free": 0.0,
        "spec_intact": 0.0,
        "forbidden_free": 0.0,
        "compiled": 0.0,
        "axioms_ok": 0.0,
    }

    original = open(args.original, encoding="utf-8").read()
    theorem_names = _RE_THEOREM.findall(original)
    details["theorems"] = theorem_names

    try:
        final = open(args.task_file, encoding="utf-8").read()
    except OSError as exc:
        details["fatal"] = f"task file unreadable: {exc}"
        final = None

    if final is not None:
        sorries = find_sorries(final)
        checks["sorry_free"] = float(not sorries)
        details["sorry_lines"] = sorries

        spec = check_spec_intact(original, final, strict_bytes=args.strict_bytes)
        checks["spec_intact"] = float(spec["ok"])
        details["spec_check"] = spec

        forbidden = find_forbidden_constructs(final)
        checks["forbidden_free"] = float(not forbidden)
        details["forbidden_constructs"] = forbidden

        # Compile even when sorries remain — the sub-metric is informative.
        comp = compile_and_check_axioms(
            final, theorem_names, args.project_dir, args.lean_timeout
        )
        checks["compiled"] = float(comp.pop("compiled"))
        checks["axioms_ok"] = float(comp.pop("axioms_ok"))
        details["lean_check"] = comp

    reward = float(all(v == 1.0 for v in checks.values()))
    rewards = {"reward": reward, **checks}

    with open(os.path.join(args.out_dir, "reward.json"), "w", encoding="utf-8") as fh:
        json.dump(rewards, fh, indent=2)
    with open(os.path.join(args.out_dir, "grade_details.json"), "w", encoding="utf-8") as fh:
        json.dump(details, fh, indent=2, ensure_ascii=False)

    print(json.dumps(rewards, indent=2))
    if reward != 1.0:
        print("UNSOLVED — details:", file=sys.stderr)
        print(json.dumps(details, indent=2, ensure_ascii=False)[:4000], file=sys.stderr)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:  # never leave the reward file missing
        out_dir = "/logs/verifier"
        for i, a in enumerate(sys.argv):
            if a == "--out-dir" and i + 1 < len(sys.argv):
                out_dir = sys.argv[i + 1]
        os.makedirs(out_dir, exist_ok=True)
        with open(os.path.join(out_dir, "reward.json"), "w", encoding="utf-8") as fh:
            json.dump({"reward": 0.0, "grader_error": 1.0}, fh)
        print(f"grader crashed: {exc}", file=sys.stderr)
        raise
