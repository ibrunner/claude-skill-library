---
name: yolo-summary
description: Internal skill — only invoked by the yolo skill. Generates a structured completion report after autonomous feature development (YOLO mode). Summarizes acceptance criteria, implementation, testing layers, and provides a QA walkthrough for user validation.
---

# YOLO Summary — Completion Report

## Overview

Generate the final summary for a YOLO mode session. This is the user's primary interface for understanding and validating what was built. It must be comprehensive but scannable.

**This skill is invoked by the `yolo` skill at the end of Phase 5. Do not invoke it standalone.**

## Gathering Information

Before generating the summary, collect:

1. **Spec document** — read the spec file written in Phase 1
2. **Plan document** — read the plan file written in Phase 2
3. **Git log** — `git log --oneline main..HEAD` for all commits on this branch
4. **Test results** — last test suite output (pass/fail counts)
5. **E2E results** — last e2e test run output (if applicable)
6. **Autonomous decisions** — any decisions made without user input (from commit messages and notes)

## Summary Template

Present this to the user as a formatted message (not written to a file):

```markdown
## YOLO Complete: <Feature Name>

### Acceptance Criteria
<List each criterion from the spec with pass/fail status>
- [x] <criterion that was met>
- [x] <criterion that was met>
- [ ] <criterion not met — with explanation>

### What Was Built
<2-4 sentences describing the feature and how it works>

**Key files:**
- `path/to/new-file.ts` — <purpose>
- `path/to/modified-file.ts` — <what changed>
- ...

### Autonomous Decisions Made
<List any decisions made without user input>
| Decision | Choice Made | Alternatives Considered |
|----------|-------------|------------------------|
| <decision> | <choice> | <alternatives> |

### Testing Coverage

#### Unit Tests (<count> tests)
<What business logic and control flow is covered>
- `path/to/test.test.ts` — <what it tests>

#### E2E Tests (<count> tests)
<What UI flows are covered>
- `path/to/feature.spec.ts` — <what it tests>

### How to Try It

**Run the project:**
<Dev server command, e.g. `npm run dev`, `pnpm dev`, etc.>

**Steps to validate:**
<Numbered walkthrough written for a QA tester who has never seen the feature.
Each step is concrete: what to click, what to look for, what the expected result is.
Write 3-8 steps covering the primary happy path and one edge case.>

1. Start the dev server and open the app
2. <Navigate to the relevant part of the app — be specific about clicks>
3. <Perform the action the feature enables>
4. <Describe what you should see — be specific about UI elements, text, behavior>
5. <Test an edge case or alternate path>
6. <Describe expected result for the edge case>

### Branch
- **Branch:** `<branch-name>`
- **Worktree:** `<worktree-path>`
- **Commits:** <count> commits

### Next Steps
- **Looks good:** merge to main (or ask me to merge)
- **Feedback:** describe what to change and I'll iterate
- **Discard:** delete the branch and worktree
```

## Conditional Sections

- **Omit "E2E Tests"** if no e2e tests were written
- **Omit "Autonomous Decisions"** table if no significant decisions were made
- **Add "Known Limitations"** section if any acceptance criteria were not met or if scope was reduced

## Quality Checks

Before presenting the summary:

1. **Every acceptance criterion has a status** — no criterion is left unaddressed
2. **Test counts match actual test files** — don't guess, run the test suite and count
3. **Branch name is correct** — verify with `git branch --show-current`
4. **File paths exist** — don't list files that weren't actually created/modified
