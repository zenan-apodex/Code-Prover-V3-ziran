#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Step 1/2 — Convert the torchtitan DCP (sharded) checkpoint → HF safetensors.
#
# torchtitan writes .distcp shards which no inference server can load. This runs
# the converter shipped with torchtitan-fork (EVAL_HANDOFF.md §2) into the SINGLE
# model_path defined in prove.local-sft.yaml. The final (highest-step) checkpoint
# is picked automatically — no step bookkeeping.
#
#   ./convert_dcp_to_hf.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${CONFIG:-$HERE/prove.local-sft.yaml}"
yget() { python3 -c "import sys,yaml;print((yaml.safe_load(open(sys.argv[1])) or {}).get(sys.argv[2]) or '')" "$CONFIG" "$1"; }

# ── single source of truth: the HF model dir lives in the yaml ───────────────
HF_OUT="$(yget model_path)"
[[ -n "$HF_OUT" ]] || { echo "✗ model_path not set in $CONFIG" >&2; exit 1; }

# ── convert-time locations (stable training outputs) ─────────────────────────
TORCHTITAN="${TORCHTITAN:-/mnt/workspace/ziran.yang/torchtitan-fork}"
TT_PY="${TT_PY:-/mnt/public-env/venv/torchtitan/bin/python}"
DCP_ROOT="${DCP_ROOT:-$TORCHTITAN/outputs/qwen35-35b-codeprover/checkpoint}"
HF_ASSETS="${HF_ASSETS:-/mnt/workspace/ziran.yang/models/Qwen3.5-35B-A3B}"
MODEL_NAME="${MODEL_NAME:-qwen3_5_moe}"
MODEL_FLAVOR="${MODEL_FLAVOR:-35b-a3b}"

# Final checkpoint = highest step-N dir. Sort by the numeric step ONLY (the path
# itself contains dashes — torchtitan-fork, qwen35-35b — so a path-wide `sort -t-`
# picks the wrong dir).
_MAX_STEP="$(ls -d "$DCP_ROOT"/step-* 2>/dev/null | sed 's#.*/step-##' | sort -n | tail -1)"
DCP_DIR="$DCP_ROOT/step-$_MAX_STEP"
[[ -n "$_MAX_STEP" && -d "$DCP_DIR" ]] || { echo "✗ no step-* checkpoint under $DCP_ROOT" >&2; exit 1; }
[[ -x "$TT_PY" ]]     || { echo "✗ torchtitan python not found: $TT_PY" >&2; exit 1; }
[[ -d "$HF_ASSETS" ]] || { echo "✗ HF assets dir not found: $HF_ASSETS" >&2; exit 1; }

if ls "$HF_OUT"/*.safetensors >/dev/null 2>&1; then
  echo "✓ HF checkpoint already present: $HF_OUT (delete it to re-convert)"; exit 0
fi

echo "── DCP → HF ─────────────────────────────────────────────"
echo "  src (DCP) : $DCP_DIR   (final checkpoint, auto-picked)"
echo "  out (HF)  : $HF_OUT"
echo "  (needs ~70GB free on the target mount — verify quota first)"
echo "─────────────────────────────────────────────────────────"

cd "$TORCHTITAN"
# torchtitan is a source tree here, not a pip install — `python script.py` only
# puts the script's own dir on sys.path, so `import torchtitan` needs the repo
# root on PYTHONPATH explicitly.
PYTHONPATH="$TORCHTITAN${PYTHONPATH:+:$PYTHONPATH}" \
"$TT_PY" scripts/checkpoint_conversion/convert_to_hf.py \
    "$DCP_DIR" "$HF_OUT" \
    --hf_assets_path "$HF_ASSETS" \
    --model_name "$MODEL_NAME" --model_flavor "$MODEL_FLAVOR"

# The converter only writes weight shards + its own model.safetensors.index.json
# (it uses --hf_assets_path ONLY for the index mapping, NOT to copy config). So
# the config + tokenizer + chat template must be copied from the base assets, or
# the model is unservable ("Unrecognized model … no model_type"). Copy every
# non-weight asset; NEVER the *.safetensors or the *.index.json (the converted
# dir already has its OWN index for its 14 shards — overwriting it corrupts load).
echo "── copying config/tokenizer assets from $HF_ASSETS ──"
for f in "$HF_ASSETS"/*; do
  base="$(basename "$f")"
  case "$base" in
    *.safetensors|*.index.json) continue ;;   # weights + index belong to the converted dir
  esac
  [[ -f "$f" ]] && cp -v "$f" "$HF_OUT/$base"
done

# The weights are VL-named (model.language_model.*) with no vision tower — the
# SFT trained text only. sglang's Qwen3_5MoeForConditionalGeneration.load_weights
# remaps that prefix and skips the (absent) visual weights without erroring, so
# the copied VL config.json serves text-only fine. Nothing to rename.

echo "✓ converted + assets → $HF_OUT"
echo "  next:  ./serve_sglang.sh"
