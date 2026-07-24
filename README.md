# Code-Prover-V3

Lean 4 定理证明评测系统，构建在 [Harbor](https://github.com/harbor-framework/harbor)
（Terminal-Bench 2.0 官方 harness）之上。取代 Code-Prover-V2 自研的 agent 编排层
（`ExperimentRunner` / vendored opengauss harness），保留 V2 已验证的任务契约与
判分语义。架构详见 [DESIGN.md](DESIGN.md)。

V2 的分批迁移、功能取舍和最终退役门槛见 [MIGRATION.md](MIGRATION.md)。

**V3 不再使用 agent skill**（V2 的 `lean4-codeprover`）：纪律约束（spec 只读、禁
negation）改由 verifier 硬校验，任务说明全部自包含在 `instruction.md` 里，因此任务
与 agent 解耦——同一套任务可跑 claude-code / codex / terminus-2 / 本地 SFT。注意
V2 的历史分数是带 skill 跑出来的，与 V3 数字不可直接对比；要做 skill A/B 时按
`images/lean-mathlib/Dockerfile` 中注释把 skill 加回镜像即可。

## 快速开始

```bash
# 0) 依赖：docker + docker compose v2 插件、uv；harbor 需要 Python >= 3.13
uv venv .venv --python 3.13
uv pip install -p .venv/bin/python -r requirements-harbor.txt
# DSW 的 docker 没有 compose 插件，装一次即可：
#   mkdir -p ~/.docker/cli-plugins && curl -fsSL -o ~/.docker/cli-plugins/docker-compose \
#     https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
#     && chmod +x ~/.docker/cli-plugins/docker-compose

# 1) 构建共享基底镜像（预构建包树在 images/lean-mathlib/lean-packages/，V3 自持）
images/lean-mathlib/build.sh                 # -> code-prover-lean:latest

# 2) 数据集就是 tasks/ 下的 Harbor task 目录（唯一格式，无 JSONL 中间层）。
#    V2 的 10 个存量 benchmark 已一次性转换完毕，直接用；新数据这样生成：
python3 tools/dataset.py make --from-lean-dir <目录> tasks/<名字>   # 每个 .lean 一个任务
python3 tools/dataset.py make-math tasks/<名字> --from-jsonl <记录.jsonl>...  # math 题源（单定理+sorry）

# 3) 跑评测（凭证放环境变量，不要写进配置文件）
export ANTHROPIC_API_KEY=...   # 或 ANTHROPIC_BASE_URL + ANTHROPIC_AUTH_TOKEN 走网关
.venv/bin/harbor run -c configs/prove-claude.yaml

# 结果与轨迹
.venv/bin/harbor view          # web viewer 浏览 trajectory
cat jobs/<job_name>/result.json

# 可审计汇总：读取 Harbor lock + 每个 trial result/reward + task manifest
python3 tools/harbor_results.py summarize jobs/<job_name> --tasks-root tasks
python3 tools/harbor_results.py verify jobs/<job_name>/audit/summary.json
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

## 可审计评测汇总

`tools/harbor_results.py` 不依赖 Harbor Python internals，直接读取持久化产物：

- job `lock.json` 是冻结的 planned-trial 清单；
- 每个 trial 的 `result.json` 是逐题 runtime 真相；
- embedded rewards 必须与 `verifier/reward.json` 完全一致；
- task metadata、dataset `manifest.json`、spec SHA、Harbor task checksum 和 lock
  digest 分开保存，不把不同 identity 混称；
- 运行该工具的代码版本从自身 tracked module 反查 Git，无法证明时返回 null 并
  fail closed，绝不借用 operator cwd 的 commit。

当前持久化 schema 与 smoke/full-run 证据固定在 Harbor 0.20.0，安装入口见
`requirements-harbor.txt`。汇总器遇到其他 Harbor 版本会保留诊断但 fail closed；升级时
必须先补对应 fixture/真实 job 验证，再扩充 supported-version 集合。

输出在 `<job>/audit/`：

- `trials.jsonl`：标准化逐 trial 记录；
- `issues.jsonl`：missing、infra、schema/hash/reward 不一致；
- `summary.json`：按 agent/model/dataset arm 聚合的 observed strict pass@k、
  p50/p90 usage/walltime、paired outcomes 和完整 input hash binding。

observed strict pass@k 不是组合估计器：每题实际计划的 k 次尝试中至少一次严格通过才
算通过。只有所有 k 次均为 scoreable（严格通过或正常失败）时 official `pass_at_k`
才非 null；infra/missing 时只报告明确命名的 provisional lower bound。默认 incomplete
退出码为 2；`--allow-incomplete` 只改变退出码，不改变 null 语义。

## 布局

| 路径 | 内容 |
|---|---|
| `images/lean-mathlib/` | 共享基底镜像：elan/Lean(v4.28.0) + 烘焙 Mathlib oleans（`lean-packages/`，V3 自持）+ repl + lean-rs-mcp + claude CLI |
| `verifier/` | 判分器（每个 task 的 `tests/` 由此拷贝）：五重校验，见下文判分语义 |
| `tools/dataset.py` | 数据集工具：`make`（从 .lean 目录生成）、`make-math`（math 题源 jsonl → 单定理任务，NL 题面进只读注释，flavor 记在 task.toml）、`refresh`（判分器升级后批量重刷派生文件，spec 不动，按 flavor 选 instruction 模板）、`validate` |
| `tools/harbor_results.py` | Harbor-native 可审计 trial/pass@k/paired 汇总与 hash-chain 验证 |
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

## 数据入库政策（2026-07-21 定）

- **基准评测集进 git**（`tasks/verina_canonical_189`、`tasks/minif2f-*`、
  `tasks/trainset_problems_300` 等）：它们的 Lean spec 源就是 canonical 版本，
  仓库即唯一事实来源，删了就没了。
- **批量生成的数据一律放 `/data/`（gitignored）**：蒸馏轮次、rescue 集、SFT 导出
  等由 `tools/distill_ops.py` 从 `data/<dataset>/tasks/` + `rounds_assignment.json`
  重新物化，不进 git。每个数据集目录带 `manifest.json`（per-task spec sha256 +
  聚合 content hash，`tools/dataset.py manifest` 生成）用于对账。
- 生成 task 目录的唯一原语是 `tools/dataset.py write_task`；衍生文件
  （grader、instruction、Dockerfile）用 `dataset.py refresh` 批量重写，
  不要手改单个任务。

## 蒸馏campaign操作（tools/distill_ops.py）

```bash
# 物化第 N 轮 / 生成该轮 harbor 配置
.venv/bin/python tools/distill_ops.py rounds --round 2
.venv/bin/python tools/distill_ops.py config --round 2

# 进度、质量与成本外推
.venv/bin/python tools/distill_ops.py status --job jobs/distill-dpsk-round1 --total 5000

# 一轮跑完后：把没干净完成的任务做成 rescue 集
.venv/bin/python tools/distill_ops.py rescue --job jobs/distill-dpsk-round1 --round round1

# 合并 job（含 rescue）导出 SFT 轨迹（默认丢弃 compaction 轨迹）
.venv/bin/python tools/distill_ops.py collect \
    --jobs jobs/distill-dpsk-round1 jobs/distill-dpsk-round1-rescue \
    --out data/coding-v2.1-full-20260721/sft/round1.jsonl --solved-only
```

## 内部 Aliyun 沙箱平台（e2b-proxy）

蒸馏/评测可跑在公司自建集群（SG=`agent.miro` / JB=`agent.miro.jb`，VPC-only）。
客户端必须用 pinned venv（平台私有 CA 与 key 格式的限制）：

```bash
uv venv --python 3.12 .venv-aliyun
uv pip install --python .venv-aliyun/bin/python "harbor==0.20.0" "e2b==2.23.0" tenacity httpx pyyaml
# e2b 2.23 缺 harbor eager-import 的 SandboxNetworkUpdate（2.24+ 才有），补 stub：
cat >> .venv-aliyun/lib/python3.12/site-packages/e2b/sandbox/sandbox_api.py <<'PATCH'


class SandboxNetworkUpdate(dict):
    """harbor-compat stub; aliyun mode no-ops the update_network path."""
PATCH
```

运行：`ALIYUN_E2B_API_KEY=... .venv-aliyun/bin/harbor run -c configs/smoke-dpsk-distill-aliyun.yaml`。
环境 kwargs 见 `tools/e2b_env.py` aliyun 模式（sandboxset + ACR 镜像 claim 时替换，
无模板构建）；域名/CA 在 `tools/aliyun_clusters.py`。SSL_CERT_FILE 用系统 CA + 私有
CA 合并 bundle（只放私有 CA 会把进程里 DPSK 网关等所有 TLS 打挂）。
