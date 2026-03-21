---
name: session-pickup
description: Use when resuming a previously bounced session. Finds the session by keyword, pulls the branch, presents context summary, cleans up old worktree, and suggests next steps.
---

# Session Pickup — Resume a Bounced Session

## Overview

Resume a session that was previously bounced with `/session-bounce`. Finds the session semantically, pulls the branch, reads the handoff document, and presents a full context briefing.

**Arguments:** `/session-pickup [search-term]`

If no search term is provided, list all active sessions and ask which one to pick up.

## Steps

### 1. Find the Session

Search for sessions matching the search term:

```bash
# Search handoff documents
ls docs/sessions/*.md 2>/dev/null

# Search remote branches
git fetch --all --prune
git branch -r | grep -v HEAD
```

Match the search term against:
- Handoff document filenames and content (grep inside the files)
- Remote branch names

If multiple matches, present them and ask which one.

If no matches:
- Try broader search terms
- Check if the branch exists on remote but has no handoff document
- Report that no matching session was found

### 2. Pull the Branch

```bash
git checkout <branch-name>
# or if it's a remote-only branch:
git checkout -b <branch-name> origin/<branch-name>
```

If you're in a worktree, create a new worktree instead:
```bash
git worktree add .claude/worktrees/<new-name> <branch-name>
```

### 3. Read the Handoff Document

Read `docs/sessions/<matching-file>.md` and extract:
- What was done
- Current state
- What's next
- Key files modified
- Any notes or gotchas

### 4. Clean Up Old Worktree

If the handoff document lists a worktree name:

```bash
# Check if old worktree still exists
git worktree list

# Remove if found
git worktree remove .claude/worktrees/<old-worktree-name> --force 2>/dev/null || true
```

Only remove the worktree listed in the handoff document, never the current one.

### 5. Update Handoff Document Status

```markdown
---
status: picked-up
picked-up-date: YYYY-MM-DD
---
```

### 6. Present Context Briefing

Output a structured summary:

```
## Session Resumed: <title>

**Branch:** <branch-name>
**Originally bounced:** <date>

### What Was Done
<from handoff doc>

### Current State
<from handoff doc>

### What's Next
<prioritized list from handoff doc>

### Suggested First Step
<your recommendation based on the "What's Next" section>
```

Then prompt: **"What would you like to tackle first?"**

## Rules

- **Always present context before doing work** — the user needs to reorient
- **Clean up the old worktree** — dead worktrees waste disk space
- **Mark the handoff document as picked-up** — prevents duplicate pickups
- **Don't start working automatically** — present the briefing and wait for direction
- **If no handoff document exists** for a branch, read the branch's recent commits and diffs to reconstruct context
