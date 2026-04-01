# Request Lifecycle

This document describes the human-readable mirror of the intake path for gameplay work and the plan shapes used after routing. Runtime authority still lives in plugin assets such as `agents/gameplay-main.md`, `skills/gameplay-context-guard/SKILL.md`, and `skills/task-intake-router/SKILL.md`.

## Intake Path

The runtime path is:

`request -> gameplay-context-guard -> task-intake-router -> pre-plan`

The flow works like this:

1. `gameplay-context-guard` forces the request into a gameplay context card before any edit or plan is drafted.
2. `task-intake-router` uses the context card to classify the request by root-cause clarity, scope, and risk, then emits the `pre-plan` output.
3. `pre-plan` is the router's output stage with fixed fields: `goal`, `impact`, `unknowns`, `validation`, and `selected plan name`.
4. `gp-experience-check` can add an `Experience summary` after `pre-plan` using the host project's verified experience library.
5. The active task also persists stage files in the host project under `docs/cpp-mmorpg-gameplay/tasks/YYYY-MM-DD-<task-slug>/`, unless the host project's `claude.md` overrides that root.

## Stage Documents

Each task stage leaves a document behind so work can resume after context loss:

- `00-context.md`: gameplay context card
- `01-pre-plan.md`: routed pre-plan and selected plan name
- `02-debug.md`: active debugging evidence and root-cause work
- `03-plan.md`: actionable implementation plan, mandatory before edits
- `04-progress.md`: execution state, blocker, and next step
- `05-review.md`: review findings and residual risks
- `06-handoff.md`: delivery summary and compile evidence

Each stage document may also record:

- delegated support work
- what the subagent returned
- what the main agent accepted or rejected

The task does not advance until the main agent records the accepted conclusion.

## Plan Shapes

### micro-plan

Use for low-risk, single-domain changes that can be validated with a short checklist. Keep it tight and action-oriented, but still persist the actionable steps in `03-plan.md`.

### short-plan

Use for a single gameplay domain change with real regression risk. Break the work into a small number of subtasks, name the validation for each one, and persist them in `03-plan.md`.

### full-plan

Use for cross-module gameplay work, state-machine changes, protocol changes, persistence changes, or requests that need clearer scoping before implementation. This shape is the most explicit and should separate discovery, implementation, and verification, while still leaving a `03-plan.md` pointer inside the task directory.

### debugging-plan

Use when the root cause is not yet known. The goal is diagnosis first: reproduction, evidence collection, log review, and narrowing the fault before any fix is chosen. Keep the active diagnosis in `02-debug.md`, then write `03-plan.md` before any fix starts.

## Routing Reminder

- Unknown root cause pushes the request to `debugging-plan`.
- Cross-module, state-machine, protocol, or persistence work pushes the request to `full-plan`.
- Single-domain work with real regression risk pushes the request to `short-plan`.
- Everything else should stay in `micro-plan`.

## Operator Note

This document is for human operators. If a runtime rule and a doc summary ever diverge, fix the plugin runtime assets first and then update this mirror.
Historical experience is secondary context only; current code, current evidence, and current validation remain the primary truth.
Task-stage documents are required runtime anchors for recovering after context compression or session handoff.
