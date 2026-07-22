#!/bin/bash
# miles RL launch for Code-Prover on a single 8x L20X-143GB node — parallelism
# and knobs from <miles>/docs/models/qwen/qwen3-6-moe.md (8-GPU reference cell),
# minus everything MTP/EAGLE (our SFT export has no MTP head).
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
MODEL_MEGATRON=/mnt/VerifiableAILab/zenan.li/models/codeprover-qwen3.6-35b-a3b-ep2_torch_dist

# Reference MODEL_ARGS from the official recipe, then strip MTP: our SFT
# export has no MTP head (converted with --mtp-num-layers 0), so the trailing
# override below must win over the recipe's `--mtp-num-layers 1`.
source "$MILES/scripts/models/qwen3.6-35B-A3B.sh"
MODEL_ARGS+=(--mtp-num-layers 0)

# SANDBOX_BACKEND=docker needs the docker CLI + daemon access wherever the
# rollout workers run; e2b only needs E2B_API_KEY + a generic prebuilt
# template (built 07-21 under team july-20-zenan: code-prover-lean-rl).
SANDBOX_BACKEND=${SANDBOX_BACKEND:-docker}

# miles' argparse rejects unknown CLI flags; custom generate-fn settings go
# through --custom-config-path, whose YAML keys are setattr'd onto args.
PROVER_CFG="$REPO/rl/_prover_config.generated.yaml"
cat > "$PROVER_CFG" <<EOF
prover_model_path: $MODEL_HF
prover_task_root: ${TASK_ROOT:-$REPO/training-data}
prover_sandbox_backend: $SANDBOX_BACKEND
prover_docker_image: lizenan1995/code-prover-lean:latest
# 4c/8GB: the original code-prover-lean-rl template (E2B default 2c/1GB)
# cannot finish a full Mathlib `lake env lean` — known-good solutions graded
# compiled=0 via 1200s timeouts (07-22 control experiment).
prover_e2b_template: ${E2B_TEMPLATE:-code-prover-lean-eval-4c8g}
prover_max_turns: 64
prover_max_total_tokens: 65536
prover_sandbox_concurrency: 32
EOF

CUSTOM_ARGS=(
   --custom-generate-function-path rl.generate_with_prover.generate
   --custom-config-path "$PROVER_CFG"
)

ROLLOUT_ARGS=(
   --prompt-data "${PROMPT_DATA:-$REPO/rl/data/training_data_1000.jsonl}"
   --input-key prompt
   --metadata-key metadata
   --rollout-batch-size 32
   --n-samples-per-prompt 8
   --rollout-max-response-len 65536
   --rollout-temperature 0.8
   # binary 0/1 reward: drop groups with ABORTED samples (reward=None) first,
   # then groups without signal — see rl/filters.py
   --dynamic-sampling-filter-path rl.filters.check_clean_and_nonzero_std
   --over-sampling-batch-size 64
)

GRPO_ARGS=(
   --advantage-estimator grpo
   # rewards normalization is default-on at HEAD (flag flipped to
   # --disable-rewards-normalization)
   # NOTE: no --grpo-std-normalization (Dr.GRPO-style, avoids length bias)
   --use-kl-loss
   --kl-loss-coef 0.00
   --kl-loss-type low_var_kl
   --entropy-coef 0.00
   --eps-clip 0.2
   --eps-clip-high 0.28
)

OPTIMIZER_ARGS=(
   --optimizer adam
   --lr 1e-6
   --lr-decay-style constant
   --weight-decay 0.1
   --adam-beta1 0.9
   --adam-beta2 0.98
   --optimizer-cpu-offload
   --overlap-cpu-optimizer-d2h-h2d
   --use-precision-aware-optimizer
)

# Single node, 8x L20X 143GB (aggregate memory ~= the recipe's 8x H200).
# Reference cell TP=1 EP=8 CP=1 PP=1 ETP=1 from docs/models/qwen/qwen3-6-moe.md.
PERF_ARGS=(
   --tensor-model-parallel-size 1
   --sequence-parallel
   --pipeline-model-parallel-size 1
   --context-parallel-size 1
   --expert-model-parallel-size 8
   --expert-tensor-parallel-size 1
   --recompute-granularity full
   --recompute-method uniform
   --recompute-num-layers 1
   --use-dynamic-batch-size
   # Must cover a full episode (65536 response + prompt) since CP=1;
   # if OOM at smoke time: raise CP or cut --prover-max-total-tokens.
   --max-tokens-per-gpu 69632
)

# No EAGLE speculative block: the SFT ckpt has no MTP head to drive it.
SGLANG_ARGS=(
   --rollout-num-gpus-per-engine 8
   --sglang-mem-fraction-static 0.7
   --sglang-ep-size 8
   # GDN linear-attention state goes NaN under radix-cache prefix reuse
   # (probability-tensor device assert, 07-21 smoke); the eval server always
   # ran with --disable-radix-cache too. Costs per-turn re-prefill.
   # Upstream MambaRadixCache is being reworked — track
   # https://github.com/sgl-project/sglang/issues/27418 before re-enabling,
   # and verify actual generated text first (same rule as SPEC).
   --sglang-disable-radix-cache
   --sglang-cuda-graph-bs 1 2 4 8 16 24 32 40 48 56 64 72 80 88 96 104 112 120 128
   --sglang-max-running-requests 256
   --sglang-mamba-scheduler-strategy extra_buffer
)

MISC_ARGS=(
   --attention-dropout 0.0
   --hidden-dropout 0.0
   --accumulate-allreduce-grads-in-fp32
   --attention-softmax-in-fp32
   --attention-backend flash
   # runtime dispatcher is flex (conversion used alltoall) — recipe quirk
   --moe-token-dispatcher-type flex
   --colocate
)

# SMOKE=1: rollout-only, tiny batch — validates sglang bring-up + episode
# loop + reward wiring without touching the trainer (passed 07-22).
# SMOKE=train: 3 real GRPO steps at small batch — validates the optimizer
# step, weight sync back to sglang, actor-vs-rollout logprob agreement, and
# checkpoint save.
SMOKE_ARGS=()
if [[ "${SMOKE:-0}" == "1" ]]; then
   SMOKE_ARGS=(
      --debug-rollout-only
      --rollout-batch-size 4
      --n-samples-per-prompt 2
      --over-sampling-batch-size 8
      --num-rollout 1
   )
elif [[ "${SMOKE:-0}" == "train" ]]; then
   SMOKE_ARGS=(
      --rollout-batch-size 8
      --n-samples-per-prompt 4
      --over-sampling-batch-size 16
      --num-rollout 3
      --save /mnt/VerifiableAILab/zenan.li/models/codeprover-rl-smoke-ckpt
      --save-interval 3
   )
fi

python3 "$MILES/train.py" \
   --actor-num-nodes 1 \
   --actor-num-gpus-per-node 8 \
   --num-gpus-per-node 8 \
   --hf-checkpoint "$MODEL_HF" \
   --ref-load "$MODEL_MEGATRON" \
   "${MODEL_ARGS[@]}" \
   "${ROLLOUT_ARGS[@]}" \
   "${GRPO_ARGS[@]}" \
   "${OPTIMIZER_ARGS[@]}" \
   "${CUSTOM_ARGS[@]}" \
   "${PERF_ARGS[@]}" \
   "${SGLANG_ARGS[@]}" \
   "${MISC_ARGS[@]}" \
   "${SMOKE_ARGS[@]}"
