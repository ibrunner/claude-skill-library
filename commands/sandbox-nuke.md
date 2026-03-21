---
description: Stop all running sandboxes, remove orphaned resources, and prune artifacts
---

Find and run the project's sandbox cleanup script (e.g., `./scripts/sandbox.sh clean --older-than 0h`). This stops all active sandboxes, removes orphaned Docker projects and worktrees, prunes stale cache volumes, and deletes all artifact directories.

Also delete any leftover test branches with `git branch -d`.

Report what was cleaned up.
