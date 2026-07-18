"""Harbor agent speaking the qwen-native-v1 protocol to a local SFT endpoint.

The code-prover SFT models (Qwen3.5/3.6-35B-A3B) were trained on Claude-Code-
shaped traces rendered in Qwen's NATIVE dialect: no system role, no OpenAI
`tool` role or structured tool_calls on the wire — assistant tool calls are
`<tool_call>{...}</tool_call>` text tags, tool results are merged into user
turns as `<tool_response>...</tool_response>`, reasoning rides inline in
`<think>` tags, and there are no call IDs. Driving such a model with a
standard OpenAI tool-calling client mismatches its training distribution.

This agent reproduces the training-side dialect (codec ported verbatim from
mainline V2 `protocols/qwen_native_v1.py`) and the union-v1 tool surface:
Claude Code core tools implemented over `environment.exec`, and the
`mcp_lean_lsp_*` tools proxied to the in-container lean-lsp-mcp server
through a persistent bridge (container/mcp_bridge.py) so its Lean REPL
stays warm across calls.

Usage:
    harbor run -p tasks/<ds> \
      -a agents.qwen_native_agent:QwenNativeAgent \
      -m code-prover-sft \
      --ak api_base=http://127.0.0.1:8000/v1 \
      --ak max_api_calls=128
(run from the repo root so `agents` is importable; or set PYTHONPATH)
"""

from __future__ import annotations

import json
import shlex
from pathlib import Path

import httpx

from harbor.agents.base import BaseAgent
from harbor.environments.base import BaseEnvironment
from harbor.models.agent.context import AgentContext

from . import qwen_native_v1 as codec

MCP_PREFIX = "mcp_lean_lsp_"
CONTAINER_AGENT_DIR = "/agents"

# Model-facing tool schemas are NOT sent on the wire (qwen-native strips
# `tools=`); the model already knows the union-v1 surface from training.
# This allowlist gates decoding — unknown names become tool_guard_blocked.
CORE_TOOLS = frozenset(
    {"Read", "Edit", "Write", "Glob", "Grep", "Bash", "Task", "TodoWrite"}
)
MCP_TOOLS = frozenset(
    {
        f"{MCP_PREFIX}{n}"
        for n in (
            "lean_goal", "lean_term_goal", "lean_diagnostic_messages",
            "lean_multi_attempt", "lean_local_search", "lean_hover_info",
            "lean_code_actions", "lean_declaration_file", "lean_leanfinder",
            "lean_leansearch", "lean_loogle", "lean_hammer_premise",
            "lean_state_search", "lean_check_statement", "lean_quick_check",
            "lean_build", "lean_replace_sorry", "lean_check_visibility",
            "lean_list_sorries", "lean_verify", "lean_ping",
            "lean_file_outline", "lean_run_code", "lean_stuck_helper",
            "lean_find_usages", "lean_explain_error", "lean_completions",
            "lean_project_overview", "lean_goal_diff", "lean_profile_proof",
            "lean_tactic_stats", "lean_references", "lean_suggest_definitions",
            "lean_slow_proofs", "lean_get_widgets",
        )
    }
)
ALLOWED_TOOLS = CORE_TOOLS | MCP_TOOLS
MAX_TOOL_RESULT_CHARS = 32_000

# Compaction prompts — same semantics as terminus-2's handoff summarization
# and mainline V2's context_compaction trace event.
HANDOFF_SUMMARY_PROMPT = (
    "You are about to hand off your work to another AI agent because the "
    "context window is nearly full. Write a concise handoff summary: the "
    "task goal, what you have already tried (including tactic attempts that "
    "FAILED and why), the current state of the task file, what remains to be "
    "done, and your concrete plan for the next steps. Do not call any tools."
)
CONTINUATION_TEMPLATE = (
    "{instruction}\n\n"
    "NOTE: A previous session ran out of context while working on this task. "
    "All of its edits are already saved in the task file — re-read the file "
    "first, then continue from where it left off. REMEMBER THE ONE RULE: "
    "never modify the specification — surgical edits inside the editable "
    "regions only, helpers only inside *_aux regions, never rewrite the "
    "whole file, never reformat read-only lines. Handoff summary from the "
    "previous session:\n\n{summary}"
)


