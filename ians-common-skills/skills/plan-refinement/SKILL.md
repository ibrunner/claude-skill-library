---
name: plan-refinement
description: Use when you want to refine a flat task plan into a phased implementation plan. Adds phase grouping, exit criteria, step checkboxes, and a notes section for multi-session tracking. Works on plan files produced by superpowers:writing-plans or written manually.
---

# Plan Refinement

## Overview

Refine a flat task plan into a phased, checkpointed plan that can be executed across multiple sessions. This skill **reads an existing plan file and replaces it in-place** — do not create a new file.

**Announce at start:** "I'm using plan-refinement to add phase structure to the plan."

---

## When to Use

- After writing a plan that needs phase organization before execution
- When a plan has tasks but no phase grouping, exit criteria, or progress checkboxes
- The user will point you at the plan file path, or you can ask for it

---

## Process

### Step 1: Read the plan file

Read the plan file. Identify all tasks and their steps.

### Step 2: Check for user flows

If the plan references a design doc, read it and check for a **User Flows** section. If missing and the feature has UI, add one to the design doc:

```markdown
## User Flows (E2E-tested)

| ID | Flow | Phase visible | Spec test |
|----|------|--------------|-----------|
| UF-1 | [First visible user action] | Phase N | `"[test name]"` |
```

If there's no design doc, add user flows directly to the plan header.

### Step 3: Group tasks into phases

Group related tasks into logical phases. A phase:
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

Wrap each group in a phase block:

```markdown
## Phase N: [Phase Name]

**Objective:** [What capability exists at the end of this phase]

**Can run in parallel:** [List independent tasks / note sequential dependencies]
```

### Step 4: Add step checkboxes

Convert all `**Step N: ...**` headings to `- [ ] **Step N: ...**` checkboxes. Detail content (code, commands) is indented under the checkbox with a blank line. Add a `- [ ] Task N.A complete` checkbox at the bottom of every task.

### Step 5: Add exit criteria to each phase

Append exit criteria after each phase's tasks:

```markdown
### Phase N Exit Criteria

Before moving to Phase N+1, ALL of the following must be true:

- [ ] Type-check passes with zero errors (if applicable)
- [ ] Tests pass (note any known pre-existing failures)
- [ ] [Specific behavioral check from the tasks in this phase]
- [ ] [Manual smoke test if applicable]
- [ ] All task and step checkboxes in Phase N are marked `[x]` in this plan file
```

Exit criteria must include at least one **specific** behavioral check — not "it works," name the behavior.

For UI phases, include UF-IDs that become testable. For the final E2E phase, include all UF-IDs as individual checkboxes.

### Step 6: Add notes section

Append at the bottom of the file:

```markdown
---

## Notes

> Add entries here during implementation. Include decisions made, deviations from the plan, and anything a future agent needs to know to continue correctly.

- **D-001** [date] [Task N.X]: [Decision or deviation and brief rationale]
```

Task ID references (e.g., `[1.A.3]`, `[Phase 2]`) are required on every note entry.

### Step 7: Renumber tasks

Prefix task numbers with their phase number:

| Level | Format | Example |
|---|---|---|
| Phase | `Phase N` | `Phase 1` |
| Task | `Task N.A` | `Task 1.A` |
| Step | `Step N` within each task | unchanged |

Add a phase summary to the plan header listing all phases with one-line summaries.

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| Creating a new file instead of replacing | Read the existing plan file, replace it in-place |
| Rewriting task content | Only reorganize — preserve all steps, commands, code from the original |
| Phases with only one task | Combine with adjacent phase or split tasks differently |
| Vague exit criteria ("tests pass") | Name the specific behaviors the tests verify |
| Skipping notes section | Always append it — needed for multi-session continuity |
| Renumbering steps inside tasks | Only rename Task-level headings, leave internal steps unchanged |
| Steps left as bold headings without checkboxes | Every `**Step N: ...**` must become `- [ ] **Step N: ...**` |
| Notes without task IDs | Every note must cite the specific task(s) it applies to |
| UI feature with no E2E phase | Any plan with frontend tasks must have a dedicated E2E phase |
