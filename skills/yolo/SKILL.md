---
name: yolo
description: Use when the user says "/yolo", "yolo mode", "yolo this", "run this autonomously", or asks to implement a feature without supervision. Autonomous feature development — accepts a feature description and runs the full lifecycle (brainstorm, plan, execute, test, summarize) without user intervention.
---

# YOLO Mode — Autonomous Feature Development

## Overview

Pick up a feature and run with it end-to-end. The user walks away; you brainstorm, plan, implement, test, and produce a summary for validation. **Never auto-merge.** The terminal state is a structured summary.

**Announce at start:** "Entering YOLO mode. I'll brainstorm, plan, implement, and test this feature autonomously. You'll get a summary when I'm done."

## Arguments

`/yolo <feature description>`

The feature description can be a sentence, a task ticket path, or an issue reference.

## Context Management — Critical

This session may run for hours. Context exhaustion is the primary failure mode. Follow these rules:

1. **Main thread stays thin** — only orchestration logic and progress reporting. All heavy work goes to sub-agents.
2. **Use TodoWrite** — track global progress. Update after each task completes, not just each phase.
3. **Report progress visibly** — see "Progress Reporting" section. The user is checking in periodically.
4. **Sub-agent prompts are self-contained** — include all context the agent needs. Never assume it has your history.
5. **One sub-agent at a time for implementation** — parallel agents for independent tasks only (e.g., writing tests for different subsystems).
6. **Commit frequently** — each completed task gets its own commit. This is your save point.
7. **Summarize sub-agent results in 2-3 sentences** — don't paste full outputs into your context.

## Progress Reporting — User Visibility

The user may glance at their screen every 10-20 minutes. Sub-agents run silently, so the **main thread must emit visible progress updates**. This is not optional.

### When to report

Output a progress update to the user:

1. **Before dispatching any sub-agent** — what phase you're in, what the sub-agent will do
2. **After every sub-agent returns** — 2-3 sentence summary of what it accomplished or failed
3. **After every TodoWrite update** — the user sees the task list change, but add a one-liner for context
4. **After every commit** — mention what was committed
5. **At phase transitions** — announce entering a new phase with what's ahead

### Format

Keep updates short and scannable. Use this pattern:

```
### Phase N: <Name> — <status>
<one-line description of what just happened or is about to happen>
```

Examples:
```
### Phase 1: Brainstorm — dispatching
Sending feature description to Opus sub-agent for autonomous design.

### Phase 1: Brainstorm — complete
Spec written to docs/specs/2026-03-15-batch-delete.md.
Key decisions: soft-delete with 30-day retention, confirmation modal with count.

### Phase 3: Execute — Task 3/7 complete
Added BatchDeleteButton component with confirmation dialog. Tests passing (4 new).

### Phase 3: Execute — Task 4/7 dispatching
Implementing the backend DELETE endpoint and database soft-delete logic.
```

### What NOT to do

- Don't go silent for more than 5 minutes without a visible update
- Don't dump full sub-agent output — summarize
- Don't skip updates because "it's obvious from TodoWrite" — the user wants text confirmation too

## Model Selection

| Role | Model | Why |
|------|-------|-----|
| Brainstorming | opus | Design decisions need reasoning depth |
| Plan writing | opus | Architecture and decomposition need judgment |
| Plan/spec review | opus | Review quality determines implementation quality |
| Implementation tasks | sonnet | Mechanical work with clear specs |
| Simple checks/lookups | haiku | Fast, cheap, no reasoning needed |
| Code review | sonnet | Good balance of speed and judgment |
| Final summary | opus | Synthesis across the full session |

## Phase 0: Setup

1. **Parse the feature description** — if it's a file path, read the ticket. If it's a sentence, use it directly.
2. **Create a worktree** — invoke `superpowers:using-git-worktrees` to isolate work.
3. **Create TodoWrite tracker** with all phases:
   - Phase 1: Brainstorm
   - Phase 2: Plan
   - Phase 3: Execute (will expand into sub-tasks)
   - Phase 4: Testing
   - Phase 5: Summary & handoff

## Phase 1: Brainstorm (Opus sub-agent)

Dispatch an Opus sub-agent with:

```
You are brainstorming a feature for an autonomous development session (YOLO mode).
The user will NOT be available for questions — make autonomous decisions.

Feature: <feature description>

Instructions:
1. Read the project's CLAUDE.md for context
2. Explore the codebase to understand relevant existing code
3. When the brainstorming process would normally ask the user a question:
   - Choose the recommended/simplest approach
   - Document your decision and rationale
   - Move on immediately
4. Write a concise spec to docs/specs/YYYY-MM-DD-<feature>-design.md (or whatever docs directory the project uses)
5. The spec should include:
   - Goal (1-2 sentences)
   - Approach (recommended path, with brief mention of alternatives considered)
   - Acceptance criteria (testable, specific)
   - Testing strategy
   - Files to create/modify
6. Commit the spec

Do NOT invoke writing-plans. Just write the spec and commit it.
Return: path to spec file + summary of key decisions made.
```

