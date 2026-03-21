---
name: plan-feature
description: Use when planning a new feature or multi-step task. Takes a 1-sentence description, infers frontmatter, and writes a task ticket to docs/tasks/.
---

# Plan Feature (Task Ticket Creator)

## Overview

Turn a 1-sentence feature description into a properly formatted task ticket in `docs/tasks/`. No brainstorming, no planning pipeline — just capture the work item fast.

## Process

1. **Scan existing projects and initiatives** from `docs/tasks/projects/` and `docs/tasks/initiatives/` to infer `project` and `initiative` slugs. Do this silently — do NOT ask the user if you can infer it.
2. **Infer frontmatter** from the description and context:
   - `type`: feature / fix / chore — infer from the request
   - `status`: backlog (default)
   - `priority`: ask only if genuinely ambiguous; default to `medium`
   - `project` / `initiative`: infer from existing docs; only ask if truly unclear
   - `labels`: infer or leave empty
   - `created` / `updated`: today's date
3. **Only ask questions you cannot answer yourself.** If priority is the only unknown, ask once.
4. **Write the ticket** to `docs/tasks/features/<slug>.md` (or `fixes/` / `chores/` as appropriate).

## Ticket Format

```markdown
---
type: feature|fix|chore
status: backlog
priority: critical|high|medium|low
project: (slug or empty)
initiative: (slug or empty)
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Title

## Summary

One paragraph describing what this does and why.

## Background

Context on the current state and why this is needed.

## Design

Key technical decisions, approach, components affected.

## Out of Scope

What this explicitly does not cover.
```

## Rules

- No brainstorming skill
- No writing-plans skill
- No other skills
- Infer everything you can from context before asking
- Ask at most one clarifying question, only if required for frontmatter
