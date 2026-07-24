# Code-Prover-V2 → V3 渐进迁移与退役计划

本文是 V2 功能迁移和最终退役的状态账本。V3 是目标仓库；V2 在所有退役门槛满足前
保持可读、可复现，不直接删除。

## 迁移原则

1. **迁能力，不迁旧架构。** 以用户可见行为、数据契约和验收测试为迁移单元，在
   Harbor/V3 上原生实现；不合并两个无共同历史的仓库，也不默认 cherry-pick V2
   提交。
2. **一个 feature 一个原子提交。** 仓库 owner 指定迁移集成分支为
   `ziran/v2-migration`；每个 feature 仍须记录 V2 完整 SHA/路径、V3 实现、测试
   证据和回滚方式，禁止把无关迁移揉成一个提交。
3. **先建立验收门，再迁高风险能力。** verifier、数据 manifest、结果 provenance
   和正/负 smoke 是后续迁移的基础。
4. **明确 abandon。** V3 已由 Harbor 替代的组件不以“以后也许有用”为由继续搬运；
   只有实测发现能力缺口时才按 V3 方式重写。
5. **不丢本地状态。** V2 的 local-only refs、stash、tracked/untracked 改动全部完成
   分类和持久化之前，不执行 archive/delete/clean。

## 2026-07-21 基线

- V3：`main@7a133f6bc3fc6c81ef2ce3d255236ce455ba966f`，remote
  `git@github.com:Lizn-zn/Code-Prover-V3.git`。
- Harbor runtime/schema 固定为 `0.20.0`（`requirements-harbor.txt`）；升级必须补
  persisted lock/result fixture 与真实 job gate。
- V2 主 checkout：`ziran/formalization-ops@c05cd74`，比 upstream 领先 2 commits。
- V2 主 checkout 仍有 62 个 tracked 改动（`+2078/-380`）和 246 个 untracked
  文件；另有两个 stash。
- 必须保全的 local-only 分支至少包括
  `codex/official-miles-sync-migration@025d18b` 和
  `codex/claude-direct-worker-refactor@ae1ec64`。
- `ziran/rl-sandbox` worktree 还有未跟踪的 E2B 文件。
- V2 没有 release tag，迁移来源必须记录完整 commit SHA。
- V2 `8c208c1` 是约 100 文件的混合提交，并包含生成 workspace；禁止整提交迁移。

### 基线验证结果

在 `ziran/v2-migration` 上完成：

- `python3 -m compileall -q agents tools verifier rl`：通过；
- `python3 tools/dataset.py validate tasks/_smoke`：`1/1` valid；
- `python3 tools/dataset.py validate tasks/verina_canonical_189`：`189/189` valid；
- `python3 tools/dataset.py validate tasks/vericoding_lean`：`6368/6368` valid；
- `images/`、`rl/`、`server/` 和 `_smoke` 下 shell 脚本 `bash -n`：通过。

Harbor oracle/nop runtime smoke 尚未执行：本 checkout 没有安装 Harbor CLI。Docker
client 可用；安装 V3 的 Python 3.13/Harbor 环境后补跑并把结果追加到这里。

## 能力矩阵

状态含义：`V3 原生` 表示已有 V3 实现但仍需持续回归；`待重写` 表示保留行为、按
V3 架构实现；`部分覆盖` 表示已有基础但尚未证明与 V2 关键契约等价；`Abandon`
表示明确不迁旧实现。

| 能力 | 状态 | V3 方向 / 验收重点 |
| --- | --- | --- |
| Harbor task 目录、历史 benchmark 数据 | V3 原生 | `manifest.json` fail-closed 校验；受影响数据集逐个 `validate` |
| sorry/spec/forbidden/compile/axiom 五重 verifier | V3 原生 | oracle 必须通过、nop 必须失败；规格投影和允许公理集合回归 |
| Lean 4.28 + Mathlib 基底镜像 | V3 原生 | 固定 toolchain/profile；不得静默混入 pipeline 4.29 产物 |
| Claude/Codex 调度、并发、resume、workspace | V3 原生 | 使用 Harbor；不迁 `ExperimentRunner`/`TaskRunner` |
| qwen-native、本地 SFT、第三方模型 | V3 原生 | 协议编码、context/truncation、task-file 恢复 smoke |
| E2B 评测后端 | V3 原生 | 与本地 oracle 的 reward/grade_details 一致性 |
| SGLang model server | 部分覆盖 | 核对 V2 `a8d7cb5` 的 context soft-limit 行为，不复制旧 prove configs |
| Miles token-level episode + checkpoint convert | 部分覆盖 | 补 source provenance、preflight、resume/offload 验收；先决定 sync/async contract |
| 可审计 pass@k、paired metrics、source attestation | V3 原生（首版） | `tools/harbor_results.py`；仍需 Harbor oracle/nop 新跑与跨 agent paired 实跑 |
| Putnam/VeriSoft/VeriCoding/Vero campaign | 部分覆盖 | 先做数据集清单差异；缺失数据按 task+manifest 原子迁移 |
| agent deadline/budget/truncation/repair guards | 部分覆盖 | 逐行为对照，不迁 `claude_direct` 大文件或其重构历史 |
| V2 Web/API/data panel | Abandon（默认） | 使用 Harbor viewer；只有实测缺口才做 V3 薄层工具 |
| vendored opengauss/自研 agent harness | Abandon | Harbor/独立 V3 agents 已替代 |
| formalization `pipeline/` 及 release 脚本 | Abandon | V3 不再生产 spec；若未来使用 `harbor publish`，重新实现发布安全门 |
| agent skill `lean4-codeprover` | Abandon | 纪律由 instruction + verifier 强制；仅作为显式 A/B 变量 |
| JSONL 中间数据格式 | Abandon | task 目录是唯一 canonical 格式 |
| 生成 workspace、jobs、结果、模型权重 | Abandon | 仅归档必要证据，禁止迁入 Git |