**Gate:** Spec file exists and is committed.

**After this phase:** Record the spec path and acceptance criteria in your TodoWrite notes. You'll need them for the summary.

## Phase 2: Plan (Opus sub-agent)

Dispatch an Opus sub-agent with:

```
You are writing an implementation plan for an autonomous development session.

Spec: <paste spec content or path>

Instructions:
1. Read the spec document
2. Use the superpowers:writing-plans skill to create the implementation plan
3. When the planning process would normally ask the user a question:
   - Choose the recommended/simplest approach
   - Document your decision
4. The plan MUST include testing at every task level:
   - Each task has TDD steps (write failing test → implement → verify)
   - After UI tasks: add e2e test steps if the project uses Playwright or similar
5. Save the plan to the project's docs/plans/ directory (or equivalent)
6. Commit the plan

Return: path to plan file + number of tasks + brief task list.
```

**Gate:** Plan file exists, is committed, and has tasks with checkboxes.

**After this phase:** Update TodoWrite with the specific implementation tasks from the plan.

## Phase 3: Execute (Sonnet sub-agents per task)

Use the `superpowers:subagent-driven-development` skill to execute the plan.

Key overrides for YOLO mode:
- **Implementation sub-agents use Sonnet** (not the default model)
- **Review sub-agents use Sonnet** for code quality
- **When sub-agents would ask questions:** provide context from the spec and plan. If truly ambiguous, choose the simpler path and document the decision.
- **After each task completes:** run the project's test suite to verify nothing is broken. If tests fail, the implementation sub-agent fixes them before moving on.

**Gate:** All plan tasks checked off. Tests pass. Type-check passes (if applicable).

## Phase 4: Testing

### 4a: E2E Tests

If the feature has UI components and the project uses e2e testing (Playwright, Cypress, etc.):

1. **Write e2e tests** — dispatch a Sonnet sub-agent:
   ```
   Write e2e tests for <feature>.

   Spec: <key acceptance criteria>
   Files changed: <list from plan>

   Follow the project's existing e2e test conventions and directory structure.
   Tests should cover: feature visibility, primary happy path, state changes.

   Run the e2e test suite to verify tests pass.
   ```

2. **Gate:** E2E tests pass.

### 4b: Skip conditions

- Skip 4a if the feature has no UI components
- Skip 4a if the project has no e2e testing infrastructure

## Phase 5: Summary & Handoff

Invoke the `yolo-summary` skill to generate the completion report. The summary MUST include:

1. **"How to Try It" section** — a step-by-step QA walkthrough written for someone who has never seen the feature. Each step is a concrete action: what to click, what to look for, what the expected result is. Not generic "test the feature" — specific actions.
2. **How to run the project** — dev server command or equivalent so the user can validate.

**Critical:** Do NOT merge to main. Do NOT invoke any merge skill. Present the summary and wait.

## Autonomous Decision-Making Rules

When you encounter a decision point that would normally require user input:

1. **Approach choices:** Pick the simplest approach that meets the acceptance criteria
2. **Scope questions:** Stay minimal — implement what was asked, not what could be added
3. **Testing questions:** More tests > fewer tests. When in doubt, add the test.
4. **Architecture questions:** Follow existing project patterns. Don't introduce new patterns.
5. **Naming questions:** Follow existing project conventions.
6. **Error handling:** Follow project patterns. Don't over-engineer error handling.
7. **Document all autonomous decisions** — note them in commit messages and the final summary

## Failure Modes & Recovery

| Failure | Recovery |
|---------|----------|
| Sub-agent fails a task | Re-dispatch with more context. If fails again, note in summary and move on. |
| Tests fail after implementation | Sub-agent fixes before moving to next task. Max 3 retries, then note in summary. |
| Context getting large | Dispatch more aggressively to sub-agents. Summarize results tersely. |
| Brainstorming scope too large | Decompose into sub-projects, implement the first one only. |
| Plan has >15 tasks | Consider if scope is too large. Implement core tasks, defer stretch goals. |
| Worktree creation fails | Branch may already exist. Try a different name or clean up stale worktrees. |

## Integration with Existing Skills

This skill orchestrates these existing skills — do NOT reimplement their logic:

| Skill | Used in Phase |
|-------|--------------|
| `superpowers:using-git-worktrees` | Phase 0 |
| `superpowers:brainstorming` | Phase 1 (sub-agent uses brainstorming principles, not the skill directly) |
| `superpowers:writing-plans` | Phase 2 (via sub-agent) |
| `superpowers:subagent-driven-development` | Phase 3 |
| `superpowers:test-driven-development` | Phase 3 (within implementation sub-agents) |
| `superpowers:verification-before-completion` | Phase 4 gates |
| `yolo-summary` | Phase 5 |

## What NOT To Do

- **Never auto-merge** — the user validates first
- **Never skip tests** — every phase has a gate
- **Never paste full sub-agent output into main context** — summarize in 2-3 sentences
- **Never ask the user questions** — make the decision and document it
- **Never introduce new dependencies without checking the project's package manifest first**
- **Never skip the summary** — it's the user's primary interface for validation
