#!/bin/bash
# One-time HF -> Megatron torch_dist conversion of the code-prover SFT ckpt,
# run inside the OFFICIAL radixark/miles:latest image on this node's 1 GPU.
# (Official docs use 8 GPUs; the tool adapts PP to WORLD_SIZE, and 65G bf16
# weights fit a single 144G card.)
#
# NOTE: free the GPU first (stop sglang), then:
#   bash rl/convert_ckpt.sh
set -euo pipefail

HF_CKPT=/mnt/VerifiableAILab/ziran.yang/models/codeprover-20260711-agent-proof-256k-qwen3.6-35b-a3b-ep2
OUT=/mnt/VerifiableAILab/zenan.li/models/codeprover-qwen3.6-35b-a3b-ep2_torch_dist
MILES_SRC=/mnt/VerifiableAILab/zenan.li/miles   # official clone, only for scripts/models preset parity check

mkdir -p "$(dirname "$OUT")"

docker run --rm --gpus all --shm-size 64g --network host \
  -v /mnt/VerifiableAILab:/mnt/VerifiableAILab \
  radixark/miles:latest \
  bash -c "
    set -euo pipefail
    cd /root/miles
    source scripts/models/qwen3.6-35B-A3B.sh
    PYTHONPATH=/root/Megatron-LM torchrun --nproc-per-node 1 \
      tools/convert_hf_to_torch_dist.py \
      \${MODEL_ARGS[@]} \
      --hf-checkpoint $HF_CKPT \
      --save $OUT \
      --mtp-num-layers 0
  "
# NOTE: the official preset/docs use --mtp-num-layers 1, but the code-prover
# SFT export dropped the MTP weights (0 'mtp.*' tensors in the safetensors
# index), so the MTP layer must be omitted here (last flag wins).

echo "converted -> $OUT"
