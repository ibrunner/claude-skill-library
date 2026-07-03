---
name: vision-verify
description: Use when verifying UI screenshots (Playwright, browser automation, visual regression checks) and a local vision model endpoint is available — offloads image analysis to save Claude vision tokens. Triggers include "verify this screenshot", "check the page looks right", "visual verification", or any workflow that would otherwise Read a screenshot into context.
---

# Vision Verify

## Overview

Offload screenshot analysis to a local OpenAI-compatible vision model (vLLM, llama.cpp, Ollama) instead of reading images into Claude's context. A full-viewport screenshot costs ~1,600 Claude vision tokens to Read; sent to the local model it costs **zero** — only a short text verdict (~100 tokens) enters the conversation.

**Announce at start:** "I'm using vision-verify to check the screenshot with the local vision model."

## The Iron Rule

**Never Read the screenshot file into context.** Save it to disk, pass the path to the script, and work only with the text verdict. Reading the image "just to double-check" defeats the entire purpose of this skill.

## Setup (one-time, per machine)

The endpoint URL contains a private IP — it must live in your shell profile, never in code or skill files (pre-commit hooks in some repos block private IPs):

```bash
# ~/.zshrc
export VISION_API_URL=http://<host>:<port>
# optional — auto-discovered from /v1/models if unset:
export VISION_MODEL=<model-id>
```

Verify connectivity: `curl -s $VISION_API_URL/v1/models`

## Workflow

1. Take a screenshot to a **file** (Playwright `screenshot({path})`, browser MCP `filename` param).
2. Run the bundled script with a structured assertion prompt. Invoke it by **absolute path** (resolve `scripts/vision-verify.sh` relative to this SKILL.md's directory — your cwd is usually elsewhere):

```bash
<skill-dir>/scripts/vision-verify.sh <screenshot.png> "You are verifying a UI screenshot for an automated test.
Check the following assertions and answer each with PASS or FAIL plus a one-line reason:
1. <assertion about page identity, e.g. 'shows the gallery page, not a login or error screen'>
2. <assertion about a specific element>
3. There are no visible error messages, blank screens, or broken layouts.
End with a single line: VERDICT: PASS or VERDICT: FAIL (fail if any assertion failed)."
```

3. Parse the final `VERDICT:` line. Report per-assertion results to the user.

### Writing good assertions

- Ask about **observable pixels**, not intent: "a button labeled X is visible", not "the feature works".
- Number assertions and demand per-assertion PASS/FAIL — a single open-ended "does this look right?" invites vague answers.
- Include the negative-space check (assertion 3 above) in every verification.
- The model reads on-screen text well (filenames, labels, percentages) — use exact expected strings when you have them.

## Fallback policy

If the model's answer is ambiguous, contradicts itself, or a FAIL is surprising:

1. Re-ask once with a narrower question about the specific disputed element.
2. Cross-check against a non-visual source when available (accessibility snapshot, DOM query) — it's cheap text and authoritative for element existence.
3. Only if still unresolved and the check is load-bearing, fall back to reading the screenshot with Claude vision — and say you're doing so and why.

A surprising FAIL is often correct: verify against ground truth before assuming the local model erred.

## Enforcement hook (makes this the default)

This plugin ships a `PreToolUse` hook (`hooks/deny-screenshot-read.sh`) that denies `Read` calls on screenshot-like image files (paths under `.playwright-mcp/`, `screenshots/`, `test-results/`, or basenames matching `*screenshot*`, `page-*`, `snapshot*`, `viewport*`) and redirects to this skill. Other images (generated art, design assets) remain readable.

It is inert unless `VISION_API_URL` is set. Toggles:

| Action | How |
|---|---|
| Off for a session | `VISION_VERIFY_ENFORCE=0` before launching |
| Off mid-session | `touch ~/.claude/vision-verify.disabled` |
| Back on | `rm ~/.claude/vision-verify.disabled` |

Hook config changes load at session start — restart Claude Code after installing/updating the plugin.

## Quick reference

| Task | Command |
|---|---|
| Verify screenshot | `scripts/vision-verify.sh img.png "<assertion prompt>"` |
| Free-form description | `scripts/vision-verify.sh img.png "Describe this UI concisely."` |
| Check endpoint | `curl -s $VISION_API_URL/v1/models` |
| Longer answer | `VISION_MAX_TOKENS=1000 scripts/vision-verify.sh ...` |

Script exit codes: `0` success, `1` API/model error (details on stderr), `2` usage error (missing args, missing image, `VISION_API_URL` unset).

## Common mistakes

| Mistake | Fix |
|---|---|
| Reading the screenshot into context anyway | Don't. The text verdict is the deliverable. See Fallback policy for the one exception. |
| `content: null` with tokens consumed | Hybrid reasoning models (Qwen3.x) burn `max_tokens` on thinking. The script already sends `chat_template_kwargs: {"enable_thinking": false}` (vLLM extension); keep it if editing. |
| Hardcoding the endpoint IP | Env var in shell profile only. Pre-commit hooks may block private IPs in source. |
| Vague prompt ("does this look OK?") | Numbered assertions + required `VERDICT:` line. |
| Treating model FAIL as model error | It may be right — cross-check the accessibility snapshot first. |
| Trusting it for pixel-perfect diffs | It verifies semantic content (elements, text, layout state), not 2px offsets or exact colors. Use screenshot-diff tools for those. |
