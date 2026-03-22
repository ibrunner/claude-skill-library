---
name: task-initiative
description: Create a new initiative document in docs/tasks/initiatives/. An initiative is the highest-level grouping — it spans multiple projects and represents a significant product or architectural direction.
---

# Create Task Initiative

## Taxonomy

An **initiative** is the highest level of the task taxonomy. It represents a significant product direction, architectural investment, or multi-project effort that spans several projects and often multiple development cycles.

- Initiatives **always** live in their own named folder: `docs/tasks/initiatives/{slug}/`
- The parent doc lives at `docs/tasks/initiatives/{slug}/{slug}.md`
- Projects and related docs for the initiative can be added alongside it in that folder
- Projects reference their parent initiative via `initiative:` in their front matter
- An initiative typically spans weeks to months and contains 2+ projects
- An initiative slug is the kebab-case folder name

## Instructions

1. **Gather requirements** — if the user hasn't provided a title and description, ask before proceeding.
2. **Determine priority** — if not specified, default to `high`. Initiatives represent strategic investments and are rarely low priority.
3. **Determine slug** — kebab-case from the title. Keep it broad and memorable — it will be used as a slug in many places.
4. **Create the folder** `docs/tasks/initiatives/{slug}/` and the file inside it at `docs/tasks/initiatives/{slug}/{slug}.md` using the template below, substituting the current date.

## Front Matter Schema

```yaml
---
type: initiative
status: draft
priority: critical|high|medium|low
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

## Template

```markdown
---
type: initiative
status: draft
priority: high
labels: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Initiative: {Title}

## Overview

{1–3 paragraphs describing the initiative, its strategic importance, and the problems it solves. Explain why this is a coherent grouping rather than independent projects.}

---

## Goals

- {Goal}

---

## Success Metrics

| Metric | Target |
|--------|--------|
| {Metric} | {Target} |

---

## Projects

Projects belonging to this initiative should set `initiative: {initiative-slug}` in their front matter.

- [ ] (list or link projects here as they are created)

---

## Non-Goals

- {Thing explicitly out of scope for this initiative}

---

## Open Questions / Decisions

| Question | Why it matters |
|----------|----------------|
| {Question} | {Reason} |

---

## Dev notes

(Use this section for references, architectural notes, and links to related docs and plans.)
```

## Notes

- Initiatives **always** get their own folder — even a single-file initiative. The folder is where related projects and docs will accumulate.
- The `initiative-slug` used in project and issue front matter is the folder name (e.g., `llm-features`).
- Success metrics should be concrete and measurable — they define what "done" looks like at the initiative level.
- Non-goals are as important as goals — they prevent scope creep and set clear boundaries.
- As projects are created, add them to the Projects list with a link to their file.
