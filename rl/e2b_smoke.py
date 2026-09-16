"""Allocate, probe, and always destroy one E2B sandbox before GPU loading."""

from __future__ import annotations

import argparse
import asyncio
import json
import os

from rl.sandbox import create_sandbox, e2b_connection_env


async def check_lean_runtime(sandbox, runtime_timeout_sec: int = 600):
    result = await sandbox.exec(
        "lake --version && test -w /task && test -w /tests && test -w /logs"
        " && cd /task && printf '%s\\n' 'import Mathlib'"
        " 'example : (1 : Nat) + 1 = 2 := by norm_num'"
        " > /tmp/codeprover-rl-preflight.lean"
        " && lake env lean /tmp/codeprover-rl-preflight.lean",
        timeout_sec=runtime_timeout_sec,
    )
    if result.return_code != 0:
        raise RuntimeError(f"E2B runtime probe failed: {result.stderr[:300]}")
    return result


async def smoke(
    template: str,
    *,
    sandbox_timeout: int = 900,
    runtime_timeout_sec: int = 600,
    mcp_timeout_sec: int = 120,
) -> dict:
    sandbox = None
    try:
        sandbox = await create_sandbox(
            "e2b",
            template=template,
            timeout=sandbox_timeout,
            metadata={"purpose": "codeprover-rl-preflight"},
        )
        result = await check_lean_runtime(sandbox, runtime_timeout_sec)
        initialize = json.dumps({
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "codeprover-preflight", "version": "1"},
            },
        }, separators=(",", ":"))
        mcp = await sandbox.exec(
            "cd /task && printf '%s\\n' " + repr(initialize)
            + " | timeout 90 /usr/local/bin/lean-lsp-mcp | head -n 1",
            timeout_sec=mcp_timeout_sec,
        )
        if mcp.return_code != 0:
            raise RuntimeError(f"E2B MCP initialize probe failed: {mcp.stderr[:500]}")
        try:
            response = json.loads(mcp.stdout.splitlines()[0])
        except (IndexError, json.JSONDecodeError) as exc:
            raise RuntimeError("E2B MCP initialize returned invalid JSON") from exc
        if response.get("id") != 1 or "result" not in response:
            raise RuntimeError(f"E2B MCP initialize failed: {str(response)[:500]}")
        return {
            "ok": True,
            "template": template,
            "e2b_connection": e2b_connection_env(
                os.environ.get("E2B_API_URL", ""), os.environ.get("E2B_DOMAIN", ""),
                os.environ.get("E2B_SANDBOX_PROVIDER", ""),
            ),
            "lake": result.stdout.splitlines()[0][:200],
            "mcp": "initialized",
            "workspace_upload": False,
        }
    finally:
        if sandbox is not None:
            await sandbox.close()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--template", required=True)
    parser.add_argument("--sandbox-timeout", type=int, default=900)
    parser.add_argument("--runtime-timeout-sec", type=int, default=600)
    parser.add_argument("--mcp-timeout-sec", type=int, default=120)
    args = parser.parse_args()
    result = asyncio.run(smoke(
        args.template,
        sandbox_timeout=args.sandbox_timeout,
        runtime_timeout_sec=args.runtime_timeout_sec,
        mcp_timeout_sec=args.mcp_timeout_sec,
    ))
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
