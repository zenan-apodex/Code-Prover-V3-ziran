"""Hardened official-Miles fully-async rollout queue for Code-Prover.

This intentionally lives in V3 instead of patching the official Miles checkout.
It follows ``examples/fully_async/fully_async_rollout.py`` at the pinned Miles
``12d80fea77d40087724a6910b08a0013a8b34d48`` while fixing fatal-worker
propagation and prompt logging for non-string prompts.
"""

from __future__ import annotations

import asyncio
import atexit
import logging
import math
import os
import queue
import threading
import time

import aiohttp

from miles.rollout.sglang_rollout import GenerateState, generate_and_rm_group
from miles.utils.async_utils import run
from miles.utils.types import Sample
from miles.rollout.base_types import RolloutFnTrainOutput

from rl.metrics import EpisodeMetrics
from rl.warm_pool import start_warm_pool

logger = logging.getLogger(__name__)

_global_worker = None
_worker_lock = threading.Lock()


class _CachedWeightVersion:
    def __init__(self, ttl: float = 1.0):
        self.ttl = ttl
        self.value: int | None = None
        self.last_query = 0.0
        self.last_error = "no query completed"
        self._router = None
        self._endpoint = None
        self._last_warning = float("-inf")

    async def get(self, args) -> int | None:
        router = f"http://{args.sglang_router_ip}:{args.sglang_router_port}"
        if router != self._router:
            self._router, self._endpoint, self.value = router, None, None
        now = time.monotonic()
        if self.value is not None and now - self.last_query < self.ttl:
            return self.value
        # Expired data must not survive a failed refresh.
        self.value = None
        # Rust router 0.3.2 exposes /get_model_info; the engine and newer
        # gateways also expose /model_info. Query the router's actual contract.
        endpoints = list(dict.fromkeys(filter(None, (
            self._endpoint, "/get_model_info", "/model_info",
        ))))
        errors = []
        try:
            async with aiohttp.ClientSession(timeout=aiohttp.ClientTimeout(total=2)) as session:
                for endpoint in endpoints:
                    try:
                        self.last_error = f"{router}{endpoint}: request in progress"
                        async with session.get(router + endpoint) as response:
                            if response.status != 200:
                                errors.append(f"{endpoint}: HTTP {response.status}")
                                continue
                            payload = await response.json()
                            version = payload.get("weight_version") if isinstance(payload, dict) else None
                            if isinstance(version, str) and version.isascii() and version.isdecimal():
                                version = int(version)
                            if type(version) is not int or version < 1:
                                errors.append(f"{endpoint}: missing or invalid positive weight_version")
                                continue
                            self.value = version
                            self.last_query = time.monotonic()
                            self.last_error = ""
                            if self._endpoint != endpoint:
                                logger.info("rollout weight version endpoint ready: %s%s version=%s",
                                            router, endpoint, version)
                            self._endpoint = endpoint
                            return version
                    except (aiohttp.ClientError, OSError, ValueError, TimeoutError) as exc:
                        errors.append(f"{endpoint}: {type(exc).__name__}")
        except (aiohttp.ClientError, OSError, ValueError, TimeoutError) as exc:
            errors.append(f"HTTP session: {type(exc).__name__}")
        self.last_error = f"{router}: " + "; ".join(errors)
        if time.monotonic() - self._last_warning >= 15:
            logger.warning("cannot query rollout weight version: %s", self.last_error)
            self._last_warning = time.monotonic()
        return None


_cached_weight_version = _CachedWeightVersion()


async def _wait_for_weight_version(args, timeout_sec: float, worker=None) -> int:
    deadline = asyncio.timeout(timeout_sec)
    try:
        async with deadline:
            while True:
                if worker is not None:
                    worker.raise_if_failed()
                version = await _cached_weight_version.get(args)
                if version is not None:
                    return version
                await asyncio.sleep(0.5)
    except TimeoutError:
        if not deadline.expired():
            raise  # Preserve a worker's own failure and traceback.
        raise TimeoutError(
            f"cannot validate sample staleness: engine weight version unavailable for "
            f"{timeout_sec:g}s; {_cached_weight_version.last_error}"
        ) from None


