---
name: writing-implementation-plans
description: Use immediately after superpowers:writing-plans saves its plan file — when the plan spans multiple sessions and needs phase organization with exit criteria and multi-session progress tracking
---

# Writing Implementation Plans

## Overview

Refine the micro-task plan produced by `superpowers:writing-plans` into a phased, checkpointed plan that an agent can execute across multiple sessions. This skill **reads the existing plan file and replaces it in-place** — do not create a new file.

**Announce at start:** "I'm using writing-implementation-plans to refine the plan into a phased format."

---

## When to Use

- Immediately after `superpowers:writing-plans` saves its plan file
- The plan file path was just announced in the previous step — use that exact path
- Do NOT run this before writing-plans; it needs the micro-task content to reorganize

---

## Process

### Step 1: Read the plan file

Read the plan file that writing-plans just saved. Identify all Tasks.

### Step 1b: Check design doc for User Flows section

If the plan header references a design doc, read it and check for a **User Flows** section.

**If the design doc has no User Flows section**, add one before phasing the plan:

```markdown
## User Flows (E2E-tested)

These flows are the canonical acceptance criteria for the feature. Each is verified by an E2E test.

| ID | Flow | Phase visible | Spec test |
|----|------|--------------|-----------|
| UF-1 | [First visible user action] | Phase N | `"[test name]"` |
| UF-2 | [Second visible user action] | Phase N | `"[test name]"` |
```

Derive flows from the feature scope and acceptance criteria already in the design doc. Each row represents one test. Add a **Phase checkpoints** note below the table indicating which phase makes each flow testable.

**If the plan has no design doc**, note this in the plan's Notes section and add user flows directly to the plan header as a fenced block.

### Step 2: Group tasks into phases

Group related tasks into logical phases. A phase is a unit of work that:
- Has a clear objective (what capability exists at the end)
- Can be validated independently before moving on
- Contains 2-5 tasks

Common phase boundaries:
- Foundation (types, utilities, path helpers)
- Core service / business logic
- Integration (wiring into existing pipeline)
- API / serving layer
- Frontend / client
- **E2E Tests** — required as the final phase for any feature with frontend UI tasks
- Operational tooling (scripts, backfill, config)

**Rule: UI features require an E2E phase.** If any task in the plan creates or modifies frontend components, the plan MUST include a dedicated final phase for E2E tests covering the user flows defined in Step 1b. This phase is not optional.

### Step 3: Add step checkboxes

Convert all `**Step N: ...**` headings to `- [ ] **Step N: ...**` checkboxes. If the project has a script for this (e.g., `scripts/add-plan-checkboxes.sh`), use it. Otherwise, do this manually via Edit tool.

Then read the updated file before proceeding to the phase reorganization.

### Step 4: Rewrite the file with phase structure

Replace the plan file with the phased structure below. **Preserve all existing task content** — you are reorganizing and wrapping, not rewriting tasks. Step checkboxes are already in place from Step 3; do not remove them.

---

## Plan Document Structure

### Header

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.
> Read the **Notes** section at the bottom before starting and after completing each phase — it records decisions and deviations that affect later steps.
> Mark each checkbox `[x]` only after completing the task AND its validation steps.

**Goal:** [Carry over from writing-plans header]

**Architecture:** [Carry over from writing-plans header]

**Tech Stack:** [Carry over from writing-plans header]

**Phases:**
- Phase 1: [Name] — [one-line summary]
- Phase 2: [Name] — [one-line summary]
- Phase N: [Name] — [one-line summary]

**Key Documents:**
- Design doc: `[path to design doc]`
- Relevant types: `[path/to/types]`
- Relevant tests: `[path/to/tests/]`

---
```

### Phase Block

Wrap each group of tasks in this structure:

```markdown
## Phase N: [Phase Name]

