# CMD.md — 项目环境变量 & 常用命令速查

> key 的**值**一律只放 `.env`(gitignored),本文件只写变量名。严禁把 key 值
> 写进任何会提交的文件或回显到终端。

## 0. 万能前缀(几乎所有命令都要)

```bash
cd /mnt/VerifiableAILab/zenan.li/Code-Prover-V3
set -a && source .env && set +a
```

## 1. 环境变量(都在 `.env`,只列名字)

| 变量 | 用途 |
|---|---|
| `DPSK_API_KEY` | DeepSeek 网关 key(`https://llm-hub.apodex.app/v1`,header `X-Llmhub-Channel: 7`;另 agent 会**自动**给每个 trial 生成 `X-Llmhub-Session: <uuid4>`——llm-hub 账号池按此路由到固定账号,保 prompt cache 命中(命中价 1/10),per-trial 粒度,勿写死进 config) |
| `ALIYUN_E2B_API_KEY` | 内部 Aliyun e2b 平台 **SG** 集群 key(`agent.miro`) |
| `ALIYUN_E2B_API_KEY_JB` | 同平台 **JB/Johor** 集群 key(`agent.miro.jb`)——**key 按集群发,不能混用** |
| `ALIYUN_E2B_TEMPLATE` | 默认沙箱模板名(`zenan-allow-internet`) |
| `E2B_API_KEY` | 旧 e2b.dev(共享 team july-20-zenan,退役中) |

运行时可选(不在 `.env`,按需临时 export):

| 变量 | 用途 |
|---|---|
| `DISTILL_DATASET` | `tools/distill_ops.py` 的数据集根目录(默认 coding v2.1;math 用 `data/math-v0-unsolved-20260722`,coding 当前代 `data/coding-v2.3-unsolved-20260723`) |
| `DISTILL_CAMPAIGN` | distill_ops 的 job/config 前缀,避免多 campaign 撞名 |
| `PYTHONPATH=$PWD` | harbor run 需要(找到 `tools/`、`agents/`) |

集群域名、私有 CA、per-cluster key 选择逻辑都在 `tools/aliyun_clusters.py`
(`configure_env` 会自动写合并 CA bundle 并设 `SSL_CERT_FILE`)。

## 2. Python 环境

- **`.venv-aliyun`**:py3.12 + `e2b==2.23.0` 钉死(py3.13 拒私有 CA;
  e2b≥2.24 拒平台 UUID key)。**所有内部平台相关的东西都用它**,
  包括 harbor:`.venv-aliyun/bin/harbor`、`.venv-aliyun/bin/python`。
- 配方见 README「aliyun venv」一节。

## 3. 集群 / 模板 / 镜像

| | SG | JB (Johor) |
|---|---|---|
| 域名 | agent.miro | agent.miro.jb |
| key | `ALIYUN_E2B_API_KEY` | `ALIYUN_E2B_API_KEY_JB` |
| 模板 | zenan-allow-internet(10) / zenan-no-internet(10) | 同名 |
| 规格 | **2c/8GiB**(07-23 扩容,冒烟过) | **2c/8GiB**(07-23 扩容已生效) |
| 镜像 | `miromind-sg-registry-vpc.ap-southeast-1.cr.aliyuncs.com/verifiable-ai-lab/code-prover-lean:latest` | `apodex-sandbox-johor-registry-vpc.ap-southeast-8.cr.aliyuncs.com/math-rl/code-prover-lean:latest` |

- 镜像兜底(两集群通用):`docker.io/lizenan1995/code-prover-lean:latest`(首拉慢)。
- 平台 ALB 对 create ~600s 硬超时 → `claim_timeout_sec`/`wait_ready_timeout_sec` 设 **≤540**。
- 沙箱内无公网、默认 uid 1001 非 root(harbor exec 默认 root,没问题)。

检查集群沙箱规格(claim 一个、读 cgroup、自动 kill):

```bash
.venv-aliyun/bin/python tools/check_sandbox_spec.py --cluster sg          # 或 jb
.venv-aliyun/bin/python tools/check_sandbox_spec.py --cluster jb --fresh  # 强制新 pod(看扩容是否生效)
```

## 4. 蒸馏(harbor)

启动 / 断点续跑(同 job_name + jobs_dir 自动跳过已完成):

```bash
PYTHONPATH=$PWD nohup .venv-aliyun/bin/harbor run \
  -c configs/distill-math-round1-sg.yaml \
  > jobs/distill-math-round1.launch.log 2>&1 &
```

冒烟(SG,单题,8min E2E,期望 reward 1.0):

```bash
PYTHONPATH=$PWD .venv-aliyun/bin/harbor run -c configs/smoke-dpsk-distill-aliyun-sg.yaml
```

