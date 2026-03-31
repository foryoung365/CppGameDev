---
name: gp-task-stage-discipline
description: Use when gameplay work must persist every stage transition into host-project task documents so execution can resume after context loss.
---

# GP Task Stage Discipline

Use this skill to keep gameplay work anchored to host-project task documents instead of transient conversation context.

## Core Rule

Every stage transition must be written to a task directory in the active host project before the next stage begins.

## Task Root Resolution

Resolve the task-doc root in this order:

1. explicit task-doc root from the active host project's `claude.md`
2. default namespaced root:
   - `docs/cpp-mmorpg-gameplay/tasks/`

The plugin repository is not the task-doc root.

## Task Directory Model

Each task lives under:

```text
<task-root>/YYYY-MM-DD-<task-slug>/
```

Create a new dated task directory for each new task instance.
Reuse an existing task directory only when the user explicitly says to continue that exact task.
The dated task directory protects new work from accidentally reusing stale stage docs from an older task with a similar name.

Required stage files:

- `00-context.md`
- `01-pre-plan.md`
- `02-debug.md`
- `03-plan.md`
- `04-progress.md`
- `05-review.md`
- `06-handoff.md`

Not every file exists from the start, but every stage transition that occurs must leave its matching document behind.

## Stage Rules

### `00-context.md`

Write this after `gameplay-context-guard`.

Must capture:

- gameplay subdomain
- main entry point
- state and lifecycle impact
- data and config impact
- event chain and call path
- current evidence source
- risk level
- recommended next path

### `01-pre-plan.md`

Write this after `task-intake-router`.

Must capture:

- goal
- impact
- unknowns
- validation
- selected plan name
- optional experience summary as secondary context

No implementation flow begins until `01-pre-plan.md` exists.

### `02-debug.md`

Write and update this while the task is in `debugging-plan`.

Must capture:

- symptom
- reproduction
- evidence gathered
- hypotheses tested
- rejected explanations
- root-cause conclusion, when known

Do not leave debugging and start implementation until `02-debug.md` explains the root cause clearly enough to support a fix plan.

### `03-plan.md`

This is mandatory before any code edit, for **all** implementation paths:

- `micro-plan`
- `short-plan`
- `full-plan`
- post-debug implementation

`03-plan.md` must include:

- exact files to inspect
- exact files to modify
- ordered implementation steps
- validation steps
- compile requirement when code changes

For `full-plan`, `03-plan.md` may point to a more detailed implementation plan, but it still must exist inside the task directory.

### `04-progress.md`

Update this during execution.

At minimum capture:

- completed steps
- remaining steps
- blocker, if any
- next action
- corrected mistakes and their verified fixes, when they occur

Update it after meaningful progress and before pausing or handing off to a new session.

### `05-review.md`

Write this when review happens.

Must capture:

- findings
- residual risks
- validation gaps
- alignment or conflict with prior learnings

### `06-handoff.md`

Write this before any delivery-ready or commit-ready conclusion.

Must capture:

- purpose
- affected modules
- validation evidence
- fresh compile evidence when code changed
- corrected pitfalls from this task
- transferable lesson candidates from this task
- commit suggestion
- rollback or risk note

## Recovery Rule

After context compression, session restart, or agent handoff:

1. reload the task directory
2. read the latest stage files
3. resume from the last incomplete stage
4. do not reconstruct plan state from memory alone

## Hard Gates

- No `03-plan.md` -> no code edits
- No current `04-progress.md` update -> no stage-complete claim
- No fresh compile evidence for code-changing work -> no ready conclusion in `06-handoff.md`

## Relationship To Other Skills

- `gameplay-context-guard` feeds `00-context.md`
- `task-intake-router` feeds `01-pre-plan.md`
- `systematic-debugging` feeds `02-debug.md`
- implementation flows feed `03-plan.md` and `04-progress.md`
- `gp-review` feeds `05-review.md`
- `svn-delivery-handoff` feeds `06-handoff.md`

Use the templates in `references/task-stage-templates.md` when you need a concise structure.
