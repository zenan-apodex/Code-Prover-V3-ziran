# TODO — 下一步(更新于 2026-07-22)

## 当前状态快照

- **蒸馏主线(dpsk → SFT 数据)**:数据集 `data/coding-v2.1-full-20260721`
  (25,880 题,6 轮 = 5×5000 + 880,seed 20260721)。Round1 进度:
  4,468/5,000 clean(1,895 solved,42.4%),**532 题待补**(e2b.dev 沙箱
  07-22 05:49-06:07 UTC 被池控制器误杀)。transcript 蒸馏链路已验证:
  think 覆盖 99.97%+,codec 可逐字回放;每题均值 ~1.2M in / 33K out tokens,
  round1 成本预估 $307-$1,155(视 prompt cache 命中)。
- **内部 Aliyun e2b 平台迁移**(替代 e2b.dev,目标集群 **JB/Johor**):
  代码全部完成并验证(`f6c7d0fa0` + `60256c289`)——harbor aliyun 模式、
  双集群 per-cluster key、claim/上传/MCP/DPSK 全链路 E2E 通。
  **阻塞在平台侧资源**,见 §1。
- **math 新题集(已洗完,07-23)**:`data/math-v0-unsolved-20260722/tasks/`
  38,457 个 harbor 任务目录(manifest 45fe10b0…),源自 numina 未解题
  (attempted-unsolved 10,966 + never-attempted 27,491,task.toml
  metadata.pool 区分)。生成:`dataset.py make-math`(math flavor:单定理
  + NL 题面只读注释 + proof/proof_aux 可编辑区,判分器零改动)。
  验证:38,457/38,457 validate 通过;200 题抽样在 4.28 镜像编译
  **200/200 全过**(题源 4.29,漂移为零,无需预编译过滤);spec_intact
  接受合法编辑/拒绝改陈述;refresh 圆环字节稳定。
  **round1(5K)07-23 在 SG 500 并发完赛**(`distill-math-round1`,4h16m):
  solve 1,331/5,000(26.6%),spec_intact 100%,think 99.97%,异常仅 8
  (7 RemoteProtocolError + 1 TypeError,rescue 集极小);均值 1.34M in /
  50K out tokens/题,轮成本 $292(全缓存)-$1,977(全 miss)。吞吐
  ~1,200 题/h @500 并发,SG 平台零沙箱事故。rounds 2-8 待启动
  (seed 20260723 分配已就位,每轮启动前确认)。
- **RL(miles)**:rollout 端到端已通,SMOKE 冒烟通过(07-22);
  下一步去掉 `--debug-rollout-only` 小步跑真 GRPO。

## 1. 内部平台资源申请(硬阻塞,找平台团队)

- [x] **SG 已扩容 2c/8GiB 并冒烟通过**(07-23):reward 1.0 全绿、
      think 40/40、transcript 完整(`smoke-dpsk-distill-aliyun-sg2c8g`,
      8min E2E)。2 CPU 判分够用。
- [ ] **JB 集群扩容未生效**:强制新 pod 仍 1c/2GB,跟平台确认 JB 的
      变更是否已发(JB 其余全就绪:key/johor ACR 镜像/claim)。
- [ ] **resourcequota**:128 并发起步(512 核/1TB),目标 512 并发
      (2048 核/4TB,可后扩)。
- [x] **镜像路线已解决**:主用 johor ACR
      `apodex-sandbox-johor-registry-vpc.ap-southeast-8.cr.aliyuncs.com/math-rl/code-prover-lean:latest`
      (07-22 从 Johor 机器 crane 直拷入库,digest sha256:b4850e…,
      swap 验证通过,claim ~123s)。兜底:Docker Hub 公开镜像
      `docker.io/lizenan1995/code-prover-lean:latest` 也验证可 swap
      (首拉慢,靠层缓存累积)。坑:ACR 临时密码登录用户是
      `cr_temp_user` 不是 RAM 邮箱;johor 实例是 cri-t5999…(别的
      token 对不上会 access:[])。
- [ ] Grafana 面板权限(顺带)。
- key 已齐:SG + JB 各一把(`.env`:`ALIYUN_E2B_API_KEY` / `_JB`;
  per-cluster 逻辑在 `tools/aliyun_clusters.py`)。

## 2. 蒸馏 campaign

- [ ] **532 题 round1 补漏**(待定:等 JB 就绪一起跑 vs 先用 e2b.dev
      现有模板清掉,约半小时+)。
- [ ] JB sandboxset 扩到 4c/8GB 后:直接重跑
      `configs/smoke-dpsk-distill-aliyun.yaml`(已切 jb + Docker Hub 镜像),
      期望 reward 1.0。
- [ ] `tools/distill_ops.py` 的 CONFIG_TEMPLATE 切 aliyun 模式
      (现在渲染的还是 e2b.dev 配置)。
