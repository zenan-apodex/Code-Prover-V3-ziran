"""Restore the original Qwen HF layout after Miles' text-only checkpoint export.

The rollout SFT checkpoint packs all experts in each layer. Miles' standalone
converter writes per-expert projections and omits the untouched vision/MTP
modules. Repack only these known differences; never substitute missing trained
language-model weights with SFT weights.
"""
from __future__ import annotations

import argparse
from contextlib import ExitStack
import json
from pathlib import Path
import re
import shutil

import torch
from safetensors import safe_open
from safetensors.torch import save_file


def reconstruct(name, reference, converted, original, consumed):
    if name in converted:
        consumed.add(name)
        return converted[name]()
    match = re.fullmatch(r'(model\.language_model\.layers\.\d+\.mlp\.experts)\.(gate_up_proj|down_proj)', name)
    if match:
        prefix, projection = match.groups()
        output = torch.empty(reference.shape, dtype=reference.dtype)
        for expert in range(output.shape[0]):
            if projection == 'gate_up_proj':
                gate = f'{prefix}.{expert}.gate_proj.weight'
                up = f'{prefix}.{expert}.up_proj.weight'
                gate_tensor, up_tensor = converted[gate](), converted[up]()
                half = output.shape[1] // 2
                if gate_tensor.shape != output[expert, :half].shape or up_tensor.shape != output[expert, half:].shape:
                    raise ValueError(f'expert shape mismatch: {name}/{expert}')
                output[expert, :half].copy_(gate_tensor)
                output[expert, half:].copy_(up_tensor)
                consumed.update([gate, up])
            else:
                key = f'{prefix}.{expert}.down_proj.weight'
                value = converted[key]()
                if value.shape != output[expert].shape:
                    raise ValueError(f'expert shape mismatch: {name}/{expert}')
                output[expert].copy_(value)
                consumed.add(key)
        return output
    if name.startswith(('model.visual.', 'mtp.')):
        return original[name]()
    raise ValueError(f'missing trained language-model tensor: {name}')


def repack(converted_dir, original_dir, output_dir):
    converted_dir, original_dir, output_dir = map(Path, (converted_dir, original_dir, output_dir))
    output_dir.mkdir(parents=True, exist_ok=False)
    converted_map = json.loads((converted_dir/'model.safetensors.index.json').read_text())['weight_map']
    original_map = json.loads((original_dir/'model.safetensors.index.json').read_text())['weight_map']
    consumed, index, total_bytes = set(), {}, 0
    with ExitStack() as stack:
        def readers(root, mapping):
            handles = {shard: stack.enter_context(safe_open(root/shard, framework='pt', device='cpu'))
                       for shard in set(mapping.values())}
            return {name: lambda n=name, h=handles[shard]: h.get_tensor(n) for name,shard in mapping.items()}
        converted, original = readers(converted_dir, converted_map), readers(original_dir, original_map)
        shards = sorted(set(original_map.values()))
        for number, shard in enumerate(shards, 1):
            tensors = {}
            for name in (n for n,s in original_map.items() if s == shard):
                reference = original[name]()
                tensor = reconstruct(name, reference, converted, original, consumed)
                if tensor.shape != reference.shape or tensor.dtype != reference.dtype:
                    raise ValueError(f'export dtype/shape mismatch: {name}')
                tensors[name] = tensor.contiguous()
                total_bytes += tensor.numel() * tensor.element_size()
            filename = f'model-{number:05d}-of-{len(shards):05d}.safetensors'
            save_file(tensors, output_dir/filename)
            index.update({name: filename for name in tensors})
            print(json.dumps({'shard':number,'shards':len(shards),'tensors':len(index)}), flush=True)
            del tensors
    if consumed != set(converted_map):
        raise ValueError(f'unmapped exported tensors: {sorted(set(converted_map)-consumed)[:20]}')
    for source in original_dir.iterdir():
        if source.is_file() and not source.name.endswith('.safetensors') and source.name != 'model.safetensors.index.json':
            shutil.copy2(source, output_dir/source.name)
    (output_dir/'model.safetensors.index.json').write_text(json.dumps(
        {'metadata':{'total_size':total_bytes},'weight_map':index},indent=2)+'\n')
    print(json.dumps({'complete':True,'tensors':len(index),'bytes':total_bytes,'converted_tensors_consumed':len(consumed)}),flush=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--converted-dir',required=True)
    parser.add_argument('--original-dir',required=True)
    parser.add_argument('--output-dir',required=True)
    args=parser.parse_args()
    repack(args.converted_dir,args.original_dir,args.output_dir)


if __name__=='__main__':
    main()
