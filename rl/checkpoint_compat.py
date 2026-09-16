"""Checkpoint compatibility rules shared by DLC render and runtime preflight."""

from __future__ import annotations

import sys
from pathlib import Path


def _load_common_state(common: Path, megatron_lm_root: str | Path | None) -> dict:
    """Load Megatron's pickled common state with an explicit import root.

    Real ``common.pt`` files reference classes below ``megatron.core``.  The
    DSW control environment used by ``submit_dlc.py`` does not install that
    package, so checkpoint inspection must not depend on the caller's ambient
    ``PYTHONPATH``.
    """
    import torch

    import_root = None
    inserted = False
    if megatron_lm_root is not None:
        root = Path(megatron_lm_root).resolve()
        if not (root / "megatron" / "core").is_dir():
            raise ValueError(f"invalid Megatron-LM import root: {root}")
        import_root = str(root)
        if import_root not in sys.path:
            sys.path.insert(0, import_root)
            inserted = True
    try:
        state = torch.load(common, map_location="cpu", weights_only=False)
    finally:
        if inserted:
            try:
                sys.path.remove(import_root)
            except ValueError:
                pass
    if not isinstance(state, dict):
        raise ValueError(f"load checkpoint common state is not a mapping: {common}")
    return state


def validate_resume_checkpoint(
    load_checkpoint_dir: str | Path,
    *,
    actor_world_size: int,
    tensor_model_parallel_size: int,
    pipeline_model_parallel_size: int,
    context_parallel_size: int,
    expert_model_parallel_size: int,
    optimizer_offload_fraction: float,
    no_load_optim: bool,
    megatron_lm_root: str | Path | None = None,
) -> dict:
    """Reject unsupported logical actor-topology changes before allocation.

    A base ``release`` checkpoint is a model initialization source, not an RL
    resume, so it may seed any supported actor topology. Numeric checkpoints
    preserve world/TP/PP/EP. CP may repartition the same DP+CP ranks because
    it does not shard model parameters or change that optimizer replica group.
    """
    load_dir = Path(load_checkpoint_dir).resolve()
    tracker = load_dir / "latest_checkpointed_iteration.txt"
    if not tracker.is_file():
        raise ValueError(f"missing load checkpoint tracker: {tracker}")
    iteration = tracker.read_text(encoding="utf-8").strip()
    if iteration != "release" and not iteration.isdecimal():
        raise ValueError(f"invalid load checkpoint tracker value: {iteration!r}")
    iteration_dir = (
        "release" if iteration == "release" else f"iter_{int(iteration):07d}"
    )
    common = load_dir / iteration_dir / "common.pt"
    if not common.is_file():
        raise ValueError(f"missing load checkpoint common state: {common}")
    saved_args = _load_common_state(common, megatron_lm_root).get("args")
    if saved_args is None:
        raise ValueError(f"load checkpoint has no saved args: {common}")

    requested_topology = {
        "world_size": actor_world_size,
        "tensor_model_parallel_size": tensor_model_parallel_size,
        "pipeline_model_parallel_size": pipeline_model_parallel_size,
        "context_parallel_size": context_parallel_size,
        "expert_model_parallel_size": expert_model_parallel_size,
    }
    saved_topology = {
        name: getattr(saved_args, name, None) for name in requested_topology
    }
    if iteration != "release":
        missing = [name for name, value in saved_topology.items() if value is None]
        if missing:
            raise ValueError(
                "numeric resume checkpoint is missing actor-topology metadata: "
                + ", ".join(missing)
            )
        mismatches = {
            name: (int(saved_topology[name]), int(requested))
            for name, requested in requested_topology.items()
            if int(saved_topology[name]) != int(requested)
        }
        if set(mismatches) == {"context_parallel_size"}:
            # A CP-only change preserves TP/PP/EP parameter shards and the
            # combined DP+CP optimizer group. Other topology changes remain gated.
            parallel = tensor_model_parallel_size * pipeline_model_parallel_size * context_parallel_size
            if context_parallel_size < 1 or actor_world_size % parallel:
                raise ValueError("context parallel size must divide the actor world")
            if getattr(saved_args, "ckpt_format", None) != "torch_dist":
                raise ValueError("CP-only resume requires a torch_dist checkpoint")
            mismatches = {}
        if mismatches:
            detail = ", ".join(
                f"{name} saved={saved} requested={requested}"
                for name, (saved, requested) in mismatches.items()
            )
            raise ValueError(
                "unsupported cross-actor-topology resume: "
                f"{detail}; keep the saved actor topology or start fresh from "
                "the base release checkpoint. --no-load-optim does not make "
                "cross-topology resume supported"
            )

    saved_fraction = getattr(saved_args, "optimizer_offload_fraction", None)
    # Megatron ignores the default fraction when CPU offload is disabled.
    if getattr(saved_args, "optimizer_cpu_offload", None) is False:
        saved_fraction = 0.0
    if (
        iteration != "release"
        and saved_fraction is not None
        and abs(float(saved_fraction) - optimizer_offload_fraction) > 1e-12
        and not no_load_optim
    ):
        raise ValueError(
            "checkpoint optimizer offload mismatch: "
            f"saved={saved_fraction}, requested={optimizer_offload_fraction}; "
            "set --no-load-optim for a same-topology model-only resume"
        )
    return {
        "iteration": iteration,
        "kind": "base_release" if iteration == "release" else "rl_resume",
        "saved_actor_topology": saved_topology,
        "requested_actor_topology": requested_topology,
        "saved_optimizer_offload_fraction": saved_fraction,
        "requested_optimizer_offload_fraction": optimizer_offload_fraction,
        "load_optimizer": iteration != "release" and not no_load_optim,
    }
