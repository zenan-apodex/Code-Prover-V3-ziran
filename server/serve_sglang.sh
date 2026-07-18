#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Step 2/2 — Serve the converted HF checkpoint as an OpenAI-compatible endpoint.
#
# Reads the model dir + served name + port straight from prove.local-sft.yaml,
# so there's one source of truth. The Qwen "hermes" tool parser recovers the
# model's <tool_call> TEXT into structured OpenAI tool_calls — exactly what the
# prover harness consumes — so the prover loop runs unchanged against this server.
#
# First run bootstraps a local sglang venv (server/.sglang-venv) if needed.
#
#   ./serve_sglang.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${CONFIG:-$HERE/prove.local-sft.yaml}"
yget() { python3 -c "import sys,yaml;print((yaml.safe_load(open(sys.argv[1])) or {}).get(sys.argv[2]) or '')" "$CONFIG" "$1"; }

# ── from the yaml (single source of truth) ───────────────────────────────────
HF_OUT="$(yget model_path)"
SERVED_NAME="$(yget model)"                          # = prover yaml `model:`
PORT="$(yget llm_base_url | sed -E 's#.*:([0-9]+).*#\1#')"; PORT="${PORT:-8000}"
[[ -n "$HF_OUT" ]] || { echo "✗ model_path not set in $CONFIG" >&2; exit 1; }

# ── serving knobs (rarely change) ────────────────────────────────────────────
HOST="${HOST:-0.0.0.0}"
TP="${TP:-8}"                                         # 8× L20X on this node
# Keep the FULL trained context (128k). These are long agentic rollouts (up to
# ~160 turns of accumulated tool output) — capping context truncates long proofs
# and breaks tasks. The CUDA illegal-memory-access crash is fixed by chunking the
# prefill (below), NOT by shrinking context.
CONTEXT_LEN="${CONTEXT_LEN:-131072}"
# Chunk big prefills instead of one fused ~80k-token kernel launch — same result
# and same usable context, but avoids the kernel edge that crashed the scheduler.
# This is the actual fix. Lower further (4096) if illegal-memory-access recurs.
CHUNKED_PREFILL="${CHUNKED_PREFILL:-8192}"
# The model's PRIMARY tool-call format is hermes JSON
# (<tool_call>{"name":..,"arguments":{..}}</tool_call>) — matches handoff §3 and
# is what it emits early/consistently. (It degrades to qwen3_coder XML only AFTER
# receiving OpenAI-style role:tool results — a train/serve mismatch fixed on the
# harness side, not here.) alt: qwen3_coder, qwen25.
TOOL_PARSER="${TOOL_PARSER:-hermes}"
REASONING_PARSER="${REASONING_PARSER:-qwen3}"         # <think> → reasoning_content; empty to disable
# ⚠️ Mamba state + radix cache reuse is BROKEN on this hybrid arch — not just
# "interacts badly": verified 2026-07-16 on sglang 0.5.13 + the 20260711-256k
# checkpoint that radix cache ON produces GARBAGE output (first token OK, then
# endless token-id-0 "!" — NaN logits in decode; HF transformers ground-truth on
# the same weights is coherent, so it's the serving path, not the checkpoint).
# Radix cache is therefore DISABLED by default. The prefill-reuse speedup it
# offered is NOT worth silently-corrupt generations; if you re-enable it on a
# future sglang, sanity-check actual generated text first (same rule as SPEC).
EXTRA_ARGS="${EXTRA_ARGS:---disable-radix-cache}"
SGLANG_PY="${SGLANG_PY:-$HERE/.sglang-venv/bin/python}"

