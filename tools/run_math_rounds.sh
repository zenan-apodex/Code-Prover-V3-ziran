#!/usr/bin/env bash
# Sequential math-v0 distillation driver: rounds FIRST..LAST on the internal
# Aliyun SG cluster, one after another (per Zenan 2026-07-23, following the
# proven round1 shape: 500 concurrency, 2c/8G sandboxset, DeepSeek+thinking).
# Each round: materialize tasks -> derive config from the round1 yaml ->
# harbor run (blocks) -> one-line result summary. Task-level failures don't
# stop the chain (stragglers go to a final rescue pass); a hard harbor crash
# aborts the chain so a human can look.
#
# Usage: set -a && source .env && set +a
#        PYTHONPATH=$PWD nohup tools/run_math_rounds.sh 2 8 \
#          > jobs/distill-math-rounds-driver.log 2>&1 & disown
set -uo pipefail
cd "$(dirname "$0")/.."

FIRST=${1:-2}
LAST=${2:-8}
export DISTILL_DATASET="$PWD/data/math-v0-unsolved-20260722"
BASE_CONFIG=configs/distill-math-round1-sg.yaml

for r in $(seq "$FIRST" "$LAST"); do
    label="distill-math-round$r"
    echo "=== $label: materialize + config @ $(date -u +%FT%TZ) ==="
    python3 tools/distill_ops.py rounds --round "$r" || exit 1
    sed -e "s/^job_name: .*/job_name: $label/" \
        -e "s|rounds/round1|rounds/round$r|" \
        "$BASE_CONFIG" > "configs/$label-sg.yaml"
    echo "=== $label: harbor run @ $(date -u +%FT%TZ) ==="
    .venv-aliyun/bin/harbor run -c "configs/$label-sg.yaml" \
        > "jobs/$label-run.log" 2>&1
    rc=$?
    echo "=== $label: harbor exited rc=$rc @ $(date -u +%FT%TZ) ==="
    python3 - <<PY
import json, glob
n = solved = exc = 0
for f in glob.glob("jobs/$label/math__*/result.json"):
    n += 1
    r = json.load(open(f))
    if r.get("exception_info"): exc += 1; continue
    if ((r.get("verifier_result") or {}).get("rewards") or {}).get("reward") == 1.0:
        solved += 1
print(f"=== $label RESULT: {solved}/{n} solved ({solved/max(n,1)*100:.1f}%), {exc} exceptions ===")
PY
    if [ "$rc" -ne 0 ]; then
        echo "harbor crashed on $label — chain aborted" >&2
        exit "$rc"
    fi
done
echo "=== all math rounds done @ $(date -u +%FT%TZ) ==="
