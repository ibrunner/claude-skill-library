# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A monorepo containing two Claude Code plugins. Each plugin is independently installable. This is a pure documentation/configuration project — no build system, no application code, no external dependencies.

## Architecture

### Repository Structure

```
.claude-plugin/
  marketplace.json   — Lists both plugins for marketplace distribution

ians-common-skills/  — Plugin: general-purpose development skills
  .claude-plugin/plugin.json
  skills/
  commands/

ians-task-tracker/   — Plugin: in-repo task management
  .claude-plugin/plugin.json
  skills/
```

### Skill Format

Each skill lives at `skills/{skill-name}/SKILL.md` with:
- **YAML frontmatter**: `name` (kebab-case), `description` (trigger conditions)
- **Body**: Procedural markdown instructions, templates, code blocks

### Command Format

Commands at `commands/{command-name}.md` are minimal — typically a single line invoking a skill with `$ARGUMENTS` substitution.

## Plugins

### ians-common-skills

- **Autonomous development**: `yolo` (full lifecycle), `yolo-summary` (completion reports)
- **Planning**: `plan-refinement` (adds phase structure, exit criteria, and checkboxes to existing plans — complements superpowers:writing-plans)
- **Session management**: `session-bounce` (end-of-session handoff), `session-pickup` (resume)
- **Branch workflows**: `merge-to-main` (direct merge, no PRs), `branch-housekeeping` (cleanup/archive)

### ians-task-tracker

Self-contained in-repo task management as an alternative to GitHub Issues or Linear.

- `task-initiative`, `task-project`, `task-issue`, `bug-report`, `plan-feature`
- Three-level hierarchy: Initiative → Project → Issue
- Task frontmatter schema: `type`, `status` (draft|backlog|in-progress|done), `priority`, `project`, `initiative`, `labels`, `created`, `updated`
- File locations: tasks in `docs/tasks/{type}s/`, projects in `docs/tasks/projects/{slug}/`, initiatives in `docs/tasks/initiatives/{slug}/`

## Conventions

- **Naming**: kebab-case for skills, commands, task slugs
- **Dates**: ISO format `YYYY-MM-DD`
- **Skill design**: keep main thread thin (dispatch to sub-agents), frequent commits as save points, self-contained sub-agent prompts
- **merge-to-main uses direct merges**, not pull request workflows

## Key Integration Points

- **superpowers plugin**: `plan-refinement` skill complements `superpowers:writing-plans` by adding phase structure to flat plans
- **TodoWrite**: used by yolo skill for progress tracking
- **Git**: branching, rebasing, merging operations across most skills
