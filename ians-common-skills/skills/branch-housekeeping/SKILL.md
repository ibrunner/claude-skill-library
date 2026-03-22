---
name: branch-housekeeping
description: Use when a development branch is winding down and needs cleanup before PR — plan reviewed, notes preserved, unfinished work captured, plan archived, and changes committed. Not for testing or PR prep, just housekeeping.
---

# Branch Housekeeping

## Overview

End-of-branch cleanup: verify the plan, preserve institutional knowledge, capture leftover work, archive the plan, and commit. Not about testing or PR readiness — just making sure nothing is lost and the repo is tidy.

## Process

### 1. Locate the Plan

Find the active implementation plan for this branch (typically `docs/plans/` or a feature-specific subdirectory). If no plan exists, skip to step 4.

### 2. Audit the Plan

Read every task/checkbox in the plan:

- **Mark completed tasks** — update any `[ ]` that are clearly done to `[x]`. Use git diff and recent commits as evidence, not memory.
- **Identify unfinished tasks** — list anything still `[ ]` that was not completed this session.

### 3. Handle Unfinished Tasks

First, scan `docs/tasks/projects/` and `docs/tasks/initiatives/` to see if this branch's work belongs to a parent project or initiative. Check the plan file itself — it often names the project or initiative it belongs to.

For each unfinished task, create a ticket in `docs/tasks/` (use the `plan-feature` skill or write manually):

- Type: match the task's nature (feature / fix / chore)
- Status: `backlog`
- `project` / `initiative`: set these if a parent exists — don't leave orphan tickets when there's an obvious home
- Include enough context that someone picking it up cold can understand what needs doing and why

### 4. Preserve Long-Term Notes

Scan the plan and any session notes for:

- **Architectural decisions** worth keeping — add to `CLAUDE.md` or relevant `docs/` file
- **Known issues / gotchas** discovered during the work — same destinations
- **Design patterns** established — `CLAUDE.md` under the relevant section
- **Recurring debugging insights** — memory files if appropriate

Only write what isn't already documented. Don't duplicate.

### 5. Archive the Plan and Related Docs

Move completed plan files and related design docs to `docs/archive/` (or an equivalent archive directory):

```bash
mkdir -p docs/archive/plans
mv <plan-file-path> docs/archive/plans/
```

Only archive when the feature is complete. If the plan covers a larger, ongoing effort, leave it in place.

### 6. Update Memory (if applicable)

If working with auto-memory, update or remove any entries that tracked the now-complete work. Don't leave stale "current focus" entries.

### 7. Clean Up Environments (if applicable)

If the project uses ephemeral environments (Docker sandboxes, dev servers, worktrees, etc.), clean up any running or orphaned instances. Skip this step if no such infrastructure exists.

### 8. Commit

Stage and commit all housekeeping changes together:

- Updated/archived plan
- New task tickets
- Any doc/CLAUDE.md additions
- Memory updates

Use a commit message like:
```
chore: branch housekeeping — archive plan, capture remaining tasks
```

## What This Is NOT

- Not a code review
- Not a test run
- Not PR prep (no squashing, no changelog, no PR description)
- Not a full retrospective

## Quick Checklist

- [ ] Plan found and read
- [ ] Completed tasks marked `[x]`
- [ ] Unfinished tasks captured as tickets in `docs/tasks/` (with correct project/initiative linkage)
- [ ] Long-term notes extracted to docs / CLAUDE.md
- [ ] Plan + related docs archived to `docs/archive/` (unless feature is ongoing)
- [ ] Environments cleaned up (if applicable)
- [ ] Memory files updated (remove stale entries)
- [ ] Everything committed
