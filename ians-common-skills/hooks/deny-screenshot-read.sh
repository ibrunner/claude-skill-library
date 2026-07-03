#!/bin/bash
# PreToolUse hook: deny Read of UI-screenshot image files and redirect the
# agent to the vision-verify skill (offloads analysis to a local vision model).
#
# Inert (allows everything) when ANY of:
#   - VISION_API_URL is not set            (no local vision endpoint on this machine)
#   - VISION_VERIFY_ENFORCE=0              (session-level off switch)
#   - ~/.claude/vision-verify.disabled     (flag file; touch/rm to toggle mid-session)
#
# Only screenshot-LIKE paths are denied; other images (e.g. generated art,
# design assets) stay readable by Claude vision.
set -euo pipefail

INPUT=$(cat)

# --- toggles ---
[ -z "${VISION_API_URL:-}" ] && exit 0
[ "${VISION_VERIFY_ENFORCE:-1}" = "0" ] && exit 0
[ -f "$HOME/.claude/vision-verify.disabled" ] && exit 0

FILE_PATH=$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)
[ -z "$FILE_PATH" ] && exit 0

# --- image extension? ---
LOWER=$(printf '%s' "$FILE_PATH" | tr '[:upper:]' '[:lower:]')
case "$LOWER" in
  *.png|*.jpg|*.jpeg|*.webp|*.gif) ;;
  *) exit 0 ;;
esac

# --- screenshot-like path? ---
BASENAME=$(basename "$LOWER")
SCREENSHOT_LIKE=0
case "$LOWER" in
  *".playwright-mcp/"*|*"/screenshots/"*|*"/test-results/"*) SCREENSHOT_LIKE=1 ;;
esac
case "$BASENAME" in
  *screenshot*|*screen-shot*|page-*|snapshot*|*-snapshot.*|viewport*) SCREENSHOT_LIKE=1 ;;
esac
[ "$SCREENSHOT_LIKE" = "0" ] && exit 0

SKILL_SCRIPT="${CLAUDE_PLUGIN_ROOT:-}/skills/vision-verify/scripts/vision-verify.sh"

python3 - "$FILE_PATH" "$SKILL_SCRIPT" <<'PYEOF'
import json, sys
file_path, skill_script = sys.argv[1], sys.argv[2]
reason = (
    "Reading UI screenshots into context is disabled: a local vision model is available "
    "(vision-verify skill). Instead run:\n"
    f"  {skill_script} '{file_path}' \"<numbered assertions ending with: End with a single line: VERDICT: PASS or VERDICT: FAIL>\"\n"
    "Only the text verdict enters context (~100 tokens vs ~1,600 for reading the image). "
    "If Claude vision is genuinely required (e.g. aesthetic judgment the local model can't do), "
    "ask the user to approve, or they can disable enforcement via VISION_VERIFY_ENFORCE=0 or "
    "`touch ~/.claude/vision-verify.disabled`."
)
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason,
    }
}))
PYEOF
