"""Tool-surface primer for models NOT trained on the union-v1 protocol.

The SFT qwen model carries the tool catalog in its weights, so the agent
sends bare instructions. Third-party models (DeepSeek, ...) need the
catalog and the ``<tool_call>`` wire convention spelled out — and it must
ride in the FIRST USER MESSAGE, because the codec drops system turns.

MCP schemas in ``lean_mcp_tools.json`` were dumped from the image's
``lean-mcp`` server via ``tools/list`` (regenerate after image upgrades).
"""

from __future__ import annotations

import json
from pathlib import Path

_MCP_SCHEMAS = json.loads(
    (Path(__file__).parent / "lean_mcp_tools.json").read_text(encoding="utf-8")
)

_HEADER = """\
# Tool-use protocol

You work by calling tools. To call one, emit EXACTLY this block in your reply
(one block per call; several blocks per reply are allowed):

<tool_call>
{"name": "<tool-name>", "arguments": {<json arguments>}}
</tool_call>

Results arrive in the next user turn inside <tool_response> blocks, in order.
Keep calling tools until the task is complete; a reply with no <tool_call>
block ends the session, so never stop early. You may reason freely inside
<think>...</think> before your tool calls.

## Core tools

- Bash {"command": str, "timeout"?: int-ms} — run a shell command in the task
  container (default timeout 300s).
- Read {"file_path": str} — print a file with line numbers.
- Edit {"file_path": str, "old_string": str, "new_string": str,
  "replace_all"?: bool} — exact-string replacement; old_string must occur
  and (unless replace_all) be unique.
- Write {"file_path": str, "content": str} — create/overwrite a file.
- Glob {"pattern": str, "path"?: str} — find files by name pattern.
- Grep {"pattern": str, "path"?: str} — regex search (ripgrep).

## Lean tools (Lean 4 + Mathlib helpers; call with the full mcp_lean_lsp_ name)
"""


def _fmt_tool(t: dict) -> str:
    args = []
    for k, v in t["properties"].items():
        opt = "" if k in t["required"] else "?"
        args.append(f'"{k}"{opt}: {v.get("type", "any")}')
    desc = t["description"].split("\n")[0][:150]
    return f'- mcp_lean_lsp_{t["name"]} {{{", ".join(args)}}} — {desc}'


def build_primer() -> str:
    return _HEADER + "\n".join(_fmt_tool(t) for t in _MCP_SCHEMAS) + "\n\n---\n\n"
