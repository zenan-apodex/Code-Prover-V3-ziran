"""Fatal producer failures must remain visible after their thread exits."""
import unittest
from types import SimpleNamespace
from unittest.mock import patch

from test_rl_reliability import async_module


class WorkerFailureTests(unittest.TestCase):
    def setUp(self):
        self.module = async_module()
        self.module.GenerateState = lambda args: SimpleNamespace(sampling_params={})
        self.original = RuntimeError('dataset fetch failed')
        self.args = SimpleNamespace(
            over_sampling_batch_size=1, rollout_batch_size=1,
            prover_async_queue_size=1, n_samples_per_prompt=2,
            prover_sandbox_concurrency=2, prover_async_max_pending_groups=2,
        )
        self.closes = 0
        def fetch(count):
            raise self.original
        self.source = SimpleNamespace(get_samples=fetch)
        async def close():
            self.closes += 1
        async def warm(args):
            return SimpleNamespace(close=close)
        with patch.object(self.module, 'start_warm_pool', warm):
            self.worker = self.module.get_global_worker(self.args, self.source)
            self.worker.worker_thread.join(timeout=2)
        self.addCleanup(self.module.stop_global_worker)
        self.assertFalse(self.worker.worker_thread.is_alive())
        self.assertEqual(self.closes, 1)

    def test_dead_worker_failure_prevents_implicit_restart(self):
        with patch.object(self.module, 'AsyncRolloutWorker') as replacement:
            with self.assertRaises(RuntimeError) as error:
                self.module.get_global_worker(self.args, self.source)
            self.assertIs(error.exception.__cause__, self.original)
            replacement.assert_not_called()

    def test_dead_worker_lookup_surfaces_failure_for_checkpoint_callers(self):
        with self.assertRaises(RuntimeError) as error:
            self.module.get_existing_worker(self.source)
        self.assertIs(error.exception.__cause__, self.original)

    def test_failure_is_not_consumed_by_first_observer(self):
        for _ in range(2):
            with self.assertRaises(RuntimeError) as error:
                self.worker.raise_if_failed()
            self.assertIs(error.exception.__cause__, self.original)


if __name__ == '__main__':
    unittest.main()
