# V2 migration evidence

本目录保存 Code-Prover-V2 frozen benchmark campaign 向 V3 迁移时必须长期保留的轻量
证据。它不是旧 runner 的副本，也不包含运行日志、模型输出、source checkout 或生成的
Harbor task payload。机器绝对路径放在 gitignored `benchmarks.local.toml`；本目录只绑定
逻辑 source、revision 和内容 hash。

## VeriCoding aligned Lean 4.28

- `formal-benchmark-campaign-v1.campaign.json`：V2 当时的四 benchmark registry 原文；
- `vericoding-lean428-source-manifest.json`：V2 138 条 compatibility overlay 的原始
  manifest，包含 original/overlay SHA、迁移理由、compile 结果和 review status；
- `vericoding-aligned-lean428-2012.json`：2,012 条 frozen selection 到 V3 Harbor
  task name/spec SHA 的完整映射，同时绑定上述两个 source artifacts 和 V3 dataset
  content hash。

V2 checkout 当时基于 `c05cd74ce5de8ba05fdf2d5b7e1d400dc96ce937`，但 registry 和
compatibility artifacts 位于未提交的 dirty worktree。因此 commit 只用于定位，不能充当
这些文件的 provenance；本目录保存的原文字节及 descriptor 中的 SHA 才是迁移输入证据。

默认离线验证 committed evidence；需要同时核对本机 pristine canonical 数据时显式传入
`--dataset`。运行视图从本机 pinned V2 source 生成：

```bash
python3 tools/migrate_vericoding_campaign.py verify
python3 tools/migrate_vericoding_campaign.py materialize
```

`materialize` 会在 `tasks/_campaign_views/` 为 1,874 个未变 task 创建相对 symlink，
并只在 ignored view 中复制、覆盖 138 个 Lean 4.28 compatibility task；canonical
`tasks/vericoding_lean` 不被修改。生成后重新校验 2,012 题的 view content SHA。

`apply --v2-root ...` 只重建 attestation metadata。运行时先校验 upstream revision、
selection CSV、ordered IDs、overlay manifest 和每个 original/overlay spec SHA，全部
匹配后才写 ignored view。

## PutnamBench aligned Lean 4.28

- `putnambench-aligned-lean428-672.json`：672 题到 canonical V3 task/spec 的逐题映射；
- `putnam-source-registry.json`：冻结的 source registry；
- `putnam-lean428-*`：Lean toolchain、Lakefile 和 Lake manifest 原文字节。

descriptor 同时绑定 upstream revision、ordered IDs、official/rewrite content aggregate、
Mathlib revision、672/672 V2 audit 和 materialized dataset content hash。Git 不保存
`tasks/putnambench_672/**`；离线验证 evidence、再从本机 pinned source 原子物化：

```bash
python3 tools/migrate_putnam_campaign.py verify
python3 tools/migrate_putnam_campaign.py materialize
```

生成器在输出任何 task 前完成 revision/registry/source/rewrite/Lake/toolchain hash 校验，
输出位于 `tasks/_campaign_views/` 并受 `.gitignore` 排除。

## VeriSoftBench filtered-context 500

- `verisoftbench-500.json`：500 个 ordered task identity、逐题 raw-record SHA 和 frozen
  native evaluator/prompt hashes；
- `verisoftbench-repos.json`：23 个 repository commit/toolchain pin。

源码和约 110 GB repository image 不进入 Git。`tools/migrate_verisoft_campaign.py`
先验 source release，再生成 image build context 和 ignored Harbor task view；grader 使用
原生 `LeanREPL` compile checker，保持 `fix_enabled=false`。

## Vero proof 44

- `vero-proof-44.json`：44 个 real instance、upstream revision/tree、逐 benchmark native
  snapshot SHA、Lean 4.29.1 和 proof-mode lifecycle。

该 descriptor 显式排除 `bankledger` exemplar 与 `tiny_unsat` fixture，并记录
`tasks/verobench_124` 不能替代此 campaign。`tools/migrate_vero_campaign.py` 校验 pinned
checkout 后生成 ignored Harbor task view；`vero/harbor_grade.py` 调用 upstream native
extract/build/axiom-audit，而不是 V3 通用单文件 grader。
