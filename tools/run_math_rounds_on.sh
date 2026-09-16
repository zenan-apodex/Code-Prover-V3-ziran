#!/usr/bin/env bash
# Split-backend math rounds driver (2026-07-24, per Zenan): run two chains in
# parallel — rounds 5/7 on e2b.dev while rounds 4/6/8 run on JB — halving
# wall-clock vs the single-backend sequential driver.
# Each round: materialize -> derive config from a backend base yaml (round
# token substitution) -> harbor run (blocks) -> one-line summary. A hard
# harbor crash aborts the chain.
#
# Usage:
#   tools/run_math_rounds_on.sh <base_yaml> <base_round> <harbor_bin> <round>...
#   base_yaml   e.g. configs/distill-math-round5-e2b.yaml
#   base_round  the round token in base_yaml to substitute, e.g. round5
#   harbor_bin  .venv/bin/harbor (e2b.dev) or .venv-aliyun/bin/harbor (aliyun)
# Env:
#   WAIT_PATTERN  if set, block until no process matches it before starting
#                 (chains behind the currently-running round on that backend)
#
# Example (JB chain behind the live round4):
#   WAIT_PATTERN='distill-math-round4-jb.yaml' PYTHONPATH=$PWD nohup \
#     tools/run_math_rounds_on.sh configs/distill-math-round4-jb.yaml round4 \
#     .venv-aliyun/bin/harbor 6 8 > jobs/distill-math-jb-chain.log 2>&1 & disown
set -uo pipefail
cd "$(dirname "$0")/.."

BASE=$1; BASE_ROUND=$2; HARBOR=$3; shift 3
SUFFIX=$(basename "$BASE" .yaml); SUFFIX=${SUFFIX##*-}   # sg / jb / e2b
# dataset + job/config name prefix are overridable for later carve
# generations (math-v0.1+); defaults preserve the original v0 campaign.
export DISTILL_DATASET="${DISTILL_DATASET:-$PWD/data/math-v0-unsolved-20260722}"
LABEL_PREFIX="${LABEL_PREFIX:-distill-math}"

if [ -n "${WAIT_PATTERN:-}" ]; then
    echo "=== waiting for '$WAIT_PATTERN' to finish @ $(date -u +%FT%TZ) ==="
    # exclude this driver itself: $BASE on our own cmdline matches the
    # pattern (2026-07-24: chain deadlocked waiting on its own pid)
    while pgrep -f "$WAIT_PATTERN" | grep -qvx "$$"; do sleep 60; done
    echo "=== predecessor done @ $(date -u +%FT%TZ) ==="
fi

for r in "$@"; do
    label="$LABEL_PREFIX-round$r-$SUFFIX"
    echo "=== $label: materialize + config @ $(date -u +%FT%TZ) ==="
    python3 tools/distill_ops.py rounds --round "$r" || exit 1
    if [ "configs/$label.yaml" != "$BASE" ]; then
        sed "s/$BASE_ROUND/round$r/g" "$BASE" > "configs/$label.yaml"
    fi
    echo "=== $label: harbor run @ $(date -u +%FT%TZ) ==="
    "$HARBOR" run -c "configs/$label.yaml" > "jobs/$label-run.log" 2>&1
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
echo "=== chain done @ $(date -u +%FT%TZ) ==="
