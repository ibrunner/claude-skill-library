---
name: merge-to-main
description: Use when finishing a feature branch and merging to main. Handles tests, merge, push, branch cleanup, and plan archival. Do not create PRs.
---

# Merge Branch to Main

## Steps

1. **Verify clean state** — `git status` to check for uncommitted changes. If any exist, ask the user what to do.
2. **Run tests** — run the project's test suite (e.g., `npm test`, `pnpm test`, `pytest`, `cargo test`, etc.) to verify the branch is clean.
3. **Switch to main** — `git checkout main && git pull origin main`
4. **Merge** — `git merge --ff-only <branch>`. If fast-forward fails, use `git merge <branch>` (regular merge commit).
5. **Push** — `git push origin main`
6. **Delete branch** — `git branch -d <branch>` (local) and `git push origin --delete <branch>` (remote, if it exists).
7. **Archive plans** — if `docs/plans/` contains a plan file for this branch, move it to `docs/archive/plans/`.
8. **Report** — show `git log --oneline -5` to confirm.

## Rules

- **Never create a pull request.** This workflow merges directly to main.
- If tests fail, stop and report. Do not merge broken code.
- If the branch has no remote, skip the remote delete step.
