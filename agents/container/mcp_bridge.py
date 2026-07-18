#!/usr/bin/env python3
"""In-container bridge: one persistent lean-lsp-mcp process, many callers.

lean-lsp-mcp keeps its Lean REPL warm per PROCESS, so spawning it per tool
call would cold-load Mathlib (~60s) every time. This daemon owns a single
stdio MCP session and serves tool calls over a Unix socket; `mcp_call.py`
is the per-call client the host agent invokes via `environment.exec`.

Start (agent setup does this):  nohup python3 /agents/mcp_bridge.py &
Protocol on the socket: one JSON request line {"tool": str, "arguments": {}},
one JSON response line (MCP result or {"error": ...}).
"""

from __future__ import annotations

import json
import os
import socket
import subprocess
import sys
import threading

SOCK = "/tmp/lean-mcp-bridge.sock"
MCP_CMD = ["/usr/local/bin/lean-mcp"]
CALL_TIMEOUT = 600.0


class McpSession:
    def __init__(self) -> None:
        self.proc = subprocess.Popen(
            MCP_CMD, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL, text=True, bufsize=1,
        )
        self.lock = threading.Lock()
        self.next_id = 0
        self._rpc("initialize", {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "codeprover-bridge", "version": "1.0"},
        })
        self._notify("notifications/initialized", {})

    def _send(self, obj: dict) -> None:
        assert self.proc.stdin
        self.proc.stdin.write(json.dumps(obj) + "\n")
        self.proc.stdin.flush()

    def _notify(self, method: str, params: dict) -> None:
        self._send({"jsonrpc": "2.0", "method": method, "params": params})

    def _rpc(self, method: str, params: dict) -> dict:
        self.next_id += 1
        rid = self.next_id
        self._send({"jsonrpc": "2.0", "id": rid, "method": method, "params": params})
        assert self.proc.stdout
        while True:
            line = self.proc.stdout.readline()
            if not line:
                raise RuntimeError("MCP server closed its stdout")
            try:
                msg = json.loads(line)
            except json.JSONDecodeError:
                continue
            if msg.get("id") == rid:
                if "error" in msg:
                    raise RuntimeError(json.dumps(msg["error"]))
                return msg.get("result", {})

    def call_tool(self, tool: str, arguments: dict) -> dict:
        with self.lock:
            return self._rpc("tools/call", {"name": tool, "arguments": arguments})


def handle(conn: socket.socket, session: McpSession) -> None:
    try:
        buf = b""
        while not buf.endswith(b"\n"):
            chunk = conn.recv(65536)
            if not chunk:
                break
            buf += chunk
        req = json.loads(buf.decode("utf-8"))
        result = session.call_tool(req["tool"], req.get("arguments") or {})
        conn.sendall((json.dumps(result, ensure_ascii=False) + "\n").encode("utf-8"))
    except Exception as exc:  # noqa: BLE001 — report, never crash the daemon
        try:
            conn.sendall((json.dumps({"error": str(exc)}) + "\n").encode("utf-8"))
        except OSError:
            pass
    finally:
        conn.close()


def main() -> None:
    if os.path.exists(SOCK):
        os.unlink(SOCK)
    session = McpSession()
    srv = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    srv.bind(SOCK)
    srv.listen(16)
    print("bridge ready", flush=True)
    while True:
        conn, _ = srv.accept()
        threading.Thread(target=handle, args=(conn, session), daemon=True).start()


if __name__ == "__main__":
    sys.exit(main())
