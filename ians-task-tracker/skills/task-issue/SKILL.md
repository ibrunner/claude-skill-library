---
name: task-issue
description: Create a new task issue (feature, fix, or chore) in docs/tasks/. Use when the user wants to create a feature request, bug report, or chore/cleanup task.
---

# Create Task Issue

## Taxonomy

Issues are discrete work items. Three types:

- **feature** — new functionality or user-facing capability
- **fix** — bug fix or behavioral correction
- **chore** — cleanup, refactoring, renaming, maintenance, or technical debt

Issues live in their type subfolder:
- `docs/tasks/features/`
- `docs/tasks/fixes/`
- `docs/tasks/chores/`

## Instructions

1. **Gather requirements** — if the user hasn't provided a title, type, and brief description, ask before proceeding.
2. **Determine type** — if unclear, ask. Default to `feature` only when the user confirms it's a new capability.
3. **Determine priority** — if not specified, default to `medium`. Valid values: `critical`, `high`, `medium`, `low`.
4. **Determine filename** — kebab-case from the title. Keep short and descriptive. Do not include the type prefix in the filename.
5. **Determine project / initiative** — if the issue clearly belongs to an existing project or initiative, set those slugs. Otherwise leave blank.
6. **Create the file** at `docs/tasks/{type}s/{filename}.md` using the template below, substituting the current date.

## Front Matter Schema

```yaml
---
type: feature|fix|chore
status: draft
priority: critical|high|medium|low
project: (slug of parent project, or omit)
initiative: (slug of parent initiative, or omit)
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

## Template

Use the following structure. For simple fixes or chores, omit sections that don't apply.

```markdown
---
type: feature
status: draft
priority: medium
project:
initiative:
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# {Title} – Product Requirements Document

## Goal

{One paragraph describing the goal and why it matters.}

---

## Scope

| Area | Description | Acceptance Criteria |
|------|-------------|---------------------|
| **{Area}** | {Description} | {Criteria} |

---

## Requirements

- [ ] {Requirement}

---

## Testing and Validation

- [ ] {Test case}

---

## Open Questions / Decisions

| Question | Why it matters |
|----------|----------------|
| {Question} | {Reason} |

---

## Dev notes

(Use this section for implementation notes, deviations, or references.)
```

## Notes

- Always include the complete front matter block — it is required for organization.
- For **fix** issues, replace "Product Requirements Document" in the title with "Bug Fix" and focus the Scope table on the broken behavior, expected behavior, and reproduction steps.
- For **chore** issues, keep the structure but replace the Scope table with a checklist of cleanup tasks if that is clearer.
- If a `project:` or `initiative:` slug is known, fill it in. The slug is the kebab-case filename of the parent project or initiative (without `.md`).
