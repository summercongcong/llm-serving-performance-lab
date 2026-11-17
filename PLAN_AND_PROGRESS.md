# AI Infra Lab — 计划 · 进度 · 产出物总览

> 整理日期：2026-11-17  
> 权威计划：本仓库 [`ROADMAP.md`](./ROADMAP.md)（v4）  
> 周进度：[`WEEKLY.md`](./WEEKLY.md)  
> 主仓库：https://github.com/summercongcong/llm-serving-performance-lab  
> 归档仓库：`Documents/plans/llm-infra-lab`（旧 52 周已停更，理论笔记已迁入本仓）

---

## 1. 计划是什么

### 1.1 一句话

只维护 **一个 Lab、一条 AI Infra 能力链**：从懂模型在算什么，到能部署、压测、看指标、诊断，再到 K8s / 可靠性；会算 KV、会部署、会压测、会监控，同属 Infra，分期取证。

### 1.2 目标与约束

| 项 | 内容 |
|----|------|
| 求职方向 | AI Platform / Model Serving / Inference Backend（工程向入口） |
| 时间约束 | 硕士课程优先；正常周约 **4–6 小时**；考试周可暂停 |
| 硬件默认 | 阿里云 Spot **A10 24GB**（首尔已验证）；更大卡按需 |
| 技术栈主线 | Docker + vLLM + 压测/指标 → 诊断 → K8s → SLO |
| 总学习量（粗算） | 整条约 **130–190 小时**；剩余主线约 **110–160 小时** → 按 5h/周约 **5–8 个月** |

### 1.3 能力链与阶段

```text
Foundations → S1a 部署 → S1b 压测 → S1c 监控
           → S2 KV/诊断 → S3 小改动 → S4 K8s → S5 SLO → S6 求职材料
           → Runner（可恢复 Spot 实验，加分后置）
```

| 阶段 | 核心交付 | 约时 | 状态 |
|------|----------|------|------|
| Foundations | Attention / 形状 / 残差·FFN 笔记与代码 | ~15–25h | ✅ 主体完成 |
| S1a | Spot GPU 上 vLLM 可复现 chat | ~4–6h | ✅ |
| S1b | 小基线压测表（TTFT/吞吐/P95 等） | ~6–10h | ⬜ **本周** |
| S1c | 流式/`/metrics`/Prometheus、扩矩阵 | ~6–8h | ⬜ |
| S2 | Prefill/Decode、KV 口算、1 个瓶颈+A/B | ~20–28h | ⬜ |
| S3 | vLLM 路径阅读 + 小改动说明 | ~20–32h | ⬜ |
| S4 | K8s GPU 部署与回滚 | ~20–30h | ⬜ |
| S5 | SLO、限流、故障注入、Postmortem | ~20–30h | ⬜ |
| S6 | 英文材料、简历、面试题、论文复用 | ~16–24h | ⬜ |
| Runner | 一次「销毁实例 → Checkpoint 续跑」 | ~10–18h | ⬜ 后置 |

### 1.4 求职最小集（「够了」的定义）

1. Foundations 笔记 — ✅  
2. 可复现部署 — ✅  
3. **压测基线表** — ⬜ 下一步  
4. KV/Decode 与数字对齐的诊断文 — ⬜  
5. 监控或至少 `/metrics` 口径 — ⬜  
6. 小改动 / K8s / SLO — 视时间叠加  

### 1.5 本周（W47，2026-11-17～11-23）唯一目标

**S1b 小基线压测**

- 矩阵：并发 `1/4/8` × 输入 `128/512`，输出固定 `128`（6 组）  
- 产出目录：`runs/w47-baseline-v0/`  
- 不做：完整大矩阵、Prometheus、Runner、旧 52 周  

### 1.6 每周固定节奏（任何阶段通用）

1. 确认课程是否冲突  
2. 写下「本周唯一核心目标」  
3. 租卡前写实验卡片（目标/预算/时长）  
4. 动手 3–5h  
5. 证据进 `runs/` 或 `notes/` 并 commit  
6. 释放实例、核对账单  

---

## 2. 目前进度

### 2.1 总览

```text
Foundations     ████████░░   ~80%   （欠：KV 口算与 Serving 数字对齐 → 归 S2）
S1a 部署        ██████████   100%
S1b 压测        ░░░░░░░░░░     0%   ← 当前
S1c 监控        ░░░░░░░░░░     0%
S2–S6 / Runner  ░░░░░░░░░░     0%
```

### 2.2 能力勾选

| 能力 | 证据要求 | 状态 |
|------|----------|------|
| Attention / 形状 / 残差·FFN | 笔记 + 代码 | ✅ |
| KV 显存、Prefill/Decode | 口算 + 图 + 对照压测 | ⬜ |
| 单机部署 vLLM | README + chat 记录 | ✅ |
| 压测基线 | 原始表 | ⬜ |
| 指标/监控 | metrics 或 Prometheus | ⬜ |
| 性能诊断 + A/B | 报告 | ⬜ |
| 引擎小改动 | diff + 测试 | ⬜ |
| K8s GPU | 部署/回滚记录 | ⬜ |
| SLO + 故障 | Postmortem | ⬜ |
| 求职材料包 | 英文 README + 简历条目 | ⬜ |
| Spot 可恢复训练实验 | 恢复证据 | ⬜ |

### 2.3 决策与里程碑时间线