async def _preflight_weight_version(args, rollout_id, no_progress_timeout=None, worker=None):
    version_timeout = getattr(args, "prover_async_weight_version_timeout_sec", 60)
    if not math.isfinite(version_timeout) or version_timeout <= 0:
        raise ValueError("weight-version timeout must be finite and positive")
    if getattr(args, "max_weight_staleness", None) is not None:
        # Miles publishes checkpoint weights before generate(). Refresh even
        # if the previous rollout's cached version has not expired yet.
        _cached_weight_version.value = None
        timeout = version_timeout if no_progress_timeout is None else min(version_timeout, no_progress_timeout)
        version = await _wait_for_weight_version(args, timeout, worker=worker)
        logger.info("rollout %s weight version preflight passed: version=%s", rollout_id, version)
    return version_timeout


def add_arguments(parser):
    parser.add_argument("--prover-async-queue-size", type=int, default=256)
    parser.add_argument("--prover-async-max-consecutive-failures", type=int, default=0,
                        help="Optional fail-fast threshold; 0 disables it.")
    parser.add_argument("--prover-async-max-group-retries", type=int, default=2,
                        help="Retries of an infrastructure-failed group before discarding it.")
    parser.add_argument("--prover-async-no-progress-timeout-sec", type=int, default=None,
                        help="No accepted-group deadline; defaults to episode timeout + 300s.")
    parser.add_argument("--prover-async-weight-version-timeout-sec", type=float, default=60,
                        help="Deadline for querying a published weight version, before starting sampling and during collection.")
    parser.add_argument("--prover-async-pause-timeout-sec", type=int, default=300)
    parser.add_argument("--prover-reset-rollout-data-state", action="store_true")


