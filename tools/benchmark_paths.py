#!/usr/bin/env python3
"""Resolve local benchmark sources without committing workstation paths."""

from __future__ import annotations

import argparse
from collections.abc import Mapping
from dataclasses import dataclass
import os
from pathlib import Path
import re
import sys
import tomllib


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_REGISTRY = REPO_ROOT / "benchmarks/registry.toml"
DEFAULT_LOCAL_CONFIG = REPO_ROOT / "benchmarks.local.toml"
_ENVIRONMENT_NAME = re.compile(r"^[A-Z_][A-Z0-9_]*$")


class BenchmarkPathError(ValueError):
    """A benchmark source or registry entry is missing or invalid."""


@dataclass(frozen=True)
class BenchmarkSpec:
    name: str
    display_name: str
    source_key: str
    environment_variable: str
    default_view: Path


def _load_toml(path: Path, label: str) -> dict:
    try:
        with path.open("rb") as handle:
            payload = tomllib.load(handle)
    except FileNotFoundError as exc:
        raise BenchmarkPathError(f"{label} does not exist: {path}") from exc
    except tomllib.TOMLDecodeError as exc:
        raise BenchmarkPathError(f"cannot parse {label} {path}: {exc}") from exc
    # Defensive: tomllib currently always returns a dict.
    if not isinstance(payload, dict):
        raise BenchmarkPathError(f"{label} must contain a TOML table: {path}")
    return payload


def _required_string(table: Mapping[str, object], field: str, context: str) -> str:
    value = table.get(field)
    if not isinstance(value, str) or not value.strip():
        raise BenchmarkPathError(f"{context}.{field} must be a non-empty string")
    return value


def load_registry(path: Path = DEFAULT_REGISTRY) -> dict[str, BenchmarkSpec]:
    """Load and validate the tracked, machine-independent benchmark registry."""

    path = Path(path)
    payload = _load_toml(path, "benchmark registry")
    if payload.get("schema_version") != 1:
        raise BenchmarkPathError(f"unsupported benchmark registry schema in {path}")
    benchmarks = payload.get("benchmarks")
    if not isinstance(benchmarks, dict) or not benchmarks:
        raise BenchmarkPathError(
            f"benchmark registry has no [benchmarks] entries: {path}"
        )

    specs: dict[str, BenchmarkSpec] = {}
    for name, raw in benchmarks.items():
        context = f"benchmarks.{name}"
        if not isinstance(name, str) or not name or "/" in name:
            raise BenchmarkPathError(f"invalid benchmark name in {path}: {name!r}")
        if not isinstance(raw, dict):
            raise BenchmarkPathError(f"{context} must be a TOML table")
        display_name = _required_string(raw, "display_name", context)
        source_key = _required_string(raw, "source_key", context)
        if not re.fullmatch(r"[a-z][a-z0-9_]*", source_key):
            raise BenchmarkPathError(f"{context}.source_key is not a logical key")
        environment_variable = _required_string(raw, "environment_variable", context)
        if not _ENVIRONMENT_NAME.fullmatch(environment_variable):
            raise BenchmarkPathError(
                f"{context}.environment_variable is not a valid environment name"
            )
        default_view = Path(_required_string(raw, "default_view", context))
        if default_view.is_absolute() or ".." in default_view.parts:
            raise BenchmarkPathError(
                f"{context}.default_view must be repository-relative"
            )
        if (
            default_view.parts[:2] != ("tasks", "_campaign_views")
            or len(default_view.parts) < 3
        ):
            raise BenchmarkPathError(
                f"{context}.default_view must be inside ignored tasks/_campaign_views/"
            )
        specs[name] = BenchmarkSpec(
            name=name,
            display_name=display_name,
            source_key=source_key,
            environment_variable=environment_variable,
            default_view=default_view,
        )
    return specs


