"""Per-episode context shared with its child tasks, without logging tool arguments."""
from __future__ import annotations

from contextlib import contextmanager
from contextvars import ContextVar
from dataclasses import dataclass, field
import time


@dataclass
class EpisodeDiagnostics:
    task_name: str
    sample_index: int | None
    sandbox_id: str | None = None
    phase: str = "sandbox_acquire"
    operation: str = ""
    turn: int | None = None
    tool: str | None = None
    phase_started: float = field(default_factory=time.monotonic)
    operation_started: float = field(default_factory=time.monotonic)

    def snapshot(self) -> dict:
        now = time.monotonic()
        return {
            "task_name": self.task_name,
            "sample_index": self.sample_index,
            "sandbox_id": self.sandbox_id,
            "failure_phase": self.phase,
            "failure_operation": self.operation,
            "failure_turn": self.turn,
            "failure_tool": self.tool,
            "failure_phase_elapsed_sec": round(now - self.phase_started, 3),
            "failure_operation_elapsed_sec": round(now - self.operation_started, 3),
        }


current_episode: ContextVar[EpisodeDiagnostics | None] = ContextVar("prover_episode", default=None)


def set_phase(phase: str, *, turn: int | None = None, tool: str | None = None) -> None:
    state = current_episode.get()
    if state is not None:
        state.phase, state.turn, state.tool = phase, turn, tool
        state.operation = ""
        state.phase_started = state.operation_started = time.monotonic()


@contextmanager
def operation(name: str):
    state = current_episode.get()
    if state is None:
        yield
        return
    previous = state.operation, state.operation_started
    state.operation, state.operation_started = name, time.monotonic()
    try:
        yield
    except BaseException:
        # Keep the innermost operation on errors/cancellation. asyncio.wait_for
        # cancels a child task, so its shared context remains readable by the
        # parent that reports EpisodeTimeout.
        raise
    else:
        state.operation, state.operation_started = previous


def failure_context() -> dict:
    state = current_episode.get()
    return state.snapshot() if state is not None else {}
