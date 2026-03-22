# Claude Skill Library

A monorepo containing two independently installable Claude Code plugins for autonomous development workflows and in-repo task management.

## Plugins

### ians-common-skills

General-purpose skills for autonomous development, session management, plan refinement, and branch workflows.

#### Skills

| Skill | Description |
|-------|-------------|
| **yolo** | Full autonomous feature lifecycle: brainstorm, plan, implement, test, summarize. |
| **yolo-summary** | Internal skill invoked by yolo. Generates the completion report with acceptance criteria and test coverage. |
| **plan-refinement** | Adds phase structure, exit criteria, and checkboxes to existing plans. Complements `superpowers:writing-plans`. |
| **session-bounce** | End-of-session handoff: documents state, kills processes, rebases, renames branch, pushes. |
| **session-pickup** | Resumes a bounced session: finds the branch, reads handoff doc, presents context briefing. |
| **merge-to-main** | Merges feature branch to main: tests, merge, push, branch cleanup, plan archival. No PRs. |
| **branch-housekeeping** | End-of-branch cleanup: audit plan, capture unfinished work as tickets, archive docs, commit. |

#### Commands

| Command | Description |
|---------|-------------|
| `/yolo` | Invoke autonomous feature development |
| `/branch-review` | Review current branch diff for code quality |
| `/squash` | Squash branch commits into one |
| `/merge` | Merge branch to main |
| `/session-bounce` | End session with handoff document |
| `/session-pickup` | Resume a bounced session |
| `/joke` | Tell a programming joke |

---

### ians-task-tracker

Self-contained in-repo task management as an alternative to GitHub Issues or Linear.

#### Skills

| Skill | Description |
|-------|-------------|
| **plan-feature** | Quick task ticket creator. Takes a 1-sentence description, infers frontmatter, writes a ticket to `docs/tasks/`. |
| **task-initiative** | Creates initiative documents (highest-level grouping spanning multiple projects). |
| **task-project** | Creates project documents (groups related issues with phases). |
| **task-issue** | Creates issue documents (feature, fix, or chore work items). |
| **bug-report** | Investigates bugs and writes structured bug tickets with root cause analysis. |

#### Task Taxonomy

```
Initiative (strategic direction, spans multiple projects)
  └── Project (coherent collection of issues, defined phases)
       └── Issue (discrete work item: feature / fix / chore)
```

All task documents use YAML frontmatter with `type`, `status`, `priority`, and optional `project`/`initiative` slugs for cross-referencing.

## Installation

Install one or both plugins from the Claude Code marketplace. In Claude Code, run:

```
/plugin install ians-common-skills
/plugin install ians-task-tracker
```