class QwenNativeAgent(BaseAgent):
    """Host-driven agent loop over an OpenAI-compatible endpoint, qwen-native wire."""

    def __init__(
        self,
        logs_dir: Path,
        model_name: str | None = None,
        *args,
        api_base: str = "http://127.0.0.1:8000/v1",
        api_key: str = "dummy",
        max_api_calls: int = 128,
        max_tokens: int = 24576,
        temperature: float = 0.6,
        request_timeout: float = 600.0,
        context_soft_limit_tokens: int = 100_000,
        enable_compaction: bool = True,
        max_compactions: int = 3,
        summary_max_tokens: int = 4096,
        **kwargs,
    ):
        super().__init__(logs_dir, model_name, *args, **kwargs)
        self._api_base = api_base.rstrip("/")
        self._api_key = api_key
        self._max_api_calls = int(max_api_calls)
        self._max_tokens = int(max_tokens)
        self._temperature = float(temperature)
        self._request_timeout = float(request_timeout)
        self._context_soft_limit = int(context_soft_limit_tokens)
        self._enable_compaction = bool(enable_compaction)
        self._max_compactions = int(max_compactions)
        self._summary_max_tokens = int(summary_max_tokens)

    @staticmethod
    def name() -> str:
        return "qwen-native-v1"

    def version(self) -> str | None:
        return "1.0"

    async def setup(self, environment: BaseEnvironment) -> None:
        here = Path(__file__).resolve().parent / "container"
        await environment.exec(f"mkdir -p {CONTAINER_AGENT_DIR}")
        for f in ("mcp_bridge.py", "mcp_call.py"):
            await environment.upload_file(here / f, f"{CONTAINER_AGENT_DIR}/{f}")
        # Persistent bridge; ready marker in its stdout.
        await environment.exec(
            f"nohup python3 {CONTAINER_AGENT_DIR}/mcp_bridge.py "
            f"> {CONTAINER_AGENT_DIR}/bridge.log 2>&1 & "
            "for i in $(seq 1 120); do "
            f"grep -q 'bridge ready' {CONTAINER_AGENT_DIR}/bridge.log 2>/dev/null && exit 0; "
            "sleep 1; done; echo 'bridge not ready' >&2; exit 1"
        )

    # ------------------------------------------------------------- tools --

    async def _exec_capped(self, env: BaseEnvironment, command: str, timeout: int = 300) -> str:
        r = await env.exec(command, timeout_sec=timeout)
        out = (r.stdout or "") + (("\n[stderr]\n" + r.stderr) if r.stderr else "")
        if r.return_code:
            out += f"\n[exit code: {r.return_code}]"
        return out[:MAX_TOOL_RESULT_CHARS] or "(no output)"

    async def _dispatch(self, env: BaseEnvironment, name: str, a: dict) -> str:
        if name.startswith(MCP_PREFIX):
            payload = json.dumps({"tool": name[len(MCP_PREFIX):], "arguments": a},
                                 ensure_ascii=False)
            return await self._exec_capped(
                env,
                f"printf %s {shlex.quote(payload)} | python3 {CONTAINER_AGENT_DIR}/mcp_call.py",
                timeout=620,
            )
        if name == "Bash":
            return await self._exec_capped(env, str(a.get("command", "")),
                                           timeout=int(a.get("timeout", 300000)) // 1000 or 300)
        if name == "Read":
            p = shlex.quote(str(a.get("file_path", "")))
            return await self._exec_capped(env, f"cat -n {p}")
        if name == "Write":
            p = str(a.get("file_path", ""))
            hp = shlex.quote(p)
            content = str(a.get("content", ""))
            b64 = __import__("base64").b64encode(content.encode()).decode()
            return await self._exec_capped(
                env, f"mkdir -p $(dirname {hp}) && echo {b64} | base64 -d > {hp} && echo written"
            )
        if name == "Edit":
            payload = json.dumps({
                "path": str(a.get("file_path", "")),
                "old": str(a.get("old_string", "")),
                "new": str(a.get("new_string", "")),
                "all": bool(a.get("replace_all", False)),
            }, ensure_ascii=False)
            script = (
                "import json,sys;d=json.load(sys.stdin);t=open(d['path']).read()\n"
                "n=t.count(d['old'])\n"
                "assert n>0, 'old_string not found'\n"
                "assert d['all'] or n==1, f'old_string not unique ({n} matches)'\n"
                "open(d['path'],'w').write(t.replace(d['old'],d['new'],-1 if d['all'] else 1))\n"
                "print('edited')"
            )
            return await self._exec_capped(
                env,
                f"printf %s {shlex.quote(payload)} | python3 -c {shlex.quote(script)}",
            )
        if name == "Glob":
            pat = shlex.quote(str(a.get("pattern", "*")))
            root = shlex.quote(str(a.get("path", ".")))
            return await self._exec_capped(
                env, f"cd {root} && find . -path ./.lake -prune -o -name {pat} -print | head -200"
            )
        if name == "Grep":
            pat = shlex.quote(str(a.get("pattern", "")))
            root = shlex.quote(str(a.get("path", ".")))
            return await self._exec_capped(
                env, f"rg -n --max-count 50 {pat} {root} 2>/dev/null | head -200"
            )
        if name in ("TodoWrite", "Task"):
            # Training traces contain these; acknowledge without side effects
            # (Task subagents are not reproduced in V3).
            return "ok"
        return f"tool {name} is not available"

    async def _handoff_summary(self, client, messages: list[dict]) -> str:
        """One summary call within the soft-limit headroom (the served window
        is larger than the soft limit, so a small-max_tokens call still fits).
        Any failure degrades to a file-only restart rather than aborting."""
        try:
            wire = codec.encode_request({
                "model": self.model_name or "code-prover-sft",
                "messages": messages + [{"role": "user", "content": HANDOFF_SUMMARY_PROMPT}],
                "max_tokens": self._summary_max_tokens,
                "temperature": self._temperature,
            })
            resp = await client.post(
                f"{self._api_base}/chat/completions",
                json=wire,
                headers={"Authorization": f"Bearer {self._api_key}"},
            )
            resp.raise_for_status()
            msg = resp.json()["choices"][0]["message"]
            text = codec.stringify_content(msg.get("content"))
            # Strip think/tool tags from the summary — it becomes plain user text.
            text = codec._TOOL_CALL_RE.sub("", text)
            return text.strip()[:8000]
        except Exception as exc:  # noqa: BLE001
            return f"(handoff summary failed: {exc})"

    # --------------------------------------------------------------- run --

    async def run(
        self, instruction: str, environment: BaseEnvironment, context: AgentContext
    ) -> None:
        log = (self.logs_dir / "qwen-native-agent.jsonl").open("a", encoding="utf-8")

        def emit(kind: str, payload: dict) -> None:
            log.write(json.dumps({"type": kind, **payload}, ensure_ascii=False) + "\n")
            log.flush()

        messages: list[dict] = [{"role": "user", "content": instruction}]
        n_in = n_out = 0
        last_prompt_tokens = 0
        n_compactions = 0
        stop_reason = "final_answer"
        async with httpx.AsyncClient(timeout=self._request_timeout) as client:
            for call_idx in range(self._max_api_calls):
                # Mainline-style context soft limit: long agentic rollouts
                # otherwise walk past the served window and die with a 400.
                if last_prompt_tokens + self._max_tokens >= self._context_soft_limit:
                    if not self._enable_compaction or n_compactions >= self._max_compactions:
                        stop_reason = "context_soft_limit"
                        emit("stop", {"reason": stop_reason,
                                      "prompt_tokens": last_prompt_tokens})
                        break
                    summary = await self._handoff_summary(client, messages)
                    n_compactions += 1
                    emit("context_compaction", {
                        "n": n_compactions,
                        "n_messages_replaced": len(messages),
                        "prompt_tokens_before": last_prompt_tokens,
                        "summary": summary,
                    })
                    messages = [{
                        "role": "user",
                        "content": CONTINUATION_TEMPLATE.format(
                            instruction=instruction,
                            summary=summary or "(summary unavailable)"),
                    }]
                    last_prompt_tokens = 0
                wire = codec.encode_request({
                    "model": self.model_name or "code-prover-sft",
                    "messages": messages,
                    "max_tokens": self._max_tokens,
                    "temperature": self._temperature,
                })
                resp = await client.post(
                    f"{self._api_base}/chat/completions",
                    json=wire,
                    headers={"Authorization": f"Bearer {self._api_key}"},
                )
                if resp.status_code == 400:
                    # Context overflow (or another unrecoverable request error):
                    # end the rollout gracefully so the verifier still grades
                    # whatever state the task file is in.
                    stop_reason = "request_rejected_400"
                    emit("stop", {"reason": stop_reason, "body": resp.text[:500]})
                    break
                resp.raise_for_status()
                data = resp.json()
                choice = data["choices"][0]["message"]
                usage = data.get("usage") or {}
                last_prompt_tokens = usage.get("prompt_tokens") or last_prompt_tokens
                n_in += usage.get("prompt_tokens") or 0
                n_out += usage.get("completion_tokens") or 0

                decoded = codec.decode_assistant(
                    content=choice.get("content"),
                    reasoning_content=choice.get("reasoning_content"),
                    structured_tool_calls=choice.get("tool_calls"),
                    allowed_tool_names=ALLOWED_TOOLS,
                    call_id_namespace=f"call{call_idx}",
                )
                emit("assistant", {"content": decoded.content,
                                   "n_calls": len(decoded.tool_calls),
                                   "n_errors": len(decoded.errors)})
                # Re-append with structured calls so encode_messages re-renders
                # the exact <tool_call> tags on the next request.
                messages.append({
                    "role": "assistant",
                    "content": decoded.content,
                    "tool_calls": [
                        {"id": tc.call_id, "type": "function",
                         "function": {"name": tc.name,
                                      "arguments": json.dumps(tc.arguments, ensure_ascii=False)}}
                        for tc in decoded.tool_calls
                    ],
                })

                if decoded.errors and not decoded.tool_calls:
                    for i, err in enumerate(decoded.errors):
                        guard = codec.protocol_error_recovery_call(
                            err, index=i, call_id_namespace=f"call{call_idx}"
                        )
                        messages.append({
                            "role": "tool", "tool_call_id": guard.call_id,
                            "name": guard.name,
                            "content": json.dumps(guard.arguments, ensure_ascii=False),
                        })
                    continue
                if not decoded.tool_calls:
                    break  # final answer turn

                for tc in decoded.tool_calls:
                    result = await self._dispatch(environment, tc.name, tc.arguments)
                    emit("tool", {"name": tc.name, "result_chars": len(result)})
                    messages.append({
                        "role": "tool", "tool_call_id": tc.call_id,
                        "name": tc.name, "content": result,
                    })

        context.n_input_tokens = n_in
        context.n_output_tokens = n_out
        context.metadata = {"protocol": "qwen-native-v1", "api_calls": call_idx + 1,
                            "stop_reason": stop_reason, "n_compactions": n_compactions}
        log.close()
