"""Fatal checkpoint failures must stop sampling and preserve the original error."""
import asyncio
from contextlib import ExitStack
import importlib.util
from pathlib import Path
import sys
import tempfile
import threading
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from test_rl_reliability import Sample, async_module
from test_rl_resume_state import BaseSource


class SaveFailureTests(unittest.TestCase):
    def setUp(self):
        self.stack = ExitStack()
        self.addCleanup(self.stack.close)
        self.directory = self.stack.enter_context(tempfile.TemporaryDirectory())
        self.module = async_module()
        self.module.GenerateState = lambda args: SimpleNamespace(sampling_params={})
        self.args = SimpleNamespace(
            over_sampling_batch_size=1, rollout_batch_size=1,
            prover_async_queue_size=1, n_samples_per_prompt=1,
            prover_sandbox_concurrency=1, prover_async_max_pending_groups=1,
            rollout_global_dataset=True, rollout_shuffle=False,
            save=self.directory, load=None, prover_async_pause_timeout_sec=1,
        )
        path = Path(__file__).parents[1] / 'rl/persistent_data_source.py'
        spec = importlib.util.spec_from_file_location('_save_failure_source', path)
        self.source_module = importlib.util.module_from_spec(spec)
        self.stack.enter_context(patch.dict(sys.modules, {
            'rl.fully_async_rollout': self.module,
            'miles.rollout.data_source': SimpleNamespace(RolloutDataSourceWithBuffer=BaseSource),
        }))
        spec.loader.exec_module(self.source_module)
        self.source = self.source_module.PersistentRolloutDataSource(self.args)
        self.source.get_samples = lambda count: [[Sample()]]
        self.entered, self.cleaned, self.closed = [threading.Event() for _ in range(3)]

        async def generate(*args, **kwargs):
            self.entered.set()
            try:
                await asyncio.Event().wait()
            finally:
                await asyncio.sleep(.005)
                self.cleaned.set()

        async def close():
            self.closed.set()

        async def warm(args):
            return SimpleNamespace(close=close)

        self.stack.enter_context(patch.object(self.module, 'generate_and_rm_group', generate))
        self.stack.enter_context(patch.object(self.module, 'start_warm_pool', warm))
        self.worker = self.module.get_global_worker(self.args, self.source)
        self.addCleanup(self.module.stop_global_worker)
        self.assertTrue(self.entered.wait(2))

    def test_disk_failure_stops_worker_and_reclaims_pool(self):
        original = OSError('disk full fixture')
        with patch.object(self.source_module.torch, 'save', side_effect=original):
            with self.assertRaises(OSError) as raised:
                self.source.save(24)
        self.assertIs(raised.exception, original)
        self.assertFalse(self.worker.worker_thread.is_alive())
        self.assertTrue(self.closed.is_set())
        self.assertTrue(self.cleaned.is_set())
        self.assertIsNone(self.module._global_worker)

    def test_snapshot_failure_stops_worker_before_reraising(self):
        original = TimeoutError('snapshot fixture')
        # Candidate takes a live snapshot; the legacy source first pauses.
        method = 'checkpoint_snapshot' if hasattr(self.worker, 'checkpoint_snapshot') else 'pause'
        with patch.object(self.worker, method, side_effect=original):
            with self.assertRaises(TimeoutError) as raised:
                self.source.save(24)
        self.assertIs(raised.exception, original)
        self.assertFalse(self.worker.worker_thread.is_alive())
        self.assertTrue(self.closed.is_set())
        self.assertTrue(self.cleaned.is_set())

    def test_cleanup_error_does_not_replace_disk_failure(self):
        original = OSError('disk full fixture')
        stop = self.worker.stop
        def stop_then_fail():
            stop()
            raise TimeoutError('cleanup fixture')
        with patch.object(self.source_module.torch, 'save', side_effect=original), \
                patch.object(self.worker, 'stop', side_effect=stop_then_fail), \
                self.assertLogs(self.source_module.logger, level='ERROR') as logs:
            with self.assertRaises(OSError) as raised:
                self.source.save(24)
        self.assertIs(raised.exception, original)
        self.assertFalse(self.worker.worker_thread.is_alive())
        self.assertTrue(any('preserving original error' in line for line in logs.output))


if __name__ == '__main__':
    unittest.main()
