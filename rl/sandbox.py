"""Sandbox backends for RL rollouts.

The agent loop (agents/qwen_native_agent.py) touches its environment through
exactly two methods — ``exec(command, timeout_sec=...)`` and
``upload_file(source, target)`` — so RL rollouts don't need Harbor at all.
This module provides that surface over two backends:

  DockerSandbox  — local `docker run` per episode; for development and
                   single-node rollouts.
  E2BSandbox     — one E2B cloud sandbox per episode; for scaled rollouts.
                   Requires E2B_API_KEY and a prebuilt generic template
                   containing the code-prover-lean image.

Both are async and safe to drive from many concurrent episodes (each episode
owns its own sandbox instance).
"""

from __future__ import annotations

import asyncio
import dataclasses
import shlex
import uuid
from pathlib import Path

try:
    from tools.prover_common import DOCKER_IMAGE_PUBLIC as DEFAULT_DOCKER_IMAGE
except ImportError:  # rollout container without the repo root on sys.path
    DEFAULT_DOCKER_IMAGE = "lizenan1995/code-prover-lean:latest"
DEFAULT_EXEC_TIMEOUT = 300


@dataclasses.dataclass
class ExecResult:
    stdout: str
    stderr: str
    return_code: int


class SandboxLostError(RuntimeError):
    """The sandbox died under us (external kill / TTL). The episode cannot
    produce a valid reward — callers must ABORT the sample, never grade it."""


class DockerSandbox:
    """One throwaway local docker container, `docker exec` per tool call."""

    def __init__(self, container_id: str):
        self._cid = container_id

    @classmethod
    async def create(
        cls,
        image: str = DEFAULT_DOCKER_IMAGE,
        cpus: float | None = None,
        memory_gb: float | None = None,
    ) -> "DockerSandbox":
        name = f"prover-rl-{uuid.uuid4().hex[:12]}"
        cmd = ["docker", "run", "-d", "--rm", "--name", name]
        if cpus:
            cmd += [f"--cpus={cpus}"]
        if memory_gb:
            cmd += [f"--memory={memory_gb}g"]
        cmd += [image, "sleep", "infinity"]
        proc = await asyncio.create_subprocess_exec(
            *cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE
        )
        out, err = await proc.communicate()
        if proc.returncode:
            raise RuntimeError(f"docker run failed: {err.decode()[:500]}")
        return cls(out.decode().strip())

    async def exec(self, command: str, timeout_sec: float | None = None) -> ExecResult:
        proc = await asyncio.create_subprocess_exec(
            "docker", "exec", self._cid, "bash", "-lc", command,
            stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE,
        )
        try:
            out, err = await asyncio.wait_for(
                proc.communicate(), timeout=timeout_sec or DEFAULT_EXEC_TIMEOUT
            )
        except asyncio.TimeoutError:
            proc.kill()
            return ExecResult("", f"[timeout after {timeout_sec or DEFAULT_EXEC_TIMEOUT}s]", 124)
        return ExecResult(out.decode(errors="replace"), err.decode(errors="replace"),
                          proc.returncode or 0)

    async def upload_file(self, source_path: Path | str, target_path: str) -> None:
        parent = str(Path(target_path).parent)
        await self.exec(f"mkdir -p {shlex.quote(parent)}")
        proc = await asyncio.create_subprocess_exec(
            "docker", "cp", str(source_path), f"{self._cid}:{target_path}",
            stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE,
        )
        _, err = await proc.communicate()
        if proc.returncode:
            raise RuntimeError(f"docker cp failed: {err.decode()[:500]}")

    async def close(self) -> None:
        proc = await asyncio.create_subprocess_exec(
            "docker", "rm", "-f", self._cid,
            stdout=asyncio.subprocess.DEVNULL, stderr=asyncio.subprocess.DEVNULL,
        )
        await proc.communicate()


class E2BSandbox:
    """One E2B cloud sandbox per episode.

    ``template`` must be a prebuilt E2B template whose image is the
    code-prover-lean base (a single generic template — task files are
    uploaded per episode, so no per-task templates are needed).
    """

    def __init__(self, sbx):
        self._sbx = sbx

    @classmethod
    async def create(
        cls,
        template: str,
        timeout: int = 3600,
        metadata: dict | None = None,
    ) -> "E2BSandbox":
        from e2b import AsyncSandbox

        sbx = await AsyncSandbox.create(
            template=template, timeout=timeout, metadata=metadata or {"purpose": "prover-rl"}
        )
        return cls(sbx)

    async def exec(self, command: str, timeout_sec: float | None = None) -> ExecResult:
        try:
            # user="root": the lean toolchain lives in /root/.elan and E2B's
            # default user is `user` (no PATH, no /root access) — harbor's
            # eval E2BEnvironment also defaults to root. Without this every
            # lake/lean call fails instantly and episodes spin to max_turns.
            r = await self._sbx.commands.run(
                command, timeout=int(timeout_sec or DEFAULT_EXEC_TIMEOUT), user="root"
            )
            return ExecResult(r.stdout or "", r.stderr or "", r.exit_code or 0)
        except Exception as exc:  # noqa: BLE001 — command errors carry exit info
            # A dead sandbox must end the episode NOW (ABORTED), not feed the
            # model error tool-responses for the remaining turns and then get
            # graded to a bogus reward-0 (observed during the 07-22 team-wide
            # sandbox sweep).
            if "sandbox was not found" in str(exc).lower():
                raise SandboxLostError(str(exc)[:300]) from exc
            exit_code = getattr(exc, "exit_code", 1)
            stderr = getattr(exc, "stderr", "") or str(exc)
            stdout = getattr(exc, "stdout", "") or ""
            return ExecResult(stdout, stderr[:4000], exit_code if isinstance(exit_code, int) else 1)

    async def upload_file(self, source_path: Path | str, target_path: str) -> None:
        data = Path(source_path).read_bytes()
        await self._sbx.files.write(target_path, data, user="root")

    async def close(self) -> None:
        try:
            await self._sbx.kill()
        except Exception:  # noqa: BLE001 — already dead is fine
            pass


async def create_sandbox(backend: str, **kwargs):
    if backend == "docker":
        allowed = {"image", "cpus", "memory_gb"}
        return await DockerSandbox.create(**{k: v for k, v in kwargs.items() if k in allowed and v})
    if backend == "e2b":
        allowed = {"template", "timeout", "metadata"}
        return await E2BSandbox.create(**{k: v for k, v in kwargs.items() if k in allowed and v})
    raise ValueError(f"unknown sandbox backend {backend!r} (expected docker|e2b)")
