"""Regression coverage for half-closed HTTP/2 envd connections."""
import asyncio
import importlib.util
import os
import shutil
import socket
import ssl
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import AsyncMock, patch

from rl.sandbox import E2BSandbox, SandboxLostError, _new_isolated_envd_transport


class SandboxErrorTests(unittest.IsolatedAsyncioTestCase):
    async def test_lost_sandbox_aborts_without_replaying_command(self):
        run = AsyncMock(side_effect=RuntimeError("sandbox was not found: test-private-key"))
        sandbox = E2BSandbox(SimpleNamespace(commands=SimpleNamespace(run=run)))
        with patch.dict(os.environ, {"E2B_API_KEY": "test-private-key"}):
            with self.assertRaises(SandboxLostError) as caught:
                await sandbox.exec("lake build")
        self.assertNotIn("test-private-key", str(caught.exception))
        run.assert_awaited_once()

    async def test_empty_network_error_retains_redacted_cause_without_replay(self):
        class WriteError(Exception):
            pass
        root = BrokenPipeError(32, "test-private-key connection closed")
        exc = WriteError()
        exc.__cause__ = root
        run = AsyncMock(side_effect=exc)
        sandbox = E2BSandbox(SimpleNamespace(commands=SimpleNamespace(run=run)))
        with patch.dict(os.environ, {"E2B_API_KEY": "test-private-key"}):
            result = await sandbox.exec("printf test")
        self.assertEqual(result.return_code, 1)
        self.assertIn("WriteError", result.stderr)
        self.assertIn("BrokenPipeError", result.stderr)
        self.assertIn("<redacted>", result.stderr)
        self.assertNotIn("test-private-key", result.stderr)
        run.assert_awaited_once()

    async def test_command_exit_output_is_preserved(self):
        error = RuntimeError("RPC command exited")
        error.exit_code = 7
        error.stdout = "output"
        error.stderr = "Lean diagnostic"
        sandbox = E2BSandbox(SimpleNamespace(commands=SimpleNamespace(run=AsyncMock(side_effect=error))))
        result = await sandbox.exec("false")
        self.assertEqual((result.return_code, result.stdout, result.stderr),
                         (7, "output", "Lean diagnostic"))


@unittest.skipUnless(importlib.util.find_spec("e2b") and shutil.which("openssl"),
                     "requires the optional E2B SDK and openssl")
class IdleHTTP2Tests(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        import h2.config
        import h2.connection
        import h2.events
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        root = Path(self.directory.name)
        cert, key = root / "cert.pem", root / "key.pem"
        subprocess.run([
            "openssl", "req", "-x509", "-newkey", "rsa:2048", "-nodes",
            "-keyout", str(key), "-out", str(cert), "-days", "1",
            "-subj", "/CN=localhost", "-addext", "subjectAltName=IP:127.0.0.1",
        ], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        key.chmod(0o600)
        self.cert = cert
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain(cert, key)
        context.set_alpn_protocols(["h2"])
        self.handlers = set()

        async def handler(reader, writer):
            task = asyncio.current_task()
            self.handlers.add(task)
            conn = h2.connection.H2Connection(config=h2.config.H2Configuration(client_side=False))
            conn.initiate_connection()
            writer.write(conn.data_to_send())
            timer = None
            paths = {}

            def peer_reset():
                sock = writer.get_extra_info("socket")
                if sock is not None:
                    sock.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER, struct.pack("ii", 1, 0))
                writer.transport.abort()

            try:
                while data := await reader.read(65536):
                    for event in conn.receive_data(data):
                        if isinstance(event, h2.events.RequestReceived):
                            paths[event.stream_id] = dict(event.headers).get(b":path", b"")
                        if isinstance(event, h2.events.StreamEnded):
                            if paths.get(event.stream_id) == b"/slow":
                                await asyncio.sleep(6.2)
                            conn.send_headers(event.stream_id, [(":status", "200"), ("content-length", "2")])
                            conn.send_data(event.stream_id, b"ok", end_stream=True)
                            if timer is None:
                                timer = asyncio.get_running_loop().call_later(1, peer_reset)
                    writer.write(conn.data_to_send())
                    await writer.drain()
            except (ConnectionError, asyncio.CancelledError):
                pass
            finally:
                if timer:
                    timer.cancel()
                writer.close()
                try:
                    await writer.wait_closed()
                except ConnectionError:
                    pass
                self.handlers.discard(task)

        self.server = await asyncio.start_server(handler, "127.0.0.1", 0, ssl=context)
        self.url = f"https://127.0.0.1:{self.server.sockets[0].getsockname()[1]}"

    async def asyncTearDown(self):
        self.server.close()
        await self.server.wait_closed()
        handlers = list(self.handlers)
        for task in handlers:
            task.cancel()
        await asyncio.gather(*handlers, return_exceptions=True)

    async def test_idle_peer_close_is_reconnected_before_next_command(self):
        import httpx
        from e2b.api import limits
        old = httpx.AsyncHTTPTransport(http2=True, verify=ssl.create_default_context(cafile=str(self.cert)), limits=limits)
        with patch.dict(os.environ, {"SSL_CERT_FILE": str(self.cert)}):
            fixed = _new_isolated_envd_transport(SimpleNamespace(proxy=None))
        async with httpx.AsyncClient(transport=old) as old_client, \
                httpx.AsyncClient(transport=fixed) as fixed_client:
            first = await asyncio.gather(old_client.get(self.url), fixed_client.get(self.url))
            self.assertTrue(all(r.http_version == "HTTP/2" for r in first))
            await asyncio.sleep(6)
            self.assertFalse(old._pool.connections[0].has_expired())
            self.assertTrue(fixed.pool.connections[0].has_expired())
            with self.assertRaises(httpx.TransportError):
                await old_client.post(self.url, content=b"synthetic-command")
            response = await fixed_client.post(self.url, content=b"synthetic-command")
            self.assertEqual(response.text, "ok")

    async def test_long_active_command_survives_idle_expiry_interval(self):
        import httpx
        with patch.dict(os.environ, {"SSL_CERT_FILE": str(self.cert)}):
            transport = _new_isolated_envd_transport(SimpleNamespace(proxy=None))
        async with httpx.AsyncClient(transport=transport, timeout=15) as client:
            request = asyncio.create_task(client.get(self.url + "/slow"))
            try:
                await asyncio.sleep(5.5)
                self.assertFalse(request.done())
                self.assertFalse(transport.pool.connections[0].has_expired())
                response = await request
                self.assertEqual(response.text, "ok")
            finally:
                if not request.done():
                    request.cancel()
                await asyncio.gather(request, return_exceptions=True)


if __name__ == "__main__":
    unittest.main()