**Objective:** [What capability exists at the end of this phase and why it's a logical unit]

**Can run in parallel:** [List independent tasks / note sequential dependencies]

---

[Tasks — see Task Structure below]

---

### Phase N Exit Criteria

Before moving to Phase N+1, ALL of the following must be true:

- [ ] Type-check passes with zero errors (if applicable)
- [ ] Tests pass (note any known pre-existing failures)
- [ ] [Specific behavioral check from the tasks in this phase]
- [ ] [Manual smoke test if applicable]
- [ ] All task and step checkboxes in Phase N are marked `[x]` in this plan file
```

### Task Structure

Every task must use per-step checkboxes. Convert each `**Step N: ...**` heading from writing-plans into a checkbox item.

```markdown
### Task N.A: [Component Name]

- [ ] **Step 1: Write the failing test**

  ```typescript
  // code goes here
  ```

- [ ] **Step 2: Run test to verify it fails**

  Run: `<project test command> -- --testPathPattern="foo"`
  Expected: FAIL with "cannot find module"

- [ ] **Step 3: Write the implementation**

  ```typescript
  // code goes here
  ```

- [ ] **Step 4: Run test to verify it passes**

  Run: `<project test command> -- --testPathPattern="foo"`
  Expected: PASS

- [ ] **Step 5: Commit**

  ```bash
  git add path/to/file.ts path/to/test.ts
  git commit -m "feat: ..."
  ```

- [ ] Task N.A complete
```

**Rules:**
- Every step from writing-plans becomes a `- [ ]` checkbox
- Detail content (code, commands, expected output) is indented under the checkbox with a blank line
- The final `- [ ] Task N.A complete` checkbox stays at the bottom of every task
- Do NOT flatten multi-line step content — preserve all code blocks and commands

### Notes Section

Append at the bottom of the file:

```markdown
---

## Notes

> Add entries here during implementation. Include decisions made, deviations from the plan, and anything a future agent needs to know to continue correctly. One bullet per item, with the affected task ID(s) listed after the date.

- **D-001** [date] [Task N.X]: [Decision or deviation and brief rationale]
```

The task ID field (e.g., `[1.A.3]`, `[4.B.1, 4.B.2]`, `[Phase 2]`) is **required** — it tells future agents exactly where in the plan the decision applies.

---

## Numbering Convention

Tasks from writing-plans are already numbered (Task 1, Task 2, etc.). When grouping into phases, prefix with phase number:

| Level | Format | Example |
|---|---|---|
| Phase | `Phase N` | `Phase 1` |
| Task | `Task N.A` | `Task 1.A` |
| Step | `Step N` within each task | unchanged from writing-plans |

Rename tasks in the file to match (e.g. "Task 1" -> "Task 1.A: Foundation — Path Utilities").

---

## Exit Criteria Content

Each phase exit criteria block must contain:
1. Type-check command + expected result
2. Test command + expected result
3. At least one specific behavioral check (not "it works" — name the behavior)
4. Manual smoke test if any UI or HTTP endpoint was added

**For phases that build frontend UI components**, exit criteria MUST also include:

5. A visual verification block listing the specific UF-IDs that become testable at the end of this phase.

**For the final E2E phase**, exit criteria must include:
- All UF-IDs as individual checkboxes
- E2E test suite passing
- Any skipped flows explicitly documented with a Note entry explaining why

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| Creating a new file instead of replacing | Read the path writing-plans announced, replace that file |
| Rewriting task content | Only reorganize — preserve all steps, commands, code from writing-plans |
| Phases with only one task | Combine with adjacent phase or split tasks differently |
| Vague exit criteria ("tests pass") | Name the specific behaviors the tests verify |
| Skipping notes section | Always append it — it's needed for multi-session continuity |
| Renumbering steps inside tasks | Only rename the Task-level headings, leave internal steps unchanged |
| Steps left as bold headings without checkboxes | Every `**Step N: ...**` must become `- [ ] **Step N: ...**` |
| Step detail content not indented | Put a blank line after the checkbox line, then indent code/commands so they nest under it |
| Notes without task IDs | Every note must cite the specific task(s) it applies to |
| No mark-complete step in exit criteria | Every phase exit criteria must include the checkbox-marking step |
| UI feature with no E2E phase | Any plan with frontend tasks must have a dedicated E2E phase as the final phase |
