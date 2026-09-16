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
import importlib.metadata
import json
import math
import logging
import random
import weakref
import os
import shlex
import stat
import time
import uuid
from pathlib import Path
from typing import Any
from urllib.parse import urlsplit

from rl.errors import safe_failure_detail
from rl.diagnostics import failure_context, operation

try:
    from tools.prover_common import DOCKER_IMAGE_PUBLIC as DEFAULT_DOCKER_IMAGE
except ImportError:  # rollout container without the repo root on sys.path
    DEFAULT_DOCKER_IMAGE = "lizenan1995/code-prover-lean:latest"
DEFAULT_EXEC_TIMEOUT = 300
E2B_SDK_VERSION = "2.34.0"
ENVD_KEEPALIVE_EXPIRY_SEC = 5.0
SAFE_OPERATION_ATTEMPTS = 3
SAFE_OPERATION_TIMEOUT_SEC = 120
_OWNS_ENVD_TRANSPORT_ATTR = "_code_prover_owns_envd_transport"
logger = logging.getLogger(__name__)
_creation_semaphores = weakref.WeakKeyDictionary()


def _creation_semaphore() -> asyncio.Semaphore:
    # A checkpoint can restart hundreds of episodes together. Limit allocation
    # and bootstrap separately from the number of already-running episodes.
    loop = asyncio.get_running_loop()
    if loop not in _creation_semaphores:
        limit = int(os.environ.get("E2B_CREATE_CONCURRENCY", "8"))
        if limit < 1:
            raise ValueError("E2B_CREATE_CONCURRENCY must be positive")
        _creation_semaphores[loop] = asyncio.Semaphore(limit)
    return _creation_semaphores[loop]


def e2b_connection_env(api_url: str = "", domain: str = "", provider: str = "") -> dict[str, str]:
    """Resolve an E2B-compatible service without mixing control and sandbox hosts."""
    if bool(api_url) != bool(domain):
        raise ValueError("E2B_API_URL and E2B_DOMAIN must be configured together")
    if not api_url:
        api_url, domain = "https://api.e2b.app", "e2b.app"
    parsed = urlsplit(api_url)
    if (parsed.scheme != "https" or not parsed.hostname or parsed.username
            or parsed.password or parsed.query or parsed.fragment
            or parsed.path not in ("", "/")):
        raise ValueError("E2B_API_URL must be an HTTPS origin without credentials")
    if not domain or any(ch.isspace() for ch in domain) or any(ch in domain for ch in "/:@?#"):
        raise ValueError("E2B_DOMAIN must be a hostname without scheme or path")
    if (parsed.hostname.endswith(".e2b.fc.aliyuncs.com")
            or domain.endswith(".e2b.fc.aliyuncs.com")):
        if parsed.hostname != "api." + domain:
            raise ValueError("Alibaba FC E2B API URL and sandbox domain must use the same region")
    result = {"E2B_API_URL": api_url.rstrip("/"), "E2B_DOMAIN": domain}
    if provider:
        if provider != "aliyun":
            raise ValueError("E2B_SANDBOX_PROVIDER currently supports aliyun")
        if domain == "e2b.app":
            raise ValueError("provider routing requires a custom E2B gateway")
        result["E2B_SANDBOX_PROVIDER"] = provider
    return result


def e2b_api_options() -> dict[str, Any]:
    """Pass provider routing to SDK control-plane calls and instance cleanup."""
    settings = e2b_connection_env(
        os.environ.get("E2B_API_URL", ""), os.environ.get("E2B_DOMAIN", ""),
        os.environ.get("E2B_SANDBOX_PROVIDER", ""),
    )
    options = {"api_url": settings["E2B_API_URL"], "domain": settings["E2B_DOMAIN"]}
    if provider := settings.get("E2B_SANDBOX_PROVIDER"):
        options["api_headers"] = {"X-Sandbox-Provider": provider}
    return options


