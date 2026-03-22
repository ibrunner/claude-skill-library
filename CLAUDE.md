# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Claude Code plugin library providing reusable skills, commands, and hooks for autonomous development workflows, session management, task tracking, and branch operations. This is a pure documentation/configuration project — no build system, no application code, no external dependencies.

## Architecture

### Plugin Structure

```
.claude-plugin/
  plugin.json        — Plugin manifest
  marketplace.json   — Marketplace distribution metadata
skills/              — Skills as SKILL.md files with YAML frontmatter (may be nested, e.g. skills/tasks/)
commands/            — Slash commands (thin wrappers that invoke skills)
hooks/
  hooks.json         — Hook event configuration
  *.sh               — Hook scripts
```

### Skill Format

Each skill lives at `skills/{skill-name}/SKILL.md` with:
- **YAML frontmatter**: `name` (kebab-case), `description` (trigger conditions)
- **Body**: Procedural markdown instructions, templates, code blocks

### Command Format

Commands at `commands/{command-name}.md` are minimal — typically a single line invoking a skill with `$ARGUMENTS` substitution.

### Hook System

The `plan-refinement-gate.sh` hook fires on PostToolUse for Write operations. It detects raw plan files written to `docs/plans/` (missing `## Phase` headers) and blocks execution (exit code 2) until the plan is refined via the `writing-implementation-plans` skill. Exit code 0 allows the write.

## Skill Categories

- **Autonomous development**: `yolo` (full lifecycle), `yolo-summary` (completion reports)
- **Task management** (`skills/tasks/`): `plan-feature` (task ticket capture), `task-initiative`, `task-project`, `task-issue`, `bug-report` — self-contained in-repo linear alternative (Initiative → Project → Issue)
- **Planning**: `writing-implementation-plans` (phased plan refinement, complements superpowers)
- **Session management**: `session-bounce` (end-of-session handoff), `session-pickup` (resume)
- **Branch workflows**: `merge-to-main` (direct merge, no PRs), `branch-housekeeping` (cleanup/archive)

## Conventions

- **Naming**: kebab-case for skills, commands, task slugs
- **Dates**: ISO format `YYYY-MM-DD`
- **Task frontmatter schema**: `type`, `status` (draft|backlog|in-progress|done), `priority`, `project`, `initiative`, `labels`, `created`, `updated`
- **File locations**: plans in `docs/plans/`, tasks in `docs/tasks/{type}s/`, sessions in `docs/sessions/`, archives in `docs/archive/`
- **Skill design**: keep main thread thin (dispatch to sub-agents), frequent commits as save points, self-contained sub-agent prompts
- **merge-to-main uses direct merges**, not pull request workflows

## Key Integration Points

- **superpowers plugin**: `writing-plans` skill produces raw plans that the plan-refinement-gate hook intercepts
- **TodoWrite**: used by yolo skill for progress tracking
- **Git**: branching, rebasing, merging operations across most skills
