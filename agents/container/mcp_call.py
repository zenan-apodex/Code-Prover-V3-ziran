#!/usr/bin/env python3
"""Per-call client for mcp_bridge.py: stdin JSON -> stdout JSON."""
import json
import socket
import sys

req = sys.stdin.read()
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.settimeout(600)
s.connect("/tmp/lean-mcp-bridge.sock")
s.sendall(req.encode("utf-8") + b"\n")
buf = b""
while not buf.endswith(b"\n"):
    chunk = s.recv(65536)
    if not chunk:
        break
    buf += chunk
sys.stdout.write(buf.decode("utf-8"))
