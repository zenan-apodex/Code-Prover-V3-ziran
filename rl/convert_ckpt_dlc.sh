#!/usr/bin/env bash
# One-time HF -> Megatron torch_dist conversion inside the RL image.
set -euo pipefail

: "${MILES_ROOT:?set MILES_ROOT}"
: "${MEGATRON_LM_ROOT:?set MEGATRON_LM_ROOT}"
: "${HF_CHECKPOINT:?set HF_CHECKPOINT}"
: "${MEGATRON_CHECKPOINT:?set MEGATRON_CHECKPOINT}"

test -f "${HF_CHECKPOINT}/config.json"
test -f "${HF_CHECKPOINT}/model.safetensors.index.json"
test -f "${MILES_ROOT}/tools/convert_hf_to_torch_dist.py"
test -d "${MEGATRON_LM_ROOT}"

if [[ -e "${MEGATRON_CHECKPOINT}" ]]; then
  if [[ -f "${MEGATRON_CHECKPOINT}/latest_checkpointed_iteration.txt" ]]; then
    echo "Megatron checkpoint already complete: ${MEGATRON_CHECKPOINT}"
    exit 0
  fi
  echo "refusing to overwrite incomplete checkpoint path: ${MEGATRON_CHECKPOINT}" >&2
  exit 2
fi

mkdir -p "$(dirname -- "${MEGATRON_CHECKPOINT}")"
cd "${MILES_ROOT}"
source scripts/models/qwen3.6-35B-A3B.sh
export PYTHONPATH="${MEGATRON_LM_ROOT}${PYTHONPATH:+:${PYTHONPATH}}"

# The actor export has no MTP tensors. The final flag overrides the model
# profile's MTP default, matching the canonical RL launcher.
torchrun --nproc-per-node 1 tools/convert_hf_to_torch_dist.py \
  "${MODEL_ARGS[@]}" \
  --hf-checkpoint "${HF_CHECKPOINT}" \
  --save "${MEGATRON_CHECKPOINT}" \
  --mtp-num-layers 0

test -f "${MEGATRON_CHECKPOINT}/latest_checkpointed_iteration.txt"
