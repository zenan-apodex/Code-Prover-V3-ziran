"""Probe the CPU/memory spec of an internal-platform sandboxset.

Claims one sandbox, reads its cgroup limits, kills it. Run with the
pinned venv (py3.12 + e2b==2.23.0):

    set -a && source .env && set +a && \
      .venv-aliyun/bin/python tools/check_sandbox_spec.py --cluster jb

--fresh forces a brand-new pod (image swap + create-on-no-stock) so you
see the sandboxset's current template spec even if the pre-warm pool
still holds old-sized pods.
"""

from __future__ import annotations

import argparse
import asyncio
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from aliyun_clusters import configure_env

FRESH_IMAGES = {
    "jb": "apodex-sandbox-johor-registry-vpc.ap-southeast-8.cr.aliyuncs.com/math-rl/code-prover-lean:latest",
    "sg": "miromind-sg-registry-vpc.ap-southeast-1.cr.aliyuncs.com/verifiable-ai-lab/code-prover-lean:latest",
}

CGROUP_CMD = (
    "cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us /sys/fs/cgroup/cpu/cpu.cfs_period_us"
    " 2>/dev/null || cat /sys/fs/cgroup/cpu.max; "
    "cat /sys/fs/cgroup/memory/memory.limit_in_bytes 2>/dev/null"
    " || cat /sys/fs/cgroup/memory.max"
)


async def probe(cluster: str, template: str, fresh: bool) -> None:
    from e2b import AsyncSandbox

    metadata = {}
    if fresh:
        metadata = {
            "e2b.agents.kruise.io/image": FRESH_IMAGES[cluster],
            "e2b.agents.kruise.io/claim-timeout-seconds": "520",
            "e2b.agents.kruise.io/wait-ready-timeout-seconds": "520",
            "e2b.agents.kruise.io/create-on-no-stock": "true",
            "e2b.agents.kruise.io/reserve-failed-sandbox": "false",
        }
    t0 = time.time()
    sbx = await AsyncSandbox.create(
        template=template, timeout=300, request_timeout=560, metadata=metadata
    )
    try:
        r = await sbx.commands.run(CGROUP_CMD, timeout=30)
        quota, period, mem = (float(x) for x in r.stdout.split()[:3])
        print(
            f"[{cluster}/{template}{'+fresh' if fresh else ''}] {sbx.sandbox_id}"
            f"  claim {time.time() - t0:.0f}s"
            f"  CPU={quota / period:.1f}  MEM={mem / 2**30:.1f}GiB"
        )
    finally:
        await sbx.kill()


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--cluster", choices=("sg", "jb"), default="jb")
    ap.add_argument("--template", default="zenan-allow-internet")
    ap.add_argument("--fresh", action="store_true", help="force a brand-new pod")
    args = ap.parse_args()
    configure_env(args.cluster)
    asyncio.run(probe(args.cluster, args.template, args.fresh))


if __name__ == "__main__":
    main()
