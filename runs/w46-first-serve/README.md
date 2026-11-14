# W46 first serve (smoke test)

**Date:** 2026-11-14 / 2026-11-15 (UTC+8)  
**Goal:** Stage 1 minimum — vLLM OpenAI API + one non-streaming chat on Aliyun preemptible A10.  
**Result:** PASS

## Environment

| Item | Value |
|------|--------|
| Cloud | Alibaba Cloud (Seoul) |
| Instance | Preemptible GPU |
| GPU | NVIDIA A10, 23028 MiB |
| Driver | 580.126.09 |
| CUDA (nvidia-smi) | 13.0 |
| Docker | 29.8.0 |
| Python (host) | 3.12.3 |
| Kernel | 6.8.0-138-generic Ubuntu |
| Serving image | `vllm/vllm-openai:latest` (see serve log for digest if recorded) |
| vLLM (response fingerprint) | `vllm-0.33.0-d3cbeec1` |
| Model | `Qwen/Qwen3-0.6B` |
| Bandwidth note | Pay-by-traffic; inbound free; peak temporarily raised to 100 Mbps for pull |

## Serve command (reference)

```bash
docker run --gpus all --name vllm \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen3-0.6B \
  --host 0.0.0.0 \
  --port 8000
```

Startup log included:

```text
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

## Smoke requests

### Chat (non-stream)

```bash
curl -s http://127.0.0.1:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen3-0.6B",
    "messages": [{"role":"user","content":"用一句话打个招呼"}],
    "max_tokens": 64,
    "temperature": 0
  }'
```

- HTTP path OK; JSON `object=chat.completion` returned.
- `finish_reason=length` with `completion_tokens=64`: model spent budget on `<think>` chain-of-thought; not a server failure.
- Follow-up (optional): raise `max_tokens` or disable thinking if the model supports it — out of scope for this smoke test.

Raw response saved in `chat.json` (if present in this folder).

## Limits / next

- No load matrix (concurrency × length).
- No Prometheus/Grafana.
- Instance must be **released** after this run; lower bandwidth peak if still at 100 Mbps.
- Next Stage 1 work: baseline bench groups + metrics collection.
