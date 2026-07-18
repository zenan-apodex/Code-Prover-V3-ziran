# Code-Prover-V3 设计文档

> V3 = 用 [Harbor](https://github.com/harbor-framework/harbor)（Terminal-Bench 2.0 官方 harness）
> 替换 V2 自研的 agent 编排层（`ExperimentRunner` / `agents/` / vendored opengauss harness），
> 保留 V2 已验证的领域资产：Lean 4 spec 任务契约、判分语义、agent skill、（可选的）formalize pipeline。

## 1. 动机

V2 的问题不在领域逻辑，而在编排层：

- `prover/vendor/opengauss/`（~76 个文件）是一套自维护的 agent harness，与 mini-swe-agent 派生代码耦合，升级/维护成本高；
- `ExperimentRunner` 手写了并行调度、checkpoint/resume、Docker 隔离、重试——这些正是 Harbor 的本职功能；
- 自研判分/结果目录格式，无法直接复用社区工具（trajectory viewer、rollout 导出给 RL 等）。

Harbor 直接提供：任务容器化隔离、内置 claude-code/codex/terminus 等 agent、`--n-concurrent` 并行、
失败重试、云端 provider（Daytona/Modal）横向扩展、标准 trajectory 格式与 viewer、RL rollout 导出。

## 2. V2 → V3 映射

| V2 组件 | V3 对应 | 说明 |
|---|---|---|
| `runner/experiment_runner.py`（并行调度、checkpoint） | **Harbor job**（`harbor run`，`--n-concurrent`） | 删除，交给 Harbor |
| `runner/task_runner.py` + `workspace.py`（每任务工作区） | **Harbor task 容器**（每 task 一个 Docker 环境） | 删除 |
| `agents/claude_direct.py` + vendored opengauss | Harbor 内置 **claude-code agent**（首选）；本地 SFT 模型走 OpenAI 兼容端点 | 删除 vendored harness |
| `agents/codex.py` | Harbor 内置 **codex agent** | 删除 |
| `core/task_discovery.py`（JSONL → .lean 物化） | **`tools/dataset.py`**：Harbor task 目录是唯一数据集格式（2026-07-17 起 JSONL 退役），`make --from-pipeline` 直读 pipeline 存储 | 存量 10 个 benchmark 已一次性转换 |
| `docker/lean4.Dockerfile`（Lean+Mathlib 环境） | **`images/lean-mathlib/`** 共享基底镜像 + 每 task 薄层 Dockerfile | 沿用烘焙 Mathlib oleans 的做法 |
| `analysis/`（sorry/编译/axiom 判分） | **task 内 verifier**（`tests/test.sh` → `/logs/verifier/reward.txt`） | 判分语义原样保留 |
| `analysis/warm_repl_grader.py` | 不再需要中央 warm REPL：判分在各自容器内进行，互不争抢 | 容器内冷编译（oleans 已烘焙，秒级 import） |
| `prover/agents/standard/`（SKILL.md + references + scripts） | **抛弃**（2026-07-17 决定）：纪律约束交给 verifier 硬校验，任务说明自包含于 instruction.md，任务与 agent 解耦 | 要 A/B 时按 Dockerfile 注释加回 |
| `collectors/` + `comparators/`（汇总、统计比较） | Harbor 内置 metrics（mean reward）+ `tools/`薄层脚本 | 大幅简化 |
| `configs/*.yaml` | **Harbor job config** | 见 Harbor 文档 |
| `pipeline/`（formalize 上游） | **弃用**（2026-07-17 决定）：不再产新 spec 数据；存量 benchmark 已全部转为 task 目录 | 需要新数据时用 `dataset.py make --from-lean-dir` |
| `server/`（sglang 本地 SFT 服务） | 脚本拷入 V3 `server/` 备用；agent 通过 OpenAI 兼容 base_url 指向它 | V2 格式的 prove 配置未拷贝 |

## 3. 判分语义（与 V2 对齐）

`solved == true` 当且仅当（在 task 容器内、agent 结束后由 verifier 判定）：

1. task `.lean` 文件里 **sorry 数为 0**（注释中的 sorry 不算，语义同 V2 `sorry_analyzer.py`）；
2. `lake env lean <file>` **编译通过**（0 error）；
3. **axiom check 通过**：`#print axioms` 只含标准公理（propext / Quot.sound / Classical.choice），
   语义同 V2 `check_axioms_inline.sh`；
4. **规格未被篡改**：spec 区（precondition/postcondition/theorem 声明）与原始任务逐字节一致
   （V2 靠 agent 自律 + 审计，V3 在 verifier 里硬校验 —— 改进点）。

reward = 1.0 / 0.0，写入 `/logs/verifier/reward.txt`（Harbor 契约）。

## 4. 仓库结构（本目录）

```
Code-Prover-V3/
├── DESIGN.md                  # 本文档
├── README.md                  # 使用说明
├── images/lean-mathlib/       # 共享 Lean4+Mathlib 基底镜像（烘焙 oleans + skill + CLIs）
├── tasks/                     # 数据集本体（Harbor task 目录，唯一格式）
├── tools/
│   └── dataset.py             # make（from-pipeline / from-lean-dir）/ refresh / validate
├── verifier/                  # 判分器源（refresh 时拷入每个 task 的 tests/）
├── configs/                   # harbor run 的 job 配置
└── .venv/                     # harbor CLI（Python 3.13）
```

## 5. 待定项

- [x] 本地 SFT 的忠实评测：`agents/qwen_native_agent.py`（codec 从主线
  `protocols/qwen_native_v1.py` 原样移植；union-v1 工具面 = Claude Code 核心工具
  over environment.exec + lean-lsp MCP 经容器内常驻 bridge，warm REPL 保持）。
- [ ] instruction 的 autonomous 结尾句对新模型是否仍有增益 —— 拿真实评测做 A/B 后决定去留。
- [ ] 大数据集分发：需要跨团队共享时走 `harbor publish`（dataset.toml + sha256 digest）。
