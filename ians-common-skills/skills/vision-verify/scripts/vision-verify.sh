#!/bin/bash
# vision-verify.sh <image-path> <question>
#
# Sends an image + question to a local OpenAI-compatible vision model and
# prints the answer. Token usage and elapsed time go to stderr.
#
# Required env:
#   VISION_API_URL   e.g. http://<host>:<port>  (set in shell profile, NOT in code)
# Optional env:
#   VISION_MODEL     model id; auto-discovered from /v1/models if unset
#   VISION_MAX_TOKENS  default 500
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "usage: vision-verify.sh <image-path> <question>" >&2
  exit 2
fi

if [ -z "${VISION_API_URL:-}" ]; then
  echo "ERROR: VISION_API_URL is not set. Add it to your shell profile, e.g." >&2
  echo "  export VISION_API_URL=http://<host>:<port>" >&2
  exit 2
fi

IMAGE="$1"
QUESTION="$2"
MAX_TOKENS="${VISION_MAX_TOKENS:-500}"

if [ ! -f "$IMAGE" ]; then
  echo "ERROR: image not found: $IMAGE" >&2
  exit 2
fi

# Auto-discover the model id if not provided
MODEL="${VISION_MODEL:-}"
if [ -z "$MODEL" ]; then
  MODEL=$(curl -s --max-time 10 "$VISION_API_URL/v1/models" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["data"][0]["id"])')
fi

case "$IMAGE" in
  *.jpg|*.jpeg) MIME="image/jpeg" ;;
  *.webp)       MIME="image/webp" ;;
  *)            MIME="image/png" ;;
esac

B64=$(base64 -i "$IMAGE" | tr -d '\n')
Q_JSON=$(printf '%s' "$QUESTION" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

PAYLOAD=$(mktemp)
trap 'rm -f "$PAYLOAD"' EXIT
cat > "$PAYLOAD" <<EOF
{
  "model": "$MODEL",
  "max_tokens": $MAX_TOKENS,
  "temperature": 0,
  "chat_template_kwargs": {"enable_thinking": false},
  "messages": [
    {
      "role": "user",
      "content": [
        {"type": "image_url", "image_url": {"url": "data:$MIME;base64,$B64"}},
        {"type": "text", "text": $Q_JSON}
      ]
    }
  ]
}
EOF

START=$(date +%s)
RESP=$(curl -s --max-time 120 "$VISION_API_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d @"$PAYLOAD")
END=$(date +%s)

echo "$RESP" | python3 -c '
import json, sys
r = json.load(sys.stdin)
if "error" in r:
    print("ERROR: " + json.dumps(r["error"]), file=sys.stderr)
    sys.exit(1)
content = r["choices"][0]["message"]["content"]
if content is None:
    print("ERROR: model returned null content (thinking mode consumed max_tokens?)", file=sys.stderr)
    sys.exit(1)
print(content)
u = r.get("usage", {})
print("--- tokens: prompt=%s completion=%s ---" % (u.get("prompt_tokens"), u.get("completion_tokens")), file=sys.stderr)
'
echo "--- elapsed: $((END - START))s ---" >&2
