"""Bounded DLC image/import smoke; no model, rollout, or E2B call."""

from __future__ import annotations

import importlib
import importlib.metadata
import json
import os
import platform
import subprocess
from pathlib import Path

EXPECTED_MAIN = {"e2b": "2.34.0", "openai": "2.6.1"}
HARBOR_PYTHON = Path("/opt/harbor-0.20.0/bin/python")
HARBOR_CLI = Path("/usr/local/bin/harbor")

def _required_paths() -> dict[str, Path]:
    return {
        "codeprover": Path(os.environ.get("CODEPROVER_ROOT", Path(__file__).resolve().parents[1])) / "rl/run_dlc.sh",
        "miles": Path(os.environ["MILES_ROOT"]) / "train_async.py",
        "megatron": Path(os.environ["MEGATRON_LM_ROOT"]) / "megatron",
    }


def main() -> int:
    if platform.machine() not in {"aarch64", "arm64"}:
        raise RuntimeError(f"expected ARM64 image, found {platform.machine()}")

    versions = {}
    for distribution, expected in EXPECTED_MAIN.items():
        actual = importlib.metadata.version(distribution)
        if actual != expected:
            raise RuntimeError(f"{distribution}=={actual}; expected {expected}")
        versions[distribution] = actual
    try:
        main_harbor = importlib.metadata.version("harbor")
    except importlib.metadata.PackageNotFoundError:
        main_harbor = None
    if main_harbor is not None:
        raise RuntimeError(f"harbor=={main_harbor} leaked into the main environment")

    required_paths = _required_paths()
    missing_paths = [name for name, path in required_paths.items() if not path.exists()]
    if missing_paths:
        raise RuntimeError(f"BMCPFS paths are not mounted: {', '.join(missing_paths)}")

    imported = []
    for module in ("torch", "ray", "sglang", "miles", "megatron", "rl.generate_with_prover"):
        importlib.import_module(module)
        imported.append(module)

    import torch

    if not torch.cuda.is_available() or torch.cuda.device_count() < 1:
        raise RuntimeError("DLC smoke did not receive a CUDA GPU")

    if not HARBOR_PYTHON.is_file() or not HARBOR_CLI.is_file():
        raise RuntimeError("isolated Harbor runtime is missing")
    harbor_probe = subprocess.run(
        [
            str(HARBOR_PYTHON),
            "-c",
            "import importlib.metadata,json;"
            "print(json.dumps({'harbor':importlib.metadata.version('harbor')}))",
        ],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=30,
    )
    isolated = json.loads(harbor_probe.stdout)
    if isolated.get("harbor") != "0.20.0":
        raise RuntimeError(f"isolated Harbor version mismatch: {isolated!r}")

    print(json.dumps({
        "ok": True,
        "architecture": platform.machine(),
        "main_environment": versions,
        "main_harbor": None,
        "isolated_harbor": isolated["harbor"],
        "imports": imported,
        "torch": {
            "version": torch.__version__,
            "cuda_build": torch.version.cuda,
            "cuda_available": True,
            "device_count": torch.cuda.device_count(),
            "device_0": torch.cuda.get_device_name(0),
        },
        "mounted_paths": {name: str(path) for name, path in required_paths.items()},
        "e2b_called": False,
        "model_loaded": False,
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
