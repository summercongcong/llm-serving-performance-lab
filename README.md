# LLM Serving Performance Lab

Production-oriented LLM serving experiments for AI Infra / Model Serving roles.

**Current focus (Roadmap 3.0 Stage 1):** get vLLM OpenAI-compatible API running on a single GPU and record a reproducible first chat.

## Hardware / cloud (this week)

| Item | Choice |
|------|--------|
| Cloud | Alibaba Cloud (Aliyun) |
| Instance | Preemptible (抢占式) |
| GPU | NVIDIA A10 (24GB) |
| Model (first run) | Qwen3-0.6B (or equivalent small instruct model) |

> Note: Roadmap 3.0 mentioned L20 48GB. A10 24GB is enough for Stage 1 smoke test. Prefer small models; do not assume 8B fits without checking VRAM.

## Status

- [x] GPU instance up; `nvidia-smi` recorded (A10, Driver 580.126.09)
- [x] vLLM serving (`vllm/vllm-openai:latest`, fingerprint `vllm-0.33.0-d3cbeec1`)
- [x] Non-streaming chat OK (`Qwen/Qwen3-0.6B`) — see `runs/w46-first-serve/`
- [ ] Confirm `/v1/models` saved in run folder (optional if chat already proved API up)
- [ ] Instance released; billing checked; bandwidth peak lowered if raised for pull

## Quick start (reproducible smoke)

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
curl -s http://127.0.0.1:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"Qwen/Qwen3-0.6B","messages":[{"role":"user","content":"用一句话打个招呼"}],"max_tokens":64,"temperature":0}'
```

## Repo layout

```text
configs/    # serve configs
scripts/    # serve / curl helpers
runs/       # per-experiment logs and results
notes/      # short notes
```

## Safety

- Preemptible instances can be reclaimed anytime — save logs to this repo before release.
- Set a budget cap before each rental; shut down when done.
- Never commit cloud keys, tokens, or `.env` files.
