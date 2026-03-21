#!/usr/bin/env bash
# plan-refinement-gate.sh
#
# PostToolUse hook: fires after every Write tool call.
# Detects when writing-plans saves a raw plan file to docs/plans/ and
# blocks Claude from offering execution options until writing-implementation-plans
# has refined the plan into phases.

set -euo pipefail

# Read the tool input JSON from stdin
INPUT=$(cat)

# Extract file_path from the JSON payload
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    tool_input = data.get('tool_input', data)
    print(tool_input.get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# No file path — not relevant
[[ -z "$FILE_PATH" ]] && exit 0

# Must be under docs/plans/, must be .md, must NOT be a design doc
[[ "$FILE_PATH" != *"docs/plans/"* ]] && exit 0
[[ "$FILE_PATH" == *"-design.md" ]] && exit 0
[[ "$FILE_PATH" != *.md ]] && exit 0

# If the file already has phase structure, writing-implementation-plans already ran — skip
grep -q "^## Phase" "$FILE_PATH" 2>/dev/null && exit 0

# Raw plan file detected — force refinement before execution options
echo "HOOK (plan-refinement-gate): A raw plan file was just written to docs/plans/ without phase structure."
echo "You MUST invoke the 'writing-implementation-plans' skill NOW to refine this plan into phases."
echo "Do NOT offer execution options (subagent-driven vs parallel session) until after refinement is complete."
exit 2
