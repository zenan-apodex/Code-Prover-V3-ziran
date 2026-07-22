"""Single source of truth for cross-stack conventions.

The eval stack (agents/ + verifier/ + harbor envs) and the RL stack
(rl/generate_with_prover.py + rl/sandbox.py) intentionally stay separate —
harbor needs its framework classes, RL needs a 2-method sandbox — but they
share these conventions. Every name below used to be hardcoded in 4-5 files;
import from here instead so the stacks cannot drift.

rl/generate_with_prover.py still carries its own literals: it is the
token-level hot path whose behavior was verified bitwise (2026-07-21) and the
regression gate (local sglang + rl/local_episode_test.py) is not currently
runnable. Migrate it to these imports the next time that gate is up.
"""

from __future__ import annotations

import json

# Docker images. The public ref works everywhere (docker hub, E2B template
# builds); the local tag exists on this box and inside generated task
# Dockerfiles (tools/dataset.py) which are only built by local harbor runs.
DOCKER_IMAGE_PUBLIC = "lizenan1995/code-prover-lean:latest"
DOCKER_IMAGE_LOCAL = "code-prover-lean:latest"

# E2B templates on team july-20-zenan (company-shared).
# RL: 2c/1GB, enough for episode tool calls, NOT for Mathlib lake builds.
# Eval/distill: 4c/8GB, built from DOCKER_IMAGE_PUBLIC, used by
# tools/e2b_env.py generic-template mode.
E2B_TEMPLATE_RL = "code-prover-lean-rl"
E2B_TEMPLATE_EVAL = "code-prover-lean-eval-4c8g"

# Where verifier/grade.py writes its flat float dict (in-sandbox path).
REWARD_PATH = "/logs/verifier/reward.json"


def parse_reward(text: str | bytes) -> float | None:
    """The `reward` field of a grade.py reward.json, or None if unreadable."""
    try:
        d = json.loads(text)
    except (ValueError, TypeError):
        return None
    r = d.get("reward")
    return float(r) if isinstance(r, (int, float)) else None
