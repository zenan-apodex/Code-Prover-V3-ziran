"""Stopping after a timed-out pause must let existing cleanup finish."""
import asyncio
import threading
import unittest
from types import SimpleNamespace
from unittest.mock import patch

from test_rl_reliability import Sample, async_module


class CancellationBoundaryTests(unittest.TestCase):
    def test_pause_timeout_then_stop_does_not_cancel_cleanup_twice(self):
        module = async_module()
        module.GenerateState = lambda args: SimpleNamespace(sampling_params={})
        args = SimpleNamespace(over_sampling_batch_size=1, rollout_batch_size=1,
            prover_async_queue_size=1, n_samples_per_prompt=1,
            prover_sandbox_concurrency=1, prover_async_max_pending_groups=1)
        entered, cleaning, release, completed, interrupted, pool_closed = [threading.Event() for _ in range(6)]
        source = SimpleNamespace(get_samples=lambda count: [[Sample()]], add_samples=lambda groups: None)
        async def episode():
            entered.set()
            try:
                await asyncio.Event().wait()
            except asyncio.CancelledError:
                cleaning.set()
                try:
                    while not release.is_set():
                        await asyncio.sleep(.005)
                    completed.set()
                except asyncio.CancelledError:
                    interrupted.set()
                    raise
                raise
        async def generate(*args, **kwargs):
            # Match Miles' group -> gather -> episode cancellation chain.
            return await asyncio.gather(asyncio.create_task(episode()))

        async def close():
            await asyncio.sleep(.02)
            pool_closed.set()
        async def warm(args):
            return SimpleNamespace(close=close)
        errors = []
        with patch.object(module, 'start_warm_pool', warm), \
                patch.object(module, 'generate_and_rm_group', generate):
            worker = module.get_global_worker(args, source)
            def stop():
                try:
                    worker.stop()
                except BaseException as exc:
                    errors.append(exc)
            stopper = threading.Thread(target=stop)
            try:
                self.assertTrue(entered.wait(2), "episode did not start")
                with self.assertRaises(TimeoutError):
                    worker.pause(timeout_sec=.03)
                self.assertTrue(cleaning.wait(1))
                stopper.start()
                self.assertTrue(pool_closed.wait(1))
                self.assertFalse(interrupted.is_set(), 'shutdown cancelled an episode already cleaning up')
                self.assertTrue(stopper.is_alive(), 'stop returned before episode cleanup finished')
            finally:
                release.set()
                if stopper.ident is not None:
                    stopper.join(timeout=2)
                module.stop_global_worker()
            self.assertFalse(worker.worker_thread.is_alive())
            self.assertTrue(completed.is_set())
            self.assertEqual(errors, [])


if __name__ == '__main__':
    unittest.main()
