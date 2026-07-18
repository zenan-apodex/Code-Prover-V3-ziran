#!/bin/bash
# Code-Prover-V3 Harbor verifier entrypoint.
#
# Harbor copies the task's tests/ dir to /tests AFTER the agent phase and runs
# this script in the same container (shared mode). It must leave the reward at
# /logs/verifier/reward.json — grade.py owns that contract.

set -u
mkdir -p /logs/verifier

# elan/lake live under /root/.elan in the code-prover-lean image.
export PATH="/root/.elan/bin:/usr/local/bin:$PATH"

TASK_FILE="$(cat /tests/task_file.txt)"

python3 /tests/grade.py \
  --task-file "$TASK_FILE" \
  --original /tests/original.lean \
  --project-dir /task \
  --out-dir /logs/verifier

# grade.py writes reward.json in every path (including its crash handler);
# exit 0 so Harbor reads the reward instead of recording a verifier exception.
exit 0
