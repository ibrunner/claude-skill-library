---
name: session-bounce
description: Use when ending a work session to preserve context for later pickup. Saves session state, kills running processes, rebases from main, renames branch semantically, commits, and pushes. Creates a handoff document for session continuity.
---

# Session Bounce — End-of-Session Handoff

## Overview

Cleanly end a work session so it can be picked up later (by you or another agent). Documents current state, cleans up processes, rebases, renames the branch to something findable, commits everything, and pushes.

**Announce at start:** "Bouncing this session. I'll document state, clean up, rebase, and push."

## Steps

### 1. Document Current State

Scan for active plans and documents that need updating:

1. **Check for implementation plans** — search `docs/plans/` for plans related to the current branch. Update checkboxes to reflect actual progress.
2. **Check for task tickets** — search `docs/tasks/` for related tickets. Update status if needed.
3. **Check TodoWrite** — capture any in-progress task state.

### 2. Write Session Handoff Document

Create `docs/sessions/YYYY-MM-DD-<semantic-slug>.md` with this structure:

```markdown
---
branch: <semantic branch name, from step 5>
worktree: <current worktree name, if applicable>
previous-branch: <original branch name before rename>
status: bounced
date: YYYY-MM-DD
---

# Session: <Short Description>

## What Was Done
- <bullet list of completed work>

## Current State
- <what's working, what's partially done>
- <any test status — what passes, what's pending>

## What's Next
- <prioritized list of remaining work>
- <any blockers or decisions needed>

## Key Files Modified
- <list of important files changed in this session>

## Notes
- <any gotchas, context, or decisions made during this session>
```

### 3. Kill Running Processes

Clean up any development processes that are still running:

```bash
# Kill dev servers (common patterns)
pkill -f 'node.*vite' 2>/dev/null || true
pkill -f 'node.*next' 2>/dev/null || true
pkill -f 'node.*webpack' 2>/dev/null || true

# Kill test runners
pkill -9 -f 'node.*vitest' 2>/dev/null || true
pkill -9 -f 'node.*jest' 2>/dev/null || true
```

Adapt these to the project's tech stack. If the project uses Docker sandboxes, stop those too.

### 4. Rebase from Main

```bash
git fetch origin main
git rebase origin/main
```

If rebase has conflicts:
- Try to resolve them if straightforward
- If complex, abort the rebase (`git rebase --abort`), note the conflict in the handoff document, and continue with a regular commit instead

### 5. Rename Branch Semantically

The current branch may have an auto-generated name. Rename it to something findable:

```bash
git branch -m <current-branch> <semantic-name>
```

Naming convention: `<type>/<feature-slug>` where type is `feature`, `fix`, or `chore`.

Choose the name based on what work was actually done, not what was planned.

**Update the handoff document** with the final branch name.

### 6. Stage and Commit

```bash
git add docs/sessions/<handoff-file>.md
git add docs/plans/  # if any plans were updated
git add docs/tasks/  # if any tickets were updated
# Add any other uncommitted work files
git status  # review what's staged
git commit -m "chore: session bounce — <short description of state>"
```

### 7. Push

```bash
git push -u origin <semantic-branch-name>
```

### 8. Report

Output a summary:

```
Session bounced successfully.

Branch: <semantic-branch-name>
Handoff: docs/sessions/YYYY-MM-DD-<slug>.md

To pick up later: /session-pickup <search-term>
```

## Rules

- **Never merge to main** — bounce preserves the branch for later pickup
- **Always write the handoff document** — it's the primary context carrier
- **Always push** — the branch must be on the remote so any machine can pick it up
- **Don't delete worktrees** — the user might want to inspect them before cleanup
