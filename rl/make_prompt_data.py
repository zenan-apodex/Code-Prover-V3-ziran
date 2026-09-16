"""Convert a harbor task dataset into miles --prompt-data jsonl.

    .venv/bin/python rl/make_prompt_data.py \
        --task-root tasks/trainset_problems_300 \
        --out rl/data/trainset_problems_300.jsonl

Each line includes the exact instruction plus task/verifier SHA-256 provenance.
miles flags: --input-key prompt --metadata-key metadata.
The rollout function resolves tests/grade.py etc. from
--prover-task-root/<task_name> at episode time, so the jsonl stays small.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

try:
    from rl.provenance import prompt_record
except ModuleNotFoundError:  # direct ``python rl/make_prompt_data.py`` invocation
    from provenance import prompt_record


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--task-root", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    root = Path(args.task_root)
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)

    n = 0
    with out.open("w", encoding="utf-8") as f:
        for task_dir in sorted(root.iterdir()):
            if not task_dir.is_dir():
                continue
            instruction = task_dir / "instruction.md"
            tests = task_dir / "tests" / "grade.py"
            if not instruction.exists() or not tests.exists():
                continue
            record = prompt_record(task_dir)
            instruction_text = record["prompt"]
            # Preserve messages-list prompts for Miles multimodal processors.
            record["prompt"] = [{"role": "user", "content": instruction_text}]
            record["metadata"]["instruction"] = instruction_text
            f.write(json.dumps(record, ensure_ascii=False) + "\n")
            n += 1
    print(f"wrote {n} prompts -> {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
