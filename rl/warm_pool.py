"""A bounded, single-owner supply of fresh Lean sandboxes for the rollout loop."""

from __future__ import annotations

import asyncio
import fcntl
import functools
import logging
import json
import math
import os
import resource
import weakref
from collections import Counter, deque
from pathlib import Path

from rl.e2b_smoke import check_lean_runtime
from rl.errors import safe_failure_detail
from rl.sandbox import E2BSandbox, e2b_api_options, load_e2b_api_key

logger = logging.getLogger(__name__)
_pools = weakref.WeakKeyDictionary()
_MAINTENANCE_CONCURRENCY = 64


def configure_control_transport() -> None:
    """Keep long creates off the connections serving short control requests.

    E2B 2.34 caches one HTTP/2 API transport per loop/proxy. Under concurrent
    SG image replacements its short renew/kill requests can stall behind
    creates. HTTP/1.1 uses a separate pooled connection for each in-flight
    request. This changes only the SDK API transport, not envd command traffic.
    """
    import importlib.metadata
    from rl.sandbox import E2B_SDK_VERSION

    if importlib.metadata.version("e2b") != E2B_SDK_VERSION:
        raise RuntimeError(f"warm pool requires e2b=={E2B_SDK_VERSION}")
    from e2b.api import client_async
    from e2b.connection_config import ConnectionConfig

    load_e2b_api_key()
    # Validate credentials/configuration before launching any producer tasks.
    client_async.get_api_client(ConnectionConfig(**e2b_api_options()))
    client_async.get_transport = functools.partial(
        client_async._get_cached_transport,
        client_async.AsyncTransportWithLogger, http2=False,
    )


