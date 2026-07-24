"""Distillation campaign operations — everything that previously lived in
ad-hoc session scripts, as one repo tool.

    .venv/bin/python tools/distill_ops.py rounds --round 2
    .venv/bin/python tools/distill_ops.py rescue --job jobs/distill-dpsk-round1 --round round1
    .venv/bin/python tools/distill_ops.py status --job jobs/distill-dpsk-round1 [--total 5000]
    .venv/bin/python tools/distill_ops.py config --round 2 [--rescue]
    .venv/bin/python tools/distill_ops.py collect --jobs jobs/distill-dpsk-round1 jobs/distill-dpsk-round1-rescue \
        --out data/coding-v2.1-full-20260721/distilled/round1-solved.jsonl

Dataset layout (all under DATASET, gitignored):
    tasks/                    all 25,880 harbor task dirs (source of truth)
    rounds_assignment.json    seeded 6-round split (seed 20260721)
    rounds/round<N>/          materialized per-round datasets
    rounds/<round>_rescue/    tasks of a round that did not finish cleanly
    distilled/round<N>-solved.jsonl   collected transcripts -> SFT jsonl exports
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
# Campaign selection: DISTILL_DATASET points at the dataset root (default v2.1),
# DISTILL_CAMPAIGN prefixes job/config labels so campaigns never collide in
# jobs/ or configs/ (e.g. "v2.2" -> distill-dpsk-v2.2-round1).
DATASET = Path(os.environ.get("DISTILL_DATASET",
                              str(REPO / "data" / "coding-v2.1-full-20260721")))
CAMPAIGN = os.environ.get("DISTILL_CAMPAIGN", "")
# Model selection for generated configs (all via the llm-hub gateway, same
# $DPSK_API_KEY): DISTILL_MODEL + its gateway channel + the job/config name
# tag, e.g. kimi-k3 -> DISTILL_MODEL=kimi-k3 DISTILL_CHANNEL=12
# DISTILL_MODEL_TAG=kimi (job names become distill-kimi-<label>).
MODEL = os.environ.get("DISTILL_MODEL", "deepseek-v4-pro")
CHANNEL = os.environ.get("DISTILL_CHANNEL", "7")
MODEL_TAG = os.environ.get("DISTILL_MODEL_TAG", "dpsk")

sys.path.insert(0, str(REPO))
from tools.dataset import write_manifest  # noqa: E402
from tools.prover_common import parse_reward  # noqa: E402

# DeepSeek-style reference prices per 1M tokens (gateway internal billing may
# differ; used only for projections in `status`).
PRICE_IN_MISS = 0.28
PRICE_IN_HIT = 0.028
PRICE_OUT = 0.42


def _assignment() -> dict:
    return json.loads((DATASET / "rounds_assignment.json").read_text())


def _materialize(names: list[str], out: Path) -> None:
    out.mkdir(parents=True, exist_ok=True)
    for i, name in enumerate(names, 1):
        dst = out / name
        if not (dst / "task.toml").is_file():
            shutil.copytree(DATASET / "tasks" / name, dst, dirs_exist_ok=True)
        if i % 500 == 0:
            print(f"  {i}/{len(names)}", flush=True)
    m = write_manifest(out)
    print(f"{out}: {m['task_count']} tasks, content_sha256={m['content_sha256'][:16]}…")


def cmd_rounds(args) -> int:
    names = _assignment()["rounds"][f"round{args.round}"]
    _materialize(names, DATASET / "rounds" / f"round{args.round}")
    return 0


def _clean_task_names(job: Path) -> set[str]:
    """Task names whose trial doesn't deserve a re-run in this job.

    A finish counts as clean when result.json has no exception AND the
    rollout wasn't gutted by infrastructure: trials that ended in
    request_transport_error/request_rejected_400 without solving (round3
    2026-07-22: 1,683 trials quit early inside a gateway 502/503 storm)
    look clean to harbor but carry a truncated, unusable rollout — unless
    they happened to be solved anyway, they belong in the rescue set.
    """
    clean = set()
    for p in job.glob("*/result.json"):
        d = json.loads(p.read_text())
        if d.get("exception_info") is not None:
            continue
        name = Path(d["task_id"]["path"]).name
        trial = p.parent
        tp = trial / "agent" / "transcript.json"
        if tp.is_file():
            try:
                stop = json.loads(tp.read_text()).get("stop_reason")
            except ValueError:
                stop = None
            if stop in ("request_transport_error", "request_rejected_400"):
                reward = None
                rw = trial / "verifier" / "reward.json"
                if rw.is_file():
                    reward = parse_reward(rw.read_text())
                if reward != 1.0:
                    continue
        clean.add(name)
    return clean


def cmd_rescue(args) -> int:
    jobs = [Path(j) for j in args.job]
    round_names = set(_assignment()["rounds"][args.round])
    clean = set()
    for job in jobs:
        clean |= _clean_task_names(job)
    rescue = sorted(round_names - clean)
    print(f"{args.round}: {len(round_names)} tasks, clean {len(clean & round_names)}, rescue {len(rescue)}")
    if not rescue:
        print("nothing to rescue")
        return 0
    # NB: _materialize merges into an existing dir (it never deletes), so a
    # second rescue pass must use a fresh --out or it inherits stale tasks.
    _materialize(rescue, DATASET / "rounds" / (args.out or f"{args.round}_rescue"))
    return 0


def cmd_status(args) -> int:
    job = Path(args.job)
    res = list(job.glob("*/result.json"))
    n_ok = n_exc = 0
    excs: dict[str, int] = {}
    t_first = None
    for p in res:
        d = json.loads(p.read_text())
        e = d.get("exception_info")
        if e is None:
            n_ok += 1
        else:
            n_exc += 1
            k = str(e.get("exception_message", ""))[:50]
            excs[k] = excs.get(k, 0) + 1
        st = d.get("started_at")
        if st:
            t = datetime.fromisoformat(st.replace("Z", "+00:00"))
            t_first = t if t_first is None or t < t_first else t_first
    rewards = []
    for p in job.glob("*/verifier/reward.json"):
        try:
            rewards.append(parse_reward(p.read_text()))
        except OSError:
            pass
    solved = sum(1 for r in rewards if r == 1.0)
    tin = tout = n_tr = n_think = n_asst = 0
    stops: dict[str, int] = {}
    for p in job.glob("*/agent/transcript.json"):
        d = json.loads(p.read_text())
        n_tr += 1
        u = d.get("usage", {})
        tin += u.get("input_tokens", 0)
        tout += u.get("output_tokens", 0)
        stops[d.get("stop_reason")] = stops.get(d.get("stop_reason"), 0) + 1
        for m in d["messages"]:
            if m["role"] == "assistant":
                n_asst += 1
                n_think += "<think>" in (m.get("content") or "")
    print(f"finished: {len(res)}" + (f"/{args.total}" if args.total else "")
          + f"  (clean {n_ok}, exceptions {n_exc})")
    if excs:
        print("  exceptions:", dict(sorted(excs.items(), key=lambda kv: -kv[1])[:5]))
    print(f"solved: {solved}/{len(rewards)} ({solved / max(len(rewards), 1):.1%})")
    print(f"stop_reasons: {stops}")
    print(f"think coverage: {n_think}/{n_asst}")
    if n_tr:
        ain, aout = tin / n_tr, tout / n_tr
        print(f"tokens: avg/task in {ain:,.0f} out {aout:,.0f}  "
              f"(total in {tin / 1e9:.2f}B out {tout / 1e6:.0f}M)")
        if args.total:
            for label, hit in (("no-cache", 0.0), ("85% cache-hit", 0.85)):
                c = (ain * args.total * (1 - hit) * PRICE_IN_MISS
                     + ain * args.total * hit * PRICE_IN_HIT
                     + aout * args.total * PRICE_OUT) / 1e6
                print(f"  projection x{args.total} [{label}]: ${c:,.0f}")
    if t_first and res:
        hours = (datetime.now(timezone.utc) - t_first).total_seconds() / 3600
        rate = len(res) / max(hours, 0.1)
        line = f"throughput: {rate:.0f}/h"
        if args.total:
            line += f", ETA remaining: {(args.total - len(res)) / max(rate, 1):.1f}h"
        print(line)
    return 0


def cmd_collect(args) -> int:
    """Merge jobs -> one jsonl of complete trajectories with rewards.

    Keeps, per task, the best trial (clean > exception, higher reward,
    then later job in the --jobs order wins ties). Drops trials with
    n_compactions > 0 (non-linear context) unless --keep-compacted.
    """
    best: dict[str, dict] = {}
    for ji, jdir in enumerate(args.jobs):
        for rp in Path(jdir).glob("*/result.json"):
            trial = rp.parent
            d = json.loads(rp.read_text())
            if d.get("exception_info") is not None:
                continue
            tp = trial / "agent" / "transcript.json"
            if not tp.is_file():
                continue
            tr = json.loads(tp.read_text())
            if tr.get("n_compactions", 0) and not args.keep_compacted:
                continue
            # SFT sequences must end on an assistant turn: rollouts that hit
            # the call/context cap right after a tool call leave a trailing
            # tool message with no training target (66/2030 in round1).
            msgs = tr["messages"]
            while msgs and msgs[-1]["role"] != "assistant":
                msgs.pop()
            if not msgs:
                continue
            reward = None
            rw = trial / "verifier" / "reward.json"
            if rw.is_file():
                reward = parse_reward(rw.read_text())
            task = Path(d["task_id"]["path"]).name
            rec = {
                "task_name": task,
                "trial": str(trial),
                "job_order": ji,
                "reward": reward,
                "model": tr.get("model"),
                "stop_reason": tr.get("stop_reason"),
                "api_calls": tr.get("api_calls"),
                "usage": tr.get("usage"),
                "messages": msgs,
            }
            cur = best.get(task)
            if (cur is None
                    or (rec["reward"] or 0) > (cur["reward"] or 0)
                    or ((rec["reward"] or 0) == (cur["reward"] or 0)
                        and ji >= cur["job_order"])):
                best[task] = rec
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    n_pos = 0
    with out.open("w", encoding="utf-8") as f:
        for task in sorted(best):
            rec = dict(best[task])
            rec.pop("job_order", None)
            if args.solved_only and rec["reward"] != 1.0:
                continue
            n_pos += rec["reward"] == 1.0
            f.write(json.dumps(rec, ensure_ascii=False) + "\n")
    kept = n_pos if args.solved_only else len(best)
    print(f"collected {kept} trajectories -> {out} "
          f"(unique tasks {len(best)}, reward==1.0: {n_pos})")
    return 0


CONFIG_TEMPLATE = """\
# Distillation {label}: generated by tools/distill_ops.py config — edit the
# generator, not this file.
# Backend is E2B (per Zenan 2026-07-22: no local docker for distillation).
# The company team is shared: sandboxes can be killed by others and creation
# can fail under contention — the env retries creation, and `distill_ops
# rescue` re-runs whatever still dies.
job_name: distill-{tag}-{label}
jobs_dir: jobs
n_attempts: 1
# 1024 per Zenan 2026-07-22 (512 validated on round1 rescues; gateway share
# is the real throughput cap; sandboxes bill while waiting on 429 backoff).
n_concurrent_trials: 1024

