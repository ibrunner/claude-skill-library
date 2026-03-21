# Claude Skill Library

A shared collection of Claude Code skills and commands for autonomous development, session management, task tracking, and branch workflows.

## Installation

Add this plugin to your Claude Code settings:

```json
{
  "plugins": [
    "/path/to/claude-skill-library"
  ]
}
```

## Skills (14)

### Autonomous Development

| Skill | Description |
|-------|-------------|
| **yolo** | Full autonomous feature lifecycle: brainstorm, plan, implement, test, summarize. User walks away, comes back to a structured summary. |
| **yolo-summary** | Internal skill invoked by yolo. Generates the completion report with acceptance criteria, test coverage, and QA walkthrough. |

### Planning & Documentation

| Skill | Description |
|-------|-------------|
| **plan-feature** | Quick task ticket creator. Takes a 1-sentence description, infers frontmatter, writes a ticket to `docs/tasks/`. |
| **writing-implementation-plans** | Refines micro-task plans into phased, multi-session implementation plans with exit criteria and checkpoints. |

### Task Management

| Skill | Description |
|-------|-------------|
| **task-initiative** | Creates initiative documents (highest-level grouping spanning multiple projects). |
| **task-project** | Creates project documents (groups related issues with phases). |
| **task-issue** | Creates issue documents (feature, fix, or chore work items). |
| **bug-report** | Investigates bugs and writes structured bug tickets with root cause analysis. |

### Session Management

| Skill | Description |
|-------|-------------|
| **session-bounce** | End-of-session handoff: documents state, kills processes, rebases, renames branch, pushes. |
| **session-pickup** | Resumes a bounced session: finds the branch, reads handoff doc, presents context briefing. |

### Branch Workflows

| Skill | Description |
|-------|-------------|
| **merge-to-main** | Merges feature branch to main: tests, merge, push, branch cleanup, plan archival. No PRs. |
| **branch-housekeeping** | End-of-branch cleanup: audit plan, capture unfinished work as tickets, archive docs, commit. |

### Testing & Tools

| Skill | Description |
|-------|-------------|
| **sandbox-testing** | Ephemeral Docker Compose environments for branch testing with Playwright. |
| **read-png-metadata** | Reads PNG tEXt chunks (A1111 parameters, ComfyUI JSON, etc.) using Node.js one-liners. |

## Commands (8)

| Command | Description |
|---------|-------------|
| `/yolo` | Invoke autonomous feature development |
| `/branch-review` | Review current branch diff for code quality |
| `/squash` | Squash branch commits into one |
| `/merge` | Merge branch to main |
| `/session-bounce` | End session with handoff document |
| `/session-pickup` | Resume a bounced session |
| `/sandbox-nuke` | Stop all sandboxes and clean up |
| `/joke` | Tell a programming joke |

## Task Taxonomy

The task management skills follow a three-level hierarchy:

```
Initiative (strategic direction, spans multiple projects)
  └── Project (coherent collection of issues, defined phases)
       └── Issue (discrete work item: feature / fix / chore)
```

All task documents use YAML frontmatter with `type`, `status`, `priority`, and optional `project`/`initiative` slugs for cross-referencing.

## Origins

Skills sourced from:
- **User-level Claude skills** (`~/.claude/skills/`) — ported directly
- **SD-flow project skills** — generalized to remove project-specific references (package managers, sandbox scripts, project paths)
