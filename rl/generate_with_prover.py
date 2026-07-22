"""miles custom-generate function for Code-Prover RL rollouts.

One episode = one sandbox (docker or E2B) + a token-level agent loop speaking
the qwen-native-v1 dialect against miles' sglang router, graded at the end by
the task's own verifier (tests/grade.py) inside the sandbox.

Wire-up (miles launch flags):
    --custom-generate-function-path rl.generate_with_prover.generate
    --prompt-data <jsonl from rl/make_prompt_data.py>
    --input-key prompt --metadata-key metadata
    (reward is computed inside `generate`, no --custom-rm-path needed)

The tool surface, spec guard, and truncation-nudge semantics are reused from
agents/qwen_native_agent.py so RL rollouts and harbor evals behave
identically; the only differences are token-level transport (sglang native
/generate with input_ids) and compaction being disabled (a context reset
would break the linear token stream — long episodes end as TRUNCATED).
"""

from __future__ import annotations

import asyncio
import dataclasses
import json
import logging
import sys
import tempfile
import time
from pathlib import Path

logger = logging.getLogger(__name__)

# Ray rollout workers import this module by dotted path; make the repo root
# importable regardless of the worker's CWD.
REPO_ROOT = Path(__file__).resolve().parent.parent
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from agents import qwen_native_v1 as codec  # noqa: E402
from agents.qwen_native_agent import (  # noqa: E402
    ALLOWED_TOOLS,
    MAX_TRUNCATION_NUDGES,
    TRUNCATION_NUDGE_PROMPT,
    QwenNativeAgent,
    _READONLY_TOOLS,
)
from rl.sandbox import create_sandbox  # noqa: E402
from rl.token_stream import TokenStream  # noqa: E402

# test.sh's lake compile alone allows 1200s; axioms/integrity checks ride on
# top. 1500 was observed too tight (graders killed mid-run -> ABORTED, 07-22);
# match the eval-side verifier timeout.
GRADE_TIMEOUT_SEC = 1800
_sandbox_semaphore: asyncio.Semaphore | None = None


@dataclasses.dataclass
class EpisodeConfig:
    model_path: str
    max_turns: int = 64
    max_total_tokens: int = 65536
    sandbox_backend: str = "docker"
    docker_image: str = "lizenan1995/code-prover-lean:latest"
    e2b_template: str = ""
    sandbox_cpus: float | None = None
    sandbox_memory_gb: float | None = None
    # E2B kills the sandbox at this TTL no matter what the episode is doing;
    # must cover the slowest episode (gen + lake builds + grading), not the
    # E2B default of 3600.
    sandbox_timeout_sec: int = 14400


@dataclasses.dataclass
class EpisodeResult:
    tokens: list[int]
    prompt_len: int
    loss_mask: list[int]
    logprobs: list[float]
    status: str                  # completed | truncated | failed
    reward: float
    rewards: dict
    n_turns: int
    stop_detail: str
    guard_events: list[dict] = dataclasses.field(default_factory=list)

    @property
    def response_length(self) -> int:
        return len(self.tokens) - self.prompt_len


def _wrap_tool_responses(results: list[str]) -> str:
    # Must match codec.encode_messages flush_tool_results byte-for-byte.
    return "\n".join(f"<tool_response>\n{r}\n</tool_response>" for r in results)


class _ToolSurface(QwenNativeAgent):
    """Reuses the eval agent's tool dispatch / spec guard / bridge setup
    without its chat-API run loop."""

    def __init__(self):
        super().__init__(logs_dir=Path(tempfile.mkdtemp(prefix="prover-rl-")))


