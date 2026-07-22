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

import asyncio
import json
import os
import random
import re
import shlex
from pathlib import Path

import httpx

from harbor.agents.base import BaseAgent
from harbor.environments.base import BaseEnvironment
from harbor.models.agent.context import AgentContext

from . import qwen_native_v1 as codec
from . import spec_guard

# Tool calls that cannot touch the task file — skipped by the spec guard.
_READONLY_TOOLS = frozenset({"Read", "Glob", "Grep", "TodoWrite", "Task"})

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
# A generation cut off by max_tokens usually dies mid-<think> with no tool
# call; treating that as a final answer ends the rollout with most of the
# call budget unused. Cap consecutive nudges so a model stuck emitting
# over-long thinks cannot loop forever.
MAX_TRUNCATION_NUDGES = 3
TRUNCATION_NUDGE_PROMPT = (
    "Your previous response was cut off by the output token limit before you "
    "issued any tool call, so nothing was executed. Do not restate the full "
    "reasoning — summarize your conclusion in a sentence or two, then act: "
    "either call the next tool, or if the task is complete, say so briefly."
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
        tool_primer: bool = False,
        extra_headers: dict[str, str] | None = None,
        save_transcript: bool = False,
        extra_request_fields: dict | None = None,
        **kwargs,
    ):
        super().__init__(logs_dir, model_name, *args, **kwargs)
        self._api_base = api_base.rstrip("/")
        if api_key.startswith("$"):  # credentials via env, never in configs
            api_key = os.environ.get(api_key[1:], "dummy")
        self._api_key = api_key
        self._tool_primer = bool(tool_primer)
        self._headers = {"Authorization": f"Bearer {self._api_key}",
                         **(extra_headers or {})}
        self._max_api_calls = int(max_api_calls)
        self._max_tokens = int(max_tokens)
        self._temperature = float(temperature)
        self._request_timeout = float(request_timeout)
        self._context_soft_limit = int(context_soft_limit_tokens)
        self._enable_compaction = bool(enable_compaction)
        self._max_compactions = int(max_compactions)
        self._summary_max_tokens = int(summary_max_tokens)
        self._save_transcript = bool(save_transcript)
        self._extra_request_fields = dict(extra_request_fields or {})

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

    # ------------------------------------------------------ spec guard --

    _TASK_PATH_RE = re.compile(r"/task/\S+?\.lean\b")

    async def _read_task_file(self, env: BaseEnvironment, path: str) -> str | None:
        try:
            r = await env.exec(f"cat {shlex.quote(path)}", timeout_sec=60)
        except Exception:  # noqa: BLE001
            return None
        return r.stdout if not r.return_code else None

    async def _guard_task_file(self, env: BaseEnvironment, emit) -> str:
        """After a tool call: if the task file's read-only projection changed,
        revert to the last good content and tell the model. Returns a warning
        string to append to the tool result ('' when clean)."""
        if not self._guard_path or self._guard_original is None:
            return ""
        current = await self._read_task_file(env, self._guard_path)
        if current is None:
            # File moved or deleted (a plain `mv` is invisible to the content
            # check below) — put the last good content back where the verifier
            # will look for it.
            b64 = __import__("base64").b64encode(self._guard_last_good.encode()).decode()
            try:
                await env.exec(
                    f"printf %s {shlex.quote(b64)} | base64 -d > {shlex.quote(self._guard_path)}",
                    timeout_sec=60,
                )
            except Exception:  # noqa: BLE001
                return ""
            emit("spec_guard_restore_missing", {"path": self._guard_path})
            return (
                "\n\n[SPEC GUARD] The task file no longer existed at"
                f" {self._guard_path} and has been RESTORED there. The verifier"
                " grades exactly this path — the file MUST stay at its original"
                " location. If you need it visible elsewhere (e.g. for lake),"
                " copy it; never move, rename, or delete the original."
            )
        if current == self._guard_last_good:
            return ""
        verdict = spec_guard.check_spec_intact(self._guard_original, current)
        if verdict["ok"]:
            self._guard_last_good = current
            return ""
        b64 = __import__("base64").b64encode(self._guard_last_good.encode()).decode()
        try:
            await env.exec(
                f"printf %s {shlex.quote(b64)} | base64 -d > {shlex.quote(self._guard_path)}",
                timeout_sec=60,
            )
        except Exception:  # noqa: BLE001
            return ""  # revert failed; leave it to the verifier
        detail = verdict.get("first_divergence") or verdict.get("reason", "")
        emit("spec_guard_revert", {"detail": detail})
        return (
            "\n\n[SPEC GUARD] That edit modified READ-ONLY benchmark text"
            f" ({json.dumps(detail, ensure_ascii=False)}). The task file has been"
            " REVERTED to its previous state. Re-apply your change strictly inside"
            " an editable `-- !benchmark @start/@end` region"
            " (code, proof, solution_aux, code_aux, proof_aux)."
        )

    async def _exec_capped(self, env: BaseEnvironment, command: str, timeout: int = 300) -> str:
        try:
            r = await env.exec(command, timeout_sec=timeout)
        except Exception as exc:  # noqa: BLE001 — a hung command must not kill the trial
            return f"[tool error] {exc}"
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
                headers=self._headers,
            )
            resp.raise_for_status()
            msg = resp.json()["choices"][0]["message"]
            text = codec.stringify_content(msg.get("content"))
            # Strip think/tool tags from the summary — it becomes plain user text.
            text = codec._TOOL_CALL_RE.sub("", text)
            return text.strip()[:8000]
        except Exception as exc:  # noqa: BLE001
            return f"(handoff summary failed: {exc})"

    # ----------------------------------------------------------- request --

    async def _post_with_retry(self, client, wire, emit):
        """POST /chat/completions, retrying transport errors, 5xx, and 429.

        429 (shared-gateway busy-hour storms, minutes long) backs off
        exponentially with jitter and honours Retry-After — treating it as
        fatal burned 1.4k tasks on 2026-07-21. Returns the response, or None
        when every attempt failed (caller ends the rollout gracefully)."""
        for attempt in range(10):
            try:
                r = await client.post(
                    f"{self._api_base}/chat/completions",
                    json=wire,
                    headers=self._headers,
                )
            except httpx.HTTPError as exc:
                emit("request_retry", {"attempt": attempt + 1,
                                       "error": repr(exc)})
                await asyncio.sleep(10 * (attempt + 1))
                continue
            if r.status_code == 429:
                retry_after = 0.0
                try:
                    retry_after = float(r.headers.get("retry-after") or 0)
                except ValueError:
                    pass
                delay = max(retry_after, min(120.0, 15.0 * 2 ** attempt))
                delay *= 0.5 + random.random()
                emit("request_retry", {"attempt": attempt + 1,
                                       "error": "HTTP 429",
                                       "sleep_sec": round(delay, 1)})
                await asyncio.sleep(delay)
                continue
            if r.status_code >= 500:
                emit("request_retry", {"attempt": attempt + 1,
                                       "error": f"HTTP {r.status_code}"})
                await asyncio.sleep(10 * (attempt + 1))
                continue
            if r.status_code < 300:
                # The gateway occasionally returns 2xx with an empty/garbage
                # body; that's as transient as a 5xx, but it used to escape
                # this loop and kill the trial at resp.json() — 102 tasks
                # burned on 2026-07-22.
                try:
                    r.json()
                except ValueError:
                    emit("request_retry", {"attempt": attempt + 1,
                                           "error": f"HTTP {r.status_code} non-JSON body",
                                           "body_head": r.text[:120]})
                    await asyncio.sleep(10 * (attempt + 1))
                    continue
            return r
        return None

    async def _compact_context(self, client, messages, instruction,
                               last_prompt_tokens, n_compactions, emit):
        """Summarize-and-restart when the context soft limit is reached.
        Returns the fresh messages list (single continuation user turn)."""
        summary = await self._handoff_summary(client, messages)
        emit("context_compaction", {
            "n": n_compactions,
            "n_messages_replaced": len(messages),
            "prompt_tokens_before": last_prompt_tokens,
            "summary": summary,
        })
        return [{
            "role": "user",
            "content": CONTINUATION_TEMPLATE.format(
                instruction=instruction,
                summary=summary or "(summary unavailable)"),
        }]

    # --------------------------------------------------------------- run --

    async def run(
        self, instruction: str, environment: BaseEnvironment, context: AgentContext
    ) -> None:
        log = (self.logs_dir / "qwen-native-agent.jsonl").open("a", encoding="utf-8")

        def emit(kind: str, payload: dict) -> None:
            log.write(json.dumps({"type": kind, **payload}, ensure_ascii=False) + "\n")
            log.flush()

        if self._tool_primer:
            from .tool_primer import build_primer
            instruction = build_primer() + instruction

        m = self._TASK_PATH_RE.search(instruction)
        self._guard_path = m.group(0) if m else None
        self._guard_original = (
            await self._read_task_file(environment, self._guard_path)
            if self._guard_path else None
        )
        self._guard_last_good = self._guard_original

        messages: list[dict] = [{"role": "user", "content": instruction}]
        n_in = n_out = 0
        last_prompt_tokens = 0
        n_compactions = 0
        n_truncation_nudges = 0
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
                    n_compactions += 1
                    messages = await self._compact_context(
                        client, messages, instruction,
                        last_prompt_tokens, n_compactions, emit)
                    last_prompt_tokens = 0
                wire = codec.encode_request({
                    "model": self.model_name or "code-prover-sft",
                    "messages": messages,
                    "max_tokens": self._max_tokens,
                    "temperature": self._temperature,
                    **self._extra_request_fields,
                })
                resp = await self._post_with_retry(client, wire, emit)
                if resp is None:
                    # Model endpoint unreachable/overloaded: end gracefully so
                    # the verifier still grades the current file state.
                    stop_reason = "request_transport_error"
                    emit("stop", {"reason": stop_reason})
                    break
                if resp.status_code == 400:
                    # Context overflow (or another unrecoverable request error):
                    # end the rollout gracefully so the verifier still grades
                    # whatever state the task file is in.
                    stop_reason = "request_rejected_400"
                    emit("stop", {"reason": stop_reason, "body": resp.text[:500]})
                    break
                resp.raise_for_status()
                data = resp.json()
                finish_reason = data["choices"][0].get("finish_reason")
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
                    # A turn cut off by max_tokens is not a final answer: the
                    # model ran out of budget mid-think and never reached a
                    # <tool_call>. Nudge it to continue instead of stopping.
                    if finish_reason == "length" and n_truncation_nudges < MAX_TRUNCATION_NUDGES:
                        n_truncation_nudges += 1
                        emit("truncation_nudge", {"n": n_truncation_nudges})
                        messages.append({
                            "role": "user",
                            "content": TRUNCATION_NUDGE_PROMPT,
                        })
                        continue
                    if finish_reason == "length":
                        stop_reason = "truncated_without_tool_call"
                        emit("stop", {"reason": stop_reason})
                        break
                    break  # final answer turn
                n_truncation_nudges = 0

                for tc in decoded.tool_calls:
                    result = await self._dispatch(environment, tc.name, tc.arguments)
                    if tc.name not in _READONLY_TOOLS:
                        result += await self._guard_task_file(environment, emit)
                    emit("tool", {"name": tc.name, "result_chars": len(result)})
                    messages.append({
                        "role": "tool", "tool_call_id": tc.call_id,
                        "name": tc.name, "content": result,
                    })

        context.n_input_tokens = n_in
        context.n_output_tokens = n_out
        context.metadata = {"protocol": "qwen-native-v1", "api_calls": call_idx + 1,
                            "stop_reason": stop_reason, "n_compactions": n_compactions}
        if self._save_transcript:
            # Full messages history: assistant content carries <think> inline
            # (reasoning_content is merged at decode time) plus structured
            # tool_calls; codec.encode_messages can replay the exact wire form.
            (self.logs_dir / "transcript.json").write_text(json.dumps({
                "protocol": "qwen-native-v1",
                "model": self.model_name,
                "stop_reason": stop_reason,
                "api_calls": call_idx + 1,
                "n_compactions": n_compactions,
                "usage": {"input_tokens": n_in, "output_tokens": n_out},
                "messages": messages,
            }, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
        log.close()