- [ ] rounds 2-6:`distill_ops rounds` + `config` 生成,逐轮启动
      (**每次启动前需确认**)。
- [ ] round1 导出:`distill_ops collect --jobs jobs/distill-dpsk-round1
      jobs/distill-dpsk-round1-rescue jobs/distill-dpsk-round1-rescue-e2b
      ... --solved-only`。

## 3. RL 线

- [ ] **真 GRPO 小步跑**:去掉 `--debug-rollout-only`,顺带看 actor vs
      rollout logprob 偏差完成运行时前向验证。
- [ ] **rollout 沙箱来源**:方向改为内部 Aliyun 平台(同 §1 的资源,
      RL episode 需要的规格/并发一并考虑);开发/单机阶段本地 docker
      后端已验证,不阻塞。
- [ ] **问子然(ziran.yang)**:SFT 导出剥 MTP 头是否有意(config 残留
      `mtp_num_hidden_layers: 1` 与权重不一致);吞吐瓶颈时可嫁接基座
      MTP 头换 1.5-2x 推理加速。

## 4. 评测线 & 协调

- [x] **e2b.dev 沙箱被杀根因**:已定位——同事的 OpenKruise 池控制器误指
      e2b.dev,07-22 05:49-06:07 UTC 扫杀 476 个我们的沙箱(463
      AddTestsDirError + 11 显式 kill)。
- [ ] **跟池系统同事对齐**:让其修控制器指向;e2b.dev 共享 team
      (july-20-zenan)在修好前不适合跑长任务。
- 内部平台上线后,e2b.dev 线(独立 team 申请等)整体退役。

## 已知坑备忘(新会话必读)

### 内部 Aliyun 平台
- 客户端钉死 **py3.12 + e2b==2.23.0**(`.venv-aliyun`,配方见 README):
  py3.13 OpenSSL 拒私有 CA(缺 AKI);e2b≥2.24 key 正则拒平台 UUID key。
- `SSL_CERT_FILE` 是进程级 → 必须**系统 CA + 私有 CA 合并 bundle**
  (只放私有 CA 会把 DPSK 网关等所有公网 TLS 打挂,全 trial
  request_transport_error)。`aliyun_clusters.configure_env` 已处理。
- **key 按集群发**(SG key 在 JB 401);VPC-only,本机(SG 区域)解析不到
  JB 的 VPC 域名。
- 沙箱内**无公网**(Docker Hub/镜像源超时)、无 root/sudo(uid 1000);
  agent 跑在本机,蒸馏不受影响。
- 平台 ALB 对 create 请求 ~600s 硬超时(504);claim-timeout 设 ≤540 拿
  干净错误。镜像替换失败时 `reserve-failed-sandbox: "false"` 丢弃残骸。

### harbor / e2b 通用
- harbor 自定义 env 构造参数必须嵌在 `environment.kwargs` 下,顶层同名
  键**静默忽略**。
- e2b generic-template 模式:整库共用一个模板,任务差异靠沙箱启动时回放
  Dockerfile COPY(`tools/e2b_env.py`)。
- DPSK 网关高峰(UTC 15:50+)429 风暴:agent 已内建指数退避+jitter+
  Retry-After(`agents/qwen_native_agent.py`),验证过 3,241 次重试零烧题。
- 本地 docker 后端 ≤24 并发(bridge 网络地址池上限)。

### RL / 模型
- qwen3.6 chat template:非 `<tool_response>` 形态的 user turn 会剥离历史
  `<think>`;RL token 流中途注入的 user turn 必须 tool_response 包裹
  (`rl/token_stream.py` 有硬断言 + 启动字节级自检)。
- RL 沙箱用通用镜像,episode 开始必须把 `environment/task.lean` 上传到
  `tests/task_file.txt` 指定路径(eval 是每任务镜像,RL 不是)。
- sglang `/generate` 需 `no_stop_trim: true` 保留 `<|im_end|>`;generation
  prompt 以 `<think>\n` 结尾,模型输出从 think 正文开始(无开 tag)。
- RL 禁用 compaction(上下文重置破坏线性 token 流),超限标 TRUNCATED;
  蒸馏同样 `enable_compaction: false`(collect 默认丢弃压缩过的轨迹)。
- ckpt 转换必须 `--mtp-num-layers 0`;数值一致性已验证(31303 张量 bitwise
  全等)。
- 本机 sglang 用 `nohup ... & disown` 起。

### 数据纪律
- `data/` 不入 git(.gitignore 根锚定 `/data/`,勿改回 `data/`——会误伤
  `rl/data`);`.env` 含各类 key,严禁提交/回显。
- 长跑/花钱的启动(harbor 批量、RL 训练、重启也算)必须先跟 Zenan 确认。
