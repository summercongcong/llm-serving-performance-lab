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

- [ ] GPU instance up; `nvidia-smi` recorded
- [ ] vLLM serving
- [ ] `/v1/models` OK
- [ ] Non-streaming chat OK
- [ ] Logs under `runs/w46-first-serve/`
- [ ] Instance released; billing checked

## Quick start (fill in after first successful run)

```bash
# TODO: paste exact image / vLLM install / serve command used on Aliyun A10
```

```bash
# TODO: paste working curl for /v1/models and chat
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
