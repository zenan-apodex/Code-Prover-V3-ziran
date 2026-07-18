> **V3 注记（2026-07-17）**：本目录从 Code-Prover-V2 拷贝而来备用（formalize
> pipeline 已弃用，仅保留 SFT 模型服务）。下文提到的 V2 prover 评测流程已被
> Harbor 取代 —— V3 里用 `configs/prove-local-sft.yaml` 连接本服务的端点；
> 文中的 `prove.local-sft*.yaml` 是 V2 格式，未拷贝。

# server/ — serve the local code-prover SFT model & eval it with the prover harness

Serve the **Qwen3.5-35B-A3B code-prover SFT** model (see
`/mnt/workspace/ziran.yang/formal-code/agentic-traces/training/EVAL_HANDOFF.md`)
as an OpenAI-compatible endpoint and point the existing `prover` harness at it.
No prover code changes — the harness already speaks `chat_completions` and feeds
the SKILL.md as the first user turn, which is exactly the format the model was
trained on.

## TL;DR

The model dir, served name, and port all live in `prove.local-sft.yaml` —
one source of truth. The scripts read it; you just run them.

```bash
cd /mnt/VerifiableAILab/zenan.li/Code-Prover-V2/server

# 1. DCP → HF (one-time; auto-picks the final checkpoint, writes to model_path; ~70GB)
./convert_dcp_to_hf.sh

# 2. Serve (8× L20X, TP=8, OpenAI API on :8000). First run bootstraps a sglang venv.
./serve_sglang.sh

# 3. In another shell — run the prover against the local endpoint
cd /mnt/VerifiableAILab/zenan.li/Code-Prover-V2
./scripts/prove.sh server/prove.local-sft.yaml
```

## Why this wires up cleanly

| Layer | Training contract (handoff §3) | Prover harness behavior | Status |
|---|---|---|---|
| Tool context | skill-doc as first **user** message; no `tools=` | feeds SKILL.md as a synthetic user turn | ✅ aligned |
| Tool calls (model→harness) | `<tool_call>{json}</tool_call>` text | needs structured `tool_calls` | ✅ **hermes parser** converts text→structured server-side |
| Tool results (harness→model) | `<tool_response>{...}</tool_response>` user turn | sends OpenAI `{role:"tool"}` msgs | ✅ sglang renders these back into the trained shape via the chat template |
| Reasoning | leading `<think>…</think>` | ignores; reads `content`/`tool_calls` | ✅ `--reasoning-parser qwen3` routes think → `reasoning_content` |
| Model id | n/a | `code-prover-sft` passes through verbatim (no "claude" → no cache_control injected) | ✅ |

## ⚠️ The one real divergence to validate on a smoke run

The training data had **no system message and no `tools=` schema** — only the
skill-doc user turn. The prover's `OpenAIClient.chat_completion_with_tools`
([client.py](../pipeline/src/goedel_pipeline/llm/client.py)) / the worker
([claude_direct.py](../prover/src/code_prover/agents/claude_direct.py)) **does**
send a system prompt + a `tools=` block in addition to the skill doc. The hermes
parser handles the *response* side regardless, and an extra `tools=` block is
usually benign, but train/serve distributions are not byte-identical here.

**Validate before trusting numbers:** run the 5-task smoke set first, then read a
`results/.../*.stderr.txt` (look for the `🔀 ClaudeDirect routing: provider=custom,
api_mode=chat_completions` line and confirm `tool_use` events appear) and a
`*.trace_messages.json`. If the model ignores tools or never emits `<tool_call>`,
the fix is harness-side: suppress the system prompt + `tools=` for this backend so
the wire matches training exactly. Ping me and I'll patch that path.

## What counts as solved (handoff §5)

Per-task `result.json`: `solved == true` ⇔ `sorry_count == 0` AND no compile error
AND `axiom_check == "pass"` AND it passed the in-agent final-verifier gate. Report
**pass@1**; the harness also emits `per_benchmark` rates. Grading is a real warm
`lean-repl` Lean build (see [prover grading warm-REPL] notes / `prover/README.md`).

## Baselines to compare against (handoff §6)

- canonical Verina (189 tasks): ~32%   ← honest baseline, use this
- reformalized variants: ~56%          ← inflated, don't headline this
- DeepSeek-V4-Pro training traces: ~55–65% on the generated set (sanity band)

The canonical-Verina-189 set is built into `benchmarks/prove/verina_canonical_189.jsonl`
(via `scripts/build_verina_jsonl.py` from github.com/sunblaze-ucb/verina — code+proof
regions sorry'd, `import Mathlib` injected). `prove.local-sft.yaml` already points there.

## Files

- `convert_dcp_to_hf.sh` — torchtitan DCP shards → HF safetensors (step-selectable).
- `serve_sglang.sh` — launch the OpenAI-compatible sglang server (TP=8, hermes +
  qwen3 reasoning parser). Auto-bootstraps `.sglang-venv` if sglang is absent.
- `prove.local-sft.yaml` — prover config pointing at `127.0.0.1:8000`.

## Gotchas

- **Convert first** — `.distcp` shards are not directly servable.
- **qwen3_5_moe is bleeding-edge.** If sglang can't load the architecture, you need
  a newer sglang/transformers (recent release or nightly), or `EXTRA_ARGS="--model-impl
  transformers"`. Pin the working version in `serve_sglang.sh` once known.
- **Disk/quota:** `/mnt/workspace` shows ~full on the shared CPFS view; confirm your
  per-dir quota has ~70GB before converting.
- **Turn cap:** training was filtered to ≤160 turns; the harness `max_turns` default
  (360) is generous — lower it if flailing runs hang.
- **Docker networking:** `docker: true` runs each task in a `--network=host`
  container, so `127.0.0.1:8000` reaches the host sglang server fine.