async def run_episode(
    generate_fn,
    sandbox,
    instruction: str,
    task_dir: Path,
    cfg: EpisodeConfig,
) -> EpisodeResult:
    """Drive one full episode. `generate_fn(input_ids) -> dict` must return
    {"token_ids": [...], "logprobs": [...], "finish_reason": "stop"|"length",
     "text": str} for one assistant turn."""
    tests_dir = task_dir / "tests"
    ts = TokenStream(cfg.model_path)
    ts.start(instruction)

    # RL sandboxes come from the GENERIC base image (no per-task docker
    # build), so the task's .lean file must be placed at the path the
    # verifier will grade — tests/task_file.txt is authoritative.
    task_file_target = (tests_dir / "task_file.txt").read_text(encoding="utf-8").strip()
    await sandbox.upload_file(task_dir / "environment" / "task.lean", task_file_target)

    surface = _ToolSurface()
    await surface.setup(sandbox)
    surface._guard_path = task_file_target
    surface._guard_original = await surface._read_task_file(sandbox, task_file_target)
    surface._guard_last_good = surface._guard_original
    guard_events: list[dict] = []

    def emit(kind: str, payload: dict) -> None:
        guard_events.append({"type": kind, **payload})

    status, stop_detail = "truncated", "max_turns"
    n_nudges = 0
    n_turns = 0
    for n_turns in range(1, cfg.max_turns + 1):
        if len(ts.tokens) >= cfg.max_total_tokens:
            status, stop_detail = "truncated", "token_budget"
            break

        out = await generate_fn(ts.tokens)
        ts.append_generated(out["token_ids"], out["logprobs"])
        finish = out["finish_reason"]
        if not ts.tokens or ts.tokens[-1] != ts.glue.im_end_id:
            # Turn cut mid-stream (length) or stop token trimmed upstream:
            # close the turn with a synthetic <|im_end|> (mask 0) so the
            # conversation format stays valid for any follow-up turn.
            ts.tokens.append(ts.glue.im_end_id)
            ts.loss_mask.append(0)
            ts.logprobs.append(0.0)

        decoded = codec.decode_assistant(
            content=out["text"],
            reasoning_content=None,
            structured_tool_calls=None,
            allowed_tool_names=ALLOWED_TOOLS,
            call_id_namespace=f"turn{n_turns}",
        )

        if decoded.errors and not decoded.tool_calls:
            recovery = [
                json.dumps(
                    codec.protocol_error_recovery_call(
                        err, index=i, call_id_namespace=f"turn{n_turns}"
                    ).arguments,
                    ensure_ascii=False,
                )
                for i, err in enumerate(decoded.errors)
            ]
            ts.append_user_turn(_wrap_tool_responses(recovery))
            continue

        if not decoded.tool_calls:
            if finish == "length" and n_nudges < MAX_TRUNCATION_NUDGES:
                n_nudges += 1
                ts.append_user_turn(_wrap_tool_responses([TRUNCATION_NUDGE_PROMPT]))
                continue
            if finish == "length":
                status, stop_detail = "truncated", "truncated_without_tool_call"
            else:
                status, stop_detail = "completed", "final_answer"
            break
        n_nudges = 0

        results = []
        for tc in decoded.tool_calls:
            result = await surface._dispatch(sandbox, tc.name, tc.arguments)
            if tc.name not in _READONLY_TOOLS:
                result += await surface._guard_task_file(sandbox, emit)
            results.append(result)
        ts.append_user_turn(_wrap_tool_responses(results))

    ts.validate()
    reward, rewards = await _grade(sandbox, tests_dir)
    return EpisodeResult(
        tokens=ts.tokens,
        prompt_len=ts.prompt_len,
        loss_mask=ts.loss_mask,
        logprobs=ts.logprobs,
        status=status,
        reward=reward,
        rewards=rewards,
        n_turns=n_turns,
        stop_detail=stop_detail,
        guard_events=guard_events,
    )


async def _grade(sandbox, tests_dir: Path) -> tuple[float, dict]:
    for f in tests_dir.iterdir():
        await sandbox.upload_file(f, f"/tests/{f.name}")
    await sandbox.exec("bash /tests/test.sh", timeout_sec=GRADE_TIMEOUT_SEC)
    r = await sandbox.exec("cat /logs/verifier/reward.json", timeout_sec=60)
    try:
        rewards = json.loads(r.stdout)
        return float(rewards.get("reward", 0.0)), rewards
    except (ValueError, TypeError):
        # Grader infrastructure failure, not a model failure: reward-0 here
        # would poison training — raise so the sample is ABORTED instead.
        raise RuntimeError(f"reward.json unreadable: {r.stderr[:200]}") from None


# --------------------------------------------------------------- miles glue --