def load_local_sources(path: Path = DEFAULT_LOCAL_CONFIG) -> dict[str, str]:
    """Load logical source keys from the ignored per-workstation config."""

    path = Path(path)
    if not path.exists():
        return {}
    payload = _load_toml(path, "local benchmark config")
    if payload.get("schema_version") != 1:
        raise BenchmarkPathError(f"unsupported local benchmark config schema in {path}")
    sources = payload.get("sources")
    if not isinstance(sources, dict):
        raise BenchmarkPathError(
            f"local benchmark config has no [sources] table: {path}"
        )
    result: dict[str, str] = {}
    for key, value in sources.items():
        if not isinstance(value, str) or not value.strip():
            raise BenchmarkPathError(
                f"sources.{key} in {path} must be a non-empty string"
            )
        result[key] = value
    return result


def _spec(benchmark: str, registry_path: Path) -> BenchmarkSpec:
    specs = load_registry(registry_path)
    try:
        return specs[benchmark]
    except KeyError as exc:
        choices = ", ".join(sorted(specs))
        raise BenchmarkPathError(
            f"unknown benchmark {benchmark!r}; registry choices: {choices}"
        ) from exc


def resolve_source(
    benchmark: str,
    explicit: str | os.PathLike[str] | None = None,
    *,
    registry_path: Path = DEFAULT_REGISTRY,
    local_config_path: Path = DEFAULT_LOCAL_CONFIG,
    environ: Mapping[str, str] | None = None,
    must_exist: bool = True,
) -> Path:
    """Resolve a source with CLI > environment > local TOML precedence.

    All sources must be absolute.  An invalid higher-precedence value is an
    error rather than permission to fall back to a different source silently.
    """

    spec = _spec(benchmark, Path(registry_path))
    environment = os.environ if environ is None else environ
    origin: str
    raw: str | os.PathLike[str]
    if explicit is not None:
        raw = explicit
        origin = "explicit CLI path"
    elif spec.environment_variable in environment:
        raw = environment[spec.environment_variable]
        origin = f"environment variable {spec.environment_variable}"
    else:
        sources = load_local_sources(Path(local_config_path))
        if spec.source_key not in sources:
            raise BenchmarkPathError(
                f"no source configured for {benchmark!r}; pass an explicit path, set "
                f"{spec.environment_variable}, or set sources.{spec.source_key} in "
                f"{local_config_path}"
            )
        raw = sources[spec.source_key]
        origin = f"sources.{spec.source_key} in {local_config_path}"

    path = Path(raw)
    if not path.is_absolute():
        raise BenchmarkPathError(f"{origin} must be absolute, got: {raw!s}")
    resolved = path.resolve()
    if must_exist and not resolved.exists():
        raise BenchmarkPathError(f"{origin} does not exist: {resolved}")
    if must_exist and not resolved.is_dir():
        raise BenchmarkPathError(f"{origin} is not a directory: {resolved}")
    return resolved


def default_view(
    benchmark: str,
    *,
    registry_path: Path = DEFAULT_REGISTRY,
    repo_root: Path = REPO_ROOT,
) -> Path:
    """Return the benchmark's ignored materialization path under ``repo_root``."""

    relative_view = _spec(benchmark, Path(registry_path)).default_view
    return (Path(repo_root).resolve() / relative_view).resolve()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("benchmark")
    parser.add_argument("--source", type=Path)
    parser.add_argument("--registry", type=Path, default=DEFAULT_REGISTRY)
    parser.add_argument("--local-config", type=Path, default=DEFAULT_LOCAL_CONFIG)
    parser.add_argument("--allow-missing", action="store_true")
    args = parser.parse_args()
    try:
        source = resolve_source(
            args.benchmark,
            args.source,
            registry_path=args.registry,
            local_config_path=args.local_config,
            must_exist=not args.allow_missing,
        )
        view = default_view(args.benchmark, registry_path=args.registry)
    except BenchmarkPathError as exc:
        print(f"FATAL: {exc}", file=sys.stderr)
        return 1
    print(f"source={source}")
    print(f"view={view}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
