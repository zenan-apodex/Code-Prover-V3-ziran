"""Carve the unsolved subset of a campaign dataset into a new dataset dir
(the v2.1->v2.2 ad-hoc flow, as a repo tool: v2.2->v2.3 and onward).

    python3 tools/carve_unsolved.py \
        --source data/coding-v2.2-unsolved-20260723 \
        --jobs jobs/distill-dpsk-v2.2-round1 jobs/distill-dpsk-v2.2-round2 \
               jobs/distill-dpsk-v2.2-round3 jobs/distill-dpsk-v2.2-round4 \
        --out data/coding-v2.3-unsolved-20260723 \
        --seed 20260723 --round-size 5000

Solved = any trial in any given job reached reward==1.0. Everything else
(clean failures, exceptions, never-attempted) is carried into the new
dataset. Output layout matches the source: tasks/ (+manifest.json),
rounds_assignment.json (seeded shuffle split), provenance.json.
"""

from __future__ import annotations

import argparse
import json
import random
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO))
from tools.dataset import write_manifest  # noqa: E402


def solved_names(job: Path) -> set[str]:
    solved = set()
    for p in job.glob("*/result.json"):
        try:
            d = json.loads(p.read_text())
        except ValueError:
            continue
        if d.get("exception_info") is not None:
            continue
        reward = ((d.get("verifier_result") or {}).get("rewards") or {}).get("reward")
        if reward == 1.0:
            solved.add(Path(d["task_id"]["path"]).name)
    return solved


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True, type=Path)
    ap.add_argument("--jobs", required=True, nargs="+", type=Path)
    ap.add_argument("--out", required=True, type=Path)
    ap.add_argument("--seed", required=True, type=int)
    ap.add_argument("--round-size", type=int, default=5000)
    args = ap.parse_args()

    if args.out.exists():
        print(f"FATAL: {args.out} already exists", file=sys.stderr)
        return 1

    universe = sorted(p.name for p in (args.source / "tasks").iterdir()
                      if p.is_dir())
    print(f"source universe: {len(universe)} tasks", flush=True)

    solved: set[str] = set()
    for job in args.jobs:
        s = solved_names(job)
        solved |= s
        print(f"{job}: {len(s)} solved (cumulative {len(solved)})", flush=True)

    unsolved = [n for n in universe if n not in solved]
    print(f"unsolved: {len(unsolved)}", flush=True)

    out_tasks = args.out / "tasks"
    out_tasks.mkdir(parents=True)
    for i, name in enumerate(unsolved, 1):
        shutil.copytree(args.source / "tasks" / name, out_tasks / name)
        if i % 500 == 0:
            print(f"  {i}/{len(unsolved)}", flush=True)
    m = write_manifest(out_tasks)

    rng = random.Random(args.seed)
    shuffled = unsolved[:]
    rng.shuffle(shuffled)
    rounds = {f"round{i + 1}": shuffled[o:o + args.round_size]
              for i, o in enumerate(range(0, len(shuffled), args.round_size))}
    (args.out / "rounds_assignment.json").write_text(json.dumps({
        "seed": args.seed,
        "total": len(unsolved),
        "sizes": {k: len(v) for k, v in rounds.items()},
        "rounds": rounds,
    }, indent=1) + "\n")

    (args.out / "provenance.json").write_text(json.dumps({
        "created": datetime.now(timezone.utc).isoformat(),
        "source_dataset": str(args.source),
        "criteria": ("no trial reached reward==1.0 across jobs "
                     + ", ".join(j.name for j in args.jobs)),
        "source_total": len(universe),
        "solved": len(solved),
        "unsolved": len(unsolved),
        "task_manifest_sha256": m["content_sha256"],
    }, indent=1) + "\n")

    print(f"{args.out}: {m['task_count']} tasks, "
          f"content_sha256={m['content_sha256'][:16]}…, "
          f"rounds {[len(v) for v in rounds.values()]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