def add_arguments(parser):
    parser.add_argument("--prover-model-path", type=str, required=True,
                        help="HF checkpoint dir (tokenizer + chat template)")
    parser.add_argument("--prover-task-root", type=str, required=True,
                        help="harbor task dataset root, e.g. tasks/trainset_problems_300")
    parser.add_argument("--prover-sandbox-backend", type=str, default="docker",
                        choices=["docker", "e2b"])
    parser.add_argument("--prover-docker-image", type=str,
                        default="lizenan1995/code-prover-lean:latest")
    parser.add_argument("--prover-e2b-template", type=str, default="")
    parser.add_argument("--prover-max-turns", type=int, default=64)
    parser.add_argument("--prover-max-total-tokens", type=int, default=65536)
    parser.add_argument("--prover-sandbox-concurrency", type=int, default=32)


def _episode_config(args) -> EpisodeConfig:
    return EpisodeConfig(
        model_path=args.prover_model_path,
        max_turns=args.prover_max_turns,
        max_total_tokens=args.prover_max_total_tokens,
        sandbox_backend=args.prover_sandbox_backend,
        docker_image=args.prover_docker_image,
        e2b_template=args.prover_e2b_template,
        sandbox_timeout_sec=getattr(args, "prover_sandbox_timeout", 14400),
    )


def _router_generate_fn(args, sampling_params: dict):
    from miles.utils.http_utils import post

    url = f"http://{args.sglang_router_ip}:{args.sglang_router_port}/generate"

    async def generate_fn(input_ids: list[int]) -> dict:
        payload = {
            "input_ids": input_ids,
            "sampling_params": {**sampling_params, "no_stop_trim": True},
            "return_logprob": True,
        }
        output = await post(url, payload)
        pairs = output["meta_info"]["output_token_logprobs"]
        return {
            "token_ids": [p[1] for p in pairs],
            "logprobs": [p[0] for p in pairs],
            "finish_reason": output["meta_info"]["finish_reason"]["type"],
            "text": output["text"],
        }

    return generate_fn


async def generate(args, sample, sampling_params: dict):
    """miles --custom-generate-function-path entrypoint."""
    from miles.utils.types import Sample

    global _sandbox_semaphore
    if _sandbox_semaphore is None:
        _sandbox_semaphore = asyncio.Semaphore(args.prover_sandbox_concurrency)

    cfg = _episode_config(args)
    meta = sample.metadata or {}
    task_dir = Path(args.prover_task_root) / meta["task_name"]
    instruction = sample.prompt if isinstance(sample.prompt, str) else meta["instruction"]

    t0 = time.monotonic()
    try:
        async with _sandbox_semaphore:
            sandbox = await create_sandbox(
                cfg.sandbox_backend,
                image=cfg.docker_image,
                template=cfg.e2b_template,
                cpus=cfg.sandbox_cpus,
                memory_gb=cfg.sandbox_memory_gb,
                timeout=cfg.sandbox_timeout_sec,
            )
            try:
                ep = await run_episode(
                    _router_generate_fn(args, sampling_params),
                    sandbox, instruction, task_dir, cfg,
                )
            finally:
                await sandbox.close()
    except Exception:
        # Infra fault (sandbox died, transport error, ...): ABORTED — miles
        # discards the group via dynamic sampling instead of training on a
        # bogus reward-0, and the rollout as a whole survives.
        logger.exception(
            "episode ABORTED task=%s elapsed=%.0fs", meta.get("task_name"), time.monotonic() - t0
        )
        sample.status = Sample.Status.ABORTED
        return sample

    logger.info(
        "episode done task=%s status=%s reward=%s turns=%d stop=%s elapsed=%.0fs "
        "rewards=%s guard_events=%d",
        meta.get("task_name"), ep.status, ep.reward, ep.n_turns, ep.stop_detail,
        time.monotonic() - t0, json.dumps(ep.rewards), len(ep.guard_events),
    )
    sample.tokens = ep.tokens
    sample.response_length = ep.response_length
    sample.response = TokenStream(cfg.model_path).tokenizer.decode(
        ep.tokens[ep.prompt_len:]
    )
    sample.loss_mask = ep.loss_mask
    sample.rollout_log_probs = ep.logprobs
    sample.reward = ep.reward
    sample.status = (
        Sample.Status.COMPLETED if ep.status == "completed" else Sample.Status.TRUNCATED
    )
    sample.metadata = {
        **meta,
        "rewards": ep.rewards,
        "n_turns": ep.n_turns,
        "stop_detail": ep.stop_detail,
    }
    return sample


generate.add_arguments = add_arguments
