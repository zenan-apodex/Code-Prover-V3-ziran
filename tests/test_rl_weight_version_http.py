"""Exercise real HTTP responses through the sampler's version gate (CPU only)."""
import asyncio
import time
import unittest
from collections import deque
from types import SimpleNamespace
from unittest.mock import patch

from aiohttp import web

from test_rl_reliability import Sample, async_module


class WeightVersionHTTPTests(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.module = async_module()
        self.cache = self.module._cached_weight_version
        self.routes = {'/get_model_info': (200, {'weight_version': '1'})}
        self.requests = []
        self.delay = 0

        async def handle(request):
            self.requests.append(request.path)
            await asyncio.sleep(self.delay)
            status, body = self.routes.get(request.path, (404, {}))
            return web.json_response(body, status=status)

        app = web.Application()
        app.router.add_get('/{path:.*}', handle)
        self.runner = web.AppRunner(app)
        await self.runner.setup()
        site = web.TCPSite(self.runner, '127.0.0.1', 0)
        await site.start()
        self.addAsyncCleanup(self.runner.cleanup)
        self.args = SimpleNamespace(
            sglang_router_ip='127.0.0.1', sglang_router_port=site._server.sockets[0].getsockname()[1],
            rollout_global_dataset=True, rollout_batch_size=1, n_samples_per_prompt=1,
            dynamic_sampling_filter_path=None, max_weight_staleness=2, start_rollout_id=0,
            update_weights_interval=1, prover_async_no_progress_timeout_sec=5470,
            prover_async_weight_version_timeout_sec=.05, num_rollout=100,
        )
        self.source = SimpleNamespace(record_accepted=lambda *_: None)

    async def test_rust_router_legacy_path_returns_version(self):
        self.assertEqual(await self.cache.get(self.args), 1)
        self.assertEqual(self.requests, ['/get_model_info'])

    async def test_modern_only_path_fallback_and_endpoint_cache(self):
        self.routes = {'/model_info': (200, {'weight_version': 3})}
        self.cache.ttl = 0
        self.assertEqual(await self.cache.get(self.args), 3)
        self.assertEqual(await self.cache.get(self.args), 3)
        self.assertEqual(self.requests, ['/get_model_info', '/model_info', '/model_info'])

    async def test_missing_routes_fail_before_worker_starts_with_http_diagnostics(self):
        self.routes = {}
        with patch.object(self.module, 'get_global_worker') as start:
            with self.assertLogs(self.module.logger, level='WARNING') as logs:
                with self.assertRaisesRegex(TimeoutError, 'HTTP 404'):
                    await self.module.generate_rollout_async(self.args, 50, self.source)
            start.assert_not_called()
        self.assertTrue(any('/get_model_info: HTTP 404' in line for line in logs.output))

    async def test_slow_query_uses_version_deadline_not_episode_deadline(self):
        self.delay = .3
        before = time.monotonic()
        with patch.object(self.module, 'get_global_worker') as start:
            with self.assertRaisesRegex(TimeoutError, 'weight version unavailable for 0.05s'):
                await self.module.generate_rollout_async(self.args, 50, self.source)
            start.assert_not_called()
        self.assertLess(time.monotonic() - before, .2)

    async def test_invalid_live_version_never_reuses_cached_version(self):
        self.cache.ttl = 0
        for bad in (None, 'default', '0', '-1', True, 1.5, '１'):
            self.routes['/get_model_info'] = (200, {'weight_version': '3'})
            self.assertEqual(await self.cache.get(self.args), 3)
            self.routes['/get_model_info'] = (200, {'weight_version': bad})
            self.assertIsNone(await self.cache.get(self.args))
            self.assertIsNone(self.cache.value)

    async def test_http_failure_does_not_accept_group_or_log_response_body(self):
        sample = Sample(1)
        sample.oldest_weight_version = 1
        sample.metadata = {'weight_versions_complete': True, 'weight_version_origin': 0}
        self.cache.ttl = 0
        def pop():
            self.routes = {'/get_model_info': (503, {'private': 'do-not-log'})}
            return 1, [sample]
        worker = SimpleNamespace(raise_if_failed=lambda: None, pop_completed=pop)
        with patch.object(self.module, 'get_global_worker', return_value=worker), \
             patch.object(self.source, 'record_accepted') as accept:
            with self.assertLogs(self.module.logger, level='WARNING') as logs:
                with self.assertRaisesRegex(TimeoutError, 'HTTP 503'):
                    await self.module.generate_rollout_async(self.args, 50, self.source)
            accept.assert_not_called()
        self.assertNotIn('do-not-log', '\n'.join(logs.output))

    async def test_http_version_allows_first_training_group(self):
        sample = Sample(1)
        sample.oldest_weight_version = 1
        sample.metadata = {'weight_versions_complete': True, 'weight_version_origin': 0}
        groups = deque([(1, [sample])])
        worker = SimpleNamespace(raise_if_failed=lambda: None, pop_completed=groups.popleft)
        with patch.object(self.module, 'get_global_worker', return_value=worker):
            result = await self.module.generate_rollout_async(self.args, 0, self.source)
        self.assertEqual(result.samples, [[sample]])
        self.assertEqual(result.metrics['sampling/stale_groups'], 0)

    async def test_worker_timeout_keeps_original_cause(self):
        original = TimeoutError('warm pool initialization failed')
        def failed():
            raise original
        worker = SimpleNamespace(raise_if_failed=failed)
        with self.assertRaises(TimeoutError) as raised:
            await self.module._wait_for_weight_version(self.args, .05, worker)
        self.assertIs(raised.exception, original)
        self.assertEqual(self.requests, [])

    async def test_wrapper_preserves_query_error_if_cleanup_also_fails(self):
        self.routes = {}
        with patch.object(self.module, 'run', asyncio.run), \
             patch.object(self.module, 'stop_global_worker', side_effect=RuntimeError('cleanup failed')) as stop, \
             self.assertLogs(self.module.logger, level='WARNING') as logs:
            with self.assertRaisesRegex(TimeoutError, 'HTTP 404'):
                await asyncio.to_thread(self.module.generate_rollout_fully_async,
                                        self.args, 50, self.source)
            stop.assert_called_once()
        self.assertTrue(any('preserving original error' in line for line in logs.output))

    async def test_rollout_preflight_refreshes_an_unexpired_version(self):
        self.cache.ttl = 60
        self.assertEqual(await self.cache.get(self.args), 1)
        self.routes['/get_model_info'] = (200, {'weight_version': '2'})
        sample = Sample(1)
        sample.oldest_weight_version = 2
        sample.metadata = {'weight_versions_complete': True, 'weight_version_origin': 0}
        groups = deque([(1, [sample])])
        worker = SimpleNamespace(raise_if_failed=lambda: None, pop_completed=groups.popleft)
        with patch.object(self.module, 'get_global_worker', return_value=worker):
            result = await self.module.generate_rollout_async(self.args, 0, self.source)
        self.assertEqual(result.samples, [[sample]])
        self.assertEqual(result.metrics['sampling/stale_groups'], 0)
        self.assertEqual(self.cache.value, 2)

    async def test_invalid_timeout_rejected_before_admission(self):
        for timeout in (0, -1, float('nan'), float('inf')):
            self.args.prover_async_weight_version_timeout_sec = timeout
            with patch.object(self.module, 'get_global_worker') as start:
                with self.assertRaisesRegex(ValueError, 'finite and positive'):
                    await self.module.generate_rollout_async(self.args, 0, self.source)
                start.assert_not_called()


if __name__ == '__main__':
    unittest.main()
