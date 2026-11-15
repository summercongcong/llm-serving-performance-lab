# LLM Infra Lab — 统一路线图（v4）

> 版本：4.0｜2026-11-15  
> **一份计划、一个仓库、一条 Infra 能力链。**  
> 不再并行维护「旧 52 周」与「3.x Serving」两套主线；旧内容并入本仓库的 **Foundations**，Serving / 压测 / 监控 / 诊断 / 平台 为同一 Lab 的后续能力层。

**仓库：** https://github.com/summercongcong/llm-serving-performance-lab  
**进度：** 根目录 `WEEKLY.md`（本仓）+ `Documents/ai infra plans/WEEKLY.md` 摘要同步  
**约束：** 硕士课程优先；正常周 4–6h；租 GPU 前写卡片，用完释放。

---

## 1. 能力地图（真正融合点）

AI Infra / Model Serving 不是「先学完理论再另起炉灶做工程」，而是同一套能力在加深：

```text
① 表示与运行时素养     懂模型在算什么、显存放哪里
② 部署与对外服务       把模型变成可调用的服务
③ 压测与指标           用数字描述快慢与稳定性
④ 诊断与改进           定位瓶颈并做可验证改动
⑤ 平台与可靠性         K8s、SLO、故障与回滚
⑥ 实验执行（加分）     Spot 上可恢复的训练/实验任务
```

| 能力 | 你要能当面讲清 / 出示的证据 | 对应阶段 | 状态 |
|------|------------------------------|----------|------|
| Attention / 形状 / 残差·FFN | 笔记 + 小代码 | Foundations | ✅ 已有（自旧 W0–2 迁入 `notes/foundations/`） |
| KV 显存、Prefill/Decode | 口算 + 一页图 | F2（原 Stage 2 前半） | ⬜ |
| 单机 GPU 部署 vLLM | README 可复现 + chat | S1a | ✅ W46 |
| 压测基线 | 原始表：并发×长度 → TTFT/吞吐/P95 | S1b | ⬜ **下一步** |
| 服务指标 / 监控 | `/metrics` 或 Prometheus 图 | S1c | ⬜ |
| 性能诊断 + 1 次 A/B | 瓶颈报告 | S2 | ⬜ |
| 引擎小改动 | diff + 测试说明 | S3 | ⬜ |
| K8s GPU 服务 | 部署/回滚记录 | S4 | ⬜ |
| SLO + 故障 | Postmortem | S5 | ⬜ |
| 求职材料 | 英文 README + 简历条目 | S6 | ⬜ |
| Spot 可恢复实验 | 销毁再续跑证据 | Runner（原 M0 精简） | ⬜ 后置加分 |

**一句话：** 会算 KV、会部署、会压测、会看指标——都是 Infra；只是证据形态从「笔记」变成「服务 + 数据 + 监控」。

---

## 2. 仓库即系统（目录 = 能力）

```text
llm-serving-performance-lab/
├── ROADMAP.md              ← 唯一主计划（本文件）
├── WEEKLY.md               ← 周进度
├── README.md               ← 对外英文入口（逐步完善）
├── notes/
│   └── foundations/        ← 旧理论笔记（已迁入）
├── configs/                ← 服务与压测配置快照
├── scripts/                ← serve / curl / bench
├── runs/                   ← 每次实验的原始证据
└── runner/                 ← Spot 可恢复实验（后置）
```

旧仓库 `plans/llm-infra-lab`：**归档**，只读；新工作只进本仓。

---

## 3. 阶段（按能力层，不再两套编号打架）

### Foundations（已完成主体）

- [x] 张量形状、QKV、causal mask、多头  
- [x] PE / 残差 / LayerNorm / FFN / GPT block  
- [x] 笔记：`notes/foundations/`

**还欠（并入 S2，不单独开「旧 Week 3」线）：** KV 口算公式练熟；Prefill/Decode 与 Serving 指标对齐着讲。

---

### S1 — Deploy & Measure（部署 + 压测 + 指标）

**目标：** 同一套 A10 + vLLM，既能启动服务，又能拿出可复现数字和（逐步）监控。

