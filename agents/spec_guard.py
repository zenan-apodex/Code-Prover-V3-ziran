"""Agent-side spec-integrity guard.

Read-only-projection check ported verbatim from the verifier
(``verifier/grade.py``): the agent runs it after every tool call that may
have touched the task file, and reverts the file when read-only benchmark
text changed. Keep the semantics in lockstep with the verifier — a guard
that is stricter is wasted work, one that is laxer leaks violations.
"""

from __future__ import annotations

import re

_START_RE = re.compile(r"^\s*-- !benchmark @start\s+([A-Za-z0-9_./:-]+)\b")
_END_RE = re.compile(r"^\s*-- !benchmark @end\s+([A-Za-z0-9_./:-]+)\b")

EDITABLE_BENCHMARK_SECTIONS = frozenset(
    {"solution_aux", "code_aux", "code", "proof_aux", "proof"}
)

_SAFE_PUNCT = re.compile(r"\s*([:,()\[\]{}⟨⟩])\s*")


def _readonly_projection(source: str) -> tuple[str, str | None]:
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


def _ws_normalize(projection: str) -> list[str]:
    out = []
    for ln in projection.splitlines():
        ln = re.sub(r"\s+", " ", ln.strip())
        ln = _SAFE_PUNCT.sub(r"\1", ln)
        if ln:
            out.append(ln)
    return out


def check_spec_intact(original: str, final: str) -> dict:
    """Whitespace-forgiving projection equality — same verdict the verifier
    reaches (its default, non ``--strict-bytes`` mode)."""
    original_has = "-- !benchmark @start" in original
    final_has = "-- !benchmark @start" in final
    if not original_has and not final_has:
        return {"ok": True, "checked": False, "reason": "no benchmark markers"}
    if original_has != final_has:
        return {"ok": False, "checked": True,
                "reason": "benchmark markers added or removed"}
    orig_proj, orig_err = _readonly_projection(original)
    if orig_err:
        return {"ok": True, "checked": False, "reason": f"original malformed: {orig_err}"}
    final_proj, final_err = _readonly_projection(final)
    if final_err:
        return {"ok": False, "checked": True, "reason": final_err}
    if orig_proj == final_proj:
        return {"ok": True, "checked": True, "mode": "byte_exact"}
    if _ws_normalize(orig_proj) == _ws_normalize(final_proj):
        return {"ok": True, "checked": True, "mode": "whitespace_normalized"}

    diff = None
    o_lines, f_lines = orig_proj.splitlines(), final_proj.splitlines()
    for i, (a, b) in enumerate(zip(o_lines, f_lines)):
        if a != b:
            diff = {"line": i + 1, "expected": a, "actual": b}
            break
    if diff is None:
        diff = {"expected_lines": len(o_lines), "actual_lines": len(f_lines)}
    return {
        "ok": False,
        "checked": True,
        "reason": "read-only benchmark text changed; only editable section bodies may differ",
        "first_divergence": diff,
    }