进度速查:

```bash
ls jobs/distill-math-round1 | wc -l                                   # 已开 trial 数
find jobs/distill-math-round1 -maxdepth 2 -name result.json | wc -l   # 已完成数
```

distill_ops(math campaign 必须带 `DISTILL_DATASET`,否则默认 coding v2.1):

```bash
export DISTILL_DATASET=$PWD/data/math-v0-unsolved-20260722
.venv-aliyun/bin/python tools/distill_ops.py status --job distill-math-round1 --total 5000
.venv-aliyun/bin/python tools/distill_ops.py rounds --round 2          # 物化下一轮任务目录
.venv-aliyun/bin/python tools/distill_ops.py config --round 2          # 渲染 harbor 配置(注意:模板还是 e2b.dev 风格,待切 aliyun)
.venv-aliyun/bin/python tools/distill_ops.py collect --jobs jobs/<job1> jobs/<job2> --out <out.jsonl> --solved-only
```

配置里的坑:自定义环境参数必须嵌在 `environment.kwargs` 下(顶层同名键静默忽略);
`enable_compaction: false` + `save_transcript: true` 是蒸馏标配;
高并发 + create_concurrency 限流时必须加顶层
`environment_build_timeout_multiplier: 3`(env-start 1800s 从排队开始计时,
不加则队尾成批超时);**改 config 后 resume 旧 job 要补三层存档**
(job/trial 级 config.json + lock.json,详见 TODO.md 已知坑)。

多轮 driver(materialize → config → harbor 串行连跑,启动前先
`pgrep -f run_math_rounds\|run_distill_rounds` 确认没有存活实例,**严禁双开**):

```bash
# coding 线(e2b.dev,.venv/bin/harbor)。模型可选:默认 deepseek-v4-pro@7,
# kimi-k3 走 channel 12(同一把 DPSK_API_KEY,07-24 验证;thinking 字段两家通用):
DISTILL_CAMPAIGN=v2.4 DISTILL_DATASET=$PWD/data/coding-v2.4-unsolved-20260724 \
  DISTILL_MODEL=kimi-k3 DISTILL_CHANNEL=12 DISTILL_MODEL_TAG=kimi \
  PYTHONPATH=$PWD nohup tools/run_distill_rounds.sh 1 3 \
  > jobs/distill-v2.4-rounds-driver.log 2>&1 & disown
# math 线(SG,.venv-aliyun/bin/harbor,base=configs/distill-math-round1-sg.yaml):
PYTHONPATH=$PWD nohup tools/run_math_rounds.sh 3 8 \
  >> jobs/distill-math-rounds-driver.log 2>&1 & disown
```

campaign 收官 → carve 下一代未解题数据集(v2.2→v2.3 即此工具产出):

```bash
python3 tools/carve_unsolved.py \
  --source data/coding-v2.2-unsolved-20260723 \
  --jobs jobs/distill-dpsk-v2.2-round{1,2,3,4} \
  --out data/coding-v2.3-unsolved-20260723 --seed 20260723 --round-size 5000
```

其它一次性工具:`tools/kill_jb_orphans.py`(批量清理 JB 泄漏沙箱,
按需改集群/过滤条件)。

## 5. 数据集(tools/dataset.py)

```bash
python tools/dataset.py make-math <out_dir> --from-jsonl a.jsonl b.jsonl   # 位置参数必须在 --from-jsonl 前面!
python tools/dataset.py validate <dataset_dir>
python tools/dataset.py refresh <dataset_dir>       # 按 task_flavor 重渲指令模板;需字节稳定
python tools/dataset.py manifest <dataset_dir>
```

- math flavor:单定理 + NL 题面只读注释,仅 `proof`/`proof_aux` 可编辑;
  题面 CRLF 已在生成期归一(否则 refresh 会悄悄改 spec 字节)。
- trial 的 transcript 在 `<trial>/agent/transcript.json`。

## 6. 纪律红线

- `data/` 不入 git(.gitignore 根锚定 `/data/`,别改回 `data/`);`.env` 严禁提交/回显。
- **长跑/花钱的启动(harbor 批量、RL 训练、重启也算)必须先跟 Zenan 确认。**
- 本地 docker 后端并发 ≤24(bridge 地址池上限)。
- DPSK 网关 UTC 15:50+ 有 429 风暴,agent 内建退避,不用干预。

## 7. RL 速记

- sglang 用 `nohup ... & disown` 起;`/generate` 要 `no_stop_trim: true`。
- RL/蒸馏都禁 compaction;ckpt 转换 `--mtp-num-layers 0`。
- 详细坑清单见 TODO.md「已知坑备忘」。
