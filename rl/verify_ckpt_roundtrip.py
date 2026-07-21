"""Numeric check of the HF -> torch_dist conversion, via round-trip.

Compares the original SFT HF checkpoint against the output of
tools/convert_torch_dist_to_hf.py run on our converted torch_dist ckpt.
Bitwise equality on every tensor proves the forward conversion preserved
the weights exactly (up to conversion-scope keys: the original is a
multimodal wrapper, so vision-tower keys are expected original-only;
MTP keys exist in neither side).

Two representation differences are normalized before comparing:
  - MoE experts: the original uses the fused per-layer layout, already in
    linear [out, in] orientation per expert (`experts.gate_up_proj`
    [E, 2*ffn, hidden] with gate/up as contiguous halves of dim 0;
    `experts.down_proj` [E, hidden, ffn]); the roundtrip tool emits
    per-expert `experts.{i}.{gate,up,down}_proj.weight`. Verified
    empirically on layer0/expert0 (halves match, interleave does not).
  - dtype upcasts (e.g. GDN A_log bf16 -> fp32 inside Megatron): values
    must still be exactly representable-equal after casting both to fp32.

Usage:
    python3 rl/verify_ckpt_roundtrip.py <original_hf_dir> <roundtrip_hf_dir>
"""

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

import torch
from safetensors import safe_open


def weight_map(hf_dir: Path) -> dict[str, str]:
    index = json.loads((hf_dir / "model.safetensors.index.json").read_text())
    return index["weight_map"]


_EXPERT_RE = re.compile(r"^(.*\.mlp\.experts)\.(\d+)\.(gate|up|down)_proj\.weight$")


def fused_expert_slice(fo, orig_map, rt_key):
    """Original-side tensor equivalent to a per-expert roundtrip key, or None."""
    m = _EXPERT_RE.match(rt_key)
    if not m:
        return None
    prefix, expert, kind = m.group(1), int(m.group(2)), m.group(3)
    fused_key = f"{prefix}.{'down_proj' if kind == 'down' else 'gate_up_proj'}"
    if fused_key not in orig_map:
        return None
    fused = fo[orig_map[fused_key]].get_tensor(fused_key)[expert]  # [out, in]
    if kind != "down":
        half = fused.shape[0] // 2
        fused = fused[:half] if kind == "gate" else fused[half:]
    return fused.contiguous()


def compare(k, a, b, counts):
    if a.shape != b.shape:
        counts["diff"] += 1
        print(f"  MISMATCH {k}: {a.dtype}{list(a.shape)} vs {b.dtype}{list(b.shape)}")
    elif a.dtype != b.dtype:
        if torch.equal(a.float(), b.float()):
            counts["upcast"] += 1
        else:
            counts["diff"] += 1
            d = (a.float() - b.float()).abs()
            print(f"  DIFF(dtype) {k}: {a.dtype} vs {b.dtype}, max_abs={d.max().item():.3e}")
    elif torch.equal(a, b):
        counts["equal"] += 1
    else:
        counts["diff"] += 1
        d = (a.float() - b.float()).abs()
        print(f"  DIFF {k}: max_abs={d.max().item():.3e} n_neq={(d != 0).sum().item()}/{a.numel()}")


def main() -> int:
    orig_dir, rt_dir = Path(sys.argv[1]), Path(sys.argv[2])
    orig_map, rt_map = weight_map(orig_dir), weight_map(rt_dir)

    orig_files = {f: safe_open(orig_dir / f, framework="pt") for f in set(orig_map.values())}

    fused_covered: set[str] = set()
    orig_only = sorted(set(orig_map) - set(rt_map))
    rt_only = sorted(set(rt_map) - set(orig_map))
    shared = sorted(set(orig_map) & set(rt_map))

    counts: dict[str, int] = defaultdict(int)

    # per-expert roundtrip keys vs fused original layout
    unmatched_rt = []
    by_rt_file: dict[str, list[str]] = defaultdict(list)
    for k in rt_only:
        by_rt_file[rt_map[k]].append(k)
    for rf, keys in sorted(by_rt_file.items()):
        with safe_open(rt_dir / rf, framework="pt") as fr:
            for k in keys:
                a = fused_expert_slice(orig_files, orig_map, k)
                if a is None:
                    unmatched_rt.append(k)
                    continue
                m = _EXPERT_RE.match(k)
                fused_covered.add(
                    f"{m.group(1)}.{'down_proj' if m.group(3) == 'down' else 'gate_up_proj'}"
                )
                compare(k, a, fr.get_tensor(k), counts)

    true_orig_only = [k for k in orig_only if k not in fused_covered]
    print(f"tensors: shared={len(shared)} fused-expert-matched={len(rt_only) - len(unmatched_rt)}")
    for k in true_orig_only[:20]:
        print(f"  orig-only (expected: vision tower etc.): {k}")
    if len(true_orig_only) > 20:
        print(f"  ... and {len(true_orig_only) - 20} more orig-only")
    for k in unmatched_rt:
        print(f"  RT-ONLY (unexpected): {k}")

    by_file: dict[tuple[str, str], list[str]] = defaultdict(list)
    for k in shared:
        by_file[(orig_map[k], rt_map[k])].append(k)
    for (of, rf), keys in sorted(by_file.items()):
        with safe_open(rt_dir / rf, framework="pt") as fr:
            for k in keys:
                compare(k, orig_files[of].get_tensor(k), fr.get_tensor(k), counts)

    print(
        f"result: bitwise-equal={counts['equal']} "
        f"upcast-equal={counts['upcast']} differ={counts['diff']} "
        f"(orig-only non-expert: {len(true_orig_only)})"
    )
    ok = counts["diff"] == 0 and not unmatched_rt
    print("ROUNDTRIP OK" if ok else "ROUNDTRIP FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
