"""Regression coverage for checkpoint cancellation and allocation bursts."""
import asyncio
import os
import sys
import types
import unittest
from pathlib import Path
from unittest.mock import patch, AsyncMock

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from rl import sandbox as backend


class SandboxRecoveryTests(unittest.IsolatedAsyncioTestCase):
    def setUp(self):
        self.sdk = types.ModuleType('e2b')
        self.sdk.AsyncSandbox = object
        self.patches = [
            patch.dict(sys.modules, {'e2b': self.sdk}),
            patch.object(backend, 'load_e2b_api_key'),
            patch.object(backend.importlib.metadata, 'version', return_value=backend.E2B_SDK_VERSION),
        ]
        for p in self.patches:
            p.start()
            self.addCleanup(p.stop)

    def raw(self):
        return types.SimpleNamespace(
            kill=AsyncMock(return_value=True),
            _envd_api=types.SimpleNamespace(aclose=AsyncMock()),
            commands=types.SimpleNamespace(run=AsyncMock(return_value=types.SimpleNamespace(stdout='', stderr='', exit_code=0))),
        )

    async def test_checkpoint_cancellation_reclaims_late_allocation(self):
        started, finish = asyncio.Event(), asyncio.Event()
        raw = self.raw()
        async def allocate(**kwargs):
            started.set()
            await finish.wait()
            return raw
        with patch.object(backend, '_isolated_async_sandbox_class', return_value=types.SimpleNamespace(create=allocate)):
            task = asyncio.create_task(backend.E2BSandbox.create('test'))
            await started.wait()
            task.cancel()
            await asyncio.sleep(0)
            finish.set()
            with self.assertRaises(asyncio.CancelledError):
                await task
        raw.kill.assert_awaited_once()
        raw._envd_api.aclose.assert_awaited_once()

    async def test_checkpoint_cancellation_during_bootstrap_reclaims_sandbox(self):
        started = asyncio.Event()
        raw = self.raw()
        async def bootstrap(*args, **kwargs):
            started.set()
            await asyncio.Event().wait()
        raw.commands.run = bootstrap
        with patch.object(backend, '_isolated_async_sandbox_class', return_value=types.SimpleNamespace(create=AsyncMock(return_value=raw))):
            task = asyncio.create_task(backend.E2BSandbox.create('test'))
            await started.wait()
            task.cancel()
            with self.assertRaises(asyncio.CancelledError):
                await task
        raw.kill.assert_awaited_once()

    async def test_failed_bootstrap_is_reclaimed_and_preserves_cause(self):
        raw = self.raw()
        raw.commands.run.return_value = types.SimpleNamespace(stdout='', stderr='bootstrap unavailable', exit_code=1)
        with patch.object(backend, '_isolated_async_sandbox_class', return_value=types.SimpleNamespace(create=AsyncMock(return_value=raw))):
            with self.assertRaises(RuntimeError) as caught:
                await backend.E2BSandbox.create('test', create_attempts=1)
        self.assertIn('bootstrap unavailable', str(caught.exception.__cause__))
        raw.kill.assert_awaited_once()

    async def test_create_burst_is_bounded_without_limiting_live_sandboxes(self):
        active = peak = 0
        async def allocate(**kwargs):
            nonlocal active, peak
            active += 1
            peak = max(active, peak)
            await asyncio.sleep(.005)
            active -= 1
            return self.raw()
        with patch.object(backend, '_isolated_async_sandbox_class', return_value=types.SimpleNamespace(create=allocate)):
            wrappers = await asyncio.gather(*(backend.E2BSandbox.create('test') for _ in range(24)))
        self.assertLessEqual(peak, 8)
        self.assertEqual(len(wrappers), 24)
        self.assertTrue(all(s._sbx.kill.await_count == 0 for s in wrappers))
        await asyncio.gather(*(s.close() for s in wrappers))

    async def test_cleanup_retries_transient_control_plane_error(self):
        raw = self.raw()
        raw.kill.side_effect = [RuntimeError('temporary failure'), True]
        with patch.object(backend.asyncio, 'sleep', new=AsyncMock()):
            await backend.E2BSandbox(raw).close()
        self.assertEqual(raw.kill.await_count, 2)

    async def test_underlying_failure_is_visible_and_secret_redacted(self):
        from rl.generate_with_prover import _safe_failure_detail
        root = RuntimeError('429 creation limited test-secret')
        outer = RuntimeError('allocation failed')
        outer.__cause__ = root
        with patch.dict(os.environ, {'E2B_API_KEY': 'test-secret'}):
            detail = _safe_failure_detail(outer)
        self.assertIn('429 creation limited', detail)
        self.assertNotIn('test-secret', detail)
        self.assertTrue(detail.index('429') < detail.index('allocation'))



class CreationLimitConfigTests(unittest.IsolatedAsyncioTestCase):
    async def test_eval_node_can_use_one_creation_slot(self):
        import os
        from unittest.mock import patch
        from rl.sandbox import _creation_semaphore
        with patch.dict(os.environ, {"E2B_CREATE_CONCURRENCY": "1"}):
            semaphore = _creation_semaphore()
            await semaphore.acquire()
            self.assertTrue(semaphore.locked())
            semaphore.release()

    async def test_zero_creation_slots_fail_instead_of_hanging(self):
        import os
        from unittest.mock import patch
        from rl.sandbox import _creation_semaphore
        with patch.dict(os.environ, {"E2B_CREATE_CONCURRENCY": "0"}):
            with self.assertRaisesRegex(ValueError, "positive"):
                _creation_semaphore()

if __name__ == '__main__':
    unittest.main()
