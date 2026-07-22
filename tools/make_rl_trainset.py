#!/usr/bin/env python3
"""Build an RL trainset from solved-problems-v0 (proven-solvable OCI tasks).

Pipeline:
  1. sample N tasks from data/solved-problems-v0/manifest.jsonl (status=ok),
     stratified by the DeepSeek solve cost (total_tokens tertiles) as a
     difficulty proxy — biased toward the easy end so early GRPO groups
     actually carry reward variance;
  2. "despec" each solved .lean back into a spec: the five editable marker
     regions are reset (code/proof -> sorry, *_aux emptied); everything else
     — imports, pre/postconditions and their aux, signatures — is untouched;
  3. emit Harbor task dirs via tools/dataset.py `make`;
  4. record sampling provenance in <out>/sampling.json.

Usage:
    python3 tools/make_rl_trainset.py --out training-data --n 1000 [--seed 17]

Then: python3 rl/make_prompt_data.py --task-root training-data --out rl/data/<name>.jsonl
"""

from __future__ import annotations

import argparse
import json
import random
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
# dataset dir renamed from solved-problems-v0 on 2026-07-22 (math split added)
SRC = REPO / "data" / "solved-coding-v0"

# The V2 solver was allowed to edit imports (`@start import type=solution`)
# and occasionally dropped editable markers entirely, so a solved file is NOT
# a faithful spec carrier: reset the import region to the canonical body
# (all 300 known-good specs use exactly `import Mathlib`) and reject any file
# missing one of the five editable regions.
EDITABLE = {"solution_aux", "code_aux", "code", "proof_aux", "proof"}
RESET = EDITABLE | {"import"}
_MARK = re.compile(r"^(\s*)-- !benchmark @(start|end) (\w+)")


def despec(text: str) -> str:
    """Reset editable/import marker regions of a solved file back to spec form.

    Raises ValueError when the file cannot be faithfully restored (markers
    dropped or unbalanced) — callers skip those tasks.
    """
    out: list[str] = []
    seen: set[str] = set()
    skipping = None  # name of the region being reset
    for line in text.splitlines():
        m = _MARK.match(line)
        if m and m.group(3) in RESET:
            indent, kind, name = m.group(1), m.group(2), m.group(3)
            if kind == "start":
                if skipping is not None:
                    raise ValueError(f"nested marker {name} inside {skipping}")
                out.append(line)
                skipping = name
                seen.add(name)
                if name in ("code", "proof"):
                    out.append(f"{indent}sorry")
                elif name == "import":
                    out.append("import Mathlib")
            else:
                if skipping != name:
                    raise ValueError(f"unbalanced markers: @end {name} while in {skipping}")
                out.append(line)
                skipping = None
            continue
        if skipping is None:
            out.append(line)
    if skipping is not None:
        raise ValueError(f"unterminated region {skipping}")
    missing = RESET - seen
    if missing:
        raise ValueError(f"markers dropped by the solver: {sorted(missing)}")
    return "\n".join(out) + "\n"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path, required=True, help="output dataset dir")
    ap.add_argument("--n", type=int, default=1000)
    ap.add_argument("--seed", type=int, default=17)
    ap.add_argument("--mix", default="0.4,0.4,0.2",
                    help="fraction drawn from easy,mid,hard token-tertiles")
    args = ap.parse_args()

    rows = [json.loads(l) for l in (SRC / "manifest.jsonl").read_text().splitlines()]
    rows = [r for r in rows if r["status"] == "ok"
            and (SRC / "leans" / f"{r['task_name']}_CodeProver.lean").exists()]
    rows.sort(key=lambda r: r["total_tokens"])
    t = len(rows) // 3
    tiers = {"easy": rows[:t], "mid": rows[t:2 * t], "hard": rows[2 * t:]}
    fracs = dict(zip(("easy", "mid", "hard"), (float(x) for x in args.mix.split(","))))

    rng = random.Random(args.seed)
    picked: list[tuple[str, dict]] = []
    n_skipped = 0
    for tier, pool in tiers.items():
        k = round(args.n * fracs[tier])
        taken = 0
        for r in rng.sample(pool, len(pool)):  # shuffled walk, skip bad files
            if taken >= k:
                break
            src = SRC / "leans" / f"{r['task_name']}_CodeProver.lean"
            try:
                r["_spec"] = despec(src.read_text(encoding="utf-8"))
            except ValueError:
                n_skipped += 1
                continue
            picked.append((tier, r))
            taken += 1
    print(f"[make_rl_trainset] skipped {n_skipped} unrestorable files")

    with tempfile.TemporaryDirectory(prefix="rl-despec-") as tmp:
        tmpd = Path(tmp)
        for _, r in picked:
            (tmpd / f"{r['task_name']}.lean").write_text(r.pop("_spec"), encoding="utf-8")
        subprocess.run(
            [sys.executable, str(HERE / "dataset.py"), "make",
             "--from-lean-dir", str(tmpd), str(args.out)],
            check=True,
        )

    (args.out / "sampling.json").write_text(json.dumps({
        "source": str(SRC),
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "seed": args.seed,
        "n": len(picked),
        "mix": fracs,
        "difficulty_proxy": "deepseek total_tokens tertiles over solved-problems-v0",
        "tasks": {r["task_name"]: {"tier": tier, "solve_tokens": r["total_tokens"],
                                   "solve_seconds": r["total_time_seconds"],
                                   "attempts_seen": r["attempts_seen"]}
                  for tier, r in picked},
    }, indent=1), encoding="utf-8")
    print(f"[make_rl_trainset] {len(picked)} tasks -> {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