# ── speculative decoding (optional) ──────────────────────────────────────────
# ⚠️⚠️ DO NOT USE SPEC=ngram ON THIS MODEL — IT CORRUPTS OUTPUT. ⚠️⚠️
# Verified 2026-06-24 on sglang 0.5.13 + this qwen3.5-MoE hybrid-Mamba checkpoint:
# ngram speculative decoding (NGRAM + SGLANG_ENABLE_SPEC_V2=1 + extra_buffer) RUNS
# and reports high accept_length, but the generated text is GARBAGE (incoherent,
# looping "</think>", broken tool_calls). A full verina p100 eval with it scored
# 0/189. The "lossless" guarantee does NOT hold here — the SPEC_V2 ngram-verify
# path is buggy for this hybrid Mamba arch and accepts wrong draft tokens. The
# high accept_length (4.9) was itself a symptom: the model loops on repetitive
# garbage, which ngram trivially "matches". ALWAYS sanity-check actual generated
# text (not just tok/s + accept_length) before trusting a spec-decode config.
# Leave SPEC empty (default) → no speculative decoding, output is correct.
# This toggle is kept only so a FUTURE sglang version can be re-tested (re-verify
# coherence with a real generation before relying on it).
SPEC="${SPEC:-}"
SPEC_ARGS=()
if [[ "$SPEC" == "ngram" ]]; then
  export SGLANG_ENABLE_SPEC_V2=1
  SPEC_ARGS=(
    --speculative-algorithm NGRAM
    --speculative-num-draft-tokens "${SPEC_DRAFT_TOKENS:-8}"
    --mamba-scheduler-strategy extra_buffer
  )
fi

# ── preflight ────────────────────────────────────────────────────────────────
if ! ls "$HF_OUT"/*.safetensors >/dev/null 2>&1; then
  echo "✗ no HF checkpoint at $HF_OUT — run ./convert_dcp_to_hf.sh first" >&2
  exit 1
fi
if ! "$SGLANG_PY" -c "import sglang" >/dev/null 2>&1; then
  echo "── sglang not found — bootstrapping $HERE/.sglang-venv (one-time) ──"
  echo "  NOTE: qwen3_5_moe is very new. If launch fails on unknown architecture,"
  echo "        use a newer sglang/transformers or EXTRA_ARGS='--model-impl transformers'."
  command -v uv >/dev/null || { echo "✗ uv not on PATH; install sglang into a venv and set SGLANG_PY" >&2; exit 1; }
  uv venv --python 3.11 "$HERE/.sglang-venv"
  uv pip install --python "$SGLANG_PY" "sglang[all]"
fi

# sglang's jit_kernel path shells out to `ninja` (via tvm_ffi). ninja lives in
# the venv's bin/, but we exec the venv python directly without activating, so
# it's not on PATH — prepend it or JIT compilation dies with FileNotFoundError.
export PATH="$(dirname "$SGLANG_PY"):$PATH"

# sglang's torch-2.9.1/cuDNN preflight aborts on a known nn.Conv3d bug — but
# Conv3d only lives in the (unused) vision tower; we serve text-only, so the bug
# can't bite. Skip the check rather than pulling in a new cuDNN.
export SGLANG_DISABLE_CUDNN_CHECK="${SGLANG_DISABLE_CUDNN_CHECK:-1}"

# ── launch ───────────────────────────────────────────────────────────────────
args=(
  -m sglang.launch_server
  --model-path "$HF_OUT"
  --served-model-name "$SERVED_NAME"
  --host "$HOST" --port "$PORT"
  --tp "$TP"
  --trust-remote-code
  --tool-call-parser "$TOOL_PARSER"
)
[[ -n "$REASONING_PARSER" ]] && args+=( --reasoning-parser "$REASONING_PARSER" )
[[ -n "$CONTEXT_LEN" ]] && args+=( --context-length "$CONTEXT_LEN" )
[[ -n "$CHUNKED_PREFILL" ]] && args+=( --chunked-prefill-size "$CHUNKED_PREFILL" )
[[ ${#SPEC_ARGS[@]} -gt 0 ]] && args+=( "${SPEC_ARGS[@]}" )
[[ -n "$EXTRA_ARGS" ]] && args+=( $EXTRA_ARGS )

echo "── sglang serve ─────────────────────────────────────────"
echo "  model     : $HF_OUT"
echo "  served as : $SERVED_NAME   endpoint: http://$HOST:$PORT/v1"
echo "  tp=$TP  tool_parser=$TOOL_PARSER  reasoning=${REASONING_PARSER:-off}  ctx=$CONTEXT_LEN  spec=${SPEC:-off}"
echo "  then run  : ./scripts/prove.sh server/prove.local-sft.yaml"
echo "─────────────────────────────────────────────────────────"

exec "$SGLANG_PY" "${args[@]}"
