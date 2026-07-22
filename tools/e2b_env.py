"""E2B environment that can pull the base image from a private registry.

Harbor's stock E2BEnvironment builds each task's template on E2B's cloud from
environment/Dockerfile; the E2B builder pulls the FROM image anonymously,
which fails against a private registry (Docker Hub private repo, ACR, ...).
The e2b SDK's build request does carry a template-level ``fromImageRegistry``
credential block, but only ``Template().from_image()`` exposes it — the
``from_dockerfile()`` path harbor uses does not. This subclass parses the
FROM image's registry host and injects matching credentials.

Credential lookup order:
  1. env vars REGISTRY_PULL_USERNAME / REGISTRY_PULL_PASSWORD
  2. ~/.docker/config.json auth for the FROM image's registry host
     (populated by docker login; Docker Hub is keyed as
     https://index.docker.io/v1/)

Usage (run config):
    environment:
      import_path: tools.e2b_env:ACRE2BEnvironment

Requires E2B_API_KEY. The FROM registry must be reachable from E2B's cloud
(public internet) — VPC-only endpoints won't work.

Generic-template mode (for large datasets):
    environment:
      import_path: tools.e2b_env:ACRE2BEnvironment
      generic_template: code-prover-lean-eval-4c8g
      override_cpus: 4
      override_memory_mb: 8192

Stock harbor builds ONE E2B TEMPLATE PER TASK (per-task Dockerfile), which is
unusable at 5k tasks/round. With ``generic_template`` set, every trial shares
that single template (built once from the task's FROM image if the alias is
missing) and the per-task files are delivered at sandbox start instead: the
task Dockerfile's COPY lines are replayed via upload_file. This matches the
RL path (rl/sandbox.py: one generic template + runtime task upload).
"""

from __future__ import annotations

import asyncio
import base64
import json
import os
import re
from pathlib import Path

from e2b import AsyncTemplate, Template
from tenacity import retry, stop_after_attempt, wait_exponential

from harbor.environments.e2b import E2BEnvironment

_COPY_RE = re.compile(r"^\s*COPY\s+(?!--)(\S+)\s+(\S+)\s*$", re.MULTILINE)

# One build per process even when many trials race the missing alias.
_GENERIC_BUILD_LOCK = asyncio.Lock()

# docker config.json auth keys to try for a given image registry host.
_DOCKER_HUB_KEYS = (
    "https://index.docker.io/v1/",
    "index.docker.io",
    "docker.io",
    "registry-1.docker.io",
)


def _image_registry_host(image_ref: str) -> str:
    """Registry host of an image reference, 'docker.io' for bare names."""
    first = image_ref.split("/", 1)[0]
    if "." in first or ":" in first or first == "localhost":
        return first
    return "docker.io"


def _docker_config_auth(host: str) -> tuple[str, str] | None:
    cfg = Path.home() / ".docker" / "config.json"
    try:
        auths = json.loads(cfg.read_text()).get("auths", {})
    except (OSError, ValueError):
        return None
    keys = _DOCKER_HUB_KEYS if host == "docker.io" else (host,)
    for key in keys:
        token = auths.get(key, {}).get("auth")
        if token:
            user, _, password = base64.b64decode(token).decode().partition(":")
            if user and password:
                return user, password
    return None


def _registry_credentials(image_ref: str | None) -> tuple[str, str] | None:
    user = os.environ.get("REGISTRY_PULL_USERNAME")
    password = os.environ.get("REGISTRY_PULL_PASSWORD")
    if user and password:
        return user, password
    if image_ref is None:
        return None
    return _docker_config_auth(_image_registry_host(image_ref))


