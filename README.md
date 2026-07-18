# Code-Prover-V3

Lean 4 定理证明评测系统，构建在 [Harbor](https://github.com/harbor-framework/harbor)
（Terminal-Bench 2.0 官方 harness）之上。取代 Code-Prover-V2 自研的 agent 编排层
（`ExperimentRunner` / vendored opengauss harness），保留 V2 已验证的任务契约与
判分语义。架构详见 [DESIGN.md](DESIGN.md)。

**V3 不再使用 agent skill**（V2 的 `lean4-codeprover`）：纪律约束（spec 只读、禁
negation）改由 verifier 硬校验，任务说明全部自包含在 `instruction.md` 里，因此任务
与 agent 解耦——同一套任务可跑 claude-code / codex / terminus-2 / 本地 SFT。注意
V2 的历史分数是带 skill 跑出来的，与 V3 数字不可直接对比；要做 skill A/B 时按
`images/lean-mathlib/Dockerfile` 中注释把 skill 加回镜像即可。

## 快速开始

```bash
# 0) 依赖：docker + docker compose v2 插件、uv；harbor 需要 Python >= 3.13
uv venv .venv --python 3.13 && uv pip install -p .venv/bin/python harbor
# DSW 的 docker 没有 compose 插件，装一次即可：
#   mkdir -p ~/.docker/cli-plugins && curl -fsSL -o ~/.docker/cli-plugins/docker-compose \
#     https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
#     && chmod +x ~/.docker/cli-plugins/docker-compose

# 1) 构建共享基底镜像（预构建包树在 images/lean-mathlib/lean-packages/，V3 自持）
images/lean-mathlib/build.sh                 # -> code-prover-lean:latest

# 2) 数据集就是 tasks/ 下的 Harbor task 目录（唯一格式，无 JSONL 中间层）。
#    V2 的 10 个存量 benchmark 已一次性转换完毕，直接用；新数据这样生成：
python3 tools/dataset.py make --from-lean-dir <目录> tasks/<名字>   # 每个 .lean 一个任务

# 3) 跑评测（凭证放环境变量，不要写进配置文件）
export ANTHROPIC_API_KEY=...   # 或 ANTHROPIC_BASE_URL + ANTHROPIC_AUTH_TOKEN 走网关
.venv/bin/harbor run -c configs/prove-claude.yaml

# 结果与轨迹
.venv/bin/harbor view          # web viewer 浏览 trajectory
cat jobs/<job_name>/result.json
```

## 端到端 smoke（不需要 LLM）

```bash
.venv/bin/harbor run -c configs/smoke-oracle.yaml   # oracle 跑标准答案，期望 reward=1.0
.venv/bin/harbor run -c configs/smoke-nop.yaml      # nop 什么都不做，期望 reward=0.0
```

## 数据集维护

- **生成**：`tools/dataset.py make --from-lean-dir <目录> tasks/<名字>`（每个 .lean
  文件一个任务，递归）。
- **重刷**：判分器（`verifier/`）、instruction 模板、超时、镜像名升级后，
  `tools/dataset.py refresh tasks/*` 批量重写所有派生文件；`environment/task.lean`
  （spec 本体）和 `[metadata]` 永不触碰。
- **校验**：`tools/dataset.py validate tasks/<名字>`（结构完整性 + original.lean 与 spec
  一致 + 判分器不过期 + **manifest fail-closed 校验**）。
- **manifest**：每个数据集根有 `manifest.json`（每任务 spec 的 sha256 + 聚合
  content_sha256 + lean_profile），`make` 自动生成，spec 变动后用
  `tools/dataset.py manifest tasks/<名字>` 重建；validate 对其 fail-closed。
- JSONL 中间格式已于 2026-07-17 退役；V2 的 10 个存量 benchmark 已全部转换为 task 目录。
- **miniF2F**（2026-07-17 转入）：`minif2f-test-244`（与主线
  benchmarks/manifests/minif2f-test-244.jsonl 字节一致）与 `minif2f-valid-243`
  （从 google-deepmind/miniF2F 上游 Valid.lean 切分：answer(x) 内联为 (x)、剔除 12 个
  .variants.* 变体与 1 道依赖 FormalConjectures nthRoot 的 mathd_algebra_282，
  243/243 在容器内编译通过）。均为 proof-completion（只有 proof 区可写）。

## 布局

| 路径 | 内容 |
|---|---|
| `images/lean-mathlib/` | 共享基底镜像：elan/Lean(v4.28.0) + 烘焙 Mathlib oleans（`lean-packages/`，V3 自持）+ repl + lean-rs-mcp + claude CLI |
| `verifier/` | 判分器（每个 task 的 `tests/` 由此拷贝）：五重校验，见下文判分语义 |
| `tools/dataset.py` | 数据集工具：`make`（从 .lean 目录生成）、`refresh`（判分器升级后批量重刷派生文件，spec 不动）、`validate` |
| `tasks/` | **数据集本体**（canonical 格式，每个子目录一个数据集） |
| `configs/` | `harbor run -c` 的 job 配置 |
| `jobs/` | Harbor 运行输出（每 trial 的 reward、日志、trajectory） |

## 判分语义（对齐主线 V2 严格口径，见 verifier/grade.py）

`reward = 1.0` 当且仅当五项全过（子项作为 sub-metric 写入 `reward.json` 便于归因）：

1. **sorry_free** — 全文无 sorry（注释豁免）；
2. **spec_intact** — 字节级只读投影比对（移植主线 `benchmark_integrity.py`）：只允许改
   `solution_aux/code_aux/code/proof_aux/proof` 五个 marker 区的内容，**import 是只读的**，
   marker 结构（增删/嵌套/错配）任何变化都判负；
3. **forbidden_free** — 源码扫描（注释/字符串豁免）：`axiom`/`constant`/`opaque`/`unsafe`
   声明与 negation 工作流一律判负（移植主线 `acceptance_audit` 禁用构造模式）；
4. **compiled** — `lake env lean` 零错误；
5. **axioms_ok** — 原始 spec 中每个定理 `#print axioms` ⊆ {propext, Classical.choice,
   Quot.sound}。

verifier 的 `tests/` 在 agent 阶段结束后才被上传进容器，agent 无法篡改判分器或原始 spec。

## 常用操作

```bash
# 单任务调试（强制重建镜像，保留容器现场）
.venv/bin/harbor run -p tasks/smoke5/oci__00__0004a45321006f094de84bb462743fff \
    -a claude-code -m anthropic/claude-opus-4-8 --no-delete

# 并发与 pass@k
.venv/bin/harbor run -c configs/prove-claude.yaml -n 16 -k 4

# 断点续跑：同一 job_name + jobs_dir 重新执行即可（Harbor 自动恢复已完成 trial）
```

## 与 V2 的差异 / 迁移说明

- V2 的 formalize `pipeline/` **已弃用**（2026-07-17 决定，不再造新 spec 数据）；
  `server/`（sglang 本地 SFT 服务脚本）已拷入 V3 `server/` 备用。本地 SFT 评测见
  `configs/prove-local-sft.yaml`（V2 的 Qwen native tool protocol 需要自定义
  agent，见 DESIGN.md §5 待定项）。
- V2 的 warm REPL 中央判分器不再需要：判分在各自容器内进行，Mathlib oleans 已烘焙。
- 镜像已完全自持：预构建包树在 `images/lean-mathlib/lean-packages/`（gitignore），
  不再依赖 V2 checkout；V2 的 Tacs/quickcheck 自定义 Lean 库、codex CLI 预装、
  code/proof 模式概念、V2 风格 summary.json 均已移除（2026-07-17 清理）。
- 安全提醒：V2 `configs/prove.yaml` 里提交过一个真实 API key，请尽快轮换；V3 的凭证
  一律走环境变量。