class E2BWarmPool:
    """Bound idle + creating + renewing inventory independently of episodes.

    Claimed instances leave permanently and their episodes destroy them.
    SDK objects stay on the owning event loop. A shared-filesystem lock rejects
    a second process for the same run instead of multiplying the inventory.
    """

    def __init__(self, *, template: str, size: int, run_id: str, lock_path: Path,
                 concurrency: int = 8, timeout: int = 3600,
                 wait_timeout: float = 1200, idle_timeout: int = 900):
        if not template or size < 1 or concurrency < 1:
            raise ValueError("warm pool requires a template, positive size and concurrency")
        if timeout < 1 or not math.isfinite(wait_timeout) or wait_timeout <= 0 or idle_timeout < 1:
            raise ValueError("warm pool timeouts must be positive and finite")
        self.template, self.size, self.run_id = template, size, run_id
        self.timeout, self.wait_timeout, self.idle_timeout = timeout, wait_timeout, idle_timeout
        self.concurrency, self.lock_path = min(concurrency, size), Path(lock_path)
        self._ready = deque()
        self._slots = asyncio.Semaphore(size)
        self._changed = asyncio.Event()
        self._tasks = []
        self._lock = None
        self._closed = False
        self._closing = None
        self.creating = self.renewing = 0
        self.counts = Counter()
        self._acquire_seconds = deque(maxlen=1024)

    def _ensure_file_descriptor_capacity(self) -> None:
        # Each idle sandbox owns an envd connection pool in addition to the
        # shared API connections used by creators, claims and maintenance.
        required = max(1024, 2 * self.size + 2 * self.concurrency + 256)
        soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
        if soft == resource.RLIM_INFINITY or soft >= required:
            return
        if hard != resource.RLIM_INFINITY and hard < required:
            raise RuntimeError(
                f"warm pool needs file-descriptor limit {required}; hard limit is {hard}. "
                "Increase the container nofile limit before starting this pool."
            )
        target = max(65536, required)
        if hard != resource.RLIM_INFINITY:
            target = min(target, hard)
        resource.setrlimit(resource.RLIMIT_NOFILE, (target, hard))
        logger.info("E2B warm pool raised file-descriptor soft limit from %s to %s", soft, target)

    async def start(self) -> None:
        if self._tasks or self._closed:
            raise RuntimeError("warm pool cannot be started twice")
        self._ensure_file_descriptor_capacity()
        configure_control_transport()
        self.lock_path.parent.mkdir(parents=True, exist_ok=True)
        self._lock = self.lock_path.open("a")
        try:
            fcntl.flock(self._lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            self._lock.close()
            self._lock = None
            raise RuntimeError(f"another process already owns the warm pool for {self.run_id}") from None
        self._tasks = [asyncio.create_task(self._produce()) for _ in range(self.concurrency)]
        self._tasks.append(asyncio.create_task(self._keep_alive()))
        try:
            await self.wait_ready()
        except BaseException:
            await self.close()
            raise
        logger.info("E2B warm pool ready run_id=%s size=%s", self.run_id, self.size)

    async def _produce(self) -> None:
        failures = 0
        while not self._closed:
            await self._slots.acquire()
            sandbox, queued = None, False
            self.creating += 1
            started = asyncio.get_running_loop().time()
            phase = "allocation"
            try:
                sandbox = await E2BSandbox.create(
                    self.template, timeout=self.timeout, create_attempts=1,
                    metadata={"purpose": "codeprover-rl", "run_id": self.run_id[:100],
                              "attempt_id": os.environ.get("ATTEMPT_ID", "unknown"),
                              "warm_pool": "true"},
                )
                phase = "runtime_check"
                await check_lean_runtime(sandbox)
                phase = "renewal"
                await sandbox.renew(self.idle_timeout)
                if self._closed:
                    return
                self._ready.append((sandbox, asyncio.get_running_loop().time()))
                sandbox, queued, failures = None, True, 0
                self.counts["created"] += 1
                duration = asyncio.get_running_loop().time() - started
                self.counts["create_seconds"] += duration
                logger.info("E2B warm pool filled ready=%s creating=%s create_sec=%.3f",
                            len(self._ready), self.creating - 1, duration)
            except Exception as exc:
                failures += 1
                self.counts["create_failures"] += 1
                self.counts[f"create_failures_{phase}"] += 1
                logger.warning(
                    "E2B warm pool creation failed phase=%s sandbox_id=%s duration_sec=%.3f type=%s detail=%s",
                    phase, getattr(getattr(sandbox, "_sbx", None), "sandbox_id", None),
                    asyncio.get_running_loop().time() - started,
                    type(exc).__name__, safe_failure_detail(exc, limit=None),
                )
            finally:
                if sandbox is not None:
                    await sandbox.close()
                self.creating -= 1
                if not queued:
                    self._slots.release()
                self._changed.set()
            if failures:
                await asyncio.sleep(min(30, 2 ** min(failures, 5)))

    async def _renew_one_due(self, interval: float) -> None:
        if not self._ready:
            return
        if asyncio.get_running_loop().time() - self._ready[0][1] < interval:
            return
        # Remove before the first await: claims must never race idle renewal
        # and receive an active lifetime shortened to the inventory TTL.
        sandbox, _ = self._ready.popleft()
        self.renewing += 1
        queued = False
        try:
            await sandbox.renew(self.idle_timeout)
            if self._closed:
                return
            self._ready.append((sandbox, asyncio.get_running_loop().time()))
            queued = True
            self.counts["idle_renewals"] += 1
        except Exception as exc:
            self.counts["renew_failures"] += 1
            logger.warning("E2B warm pool idle renewal failed type=%s", type(exc).__name__)
        finally:
            if not queued:
                await sandbox.close()
                self._slots.release()
            self.renewing -= 1
            self._changed.set()

    async def _keep_alive(self) -> None:
        interval = self.idle_timeout / 3

        async def renew_worker():
            while not self._closed:
                if (not self._ready or
                    asyncio.get_running_loop().time() - self._ready[0][1] < interval):
                    await asyncio.sleep(min(30, interval))
                    continue
                await self._renew_one_due(interval)

        # Independent workers avoid a slow renewal holding up a whole batch
        # and let the remaining workers continue through large inventories.
        await asyncio.gather(*(renew_worker() for _ in
            range(min(_MAINTENANCE_CONCURRENCY, self.size))))

    async def wait_ready(self, count: int | None = None) -> None:
        target = self.size if count is None else count
        if not 0 <= target <= self.size:
            raise ValueError("ready target exceeds warm pool size")
        async with asyncio.timeout(self.wait_timeout):
            while len(self._ready) < target:
                self._changed.clear()
                if self._closed:
                    raise RuntimeError("warm pool is closed")
                await self._changed.wait()

    async def acquire(self, *, template: str, timeout: int = 3600,
                      metadata: dict | None = None) -> E2BSandbox:
        if template != self.template:
            raise ValueError("requested template differs from the active warm pool")
        if metadata and metadata.get("run_id", self.run_id[:100]) != self.run_id[:100]:
            raise ValueError("requested run differs from the active warm pool")
        started = asyncio.get_running_loop().time()
        hit = bool(self._ready)
        self.counts["requests"] += 1
        self.counts["misses"] += not hit
        async with asyncio.timeout(self.wait_timeout):
            while True:
                self._changed.clear()
                if self._closed:
                    raise RuntimeError("warm pool is closed")
                if not self._ready:
                    await self._changed.wait()
                    continue
                sandbox, _ = self._ready.popleft()
                self._slots.release()
                try:
                    await sandbox.renew(max(timeout, self.timeout))
                except BaseException as exc:
                    await sandbox.close()
                    if not isinstance(exc, Exception):
                        raise
                    self.counts["renew_failures"] += 1
                    self.counts["misses"] += hit
                    hit = False
                    continue
                self.counts["claimed"] += 1
                elapsed = asyncio.get_running_loop().time() - started
                self._acquire_seconds.append(elapsed)
                sandbox.warm_pool_hit = hit
                logger.info("E2B warm pool claim sandbox_id=%s task=%s sample_index=%s wait_sec=%.3f ready=%s",
                            sandbox._sbx.sandbox_id, (metadata or {}).get("task_name", ""),
                            (metadata or {}).get("sample_index"), elapsed, len(self._ready))
                return sandbox

    def metrics(self) -> dict:
        values = sorted(self._acquire_seconds)
        result = {"ready": len(self._ready), "creating": self.creating, "renewing": self.renewing,
                  **self.counts}
        result["create_seconds_mean"] = self.counts["create_seconds"] / max(1, self.counts["created"])
        for label, fraction in (("p50", .5), ("p95", .95)):
            if values:
                result[f"acquire_seconds_{label}"] = values[math.ceil(fraction * len(values)) - 1]
        return {f"sandbox_pool/{key}": value for key, value in result.items()}

    async def close(self) -> None:
        # Concurrent shutdown paths must not cancel a producer twice while it
        # is resolving an allocation and reclaiming the returned sandbox.
        if self._closing is None:
            self._closing = asyncio.create_task(self._close())
        cancelled = False
        while not self._closing.done():
            try:
                await asyncio.shield(self._closing)
            except asyncio.CancelledError:
                cancelled = True
        self._closing.result()
        if cancelled:
            raise asyncio.CancelledError

    async def _close(self) -> None:
        self._closed = True
        self._changed.set()
        for task in self._tasks:
            task.cancel()
        idle = [sandbox for sandbox, _ in self._ready]
        self._ready.clear()

        async def reclaim_idle():
            slots = asyncio.Semaphore(_MAINTENANCE_CONCURRENCY)

            async def reclaim(sandbox):
                async with slots:
                    await sandbox.close()

            await asyncio.gather(*(reclaim(sandbox) for sandbox in idle))

        # Release idle inventory while cancelled allocations resolve. Waiting
        # for allocations first can retain all available provider capacity
        # until their request timeouts when the provider is out of stock.
        idle_cleanup = asyncio.create_task(reclaim_idle())
        if self._tasks:
            await asyncio.gather(*self._tasks, return_exceptions=True)
        self._tasks.clear()
        await idle_cleanup
        if self._lock is not None:
            self._lock.close()
            self._lock = None
        loop = asyncio.get_running_loop()
        if _pools.get(loop) is self:
            del _pools[loop]
        logger.info("E2B warm pool closed run_id=%s idle_reclaimed=%s", self.run_id, len(idle))


def get_warm_pool() -> E2BWarmPool | None:
    return _pools.get(asyncio.get_running_loop())


async def start_warm_pool(args) -> E2BWarmPool | None:
    size = int(os.environ.get("E2B_WARM_POOL_SIZE", "0"))
    if size < 0:
        raise ValueError("E2B_WARM_POOL_SIZE must be nonnegative")
    if not size:
        return None
    if args.prover_sandbox_backend != "e2b":
        raise ValueError("warm pool requires the E2B backend")
    if get_warm_pool() is not None:
        raise RuntimeError("this event loop already owns a warm pool")
    run_id, run_dir = os.environ.get("RUN_ID"), os.environ.get("RUN_DIR")
    if not run_id or not run_dir or not Path(run_dir).is_absolute():
        raise ValueError("warm pool requires RUN_ID and absolute shared RUN_DIR for ownership and cleanup")
    pool = E2BWarmPool(
        template=args.prover_e2b_template, size=size, run_id=run_id,
        lock_path=Path(run_dir) / ".e2b-warm-pool.lock",
        concurrency=int(os.environ.get("E2B_CREATE_CONCURRENCY", "8")),
        timeout=max(3600, args.prover_episode_timeout_sec + 300),
        wait_timeout=float(os.environ.get("E2B_WARM_POOL_WAIT_TIMEOUT_SEC", "1200")),
    )
    await pool.start()
    _pools[asyncio.get_running_loop()] = pool
    return pool


async def cleanup_warm_pool_run(run_id: str, attempt_id: str) -> dict:
    """Reclaim only this submission's pooled instances after Ray stops."""
    if not run_id or not attempt_id or attempt_id == "unknown":
        raise ValueError("cleanup requires an explicit run and submission attempt")
    load_e2b_api_key()
    from e2b import AsyncSandbox, SandboxQuery

    owner = {"purpose": "codeprover-rl", "run_id": run_id[:100],
             "attempt_id": attempt_id, "warm_pool": "true"}
    pager = AsyncSandbox.list(query=SandboxQuery(metadata=owner), limit=100,
                              **e2b_api_options(), request_timeout=30)
    ids = []
    while pager.has_next:
        for info in await pager.next_items():
            # Verify ownership locally even if a provider ignores query filters.
            if all((info.metadata or {}).get(k) == v for k, v in owner.items()):
                ids.append(info.sandbox_id)
    slots = asyncio.Semaphore(_MAINTENANCE_CONCURRENCY)

    async def reclaim(sandbox_id):
        async with slots:
            for attempt in range(3):
                try:
                    await asyncio.wait_for(
                        AsyncSandbox.kill(sandbox_id, **e2b_api_options(), request_timeout=30),
                        timeout=35,
                    )
                    return
                except Exception:
                    if attempt == 2:
                        raise
                    await asyncio.sleep(1 + attempt)

    results = await asyncio.gather(*(reclaim(sid) for sid in ids), return_exceptions=True)
    failed = sum(isinstance(value, BaseException) for value in results)
    if failed:
        raise RuntimeError(f"failed to reclaim {failed} of {len(ids)} warm-pool sandboxes")
    return {"matched": len(ids), "reclaimed": len(ids)}


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Reclaim one stopped submission's warm pool")
    parser.add_argument("--cleanup", action="store_true", required=True)
    options = parser.parse_args()
    print(json.dumps(asyncio.run(cleanup_warm_pool_run(
        os.environ.get("RUN_ID", ""), os.environ.get("ATTEMPT_ID", ""),
    )), sort_keys=True))
