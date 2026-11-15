# LLM Infra Lab

Unified lab for **AI Infrastructure / Model Serving** skills:

| Capability | Meaning |
|------------|---------|
| Foundations | What the model computes (Attention, shapes, residual/FFN) |
| KV / runtime literacy | Prefill vs decode, memory math |
| Deploy | vLLM (and later K8s) on Spot GPU |
| Measure | Load tests: TTFT, throughput, tail latency |
| Observe | Metrics / Prometheus |
| Diagnose & change | Bottlenecks, A/B, small engine fixes |
| Reliability | SLO, failure drills |
| Runner (optional) | Spot jobs with checkpoint resume |

**Single roadmap:** [`ROADMAP.md`](./ROADMAP.md) · **Weekly log:** [`WEEKLY.md`](./WEEKLY.md)

Legacy theory notes live under [`notes/foundations/`](./notes/foundations/) (imported from the archived `llm-infra-lab` weeks 0–2).

## Hardware (current)

| Item | Choice |
|------|--------|
| Cloud | Alibaba Cloud Spot |
| GPU | NVIDIA A10 24GB (Seoul verified) |
| First model | `Qwen/Qwen3-0.6B` |

## Status

- [x] Foundations notes imported
- [x] S1a smoke: vLLM chat on A10 — `runs/w46-first-serve/` (~¥7)
- [ ] S1b baseline load matrix — **next**
- [ ] S1c metrics / Prometheus
- [ ] S2 KV + diagnose aligned with numbers

## Quick start (smoke)

```bash
docker run --gpus all --name vllm \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen3-0.6B \
  --host 0.0.0.0 \
  --port 8000
```

```bash
./scripts/curl_smoke.sh
# or set BASE_URL / MODEL as needed
```

## Layout

```text
notes/foundations/   theory (Attention, GPT block)
configs/             serve & bench snapshots
scripts/             serve / curl / bench helpers
runs/                raw evidence per experiment
runner/              optional Spot training resume (later)
```

## Safety

- Write an experiment card before renting GPU; release when done.
- Inbound traffic on pay-by-traffic ECS is typically free; watch instance hours.
- Never commit cloud keys or tokens.