#### S1a 部署冒烟 — ✅

- [x] Spot A10、Docker、vLLM、Qwen3-0.6B、非流式 chat  
- [x] `runs/w46-first-serve/`，约 ¥7  

#### S1b 压测基线 — 当前唯一主线

- [ ] 实验卡片（目标/预算/时长）  
- [ ] 小矩阵：并发 1/4/8 × 输入 128/512，输出固定  
- [ ] 采集 TTFT、P50/P95、吞吐、成功率、显存  
- [ ] `runs/w47-baseline-v0/` + 一页结论  

**S1b 完成 =「会压测」入门通过**（不必一次做满 9 组）。

#### S1c 指标与监控 — S1b 之后

- [ ] 流式 chat；服务侧 `/metrics`（若有）  
- [ ] 扩大矩阵（在 A10 不 OOM 前提下）  
- [ ] Prometheus（+ 可选 Grafana）留存实验期指标  
- [ ] 口径说明：客户端 vs 服务端  

**S1 整体验收：** 别人按 README 能起服务；你能指着一张基线表和（加分）一张监控图讲瓶颈方向。

---

### S2 — Explain & Diagnose（KV + 诊断）

把「会算 KV」和「会看压测数字」接在一起：

- [ ] Prefill/Decode 图（对照你的基线：为何长 prompt 伤 TTFT）  
- [ ] KV 显存口算（对照 `nvidia-smi` 量级）  
- [ ] PagedAttention / Continuous Batching / Prefix Cache（概念）  
- [ ] 1 个可重复瓶颈 + A/B（如 Prefix Cache 开/关）  

**验收：** 一篇「数字 ↔ 原理」报告，而不是纯公式或纯图表。

---

### S3 — Change the runtime（小改进）

- [ ] 读懂 vLLM 一条请求路径  
- [ ] 一个小改动 + 测试 + 前后对比（可无加速，但要诚实）  

---

### S4 — Platform deploy（K8s）

- [ ] 单卡 K8s 部署 vLLM；探针；升级回滚  

---

### S5 — Reliability（SLO / 故障）

- [ ] 两项 SLO；限流/超时；故障注入 + Postmortem  

---

### S6 — Package for jobs & thesis

- [ ] 英文 README、案例、系统设计；简历；面试题；论文复用数据  

---

### Runner — Spot 可恢复实验（原 M0 精简，加分/后置）

与 Serving **同一 Infra 思维**（可销毁节点、状态外置、可重建），对象从 InferenceService 换成 TrainingJob：

- [ ] 固定 Commit + 容器；小训练任务  
- [ ] 一次：中断 → 释放 → 新机 → Checkpoint 续跑  
- [ ] 完整自定义镜像 / OSS 原子指针 = 后置增强，不挡 S1–S2  

---

## 4. 训练 vs 推理（同一人的两种工作负载）

| | TrainingJob（Runner） | InferenceService（S1–S5） |
|--|----------------------|---------------------------|
| 生命周期 | 有限 | 持续 |
| 成功标准 | 收敛/指标/可恢复 | 延迟、吞吐、可用性 |
| 你的证据 | Checkpoint 恢复日志 | 基线表、监控、SLO |

职责分工仍成立，但都算 **你的 Infra 作品集的不同章节**，不是第二个计划。

---

## 5. 求职最小集（融合后的「够了」）

1. Foundations 笔记（已有）  
2. 可复现部署（已有）  
3. **压测基线表（下一步）**  
4. KV/Decode 与数字对齐的诊断文（S2）  
5. 监控或至少 `/metrics` 口径（S1c）  
6. 小改动 / K8s / SLO 视时间叠加  

---

## 6. 当前进度与下一步

```text
Foundations     ████████░░  80%（欠 KV 口算与 Serving 对齐）
S1a 部署        ██████████ 100%
S1b 压测        ░░░░░░░░░░   0%  ← 本周唯一核心
S1c 监控        ░░░░░░░░░░   0%
S2–S6 / Runner  ░░░░░░░░░░   0%
```

**下一实验任务：** S1b 小基线（见 `WEEKLY.md`）。
