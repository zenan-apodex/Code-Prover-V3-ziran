"""Exercise fresh inventory, renewal races, cancellation and process ownership."""
import asyncio
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import AsyncMock, patch

from rl import warm_pool
from rl.sandbox import ExecResult, create_sandbox


class WarmPoolTests(unittest.IsolatedAsyncioTestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.created = []
        self.args = SimpleNamespace(prover_sandbox_backend="e2b",
                                    prover_e2b_template="lean",
                                    prover_episode_timeout_sec=2400)
        self.env = patch.dict(os.environ, {
            "RUN_ID": "test-run", "RUN_DIR": self.directory.name,
            "E2B_WARM_POOL_SIZE": "2", "E2B_CREATE_CONCURRENCY": "2",
            "E2B_WARM_POOL_WAIT_TIMEOUT_SEC": "2",
        })
        self.env.start()
        self.addCleanup(self.env.stop)
        transport = patch.object(warm_pool, "configure_control_transport")
        transport.start()
        self.addCleanup(transport.stop)
        self.factory = patch.object(warm_pool.E2BSandbox, "create", side_effect=self.allocate)
        self.factory.start()
        self.addCleanup(self.factory.stop)

    async def allocate(self, *args, **kwargs):
        sandbox = SimpleNamespace(
            _sbx=SimpleNamespace(sandbox_id=str(len(self.created))),
            renew=AsyncMock(), close=AsyncMock(),
            exec=AsyncMock(return_value=ExecResult("Lean 4.28", "", 0)),
        )
        self.created.append(sandbox)
        return sandbox

    async def start(self):
        pool = await warm_pool.start_warm_pool(self.args)
        self.addAsyncCleanup(pool.close)
        return pool

    async def test_low_soft_descriptor_limit_is_raised_before_allocating(self):
        with patch.object(warm_pool.resource, "getrlimit", return_value=(128, 1000000)), \
                patch.object(warm_pool.resource, "setrlimit") as set_limit:
            pool = await self.start()
        set_limit.assert_called_once_with(warm_pool.resource.RLIMIT_NOFILE, (65536, 1000000))
        self.assertEqual(len(pool._ready), 2)

    async def test_insufficient_hard_descriptor_limit_fails_before_allocating(self):
        with patch.object(warm_pool.resource, "getrlimit", return_value=(128, 512)):
            with self.assertRaisesRegex(RuntimeError, "hard limit is 512"):
                await warm_pool.start_warm_pool(self.args)
        self.assertEqual(self.created, [])

    async def test_prefill_factory_claims_and_refills_without_reusing_episodes(self):
        pool = await self.start()
        self.assertEqual(len(self.created), 2)
        for sandbox in self.created:
            sandbox.exec.assert_awaited_once()
            self.assertIn("import Mathlib", sandbox.exec.call_args.args[0])
        claimed = await create_sandbox("e2b", template="lean",
                                       metadata={"run_id": "test-run", "task_name": "a"})
        self.assertIs(claimed, self.created[0])
        self.assertTrue(claimed.warm_pool_hit)
        claimed.renew.assert_awaited_with(3600)
        await pool.wait_ready()
        self.assertEqual(len(self.created), 3)
        await claimed.close()
        await pool.close()
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))
        self.assertIsNone(warm_pool.get_warm_pool())

    async def test_empty_inventory_waits_without_starting_unbounded_cold_fallback(self):
        pool = await self.start()
        gate = asyncio.Event()
        async def delayed(*args, **kwargs):
            await gate.wait()
            return await self.allocate(*args, **kwargs)
        with patch.object(warm_pool.E2BSandbox, "create", side_effect=delayed):
            claimed = await asyncio.gather(*(pool.acquire(template="lean") for _ in range(2)))
            waiting = asyncio.create_task(pool.acquire(template="lean"))
            await asyncio.sleep(.01)
            self.assertFalse(waiting.done())
            self.assertEqual(pool.creating, 2)
            self.assertEqual(len(self.created), 2)
            gate.set()
            third = await waiting
            self.assertFalse(third.warm_pool_hit)
            await pool.wait_ready()
        await asyncio.gather(*(s.close() for s in [*claimed, third]))
        self.assertEqual(pool.counts["misses"], 1)
        self.assertLessEqual(len(pool._ready) + pool.creating + pool.renewing, pool.size)

    async def test_cancelled_claim_reclaims_removed_instance(self):
        pool = await self.start()
        first = self.created[0]
        entered = asyncio.Event()
        async def blocked(timeout):
            entered.set()
            await asyncio.Event().wait()
        first.renew.side_effect = blocked
        task = asyncio.create_task(pool.acquire(template="lean"))
        await entered.wait()
        task.cancel()
        with self.assertRaises(asyncio.CancelledError):
            await task
        first.close.assert_awaited_once()
        await pool.wait_ready()

    async def test_failed_claim_renewal_discards_stale_instance(self):
        pool = await self.start()
        stale = self.created[0]
        stale.renew.side_effect = RuntimeError("expired")
        claimed = await pool.acquire(template="lean")
        self.assertIsNot(claimed, stale)
        self.assertFalse(claimed.warm_pool_hit)
        stale.close.assert_awaited_once()
        self.assertEqual(pool.counts["renew_failures"], 1)
        await claimed.close()

    async def test_initialization_failure_never_enters_ready_pool(self):
        async def bad(*args, **kwargs):
            sandbox = await self.allocate(*args, **kwargs)
            sandbox.exec.return_value = ExecResult("", "Mathlib missing", 1)
            return sandbox
        with patch.dict(os.environ, {"E2B_WARM_POOL_WAIT_TIMEOUT_SEC": ".03"}), \
                patch.object(warm_pool.E2BSandbox, "create", side_effect=bad):
            with self.assertRaises(TimeoutError):
                await warm_pool.start_warm_pool(self.args)
        self.assertTrue(self.created)
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))
        self.assertIsNone(warm_pool.get_warm_pool())

    async def test_failure_diagnostics_do_not_depend_on_rollout_agent_imports(self):
        pool = warm_pool.E2BWarmPool(template="lean", size=1, run_id="test-run",
                                    lock_path=Path(self.directory.name)/"pool.lock",
                                    concurrency=1, wait_timeout=2)
        with patch.dict(sys.modules, {"rl.generate_with_prover": None}), \
                patch.dict(os.environ, {"E2B_API_KEY": "fake-private-key"}), \
                patch.object(warm_pool.E2BSandbox, "create", side_effect=RuntimeError("fake-private-key unavailable")), \
                self.assertLogs(warm_pool.logger, level="WARNING") as logs:
            starting = asyncio.create_task(pool.start())
            try:
                deadline = asyncio.get_running_loop().time() + 1
                while not pool.counts["create_failures"]:
                    self.assertLess(asyncio.get_running_loop().time(), deadline)
                    await asyncio.sleep(.01)
                self.assertFalse(pool._tasks[0].done(), "producer died while formatting the error")
                self.assertEqual(pool.counts["create_failures_allocation"], 1)
            finally:
                starting.cancel()
                await asyncio.gather(starting, return_exceptions=True)
        self.assertIn("<redacted>", " ".join(logs.output))
        self.assertNotIn("fake-private-key", " ".join(logs.output))

    async def test_idle_renewal_and_claim_do_not_shorten_active_lifetime(self):
        pool = warm_pool.E2BWarmPool(template="lean", size=1, run_id="test-run",
                                    lock_path=Path(self.directory.name)/"pool.lock",
                                    idle_timeout=1, wait_timeout=2)
        await pool.start()
        self.addAsyncCleanup(pool.close)
        first = self.created[0]
        entered, finish = asyncio.Event(), asyncio.Event()
        async def renewal(timeout):
            if timeout == 1:
                entered.set()
                await finish.wait()
        first.renew.side_effect = renewal
        await asyncio.wait_for(entered.wait(), 1)
        claim = asyncio.create_task(pool.acquire(template="lean"))
        await asyncio.sleep(.01)
        self.assertFalse(claim.done())
        finish.set()
        claimed = await claim
        self.assertIs(claimed, first)
        self.assertEqual(first.renew.call_args_list[-1].args, (3600,))
        await claimed.close()

    async def test_slow_idle_renewal_does_not_starve_other_inventory(self):
        pool = warm_pool.E2BWarmPool(template="lean", size=3, run_id="test-run",
                                    lock_path=Path(self.directory.name)/"pool.lock",
                                    idle_timeout=1, wait_timeout=2)
        await pool.start()
        self.addAsyncCleanup(pool.close)
        blocked, other_renewed, release = asyncio.Event(), asyncio.Event(), asyncio.Event()

        async def slow(timeout):
            blocked.set()
            await release.wait()

        async def fast(timeout):
            other_renewed.set()

        self.created[0].renew.side_effect = slow
        self.created[1].renew.side_effect = fast
        try:
            await asyncio.wait_for(blocked.wait(), 1)
            await asyncio.wait_for(other_renewed.wait(), .2)
            # The blocked sandbox remains unavailable to claims, while the
            # other inventory is renewed without waiting for it.
            self.assertGreaterEqual(pool.counts["idle_renewals"], 1)
            self.assertNotIn(self.created[0], [sandbox for sandbox, _ in pool._ready])
        finally:
            release.set()
            await pool.close()
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))

    async def test_large_inventory_shutdown_bounds_control_requests(self):
        pool = warm_pool.E2BWarmPool(template="lean", size=192, run_id="test-run",
                                    lock_path=Path(self.directory.name)/"pool.lock",
                                    concurrency=32, wait_timeout=5)
        await pool.start()
        self.addAsyncCleanup(pool.close)
        active = peak = 0
        filled, release = asyncio.Event(), asyncio.Event()

        async def close():
            nonlocal active, peak
            active += 1
            peak = max(peak, active)
            if active == 64:
                filled.set()
            try:
                await release.wait()
            finally:
                active -= 1

        for sandbox in self.created:
            sandbox.close.side_effect = close
        closing = asyncio.create_task(pool.close())
        try:
            await asyncio.wait_for(filled.wait(), 1)
            await asyncio.sleep(.01)
            self.assertEqual(peak, 64)
        finally:
            release.set()
            await closing
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))

    async def test_shutdown_cancels_bootstrap_and_releases_owner_lock(self):
        entered = asyncio.Event()
        async def allocating(*args, **kwargs):
            sandbox = await self.allocate(*args, **kwargs)
            async def check(*args, **kwargs):
                entered.set()
                await asyncio.Event().wait()
            sandbox.exec.side_effect = check
            return sandbox
        with patch.object(warm_pool.E2BSandbox, "create", side_effect=allocating):
            start = asyncio.create_task(warm_pool.start_warm_pool(self.args))
            await entered.wait()
            start.cancel()
            with self.assertRaises(asyncio.CancelledError):
                await start
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))
        pool = await self.start()
        self.assertEqual(len(pool._ready), 2)

    async def test_shutdown_frees_inventory_before_waiting_on_starved_allocation(self):
        pool = await self.start()
        entered, capacity_released = asyncio.Event(), asyncio.Event()

        async def allocation_waiting_for_capacity(*args, **kwargs):
            entered.set()
            try:
                await asyncio.Event().wait()
            except asyncio.CancelledError:
                # Model the SDK resolving an accepted create request even
                # after cancellation; it needs existing inventory released.
                await capacity_released.wait()
                raise

        with patch.object(warm_pool.E2BSandbox, "create", side_effect=allocation_waiting_for_capacity):
            claimed = await pool.acquire(template="lean")
            await entered.wait()
            remaining = next(s for s in self.created if s is not claimed)
            remaining.close.side_effect = lambda: capacity_released.set()
            closing = asyncio.create_task(pool.close())
            try:
                await asyncio.wait_for(asyncio.shield(closing), 1)
            finally:
                capacity_released.set()
                await closing
        await claimed.close()
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))

    async def test_concurrent_shutdown_finishes_inflight_cleanup_once(self):
        pool = await self.start()
        gate, entered = asyncio.Event(), asyncio.Event()
        first = self.created[0]
        async def cleanup():
            entered.set()
            await gate.wait()
        first.close.side_effect = cleanup
        closing = asyncio.create_task(pool.close())
        await entered.wait()
        again = asyncio.create_task(pool.close())
        closing.cancel()
        await asyncio.sleep(.01)
        self.assertFalse(closing.done())
        gate.set()
        with self.assertRaises(asyncio.CancelledError):
            await closing
        await again
        first.close.assert_awaited_once()

    async def test_real_worker_prefills_before_generating_and_cleans_on_exit(self):
        import importlib.util
        import types

        entered = asyncio.Event()
        async def group(*args, **kwargs):
            sandbox = await create_sandbox("e2b", template="lean")
            try:
                self.assertTrue(sandbox.warm_pool_hit)
                entered.set()
                await asyncio.Event().wait()
            finally:
                await sandbox.close()
        fake = {
            "miles": types.ModuleType("miles"),
            "miles.rollout": types.ModuleType("miles.rollout"),
            "miles.rollout.sglang_rollout": SimpleNamespace(
                GenerateState=lambda args: SimpleNamespace(sampling_params={}),
                generate_and_rm_group=group),
            "miles.rollout.base_types": SimpleNamespace(RolloutFnTrainOutput=object),
            "miles.utils": types.ModuleType("miles.utils"),
            "miles.utils.async_utils": SimpleNamespace(run=lambda value: value),
            "miles.utils.types": SimpleNamespace(Sample=object),
        }
        path = Path(__file__).parents[1]/"rl/fully_async_rollout.py"
        spec = importlib.util.spec_from_file_location("_warm_pool_worker_test", path)
        module = importlib.util.module_from_spec(spec)
        with patch.dict(sys.modules, fake):
            spec.loader.exec_module(module)
        args = SimpleNamespace(**vars(self.args), over_sampling_batch_size=1,
                               rollout_batch_size=1, prover_async_queue_size=1)
        worker = module.AsyncRolloutWorker(args, SimpleNamespace(get_samples=lambda n: [[object()]]))
        task = asyncio.create_task(worker._loop())
        try:
            await asyncio.wait_for(entered.wait(), 2)
            self.assertFalse(worker.warming)
            self.assertIsNotNone(worker.warm_pool)
        finally:
            worker.running = False
            await asyncio.wait_for(task, 2)
        self.assertTrue(all(s.close.await_count == 1 for s in self.created))
        self.assertIsNone(warm_pool.get_warm_pool())

    async def test_second_process_cannot_multiply_inventory(self):
        pool = await self.start()
        program = (
            "import fcntl,sys; f=open(sys.argv[1], 'a'); "
            "fcntl.flock(f, fcntl.LOCK_EX|fcntl.LOCK_NB)"
        )
        result = await asyncio.to_thread(subprocess.run,
            [sys.executable, "-c", program, str(pool.lock_path)], capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        await pool.close()
        result = await asyncio.to_thread(subprocess.run,
            [sys.executable, "-c", program, str(pool.lock_path)], capture_output=True)
        self.assertEqual(result.returncode, 0)

    async def test_template_or_run_mismatch_cannot_consume_inventory(self):
        pool = await self.start()
        with self.assertRaises(ValueError):
            await pool.acquire(template="other")
        with self.assertRaises(ValueError):
            await pool.acquire(template="lean", metadata={"run_id": "other-run"})
        self.assertEqual(len(pool._ready), 2)

    async def test_exit_cleanup_checks_all_owner_fields_before_deleting(self):
        owner = {"purpose": "codeprover-rl", "run_id": "test-run",
                 "attempt_id": "attempt-a", "warm_pool": "true"}
        pages = [
            [SimpleNamespace(sandbox_id="mine", metadata=owner),
             SimpleNamespace(sandbox_id="other-attempt", metadata={**owner, "attempt_id": "b"})],
            [SimpleNamespace(sandbox_id="other-run", metadata={**owner, "run_id": "other"}),
             SimpleNamespace(sandbox_id="not-pooled", metadata={**owner, "warm_pool": "false"}),
             SimpleNamespace(sandbox_id="unlabelled", metadata=None)],
        ]
        class Pager:
            @property
            def has_next(self):
                return bool(pages)
            async def next_items(self):
                return pages.pop(0)
        sdk = SimpleNamespace(
            AsyncSandbox=SimpleNamespace(list=lambda **kw: Pager(), kill=AsyncMock()),
            SandboxQuery=lambda **kw: SimpleNamespace(**kw),
        )
        with patch.dict(sys.modules, {"e2b": sdk}), patch.object(warm_pool, "load_e2b_api_key"):
            result = await warm_pool.cleanup_warm_pool_run("test-run", "attempt-a")
        self.assertEqual(result, {"matched": 1, "reclaimed": 1})
        self.assertEqual(sdk.AsyncSandbox.kill.await_count, 1)
        self.assertEqual(sdk.AsyncSandbox.kill.call_args.args, ("mine",))
        with self.assertRaises(ValueError):
            await warm_pool.cleanup_warm_pool_run("test-run", "")

    async def test_dlc_failure_runs_exit_cleanup_and_preserves_failure_status(self):
        import json
        root = Path(self.directory.name)
        commands = root/"bin"
        commands.mkdir()
        python = commands/"python3"
        python.write_text(
            "#!" + sys.executable + "\n"
            "import json,os,sys\n"
            "from pathlib import Path\n"
            "if '--cleanup' in sys.argv:\n"
            " Path(os.environ['CLEANUP_TRACE']).write_text(json.dumps("
            "{'argv':sys.argv[1:],'run':os.environ['RUN_ID'],'attempt':os.environ['ATTEMPT_ID']}))\n"
        )
        ray = commands/"ray"
        ray.write_text('#!/bin/sh\nif [ "$1" = start ]; then exit 7; fi\nexit 0\n')
        python.chmod(0o755)
        ray.chmod(0o755)
        trace=root/"cleanup.json"
        env={**os.environ, "PATH":str(commands)+os.pathsep+os.environ["PATH"],
             "CODEPROVER_ROOT":str(Path(__file__).parents[1]), "MILES_ROOT":str(root),
             "RUN_ROOT":str(root), "RUN_ID":"exit-test", "ATTEMPT_ID":"attempt-a",
             "MLP_WORKER_RACK_RANK_INDEX":"0", "E2B_WARM_POOL_SIZE":"32",
             "CLEANUP_TRACE":str(trace)}
        result=await asyncio.to_thread(subprocess.run,
            ["bash",str(Path(__file__).parents[1]/"rl/run_dlc.sh")],
            env=env,capture_output=True,text=True,timeout=5)
        self.assertEqual(result.returncode,7,result.stderr)
        recorded=json.loads(trace.read_text())
        self.assertEqual(recorded, {"argv":["-m","rl.warm_pool","--cleanup"],
                                    "run":"exit-test","attempt":"attempt-a"})
        self.assertEqual((root/"exit-test/cluster.done.attempt-a").read_text().strip(),"7")


    async def test_disabled_pool_preserves_direct_creation(self):
        with patch.dict(os.environ, {"E2B_WARM_POOL_SIZE": "0"}):
            self.assertIsNone(await warm_pool.start_warm_pool(self.args))
            sandbox = await create_sandbox("e2b", template="lean")
        self.assertEqual(len(self.created), 1)
        sandbox.exec.assert_not_awaited()
        await sandbox.close()


if __name__ == "__main__":
    unittest.main()