| 日期 | 事件 |
|------|------|
| 2026-09 | 旧 `llm-infra-lab` 启动；完成 Week 0–2（Transformer 基础） |
| 2026-10 | 进度放缓；国庆等空档；讨论 CS336 / 工时 |
| 2026-11-13 | 改就业导向，主执行 Roadmap 3.0 Serving 线 |
| 2026-11-14～15 | W46：首尔 Spot A10 冒烟成功；费用约 ¥7；实例释放 |
| 2026-11-15 | 3.1 → 3.1.1 顺序优化；**v4 融合**为单一 ROADMAP |
| 2026-11-17 | 本周目标锁定 S1b 压测 |

---

## 3. 已有产出物清单

### 3.1 主仓库 `llm-serving-performance-lab`

#### 计划与进度文档

| 路径 | 说明 |
|------|------|
| `ROADMAP.md` | 唯一权威路线图（v4） |
| `WEEKLY.md` | 周任务与勾选 |
| `README.md` | 仓库说明与冒烟 Quick start |
| `PLAN_AND_PROGRESS.md` | **本文：计划+进度+产出总览** |

#### Foundations（自旧仓迁入）

| 路径 | 说明 |
|------|------|
| `notes/foundations/glossary.md` | 术语本 |
| `notes/foundations/w01-shapes.md` | Attention / 多头形状表 |
| `notes/foundations/w02-forward.md` | GPT block 数据流、「去掉会怎样」、验收问答 |

#### 实验证据

| 路径 | 说明 |
|------|------|
| `runs/w46-first-serve/README.md` | 冒烟实验记录（环境、命令、结论） |
| `runs/w46-first-serve/chat.json` | 一次非流式 chat 原始返回 |

#### 脚本与占位

| 路径 | 说明 |
|------|------|
| `scripts/curl_smoke.sh` | `/v1/models` + chat 冒烟脚本 |
| `configs/` | 配置快照目录（待填） |
| `runner/README.md` | 后置 Runner 模块说明 |

#### W46 实验摘要（已完成）

| 项 | 值 |
|----|-----|
| 云 | 阿里云首尔，抢占式 |
| GPU | NVIDIA A10，23028 MiB |
| 驱动 / CUDA | 580.126.09 / 13.0（nvidia-smi） |
| 服务 | `vllm/vllm-openai:latest`，fingerprint `vllm-0.33.0-d3cbeec1` |
| 模型 | `Qwen/Qwen3-0.6B` |
| 结果 | PASS（`finish_reason=length` 因思考链占满 max_tokens，非服务故障） |
| 费用 | 约 ¥7 |
| 启动命令 | 见 `runs/w46-first-serve/README.md` |

### 3.2 归档仓库 `plans/llm-infra-lab`（只读参考）

> README 已标明归档；新工作勿再提交至此。

| 路径 | 说明 |
|------|------|
| `01.md` / `02.md` | 旧 52 周战略/手册（已去个性化后的技术清单） |
| `code/w01_*.py` / `w02_*.py` | 本地练习代码（Attention、多头、GPT block） |
| `notes/*` | 与 foundations 同源的本地原稿 |
| `WEEKLY.md` | 旧周志（历史） |

代码未全部复制进主仓；需要时可从归档仓引用或再迁入 `notes/foundations/code/`。

### 3.3 本地其它文档（演变记录，非执行权威）

| 路径 | 说明 |
|------|------|
| `Documents/ai infra plans/AI_Infra_Roadmap_3.1.md` | 指向 v4 的说明 |
| `Documents/ai infra plans/WEEKLY.md` | 摘要，指向主仓 |
| 大学目录下原 3.1 文件名文档 | 已改为「以主仓 ROADMAP 为准」 |

---

## 4. 尚未产出（按优先级）

| 优先级 | 产出物 | 阶段 |
|--------|--------|------|
| P0 | `runs/w47-baseline-v0/` 六组压测原始数据 + 结果表 + 一页结论 | S1b |
| P1 | 流式 chat 记录；`/metrics` 或 Prometheus 截图/导出 | S1c |
| P1 | KV 口算笔记 + Prefill/Decode 图（对照基线数字） | S2 |
| P1 | 一篇瓶颈→证据→A/B 报告 | S2 |
| P2 | vLLM 小改动 diff + 说明 | S3 |
| P2 | K8s 部署清单与回滚记录 | S4 |
| P2 | SLO 定义 + Postmortem | S5 |
| P2 | 求职向英文 README / 系统设计 / 面试题集 | S6 |
| P3 | Runner：Checkpoint 跨实例恢复证据 | Runner |

---

## 5. 仓库目录（当前）

```text
llm-serving-performance-lab/
├── ROADMAP.md                 # 唯一主计划
├── WEEKLY.md                  # 周进度
├── PLAN_AND_PROGRESS.md       # 本总览
├── README.md
├── .gitignore
├── configs/
├── scripts/
│   └── curl_smoke.sh
├── notes/
│   ├── README.md
│   └── foundations/
│       ├── glossary.md
│       ├── w01-shapes.md
│       └── w02-forward.md
├── runs/
│   └── w46-first-serve/
│       ├── README.md
│       └── chat.json
└── runner/
    └── README.md
```

---

## 6. 相关链接

- 主仓库：https://github.com/summercongcong/llm-serving-performance-lab  
- 冒烟记录：https://github.com/summercongcong/llm-serving-performance-lab/tree/main/runs/w46-first-serve  
- 路线图：https://github.com/summercongcong/llm-serving-performance-lab/blob/main/ROADMAP.md  

---

*本文随实验更新；完成 S1b 后应增补 `runs/w47-baseline-v0/` 并刷新第 2、3 节状态。*
