"""Reserve reproducible hard-pool validation and tuning tasks outside RL batches."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from rl.provenance import prompt_record, validate_prompt_data


def reserve(pool, task_root, excluded, *, count=256, tuning_count=64, seed=20260907):
    if count <= 0 or tuning_count < 0 or count % 2 or tuning_count % 2:
        raise ValueError("validation and tuning sizes must be even; validation must be positive")
    names = {r["metadata"]["task_name"] for r in excluded}
    hashes = {r["metadata"]["task_sha256"] for r in excluded}
    validation, tuning = [], []
    for domain in ("coding", "math"):
        candidates = sorted(
            (r for r in pool if r["domain"] == domain and r["task_name"] not in names),
            key=lambda r: hashlib.sha256(f"{seed}:{r['task_name']}".encode()).digest(),
        )
        chosen = []
        for row in candidates:
            path = (task_root / row["root_pool"] / "tasks" / row["task_name"]).resolve()
            path.relative_to(task_root.resolve())
            record = prompt_record(path)
            if record["metadata"]["task_sha256"] in hashes:
                continue
            record["metadata"].update({
                "task_dir": str(path), "domain": domain, "status": row["status"],
                "root_pool": row["root_pool"],
            })
            names.add(row["task_name"])
            hashes.add(record["metadata"]["task_sha256"])
            chosen.append(record)
            if len(chosen) == (count + tuning_count) // 2:
                break
        if len(chosen) != (count + tuning_count) // 2:
            raise ValueError(f"not enough disjoint {domain} tasks")
        validation.extend(chosen[:count // 2])
        tuning.extend(chosen[count // 2:])
    return validation, tuning


def assert_disjoint(training_path, reserved_paths):
    training = [json.loads(line) for line in Path(training_path).read_text().splitlines() if line.strip()]
    names = {r["metadata"]["task_name"] for r in training}
    hashes = {r["metadata"]["task_sha256"] for r in training}
    for path in reserved_paths:
        for line in Path(path).read_text().splitlines():
            row = json.loads(line)
            meta = row["metadata"]
            if meta["task_name"] in names or meta["task_sha256"] in hashes:
                raise ValueError(f"reserved evaluation task overlaps training: {meta['task_name']}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pool", type=Path, required=True)
    parser.add_argument("--task-root", type=Path, required=True)
    parser.add_argument("--exclude-prompts", type=Path, nargs="+", required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--tuning-out", type=Path, required=True)
    parser.add_argument("--count", type=int, default=256)
    parser.add_argument("--tuning-count", type=int, default=64)
    parser.add_argument("--seed", type=int, default=20260907)
    args = parser.parse_args()
    if args.out.exists() or args.tuning_out.exists():
        raise FileExistsError("refusing to replace an existing fixed evaluation split")
    pool = [json.loads(line) for line in args.pool.read_text().splitlines()]
    excluded = [json.loads(line) for p in args.exclude_prompts for line in p.read_text().splitlines()]
    validation, tuning = reserve(pool, args.task_root, excluded, count=args.count,
                                 tuning_count=args.tuning_count, seed=args.seed)
    for path, rows in ((args.out, validation), (args.tuning_out, tuning)):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("".join(json.dumps(r, ensure_ascii=False) + "\n" for r in rows))
        validate_prompt_data(path, args.task_root)
    for path in args.exclude_prompts:
        assert_disjoint(path, [args.out, args.tuning_out])
    print(json.dumps({"validation": len(validation), "tuning": len(tuning), "training_overlap": 0}))


if __name__ == "__main__":
    main()
