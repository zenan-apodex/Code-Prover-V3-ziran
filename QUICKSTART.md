# Quickstart — 新机器从零到跑评测

假设：机器能访问 `/mnt` 共享存储（CPFS）、有 docker、（评本地 SFT 需要）有 GPU。

## 1. 代码与环境

```bash
git clone https://github.com/Lizn-zn/Code-Prover-V3.git && cd Code-Prover-V3

# harbor 需要 Python >= 3.13
uv venv .venv --python 3.13
uv pip install -p .venv/bin/python -r requirements-harbor.txt

# DSW 的 docker 缺 compose v2 插件，装一次：
mkdir -p ~/.docker/cli-plugins && curl -fsSL -o ~/.docker/cli-plugins/docker-compose \
  https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-linux-x86_64 \
  && chmod +x ~/.docker/cli-plugins/docker-compose
docker compose version   # 确认可用
```

## 2. 基底镜像 `code-prover-lean:latest`

预构建包树（6.9G Mathlib oleans）不在 git 里，镜像二选一获取：

**方式 A（推荐，~2 分钟）**：从共享盘直接 load 导出好的镜像

```bash
docker load -i /mnt/VerifiableAILab/zenan.li/Code-Prover-V3/code-prover-lean.tar
```

**方式 B（自建，~30-60 分钟）**：先从任一已构建机器种入包树再 build

```bash
cp -al /mnt/VerifiableAILab/zenan.li/Code-Prover-V3/images/lean-mathlib/lean-packages \
       images/lean-mathlib/lean-packages
images/lean-mathlib/build.sh          # DOCKER_BUILDKIT=0 + --network=host 已内置
```

## 3. 冒烟验证（1 分钟，不需要任何模型/密钥）

```bash
.venv/bin/harbor run -c configs/smoke-oracle.yaml   # 期望 reward = 1.0
.venv/bin/harbor run -c configs/smoke-nop.yaml      # 期望全部 reward = 0.0
```

## 4A. 评本地 SFT 模型（qwen-native-v1 agent）

```bash
# 起 sglang（模型在 CPFS 上，serve.local.yaml 已指好路径）
cd server && CONFIG=$PWD/serve.local.yaml TP=1 nohup bash serve_sglang.sh > serve.log 2>&1 &
cd .. && until curl -sf http://127.0.0.1:8000/v1/models >/dev/null; do sleep 10; done
# 多卡机器把 TP 改成卡数（如 TP=8），并发和速度直接翻倍

# 跑（PYTHONPATH 必须指到仓库根，qwen agent 从 agents/ 导入）
PYTHONPATH=$PWD .venv/bin/harbor run -c configs/prove-local-sft.yaml
```

Verina-189 全量正式评测（充足预算：4h/任务、384 calls）：

```bash
PYTHONPATH=$PWD .venv/bin/harbor run -c configs/prove-verina189-full.yaml
# 断点续跑：中断后重新执行同一命令即可
```

## 4B. 评 claude-code

```bash
export ANTHROPIC_API_KEY=...   # 或网关: ANTHROPIC_BASE_URL + ANTHROPIC_AUTH_TOKEN
.venv/bin/harbor run -c configs/prove-claude.yaml
```

## 5. 结果

- 每个 trial：`jobs/<job_name>/<trial>/`（`result.json`、`verifier/reward.json`、
  `verifier/grade_details.json`、agent 轨迹）
- 断点续跑：同 `job_name` + `jobs_dir` 重新执行同一命令即可
- 浏览轨迹：`.venv/bin/harbor view`

## 常见问题

| 症状 | 原因/处理 |
|---|---|
| `unknown flag: --project-name` | compose 插件没装，回到第 1 步 |
| docker 挂载报 `authorization denied` | DSW authZ 只允许 `/mnt` 下的 bind-mount，别用 `/tmp` |
| 任务全部 build 失败 | 镜像没 load/build，回到第 2 步 |
| qwen agent `ModuleNotFoundError: agents` | 没设 `PYTHONPATH=$PWD`，且必须从仓库根运行 |
| sglang 400 / 上下文溢出 | agent 内置 100k 软限 + compaction，正常不应触发；确认 served ctx 131072 |

判分语义、数据集维护（`tools/dataset.py make/refresh/validate/manifest`）、架构说明见
[README.md](README.md) 与 [DESIGN.md](DESIGN.md)。