environment:
  import_path: tools.e2b_env:ACRE2BEnvironment
  override_cpus: 4
  override_memory_mb: 8192
  kwargs:
    generic_template: code-prover-lean-eval-4c8g
    # agent 3600 + verifier 1800 + overhead; sandboxes bill while alive.
    sandbox_timeout_sec: 7200

agents:
  - import_path: agents.thirdparty_agent:ThirdPartyAgent
    model_name: {model}
    kwargs:
      api_base: https://llm-hub.apodex.app/v1
      # generic llm-hub key (works across channels; kimi-k3@12 验证过)
      api_key: $DPSK_API_KEY
      extra_headers: {{"X-Llmhub-Channel": "{channel}"}}
      max_api_calls: 384
      max_tokens: 16384
      enable_compaction: false
      save_transcript: true
      # thinking is gateway-default-on; pinned so a default flip can never
      # silently drop the CoT we distill on. kimi-k3 也接受此字段
      # (07-24 验证:reasoning_content 正常返回)。
      extra_request_fields: {{"thinking": {{"type": "enabled"}}}}

datasets:
  - path: {dataset}
"""


def cmd_config(args) -> int:
    label = (f"{CAMPAIGN}-" if CAMPAIGN else "") + f"round{args.round}" \
        + ("-rescue" if args.rescue else "") \
        + (f"-{args.suffix}" if args.suffix else "")
    ds = DATASET / "rounds" / (f"round{args.round}_rescue" if args.rescue
                               else f"round{args.round}")
    out = REPO / "configs" / f"distill-{MODEL_TAG}-{label}.yaml"
    if out.exists() and not args.force:
        print(f"FATAL: {out} exists — pass --force to overwrite", file=sys.stderr)
        return 1
    out.write_text(CONFIG_TEMPLATE.format(label=label, dataset=ds.relative_to(REPO),
                                          model=MODEL, channel=CHANNEL,
                                          tag=MODEL_TAG))
    print(f"wrote {out}")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    r = sub.add_parser("rounds", help="materialize a round's task dirs")
    r.add_argument("--round", type=int, required=True)
    r.set_defaults(func=cmd_rounds)

    rs = sub.add_parser("rescue", help="build <round>_rescue from unclean tasks")
    rs.add_argument("--job", nargs="+", required=True,
                    help="job dir(s) whose clean finishes count as done")
    rs.add_argument("--round", required=True, help="e.g. round1")
    rs.add_argument("--out", default=None,
                    help="output dir name under rounds/ (default <round>_rescue; "
                         "use a fresh name for a second rescue pass)")
    rs.set_defaults(func=cmd_rescue)

    st = sub.add_parser("status", help="progress / quality / cost report")
    st.add_argument("--job", required=True)
    st.add_argument("--total", type=int, default=0,
                    help="dataset size for ETA and cost projection")
    st.set_defaults(func=cmd_status)

    co = sub.add_parser("collect", help="merge jobs into an SFT jsonl")
    co.add_argument("--jobs", nargs="+", required=True,
                    help="job dirs, later ones win reward ties")
    co.add_argument("--out", required=True)
    co.add_argument("--solved-only", action="store_true")
    co.add_argument("--keep-compacted", action="store_true")
    co.set_defaults(func=cmd_collect)

    cf = sub.add_parser("config", help="render a round's harbor config")
    cf.add_argument("--round", type=int, required=True)
    cf.add_argument("--rescue", action="store_true")
    cf.add_argument("--suffix", default="",
                    help="extra job-name suffix, e.g. e2b for a backend redo")
    cf.add_argument("--force", action="store_true")
    cf.set_defaults(func=cmd_config)

    args = ap.parse_args()
    return args.func(args)


if __name__ == "__main__":
    # Default SIGPIPE so `... | head` truncates quietly instead of raising.
    import signal
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)
    raise SystemExit(main())
