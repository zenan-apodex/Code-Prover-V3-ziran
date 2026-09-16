"""Checkpoint the fully-async read-ahead queue together with dataset cursors."""

from __future__ import annotations

import os
import logging
import threading
from pathlib import Path
from typing import TYPE_CHECKING

import torch
from miles.rollout.data_source import RolloutDataSourceWithBuffer

if TYPE_CHECKING:
    from miles.utils.types import Sample

logger = logging.getLogger(__name__)


class PersistentRolloutDataSource(RolloutDataSourceWithBuffer):
    """Quiesce prefetch and persist every fetched-but-untrained group on save."""

    def __init__(self, args):
        # This campaign is text-only. Qwen 3.5 nevertheless exposes an
        # AutoProcessor, and Miles' prompt-length filter currently feeds the
        # already-rendered string back into qwen_vl_utils as a conversation.
        # Skip only that eager filter while the base datasource is built; the
        # original context limit remains available to the rollout engine.
        had_max_prompt_len = hasattr(args, "rollout_max_prompt_len")
        max_prompt_len = getattr(args, "rollout_max_prompt_len", None)
        if had_max_prompt_len:
            args.rollout_max_prompt_len = None
        try:
            super().__init__(args)
        finally:
            if had_max_prompt_len:
                args.rollout_max_prompt_len = max_prompt_len
        self._checkpoint_lock = threading.Lock()
        self._uncommitted: dict[int, list[Sample]] = {}
        self._rollout_groups: dict[int, set[int]] = {}

    def record_completed(self, group_id: int, group: list[Sample]) -> None:
        with self._checkpoint_lock:
            self._uncommitted[group_id] = group

    def record_accepted(self, rollout_id: int, group_id: int) -> None:
        with self._checkpoint_lock:
            if group_id not in self._uncommitted:
                raise RuntimeError(f"async group {group_id} was accepted before completion")
            self._rollout_groups.setdefault(rollout_id, set()).add(group_id)

    def discard_completed(self, group_id: int) -> None:
        with self._checkpoint_lock:
            self._uncommitted.pop(group_id, None)

    def retry_completed(self, group_id: int, group: list[Sample]) -> None:
        """Atomically move a failed/stale result back to the input buffer."""
        with self._checkpoint_lock:
            self._uncommitted.pop(group_id, None)
            self.buffer.append(group)

    def retry_inflight(self, group: list[Sample]) -> None:
        """Return a canceled read-ahead group before taking a checkpoint."""
        with self._checkpoint_lock:
            self.buffer.append(group)

    @staticmethod
    def _buffer_path(root: str, rollout_id: int) -> Path:
        return Path(root) / "rollout" / f"codeprover_buffer_{rollout_id}.pt"

    def save(self, rollout_id):
        from rl.fully_async_rollout import stop_global_worker

        try:
            self._save_checkpoint(rollout_id)
        except BaseException:
            # Miles propagates save failures without disposing RolloutManager.
            # End admission and reclaim sandboxes before returning that error.
            logger.exception("async checkpoint %s failed; stopping sampler", rollout_id)
            try:
                stop_global_worker()
            except Exception:
                logger.exception("checkpoint cleanup also failed; preserving original error")
            raise

    def _save_checkpoint(self, rollout_id):
        from rl.fully_async_rollout import get_existing_worker

        worker = get_existing_worker(self)
        if worker is not None:
            worker.pause(
                timeout_sec=float(self.args.prover_async_pause_timeout_sec)
            )
        with self._checkpoint_lock:
            committed_ids = {
                group_id
                for accepted_rollout, group_ids in self._rollout_groups.items()
                if accepted_rollout <= rollout_id
                for group_id in group_ids
            }
            for group_id in committed_ids:
                self._uncommitted.pop(group_id, None)
            self._rollout_groups = {
                accepted_rollout: group_ids
                for accepted_rollout, group_ids in self._rollout_groups.items()
                if accepted_rollout > rollout_id
            }
            checkpoint_buffer = [*self.buffer, *self._uncommitted.values()]
        path = self._buffer_path(self.args.save, rollout_id)
        path.parent.mkdir(parents=True, exist_ok=True)
        temporary = path.with_name(f"{path.name}.tmp.{os.getpid()}")
        torch.save(checkpoint_buffer, temporary)
        os.replace(temporary, path)
        # Publish the cursor only after the read-ahead snapshot. A crash
        # between the two can replay data, but cannot skip fetched data.
        super().save(rollout_id)
        if worker is not None:
            worker.resume()

    def load(self, rollout_id=None):
        # RolloutManager is created before the training actor resolves resume
        # step. Its shared args must receive that resolved value via load().
        if getattr(self.args, "start_rollout_id", None) is None and rollout_id is not None:
            self.args.start_rollout_id = rollout_id + 1
        if getattr(self.args, "prover_reset_rollout_data_state", False):
            self.buffer = []
            logger.info(
                "starting the new prompt shard with fresh data cursors at rollout %s",
                rollout_id,
            )
            return
        if rollout_id is None or self.args.load is None:
            super().load(rollout_id)
            return
        path = self._buffer_path(self.args.load, rollout_id)
        if rollout_id >= 0:
            if not path.is_file():
                raise FileNotFoundError(
                    f"missing sampling checkpoint: {path}; resume a complete checkpoint "
                    "or explicitly set --prover-reset-rollout-data-state"
                )
            if getattr(self.args, "rollout_global_dataset", False):
                cursor = path.parent / f"global_dataset_state_dict_{rollout_id}.pt"
                if not cursor.is_file():
                    raise FileNotFoundError(f"missing sampling checkpoint cursor: {cursor}")
        super().load(rollout_id)
        if path.is_file():
            self.buffer = torch.load(path, weights_only=False)
