---
name: task-project
description: Create a new project document in docs/tasks/projects/. A project groups multiple related issues and has defined phases. Use when a body of work is too large for a single issue and spans multiple work streams or deliverable phases.
---

# Create Task Project

## Taxonomy

A **project** is a coherent collection of related issues with a defined scope, deliverable phases, and a clear end state. Projects are larger than a single issue but smaller than an initiative.

- Projects **always** live in their own named folder: `docs/tasks/projects/{slug}/`
- The parent doc lives at `docs/tasks/projects/{slug}/{slug}.md`
- Issues and sub-docs for the project can be added alongside it in that folder
- Issues reference their parent project via `project:` in their front matter
- Projects may optionally belong to an `initiative:`
- A project slug is the kebab-case folder name

## Instructions

1. **Gather requirements** — if the user hasn't provided a title and description, ask before proceeding.
2. **Determine priority** — if not specified, default to `medium`. Valid values: `critical`, `high`, `medium`, `low`.
3. **Determine initiative** — if this project clearly belongs to an existing initiative, set the `initiative:` slug. Otherwise leave blank.
4. **Determine slug** — kebab-case from the title. Keep broad enough to encompass all related issues.
5. **Create the folder** `docs/tasks/projects/{slug}/` and the file inside it at `docs/tasks/projects/{slug}/{slug}.md` using the template below, substituting the current date.

## Front Matter Schema

```yaml
---
type: project
status: draft
priority: critical|high|medium|low
initiative: (slug of parent initiative, or omit)
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

## Template

```markdown
---
type: project
status: draft
priority: medium
initiative:
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Project: {Title}

## Overview

{1–2 paragraphs describing the project, its purpose, and what success looks like.}

---

## Goals

- {Goal}

---

## Scope

| In scope | Out of scope |
|----------|--------------|
| {Item} | {Item} |

---

## Issues

Issues belonging to this project should set `project: {project-slug}` in their front matter.

- [ ] (list or link issues here as they are created)

---

## Phases

### Phase A

- [ ] {Task}

### Phase B

- [ ] {Task}

---

## Open Questions / Decisions

| Question | Why it matters |
|----------|----------------|
| {Question} | {Reason} |

---

## Dev notes

(Use this section for notes, architectural decisions, references, and links to related docs.)
```

## Notes

- Projects **always** get their own folder — even a single-file project. The folder is where sub-issues and related docs will accumulate.
- The `project-slug` used in issue front matter is the folder name (e.g., `mock-backend`).
- Phases are flexible — use as many as needed. If the project is simple, collapse to a single phase or replace with a flat checklist.
- As issues are created, add them to the Issues list with a link to their file.