class ACRE2BEnvironment(E2BEnvironment):
    def __init__(
        self,
        *args,
        generic_template: str | None = None,
        sandbox_timeout_sec: int | None = None,
        **kwargs,
    ):
        super().__init__(*args, **kwargs)
        self._generic_template = generic_template
        # Stock harbor hardcodes a 24h sandbox timeout; sandboxes bill while
        # they exist, so cap to just above agent+verifier budget instead.
        self._sandbox_timeout_sec = sandbox_timeout_sec
        if generic_template:
            self._template_name = generic_template

    async def start(self, force_build: bool):
        if not self._generic_template:
            return await super().start(force_build)

        async with _GENERIC_BUILD_LOCK:
            if force_build or not await self._does_template_exist():
                self.logger.info("Building generic template %s", self._template_name)
                await self._create_generic_template()

        await self._create_sandbox()
        if not self._sandbox:
            raise RuntimeError("Sandbox not found but was just created.")
        await self.ensure_dirs(self._mount_targets(writable_only=True))
        await self._upload_environment_dir_after_start()
        await self._replay_dockerfile_copies()

    async def _create_generic_template(self):
        """Build the shared template from the task's base (FROM) image only —
        per-task COPY lines are replayed at sandbox start instead."""
        base_ref = self.task_env_config.docker_image
        if not base_ref:
            dockerfile = self._environment_definition_path.read_text(encoding="utf-8")
            m = re.search(r"^FROM\s+(\S+)", dockerfile, re.MULTILINE)
            if not m:
                raise RuntimeError("generic_template: cannot determine FROM image")
            base_ref = m.group(1)
        template = Template().from_image(image=base_ref)
        creds = _registry_credentials(base_ref)
        if creds:
            template._registry_config = {
                "type": "registry", "username": creds[0], "password": creds[1],
            }
        build_kwargs = {}
        if self._effective_cpus is not None:
            build_kwargs["cpu_count"] = self._effective_cpus
        if self._effective_memory_mb is not None:
            build_kwargs["memory_mb"] = self._effective_memory_mb
        await AsyncTemplate.build(
            template=template, alias=self._template_name, **build_kwargs
        )

    async def _replay_dockerfile_copies(self):
        df = self._environment_definition_path
        if not df.is_file():
            return
        for src, dst in _COPY_RE.findall(df.read_text(encoding="utf-8")):
            target = dst if not dst.endswith("/") else dst + Path(src).name
            await self.exec(f"mkdir -p {Path(target).parent}")
            await self.upload_file(self.environment_dir / src, target)
            self.logger.debug("Replayed COPY %s -> %s", src, target)

    async def _create_sandbox(self):
        if self._sandbox_timeout_sec is None:
            await super()._create_sandbox()
        else:
            # Mirror of stock _create_sandbox with the timeout made
            # configurable (stock hardcodes 86_400).
            from e2b import AsyncSandbox
            from harbor.models.task.config import NetworkMode

            self._sandbox = await AsyncSandbox.create(
                template=self._template_name,
                metadata={
                    "environment_name": self.environment_name,
                    "session_id": self.session_id,
                },
                envs=self._startup_env(),
                timeout=self._sandbox_timeout_sec,
                allow_internet_access=(
                    self.network_policy.network_mode != NetworkMode.NO_NETWORK
                ),
                network=self._sandbox_create_network_options(),
            )
        # Log the sandbox ID so external terminations (e.g. by another system
        # sharing the E2B team) can be matched against provider audit logs.
        self.logger.info(
            "E2B sandbox created: %s (template %s)",
            self._sandbox.sandbox_id,
            self._template_name,
        )

    @retry(
        stop=stop_after_attempt(2),
        wait=wait_exponential(multiplier=1, min=1, max=10),
        reraise=True,
    )
    async def _create_template(self):
        if self.task_env_config.docker_image:
            base_ref = self.task_env_config.docker_image
            template = Template().from_image(image=base_ref)
        else:
            dockerfile = self._environment_definition_path.read_text(
                encoding="utf-8"
            )
            m = re.search(r"^FROM\s+(\S+)", dockerfile, re.MULTILINE)
            base_ref = m.group(1) if m else None
            template = Template(
                file_context_path=str(self.environment_dir),
            ).from_dockerfile(
                dockerfile_content_or_path=str(self._environment_definition_path),
            )

        creds = _registry_credentials(base_ref)
        if creds:
            # from_dockerfile() returns a TemplateBuilder wrapping the Template
            # whose serializer emits fromImageRegistry; there is no public API
            # to set it on that path, so reach into the wrapped object.
            inner = getattr(template, "_template", template)
            inner._registry_config = {
                "type": "registry",
                "username": creds[0],
                "password": creds[1],
            }
        else:
            self.logger.warning(
                "No registry credentials found for %s "
                "(REGISTRY_PULL_USERNAME/PASSWORD or docker login); "
                "E2B will pull the base image anonymously.",
                base_ref,
            )

        build_kwargs = {}
        if self._effective_cpus is not None:
            build_kwargs["cpu_count"] = self._effective_cpus
        if self._effective_memory_mb is not None:
            build_kwargs["memory_mb"] = self._effective_memory_mb
        await AsyncTemplate.build(
            template=template, alias=self._template_name, **build_kwargs
        )