## 执行顺序

### 0. 冻结和保全 V2

- 只允许修复迁移阻塞或补充归档信息，不再向 V2 增加新产品 feature。
- 为 local-only refs 建立耐久备份；展开两个 stash 并判断是否已被现有分支吸收。
- 把 dirty tree 至少拆为：benchmark campaign、Physics/Chemistry 数据、coding
  reuse/rejudge/release 运维三组；生成产物单独排除。
- 不删除大小写相近目录或 prunable worktree，直到目标和可恢复性逐项确认。

### 1. 固定 V3 基线门

- 非 task Python 源码通过编译检查。
- `_smoke` 和代表性正式数据集通过 `tools/dataset.py validate`。
- Harbor oracle-positive 与 nop-negative smoke 通过。
- 记录当前 V3 commit、镜像 digest、Harbor 版本和 task manifest hash。

### 2. 迁移可审计评测契约

- [x] 以 V2 `a531eda76deb80c412df6c84266fad9585d9c13c`、
  `3b3a08b50c2ca395991ddd182161bed550694da1`、
  `eb911977ad5817e316100192d49fcda9efede14c` 为行为来源，实现 Harbor-native 的
  source attestation、paired outcomes、usage distributions 和 observed strict pass@k。
- [x] 不迁 V2 runner；`tools/harbor_results.py` 只读 Harbor 0.20 持久化的 job
  `lock.json`、逐 trial `result.json`/raw reward，以及 V3 task metadata/manifest。
- [x] incomplete 时 official pass@k 保持 null，provisional lower bound 单列；
  embedded/raw reward 不一致、grader crash、manifest/spec drift 和 unattestable source
  均 fail closed。
- [x] 在既有 Harbor 0.20.0 产物上验证：oracle job 恢复 1/1 strict pass；
  Qwen Verina-189 job 恢复 189/189 scoreable、135 strict pass，observed pass@1 为
  71.4286%；两份生成报告的 input/output hash 自检通过。报告属于 ignored `jobs/`
  验证产物，不提交。
- [ ] 安装当前 Harbor 后重跑 oracle-positive、nop-negative，以及同一 job 的双 arm
  paired smoke；把新 run 的 report hash 追加到本节。

### 3. 补齐 benchmark campaign

- 对比 V2 frozen manifests/4.28 overlays 与 V3 `tasks/`，先输出缺失/等价/冲突清单。
- 数据、task metadata、verifier 快照、manifest 和配置作为一个原子 feature。

### 4. 收敛 RL/Miles

- 先确定 V3 对 Miles 的 artifact/contract 边界以及 sync/async 选择。
- 再按顺序补：source provenance → preflight → checkpoint resume/offload → E2B
  transport/runtime；不 vendor 整个 Miles。
- 重点审计 V2 local-only `codex/official-miles-sync-migration` 和两个 stash。

### 5. 只按证据补能力缺口

- 对 context limit、deadline/budget、truncation recovery、task-file restore 等行为做
  小型 fixture/A-B；V3 已满足时记录为 covered，不复制实现。
- Harbor viewer 或 publisher 真实缺功能时才加薄层工具。

### 6. 退役 V2

只有下面所有门槛满足后，才把旧 GitHub 仓库设为 archived/read-only，并最后处理本地
checkout：

- 能力矩阵每项均为已验收、明确 abandon 或有独立长期 owner；
- V2 所有 local-only refs、stash、tracked/untracked 改动均已持久化并审计；
- 所有 V2 worktree clean，且没有运行中的 eval/solver 依赖它们；
- V3 在代表性 benchmark 上完成 oracle/nop、至少一个真实模型和所选 RL 路径验证；
- 生产 run manifest 不再引用 V2 commit、V2 配置或 V2 本地路径；
- 文档、CI、启动脚本和团队入口全部指向 V3；
- V2 最终 commit/ref 清单与恢复说明已保存。

## 单 feature 完成定义

每个迁移 PR 至少包含：

1. V2 来源（完整 SHA、路径、保留的行为）；
2. V3-native 设计和明确未迁内容；
3. focused tests/fixtures；
4. 相关 dataset validate 与正/负 smoke 结果；
5. provenance/manifest 更新；
6. 回滚方式及本表状态更新。
