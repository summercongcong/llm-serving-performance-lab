#!/usr/bin/env bash
# Smoke test against a local or remote vLLM OpenAI-compatible server.
set -euo pipefail
BASE_URL="${BASE_URL:-http://127.0.0.1:8000}"
MODEL="${MODEL:-Qwen/Qwen3-0.6B}"

echo "== GET /v1/models =="
curl -sS "${BASE_URL}/v1/models" | head -c 2000
echo
echo

echo "== POST /v1/chat/completions (non-stream) =="
curl -sS "${BASE_URL}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${MODEL}\",\"messages\":[{\"role\":\"user\",\"content\":\"Say hello in one short sentence.\"}],\"max_tokens\":64,\"temperature\":0}"
echo