def e2b_creation_options(metadata: dict | None = None) -> dict[str, Any]:
    extra = json.loads(os.environ.get("E2B_CREATE_METADATA_JSON", "{}"))
    if not isinstance(extra, dict) or any(
        not isinstance(k, str) or not isinstance(v, str) for k, v in extra.items()
    ):
        raise ValueError("E2B_CREATE_METADATA_JSON must contain string metadata values")
    options = {"metadata": {**extra, **(metadata or {"purpose": "prover-rl"})}}
    profile = os.environ.get("E2B_BOOTSTRAP_PROFILE", "prover")
    if profile == "lean-base":
        options["envs"] = {
            "ELAN_HOME": "/root/.elan",
            "PATH": "/root/.elan/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        }
    elif profile != "prover":
        raise ValueError("E2B_BOOTSTRAP_PROFILE must be prover or lean-base")
    return options


def load_e2b_api_key() -> None:
    """Load a staged key without placing the secret in a job body or argv."""
    os.environ.update(e2b_connection_env(
        os.environ.get("E2B_API_URL", ""), os.environ.get("E2B_DOMAIN", ""),
        os.environ.get("E2B_SANDBOX_PROVIDER", ""),
    ))
    key_file = os.environ.get("E2B_API_KEY_FILE")
    if not key_file:
        if os.environ.get("E2B_API_KEY"):
            raise RuntimeError("raw E2B_API_KEY is forbidden; provide E2B_API_KEY_FILE")
        raise RuntimeError("E2B sandbox backend requires E2B_API_KEY_FILE")
    path = Path(key_file)
    if not path.is_absolute() or "\x00" in key_file:
        raise RuntimeError("E2B_API_KEY_FILE must be an absolute path")
    flags = os.O_RDONLY | os.O_CLOEXEC | getattr(os, "O_NOFOLLOW", 0)
    try:
        descriptor = os.open(path, flags)
    except OSError as exc:
        raise RuntimeError(
            "E2B_API_KEY_FILE must be a readable regular non-symlink file"
        ) from exc
    try:
        info = os.fstat(descriptor)
        if not stat.S_ISREG(info.st_mode):
            raise RuntimeError("E2B_API_KEY_FILE must be a regular file")
        if stat.S_IMODE(info.st_mode) != 0o600 or info.st_uid != os.geteuid():
            raise RuntimeError("E2B_API_KEY_FILE must be owner-owned with mode 0600")
        payload = os.read(descriptor, 16_385)
    finally:
        os.close(descriptor)
    if len(payload) > 16_384:
        raise RuntimeError("E2B_API_KEY_FILE is unexpectedly large")
    try:
        value = payload.decode("utf-8").strip()
    except UnicodeDecodeError as exc:
        raise RuntimeError("E2B_API_KEY_FILE must contain UTF-8 text") from exc
    if not value or any(ch.isspace() for ch in value):
        raise RuntimeError("E2B_API_KEY_FILE does not contain one valid key")
    os.environ["E2B_API_KEY"] = value


def _new_isolated_envd_transport(config: Any, http2: bool = True) -> Any:
    """Construct an envd transport owned by exactly one E2B sandbox."""
    import httpx
    from e2b.api import connection_retries, limits
    from e2b.api.client_async import AsyncEnvdTransportWithLogger

    # SG closes idle envd connections after about 15 seconds. The SDK's
    # 300-second default can reuse a half-closed HTTP/2 connection and fail
    # with BrokenPipeError/WriteError. Expire idle connections before that
    # boundary, including gaps between tools within an active episode.
    # Active command streams have no idle expiry and remain connected.
    envd_limits = httpx.Limits(
        max_connections=limits.max_connections,
        max_keepalive_connections=limits.max_keepalive_connections,
        keepalive_expiry=ENVD_KEEPALIVE_EXPIRY_SEC,
    )
    return AsyncEnvdTransportWithLogger(
        limits=envd_limits,
        proxy=config.proxy,
        http2=http2,
        retries=connection_retries,
    )


def _configure_envd_client(instance: Any) -> None:
    """Wire every SDK surface to the same newly owned command/file transport."""
    import httpx
    from e2b.api import make_async_logging_event_hooks
    from e2b.sandbox_async.commands.command import Commands
    from e2b.sandbox_async.commands.pty import Pty
    from e2b.sandbox_async.filesystem.filesystem import Filesystem
    from e2b.sandbox_async.git import Git

    instance._transport = _new_isolated_envd_transport(instance.connection_config)
    instance._envd_api = httpx.AsyncClient(
        base_url=instance.envd_api_url,
        transport=instance._transport,
        headers=instance.connection_config.sandbox_headers,
        event_hooks=make_async_logging_event_hooks(instance.connection_config.logger),
    )
    instance._filesystem = Filesystem(
        instance.envd_api_url,
        instance._envd_version,
        instance.connection_config,
        instance._transport.pool,
        instance._envd_api,
    )
    instance._commands = Commands(
        instance.envd_api_url,
        instance.connection_config,
        instance._transport.pool,
        instance._envd_version,
        instance._envd_api,
    )
    instance._pty = Pty(
        instance.envd_api_url,
        instance.connection_config,
        instance._transport.pool,
        instance._envd_version,
        instance._envd_api,
    )
    instance._git = Git(instance._commands)


def _isolated_async_sandbox_class(base_class: Any) -> Any:
    """Pin the E2B 2.34 constructor while replacing its cached transport."""

    def _init(instance: Any, **opts: Any) -> None:
        # E2B 2.34's AsyncSandbox constructor obtains a process-cached envd
        # transport. Skip only that constructor and reproduce its pinned
        # wiring with a per-instance transport.
        super(base_class, instance).__init__(**opts)
        _configure_envd_client(instance)

    return type("CodeProverIsolatedAsyncSandbox", (base_class,), {"__init__": _init})


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



def _is_transient_transport_error(exc: Exception) -> bool:
    import httpx
    import httpcore

    seen = set()
    current = exc
    while current is not None and id(current) not in seen:
        seen.add(id(current))
        if isinstance(current, (httpx.TransportError, httpcore.NetworkError,
                                httpcore.TimeoutException, httpcore.RemoteProtocolError,
                                ConnectionError)):
            return True
        current = current.__cause__ or (
            current.__context__ if not current.__suppress_context__ else None
        )
    return False


class SandboxOperationTimeout(RuntimeError):
    """A safe sandbox operation exhausted its own deadline, not the episode's."""


class E2BSandbox:
    """One E2B cloud sandbox per episode.

    ``template`` must be a prebuilt E2B template whose image is the
    code-prover-lean base (a single generic template — task files are
    uploaded per episode, so no per-task templates are needed).
    """

    def __init__(self, sbx):
        self._sbx = sbx

    async def _reset_envd_connection(self) -> None:
        # Only private instance transports may be closed. Never kill/recreate
        # the sandbox here: its task files must survive a transport retry.
        if not getattr(self._sbx, _OWNS_ENVD_TRANSPORT_ATTR, False):
            raise RuntimeError("cannot reset an unowned E2B transport")
        await asyncio.wait_for(self._sbx._envd_api.aclose(), timeout=10)
        _configure_envd_client(self._sbx)

    async def _retry_safe_operation(self, name, call):
        with operation(name):
            # This deadline includes reconnects and backoff, not just one try.
            deadline = asyncio.timeout(SAFE_OPERATION_TIMEOUT_SEC)
            try:
                async with deadline:
                    for attempt in range(1, SAFE_OPERATION_ATTEMPTS + 1):
                        try:
                            return await call()
                        except Exception as exc:
                            transient = _is_transient_transport_error(exc)
                            logger.warning(
                                "E2B operation failed sandbox_id=%s operation=%s attempt=%s/%s "
                                "retryable=%s context=%s detail=%s",
                                getattr(self._sbx, "sandbox_id", None), name,
                                attempt, SAFE_OPERATION_ATTEMPTS, transient,
                                json.dumps(failure_context()), safe_failure_detail(exc, limit=None),
                            )
                            if not transient or attempt == SAFE_OPERATION_ATTEMPTS:
                                raise
                            await self._reset_envd_connection()
                            await asyncio.sleep(2 ** (attempt - 1) + random.random())
            except TimeoutError as exc:
                detail = (f"exceeded {SAFE_OPERATION_TIMEOUT_SEC}s" if deadline.expired()
                          else "request or reconnect timed out")
                raise SandboxOperationTimeout(f"{name} {detail}") from exc

    async def renew(self, timeout: int) -> None:
        """Give an idle or newly acquired sandbox a fresh execution lifetime."""
        await asyncio.wait_for(
            self._sbx.set_timeout(timeout, request_timeout=30), timeout=35,
        )

    @classmethod
    async def create(
        cls,
        template: str,
        timeout: int = 3600,
        metadata: dict | None = None,
        create_attempts: int = 3,
        create_timeout_sec: float = 120,
    ) -> "E2BSandbox":
        if not template:
            raise ValueError("E2B sandbox backend requires a non-empty template")
        load_e2b_api_key()
        create_options = e2b_creation_options(metadata)
        create_timeout_sec = float(os.environ.get("E2B_CREATE_TIMEOUT_SEC", create_timeout_sec))
        if not math.isfinite(create_timeout_sec) or create_timeout_sec <= 0:
            raise ValueError("E2B_CREATE_TIMEOUT_SEC must be positive and finite")
        actual_version = importlib.metadata.version("e2b")
        if actual_version != E2B_SDK_VERSION:
            raise RuntimeError(
                f"E2B sandbox backend requires e2b=={E2B_SDK_VERSION}; found {actual_version}"
            )
        from e2b import AsyncSandbox

        isolated_sandbox_class = _isolated_async_sandbox_class(AsyncSandbox)

        last_error: Exception | None = None
        attempts = max(1, create_attempts)
        async with _creation_semaphore():
            for attempt in range(1, attempts + 1):
                wrapper = None
                attempt_started = time.monotonic()
                phase = "allocation"
                try:
                    allocation = asyncio.create_task(asyncio.wait_for(
                        isolated_sandbox_class.create(
                            template=template,
                            timeout=timeout,
                            **create_options,
                            **e2b_api_options(),
                            request_timeout=create_timeout_sec,
                        ),
                        timeout=create_timeout_sec,
                    ))
                    try:
                        sbx = await asyncio.shield(allocation)
                    except asyncio.CancelledError:
                        # The API may already have allocated a sandbox. Resolve
                        # the bounded request and reclaim it before checkpointing.
                        try:
                            sbx = await allocation
                        except Exception:
                            pass
                        else:
                            setattr(sbx, _OWNS_ENVD_TRANSPORT_ATTR, True)
                            await cls(sbx).close()
                        raise
                    setattr(sbx, _OWNS_ENVD_TRANSPORT_ATTR, True)
                    wrapper = cls(sbx)
                    phase = "bootstrap"
                    if os.environ.get("E2B_BOOTSTRAP_PROFILE", "prover") == "lean-base":
                        # The immutable Lean image already contains /task and its
                        # prebuilt packages. Only initialize writable task dirs and
                        # allow the sandbox user to read the root-owned toolchain.
                        bootstrap = await wrapper.exec(
                            "chmod a+x /root"
                            " && install -d -m 0777 /task /task/.lake /tests /logs /agents"
                            " && for d in /task/.lake/packages/*; do"
                            " git config --system --add safe.directory \"$d\"; done",
                            timeout_sec=120, user="root",
                        )
                    else:
                        bootstrap = await wrapper.exec(
                            "sudo install -d -m 0755 -o $(id -u) -g $(id -g) /task /tests /logs /agents"
                            " && cp -a /opt/code-prover/prover/. /task/",
                            timeout_sec=120,
                        )
                    if bootstrap.return_code != 0:
                        raise RuntimeError(f"E2B workspace bootstrap failed: {bootstrap.stderr[:500]}")
                    return wrapper
                except BaseException as exc:
                    if isinstance(exc, Exception):
                        logger.warning(
                            "E2B create failed phase=%s sandbox_id=%s task=%s sample_index=%s "
                            "attempt=%s/%s duration_sec=%.3f detail=%s",
                            phase, getattr(getattr(wrapper, "_sbx", None), "sandbox_id", None),
                            (metadata or {}).get("task_name"), (metadata or {}).get("sample_index"),
                            attempt, attempts, time.monotonic() - attempt_started,
                            safe_failure_detail(exc, limit=None),
                        )
                    if wrapper is not None:
                        await wrapper.close()
                    if not isinstance(exc, Exception):
                        raise
                    last_error = exc
                    if attempt < attempts:
                        await asyncio.sleep(min(8.0, float(2 ** (attempt - 1))) + random.random())
        raise RuntimeError(f"E2B sandbox allocation failed after {attempts} attempts") from last_error

    async def exec(self, command: str, timeout_sec: float | None = None, *, user: str | None = None) -> ExecResult:
        try:
            options = {"user": user} if user is not None else {}
            with operation("envd.exec"):
                r = await self._sbx.commands.run(
                    command, timeout=int(timeout_sec or DEFAULT_EXEC_TIMEOUT), **options
                )
            return ExecResult(r.stdout or "", r.stderr or "", r.exit_code or 0)
        except Exception as exc:  # noqa: BLE001 — command errors carry exit info
            if "sandbox was not found" in str(exc).lower():
                raise SandboxLostError(safe_failure_detail(exc, limit=300)) from exc
            # Preserve normal command exits, but log transport diagnostics even
            # when the agent consumes the error as tool feedback. Do not replay.
            if not hasattr(exc, "exit_code"):
                logger.warning(
                    "E2B command request failed sandbox_id=%s context=%s detail=%s",
                    getattr(self._sbx, "sandbox_id", None), json.dumps(failure_context()),
                    safe_failure_detail(exc, limit=None),
                )
            exit_code = getattr(exc, "exit_code", 1)
            stderr = getattr(exc, "stderr", "") or safe_failure_detail(exc, limit=4000)
            stdout = getattr(exc, "stdout", "") or ""
            return ExecResult(stdout, stderr[:4000], exit_code if isinstance(exit_code, int) else 1)

    async def upload_file(self, source_path: Path | str, target_path: str) -> None:
        # Read once: every retry overwrites the same path with identical bytes.
        data = Path(source_path).read_bytes()
        parent = str(Path(target_path).parent)
        result = await self._retry_safe_operation(
            "envd.mkdir",
            lambda: self._sbx.commands.run(f"mkdir -p {shlex.quote(parent)}", timeout=60),
        )
        if result.exit_code:
            raise RuntimeError(f"E2B mkdir failed: {result.stderr[:500]}")
        await self._retry_safe_operation(
            "envd.files.write", lambda: self._sbx.files.write(target_path, data),
        )

    async def close(self) -> None:
        for attempt in range(3):
            try:
                await asyncio.wait_for(self._sbx.kill(), timeout=30)
                break
            except Exception as exc:  # already-dead sandboxes return False
                if attempt == 2:
                    logger.warning("E2B sandbox cleanup failed sandbox_id=%s type=%s",
                                   getattr(self._sbx, "sandbox_id", "unknown"), type(exc).__name__)
                else:
                    await asyncio.sleep(1 + attempt)
        if getattr(self._sbx, _OWNS_ENVD_TRANSPORT_ATTR, False):
            setattr(self._sbx, _OWNS_ENVD_TRANSPORT_ATTR, False)
            close = getattr(getattr(self._sbx, "_envd_api", None), "aclose", None)
            if callable(close):
                try:
                    await asyncio.wait_for(close(), timeout=30)
                except Exception:  # noqa: BLE001 — sandbox lifetime is the final guard
                    pass


async def create_sandbox(backend: str, **kwargs):
    if backend == "docker":
        allowed = {"image", "cpus", "memory_gb"}
        return await DockerSandbox.create(**{k: v for k, v in kwargs.items() if k in allowed and v})
    if backend == "e2b":
        from rl.warm_pool import get_warm_pool

        pool = get_warm_pool()
        if pool is not None:
            return await pool.acquire(
                template=kwargs.get("template"), timeout=kwargs.get("timeout") or 3600,
                metadata=kwargs.get("metadata"),
            )
        allowed = {"template", "timeout", "metadata", "create_attempts", "create_timeout_sec"}
        values = {k: v for k, v in kwargs.items() if k in allowed and v is not None}
        return await E2BSandbox.create(**values)
    raise ValueError(f"unknown sandbox backend {backend!r} (expected docker|e2b)")
