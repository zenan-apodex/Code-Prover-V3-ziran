# TODO — 下一步(更新于 2026-07-24)

## 当前状态快照(07-24 01:15 UTC)

- **coding 蒸馏主线**:v2.1 campaign(25,880 题,6 轮)已收官,solved
  9,505/25,880 → 未解题 carve 成 `data/coding-v2.2-unsolved-20260723`
  (16,375 题,4 轮,seed 20260723)。**v2.2 campaign 07-23 全部跑完**:
  solved 3,334/16,375(20.4%;r1 906 / r2 1,054 / r3 1,083 / r4 291),
  SFT 导出在 `data/coding-v2.2-unsolved-20260723/distilled/round{1..4}-solved.jsonl`
  (3,334 条;v2.3 同款在其 `distilled/`,1,587 条;目录约定与 v2.1 一致)。未解题再 carve 成
  `data/coding-v2.3-unsolved-20260723`(13,041 题,3 轮 5000/5000/3041,
  seed 20260723,工具 `tools/carve_unsolved.py`)。**v2.3 campaign 07-23
  17:19 启动**(e2b.dev,1024 并发):r1 完(solved 396,exceptions
  2,153 ⚠️ 晚间 e2b.dev 波动)、r2 完(solved 730,exc 2)、r3 接近完成
  (solved 461,exc 1)。
- **coding-v1 线**(`data/coding-v1-unsolved-20260721`,round1 4,836 题
  @ JB zenan-no-internet):3,481/4,836,solved 313,exceptions 2,224 ⚠️
  (大部分是 env-start 超时 bug 时代坏账,见已知坑)。harbor 续跑中。
- **math 线**(`data/math-v0-unsolved-20260722`,38,457 题,8 轮,
  driver `tools/run_math_rounds.sh`):round1 完(solved 1,331/5,000,
  26.6%,异常仅 8);round2 完但成绩报废(solved 221/5,000,4,254
  ConnectError——11:40 误双开 driver 两个 harbor 同跑所致,待 rescue);
  round3 进行中(1,602/5,000,solved 95,exc 1,298 ⚠️ 事故窗口坏账)。
  driver 自动跑到 round8。
- **07-23 事故日汇总**(细节见"已知坑"):DSW 机器 13:00 重启杀光全部
  driver(JB 泄漏 119 个沙箱已清,工具 `tools/kill_jb_orphans.py`);
  SG DNS 事故(dnsmasq shim 绕过,DSW 重启需重做);env-start 超时 bug
  (multiplier=3 修复);改 config 后 resume 三层补丁;18:46 两个 aliyun
  harbor 被不明强杀(无 OOM/无日志),07-24 01:12 重新拉起。
- **RL(miles)**:rollout 端到端已通,SMOKE 冒烟通过(07-22);
  下一步去掉 `--debug-rollout-only` 小步跑真 GRPO。

## 1. 内部平台资源申请(硬阻塞,找平台团队)

- [x] **SG 已扩容 2c/8GiB 并冒烟通过**(07-23):reward 1.0 全绿、
      think 40/40、transcript 完整(`smoke-dpsk-distill-aliyun-sg2c8g`,
      8min E2E)。2 CPU 判分够用。
- [x] **JB 集群扩容已生效 2c/8GiB**(07-23 Zenan 确认;此前"强制新 pod
      仍 1c/2GB"的观察已过时)。
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

- [ ] **集中 rescue**(各轮跑完后一起做,exception 任务都在,不丢):
      math round2(4,254 ConnectError)、math round3(1,298)、
      v1 round1(2,224)、v2.3 round1(2,153)。
      `distill_ops rescue --job jobs/<job> --round roundN`(注意二次
      rescue 换 --out,materialize 只增不删)。
- [ ] **导出**:v1 / math / v2.3 各 campaign 收官后
      `distill_ops collect --jobs ... --solved-only`(v2.2 已导出)。
- [ ] v2.3 跑完后:如继续 carve v2.4,用 `tools/carve_unsolved.py`
      (用法见 CMD.md §4)。
- [ ] `tools/distill_ops.py` 的 CONFIG_TEMPLATE 切 aliyun 模式
      (现在渲染的还是 e2b.dev 配置;math 线是 sed 改 round1 yaml 绕的)。

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
- **冷镜像 + 大并发 create = 踩踏死锁**(07-23 JB 实锤):500 路首拉打满
  ACR/节点盘,每路超时→丢 pod→换冷节点重拉,1,500 次失败零成功,且需
  ~25min 全静默才恢复(风暴后连单发都挂,pod state=dead)。修复:aliyun
  模式 create 加信号量(`create_concurrency`,默认 24,tools/e2b_env.py)
  ——只限"同时在建",跑的并发不受限;节点缓存热后 create ~2min,不再触发。
  新集群/新镜像首跑务必带此限流。
- **env-start 超时 bug(07-23 实锤)**:harbor 环境启动限时 1800s **从
  trial 排队就计时**,包含在 create_concurrency 信号量上排队的时间;
  500 并发 ÷ 24 create 槽 ⇒ 队尾等 40-50min ⇒ 成批
  `Environment start timed out after 1800s`(v1/math 数千 exception 的
  主因)。修复:job config 顶层 `environment_build_timeout_multiplier: 3`
  (见 configs/distill-dpsk-v1-round1.yaml 注释;只影响环境启动容忍)。
- **改 config 后 resume 旧 job = 三层存档补丁**(07-23 连环崩三次定位):
  harbor 全等比较,缺一层就崩——① `jobs/<job>/config.json` 不一致 →
  启动秒崩 FileExistsError;② **每个 trial** 的
  `jobs/<job>/<trial>/config.json` 不一致 → 对账阶段
  ValueError(trial 多时 NFS 要 5-20min 才走到,像"启动成功后又崩");
  ③ `lock.json` trials[*]。补法:json 读入→设字段→写回。
  或换新 job 目录(丢已完成 trial)。
- **driver 严禁双开**:math round2 报废(221/5000)就是 11:40 误开第二个
  driver,两个 harbor 同 job 并跑 + `>` 截断日志。重启 driver 前必
  `pgrep -f run_math_rounds`/`run_distill_rounds` 确认无存活。

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
