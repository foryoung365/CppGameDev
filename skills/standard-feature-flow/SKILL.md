---
name: standard-feature-flow
description: Use when gameplay work needs a short-plan with a few subtasks and validation at each step.
---

# Standard Feature Flow

Use only after `task-intake-router` has already produced a `pre-plan` whose `selected plan name` is `short-plan`.
Do not skip `gameplay-context-guard -> task-intake-router` or choose this flow directly.

Use a `short-plan`.

Checklist:

- Break the work into 2-4 subtasks.
- Add a short risk note up front.
- Give each subtask its own validation step.
- Keep the work inside one gameplay domain unless routing escalates it to `full-plan`.

Make each subtask concrete enough that another agent can execute it without adding new scope.
