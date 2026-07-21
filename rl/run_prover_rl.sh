#!/bin/bash
# miles RL launch template for Code-Prover — adapted from
# <miles>/examples/retool/retool_qwen3_4b_rl.sh. Fill the TODO() blocks for
# the actual cluster (this script is a wiring reference, not runnable as-is).
#
# Prereqs:
#   - OFFICIAL miles: repo /mnt/VerifiableAILab/zenan.li/miles (radixark/miles),
#     run inside the OFFICIAL image `radixark/miles:latest` (no custom builds).
#     Our generate() uses the legacy 3-arg signature, auto-wrapped by miles'
#     LegacyGenerateFnAdapter — works on current HEAD (ab97f75).
#   - SFT ckpt converted to Megatron format (miles ckpt tools)
#   - code-prover-lean docker image on every rollout node (or E2B template)
#   - ray started on the cluster, then:
#       ray job submit --address=http://127.0.0.1:8265 -- bash rl/run_prover_rl.sh
set -euo pipefail

REPO=$(cd "$(dirname "$0")/.." && pwd)
MILES=/mnt/VerifiableAILab/zenan.li/miles
MODEL_HF=/mnt/VerifiableAILab/ziran.yang/models/codeprover-20260711-agent-proof-256k-qwen3.6-35b-a3b-ep2
MODEL_MEGATRON="TODO(converted Megatron ckpt dir)"

CUSTOM_ARGS=(
   --custom-generate-function-path rl.generate_with_prover.generate
   --prover-model-path "$MODEL_HF"
   --prover-task-root "$REPO/tasks/trainset_problems_300"
   --prover-sandbox-backend docker          # or: e2b (+ --prover-e2b-template)
   --prover-docker-image lizenan1995/code-prover-lean:latest
   --prover-max-turns 64
   --prover-max-total-tokens 65536
   --prover-sandbox-concurrency 32
)

ROLLOUT_ARGS=(
   --prompt-data "$REPO/rl/data/trainset_problems_300.jsonl"
   --input-key prompt
   --metadata-key metadata
   --rollout-batch-size 32
   --n-samples-per-prompt 8
   --rollout-max-response-len 65536
   --rollout-temperature 0.8
   # binary 0/1 reward: keep groups with signal only
   --dynamic-sampling-filter-path miles.rollout.filter_hub.dynamic_sampling_filters.check_reward_nonzero_std
   --over-sampling-batch-size 64
)

GRPO_ARGS=(
   --advantage-estimator grpo
   --rewards-normalization
   # NOTE: no --grpo-std-normalization (Dr.GRPO-style, avoids length bias)
)

PERF_ARGS=(
   # TODO(parallelism for qwen3.6-35B-A3B on the actual cluster):
   # --tensor-model-parallel-size / --expert-model-parallel-size /
   # --pipeline-model-parallel-size / sglang server counts & memory fractions
   :
)

python3 "$MILES/train.py" \
   --actor-num-nodes "TODO" \
   --actor-num-gpus-per-node "TODO" \
   --hf-checkpoint "$MODEL_HF" \
   --ref-load "$MODEL_MEGATRON" \
   "${ROLLOUT_ARGS[@]}" \
   "${GRPO_ARGS[@]}" \
   "${CUSTOM_ARGS[@]}" \
   "${PERF_ARGS[@]}"
