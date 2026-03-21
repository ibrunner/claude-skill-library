---
name: bug-report
description: Use when reporting a bug, capturing a bug ticket, or the user says to file/write/create a bug report. Investigates root cause and writes a structured ticket.
---

# Bug Report

## Steps

1. **Gather info** — ask for reproduction steps if the user hasn't provided them. Get: what happens, what should happen, and how to trigger it.
2. **Investigate** — search the codebase for the root cause. Start with the simplest explanation. Do not over-investigate — find the likely cause and stop.
3. **Write the ticket** — create a file at `docs/tasks/fixes/<slug>.md` (or the project's equivalent bug tracking location) using the template below.
4. **Do NOT mark as fixed** — status is always `draft` or `backlog`. Never mark a bug as fixed in the ticket without verified confirmation.

## Template

```markdown
---
type: fix
status: draft
priority: medium
project:
initiative:
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# {Title} - Bug Fix

## Bug

**What happens:** {Describe the broken behavior}

**Expected:** {What should happen instead}

**Reproduction:** {Steps to reproduce}

## Root Cause

{Brief analysis of why this happens, with file:line references}

## Fix Plan

- [ ] {Step 1}
- [ ] {Step 2}

## Testing

- [ ] {How to verify the fix}
```

## Notes

- Set priority based on severity: `critical` (data loss, crash), `high` (broken feature), `medium` (wrong behavior), `low` (cosmetic).
- Link to parent project/initiative if applicable.
- If root cause is uncertain, say so — don't guess.
