#!/usr/bin/env bash
# Sequential distillation driver: rounds FIRST..LAST on e2b.dev, one after
# another (per Zenan 2026-07-22: 1024 concurrency, auto-continue when a round
# ends). Each round: materialize tasks -> render config -> harbor run (blocks).
# Harbor task-level failures don't stop the chain — stragglers are caught
# by `distill_ops rescue` afterwards. A hard harbor crash aborts the chain
# so a human can look.
#
# Campaign selection via env (see tools/distill_ops.py):
#   DISTILL_DATASET   dataset root (default data/coding-v2.1-full-20260721)
#   DISTILL_CAMPAIGN  label prefix, e.g. v2.2 -> distill-dpsk-v2.2-roundN
#
# Usage: set -a && source .env && set +a
#        PYTHONPATH=$PWD nohup tools/run_distill_rounds.sh 2 6 \
#          > jobs/distill-rounds-driver.log 2>&1 & disown
set -uo pipefail
cd "$(dirname "$0")/.."

FIRST=${1:-2}
LAST=${2:-6}
PREFIX="${DISTILL_CAMPAIGN:+$DISTILL_CAMPAIGN-}"

for r in $(seq "$FIRST" "$LAST"); do
    label="${PREFIX}round$r"
    echo "=== $label: materialize + config @ $(date -u +%FT%TZ) ==="
    python3 tools/distill_ops.py rounds --round "$r" || exit 1
    python3 tools/distill_ops.py config --round "$r" --force || exit 1
    echo "=== $label: harbor run @ $(date -u +%FT%TZ) ==="
    .venv/bin/harbor run -c "configs/distill-dpsk-$label.yaml" \
        > "jobs/distill-dpsk-$label-run.log" 2>&1
    rc=$?
    echo "=== $label: harbor exited rc=$rc @ $(date -u +%FT%TZ) ==="
    if [ "$rc" -ne 0 ]; then
        echo "harbor crashed on $label — chain aborted" >&2
        exit "$rc"
    fi
done
echo "=== all rounds done @ $(date -u +%FT%TZ) ==="
