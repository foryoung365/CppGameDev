---
name: standard-feature-flow
description: Use when gameplay work needs a short-plan with a few subtasks and validation at each step.
---

# Standard Feature Flow

Use only after `task-intake-router` has already produced a `pre-plan` whose `selected plan name` is `short-plan`.
Do not skip `gameplay-context-guard -> task-intake-router` or choose this flow directly.
Do not edit code until the host-project task directory contains `03-plan.md`.

Use a `short-plan`.

Checklist:

- Write or update `<task-dir>/03-plan.md` before edits begin.
- Break the work into 2-4 subtasks.
- Add a short risk note up front.
- Give each subtask its own validation step.
- Include a fresh compile step whenever code changes.
- Update `<task-dir>/04-progress.md` after each meaningful subtask and before pausing.
- Keep the work inside one gameplay domain unless routing escalates it to `full-plan`.

Make each subtask concrete enough that another agent can execute it without adding new scope.