def _group_weight_version(
    group: list[Sample], update_interval: int = 1, start_rollout_id: int | None = None,
) -> int | None:
    versions = []
    for sample in group:
        metadata = getattr(sample, "metadata", None) or {}
        # Old checkpoints may have silently omitted unversioned turns.
        if metadata.get("weight_versions_complete") is not True:
            return None
        origin = metadata.get("weight_version_origin")
        if metadata.get("weight_update_interval", 1) != update_interval:
            return None
        if update_interval > 1:
            # Restart pushes checkpoint weights immediately, even between
            # periodic updates. Equal counters across different starts therefore
            # need not identify equal weights. Legacy provenance is ambiguous too.
            sample_start = metadata.get("weight_version_start_rollout_id")
            if (type(sample_start) is not int or sample_start < 0
                    or sample_start != start_rollout_id
                    or origin != sample_start // update_interval):
                return None
        version = sample.oldest_weight_version
        if type(origin) is not int or origin < 0 or version is None:
            return None
        versions.append(origin + version)
    return min(versions) if versions else None


def _sample_preview(sample: Sample) -> str:
    return (str(sample.prompt) + str(sample.response))[:500]


class AsyncRolloutWorker:
    def __init__(self, args, data_source):
        self.args = args
        self.data_source = data_source
        self.running = True
        self.sampling_batch_size = (
            args.over_sampling_batch_size
            if args.over_sampling_batch_size is not None
            else args.rollout_batch_size
        )
        if self.sampling_batch_size < args.rollout_batch_size:
            raise ValueError("over_sampling_batch_size must be >= rollout_batch_size")
        # The background worker is the fully-async equivalent of Miles' sampling
        # wave. Keep enough read-ahead capacity for the requested oversampling
        # batch; the E2B semaphore still bounds live sandboxes.
        queue_capacity = max(args.prover_async_queue_size, self.sampling_batch_size)
        self.output_queue: queue.Queue = queue.Queue(maxsize=queue_capacity)
        self._failure: BaseException | None = None
        self.worker_thread: threading.Thread | None = None
        self.event_loop: asyncio.AbstractEventLoop | None = None
        self.state = GenerateState(args)
        self._next_group_id = 0
        self._pause_requested = threading.Event()
        self._idle = threading.Event()
        self._main_task = None
        self.warm_pool = None
        self.warming = False

    def _publish_failure(self, exc: BaseException) -> None:
        # The producer loop is the sole writer. Keep its first failure visible
        # to every observer, including lookups after this thread has exited.
        if self._failure is None:
            self._failure = exc
        self.running = False

    def _publish_result(self, group_id: int, result: list[Sample]) -> None:
        record = getattr(self.data_source, "record_completed", None)
        if callable(record):
            record(group_id, result)
        self.output_queue.put_nowait((group_id, result))

    def _recycle_inflight(self, group: list[Sample]) -> None:
        for sample in group:
            if sample.status not in (Sample.Status.COMPLETED, Sample.Status.TRUNCATED):
                sample.reset_for_retry()
        retry = getattr(self.data_source, "retry_inflight", None)
        if callable(retry):
            retry(group)
        else:
            self.data_source.add_samples([group])

    async def _cancel_for_pause(
        self,
        active: dict[asyncio.Task, tuple[int, list[Sample]]],
    ) -> None:
        pending = list(active.items())
        for task, _metadata in pending:
            if not task.done() and not task.cancelling():
                task.cancel()
        # stop() may cancel this loop after pause() times out. Keep that
        # cancellation from interrupting episode allocation/cleanup again;
        # the loop's finally block will await these same tasks to completion.
        results = await asyncio.shield(asyncio.gather(
            *(task for task, _metadata in pending), return_exceptions=True
        ))
        for (task, (group_id, group)), result in zip(pending, results, strict=True):
            active.pop(task, None)
            if isinstance(result, asyncio.CancelledError):
                self._recycle_inflight(group)
            elif isinstance(result, BaseException):
                self._publish_failure(result)
            else:
                completed_group_id, completed_group = result
                if completed_group_id != group_id:
                    self._publish_failure(RuntimeError("async group id changed in flight"))
                    continue
                self._publish_result(completed_group_id, completed_group)

    async def _loop(self) -> None:
        self.event_loop = asyncio.get_running_loop()
        self._main_task = asyncio.current_task()
        active: dict[asyncio.Task, tuple[int, list[Sample]]] = {}
        max_active = self.sampling_batch_size
        try:
            self.warming = True
            try:
                self.warm_pool = await start_warm_pool(self.args)
            finally:
                self.warming = False
            while self.running:
                done = {task for task in active if task.done()}
                for task in done:
                    group_id, _group = active.pop(task)
                    try:
                        completed_group_id, result = task.result()
                        if completed_group_id != group_id:
                            raise RuntimeError("async group id changed in flight")
                        self._publish_result(group_id, result)
                    except BaseException as exc:  # fatal: collector must not hang forever
                        self._publish_failure(exc)
                        break

                if self._pause_requested.is_set():
                    if active:
                        await self._cancel_for_pause(active)
                    self._idle.set()
                    await asyncio.sleep(0.01)
                    continue
                self._idle.clear()
                while (
                    self.running
                    and len(active) < max_active
                    and self.output_queue.qsize() + len(active) < self.output_queue.maxsize
                ):
                    groups = self.data_source.get_samples(1)
                    if len(groups) != 1:
                        raise RuntimeError(f"data source returned {len(groups)} groups; expected exactly 1")
                    group_id = self._next_group_id
                    self._next_group_id += 1

                    async def generate(gid, group):
                        result = await generate_and_rm_group(
                            self.args,
                            group,
                            sampling_params=self.state.sampling_params.copy(),
                            evaluation=False,
                        )
                        return gid, result

                    task = asyncio.create_task(generate(group_id, groups[0]))
                    active[task] = (group_id, groups[0])
                await asyncio.sleep(0.01)
        except BaseException as exc:
            if self.running:
                self._publish_failure(exc)
        finally:
            for task in active:
                if not task.done() and not task.cancelling():
                    task.cancel()
            cleanup = list(active)
            if self.warm_pool is not None:
                cleanup.append(self.warm_pool.close())
            if cleanup:
                await asyncio.gather(*cleanup, return_exceptions=True)

    def start(self) -> None:
        if self.worker_thread is None or not self.worker_thread.is_alive():
            self.running = True
            self.worker_thread = threading.Thread(
                target=lambda: asyncio.run(self._loop()),
                name="codeprover-async-rollout",
                daemon=True,
            )
            self.worker_thread.start()

    def stop(self) -> None:
        was_running = self.running
        self.running = False
        if self.worker_thread and self.worker_thread.is_alive():
            # Wake a worker that is still pre-filling. Its cancellation path
            # resolves in-flight allocations and destroys every owned instance.
            if was_running and self.event_loop is not None and self._main_task is not None:
                self.event_loop.call_soon_threadsafe(self._main_task.cancel)
            deadline = max(10, float(os.environ.get("E2B_CREATE_TIMEOUT_SEC", "120")) + 150)
            self.worker_thread.join(timeout=deadline)
            if self.worker_thread.is_alive():
                raise TimeoutError("async rollout cleanup exceeded its allocation and cleanup deadline")

    def raise_if_failed(self) -> None:
        if self._failure is not None:
            raise RuntimeError("Code-Prover async rollout worker failed") from self._failure

    def drain(self) -> list[tuple[int, list[Sample]]]:
        completed = []
        while True:
            try:
                completed.append(self.output_queue.get_nowait())
            except queue.Empty:
                return completed

    def pop_completed(self) -> tuple[int, list[Sample]] | None:
        try:
            return self.output_queue.get_nowait()
        except queue.Empty:
            return None

    def pause(self, timeout_sec: float) -> None:
        self._pause_requested.set()
        if not self._idle.wait(timeout=timeout_sec):
            raise TimeoutError(f"async rollout worker did not quiesce within {timeout_sec}s")
        self.raise_if_failed()

    def resume(self) -> None:
        self._idle.clear()
        self._pause_requested.clear()


def get_global_worker(args, data_source):
    global _global_worker
    with _worker_lock:
        if _global_worker is not None:
            _global_worker.raise_if_failed()
        if _global_worker is None or not _global_worker.worker_thread.is_alive():
            _global_worker = AsyncRolloutWorker(args, data_source)
            _global_worker.start()
        return _global_worker


def stop_global_worker() -> None:
    global _global_worker
    with _worker_lock:
        if _global_worker is not None:
            _global_worker.stop()
            _global_worker = None


def get_existing_worker(data_source):
    with _worker_lock:
        if _global_worker is None or _global_worker.data_source is not data_source:
            return None
        # A dead failed worker still owns an advanced data cursor. Treating it
        # as absent could save an incomplete snapshot or silently skip groups.
        _global_worker.raise_if_failed()
        if (_global_worker.worker_thread is not None
                and _global_worker.worker_thread.is_alive()):
            return _global_worker
        return None


async def generate_rollout_async(args, rollout_id: int, data_source):
    if not args.rollout_global_dataset:
        raise ValueError("Code-Prover fully async rollout requires the global dataset")
    configured = getattr(args, "prover_async_no_progress_timeout_sec", None)
    if configured is not None and configured <= 0:
        raise ValueError("no-progress timeout must be positive")
    if hasattr(args, "prover_wall_time_budget_sec"):
        from rl.generate_with_prover import effective_episode_timeout

        timeout = effective_episode_timeout(args)
        if timeout != args.prover_episode_timeout_sec:
            logger.info("extending episode timeout from %ss to %ss to cover verifier budget",
                        args.prover_episode_timeout_sec, timeout)
            args.prover_episode_timeout_sec = timeout
        configured = getattr(args, "prover_async_no_progress_timeout_sec", None)
        args.prover_async_no_progress_timeout_sec = max(configured or 0, timeout + 300)
    max_retries = getattr(args, "prover_async_max_group_retries", 2)
    fail_fast = getattr(args, "prover_async_max_consecutive_failures", 0)
    no_progress_timeout = getattr(args, "prover_async_no_progress_timeout_sec", None)
    if no_progress_timeout is None:
        no_progress_timeout = getattr(args, "prover_episode_timeout_sec", 2400) + 300
    if max_retries < 0 or fail_fast < 0 or no_progress_timeout <= 0:
        raise ValueError("retry limits must be nonnegative and no-progress timeout must be positive")
    version_timeout = await _preflight_weight_version(
        args, rollout_id, no_progress_timeout, worker=get_existing_worker(data_source),
    )
    worker = get_global_worker(args, data_source)
    target = args.rollout_batch_size
    accepted: list[list[Sample]] = []
    dynamic_filter = None
    if args.dynamic_sampling_filter_path is not None:
        from miles.utils.misc import load_function

        dynamic_filter = load_function(args.dynamic_sampling_filter_path)
    filtered_groups = 0
    raw_metrics = EpisodeMetrics()
    accepted_metrics = EpisodeMetrics()
    infrastructure_groups = 0
    retried_groups = 0
    exhausted_groups = 0
    stale_groups = 0
    consecutive_failures = 0
    last_progress = time.monotonic()
    first = True

    while len(accepted) < target:
        worker.raise_if_failed()
        # Failed, stale, or filtered groups must not keep a run alive
        # indefinitely without usable data, even when the queue stays full.
        # Warm-pool prefill has its own bounded deadline.
        if getattr(worker, "warming", False):
            last_progress = time.monotonic()
        if time.monotonic() - last_progress > no_progress_timeout:
            raise TimeoutError(
                f"no accepted async rollout group for {no_progress_timeout}s "
                f"(failed={infrastructure_groups}, exhausted={exhausted_groups}, "
                f"filtered={filtered_groups}, stale={stale_groups})"
            )
        completed = worker.pop_completed()
        if completed is None:
            await asyncio.sleep(0.05)
            continue
        group_id, group = completed
        if len(group) != args.n_samples_per_prompt:
            raise RuntimeError(
                f"async group {group_id} has {len(group)} samples; expected {args.n_samples_per_prompt}"
            )
        failed = any(s.status in (Sample.Status.FAILED, Sample.Status.ABORTED) for s in group)
        if failed:
            infrastructure_groups += 1
            logger.warning(
                "async group %s failed infrastructure checks: %s",
                group_id,
                [
                    {
                        "task": (s.metadata or {}).get("task_name"),
                        "sample_index": s.index,
                        "sandbox_id": (s.metadata or {}).get("sandbox_id"),
                        "phase": (s.metadata or {}).get("failure_phase"),
                        "operation": (s.metadata or {}).get("failure_operation"),
                        "type": (s.metadata or {}).get("failure_type"),
                        "detail": (s.metadata or {}).get("failure_detail"),
                    }
                    for s in group
                ],
            )
            # Metadata survives resets and checkpoint reload; worker group IDs
            # change each time a buffered group is resubmitted.
            retries = max((s.metadata or {}).get("infrastructure_retries", 0) for s in group)
            if retries >= max_retries:
                discard = getattr(data_source, "discard_completed", None)
                if callable(discard):
                    discard(group_id)
                exhausted_groups += 1
                logger.warning("discarding async group %s after %s infrastructure retries", group_id, retries)
            else:
                for sample in group:
                    if sample.status in (Sample.Status.FAILED, Sample.Status.ABORTED):
                        sample.reset_for_retry()
                    sample.metadata = {**(sample.metadata or {}), "infrastructure_retries": retries + 1}
                retry = getattr(data_source, "retry_completed", None)
                if callable(retry):
                    retry(group_id, group)
                else:
                    data_source.add_samples([group])
                retried_groups += 1
                logger.info("retrying async group %s attempt=%s/%s", group_id, retries + 1, max_retries)
            consecutive_failures += 1
            if fail_fast and consecutive_failures >= fail_fast:
                raise RuntimeError(
                    f"{consecutive_failures} consecutive async groups failed infrastructure checks"
                )
            continue

        # A healthy but homogeneous reward group still breaks an infrastructure
        # failure streak, even though it carries no policy-gradient signal.
        consecutive_failures = 0
        max_staleness = getattr(args, "max_weight_staleness", None)
        oldest = _group_weight_version(
            group, getattr(args, "update_weights_interval", 1),
            getattr(args, "start_rollout_id", 0),
        )
        if max_staleness is not None:
            from rl.generate_with_prover import weight_version_origin

            current = await _wait_for_weight_version(
                args, min(version_timeout, max(0.0, no_progress_timeout - (time.monotonic() - last_progress))),
                worker=worker,
            )
            current += weight_version_origin(args)
            # Missing provenance includes pre-fix checkpoints. Never infer a
            # cross-process age from their local counters, or accept the future.
            if oldest is None or current < oldest or current - oldest > max_staleness:
                stale_groups += 1
                logger.warning("discarding stale async group %s", group_id)
                for sample in group:
                    sample.reset_for_retry()
                retry = getattr(data_source, "retry_completed", None)
                if callable(retry):
                    retry(group_id, group)
                else:
                    data_source.add_samples([group])
                continue

        raw_metrics.add_group(group)
        if dynamic_filter is not None:
            from miles.rollout.filter_hub.base_types import call_dynamic_filter

            filter_output = call_dynamic_filter(dynamic_filter, args, group)
            if not filter_output.keep:
                discard = getattr(data_source, "discard_completed", None)
                if callable(discard):
                    discard(group_id)
                filtered_groups += 1
                logger.info(
                    "discarding async group %s via dynamic filter (reason=%s, dropped=%s)",
                    group_id,
                    filter_output.reason,
                    filtered_groups,
                )
                continue

        accept = getattr(data_source, "record_accepted", None)
        if callable(accept):
            accept(rollout_id, group_id)
        accepted.append(group)
        accepted_metrics.add_group(group)
        last_progress = time.monotonic()
        if first:
            sample = group[0]
            logger.info(
                "First rollout sample: %s label=%s reward=%s",
                _sample_preview(sample),
                str(sample.label)[:100],
                sample.reward,
            )
            first = False

    accepted.sort(key=lambda group: group[0].index)
    if rollout_id + 1 >= args.num_rollout:
        # No later rollout can consume read-ahead. Quiesce first so every
        # fetched group is recycled or recorded for the final checkpoint,
        # then stop the worker instead of spending E2B calls during training.
        worker.pause(timeout_sec=float(args.prover_async_pause_timeout_sec))
        worker.stop()
        logger.info("stopped async rollout worker after final rollout %s", rollout_id)
    sample = accepted[-1][0]
    logger.info(
        "Finish rollout %s: %s label=%s reward=%s filtered_groups=%s",
        rollout_id,
        _sample_preview(sample),
        str(sample.label)[:100],
        sample.reward,
        filtered_groups,
    )
    metrics = raw_metrics.summarize("sampling/raw")
    metrics.update(accepted_metrics.summarize("sampling/accepted"))
    metrics.update({
        "sampling/accepted_group_fraction": len(accepted) / raw_metrics.counts["groups"],
        "sampling/filtered_groups": filtered_groups,
        "sampling/infrastructure_failed_groups": infrastructure_groups,
        "sampling/infrastructure_retried_groups": retried_groups,
        "sampling/infrastructure_exhausted_groups": exhausted_groups,
        "sampling/stale_groups": stale_groups,
    })
    if getattr(worker, "warm_pool", None) is not None:
        metrics.update(worker.warm_pool.metrics())
    return RolloutFnTrainOutput(samples=accepted, metrics=metrics)


def generate_rollout_fully_async(args, rollout_id, data_source, evaluation=False):
    if evaluation:
        raise ValueError("evaluation is not supported by Code-Prover fully async rollout")
    try:
        return run(generate_rollout_async(args, rollout_id, data_source))
    except BaseException:
        # Ray propagates a failed generate() without necessarily disposing this
        # actor. Stop admission and reclaim its pool before handing back failure.
        logger.exception("async rollout %s failed; stopping sampler and reclaiming sandboxes", rollout_id)
        try:
            stop_global_worker()
        except Exception:
            logger.exception("async rollout cleanup also failed; preserving original error")
        raise


generate_rollout_fully_async.add_arguments = add_arguments
atexit.register(stop_global_worker)
