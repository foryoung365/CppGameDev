---
name: writing-plans
description: Use when you have routed requirements or a clarified design and need an implementation plan before touching files.
---

# Writing Plans

Use this skill to create the implementation plan for the routed task shape.
Every task starts with planning. The depth changes with the plan shape, but planning is never skipped.

## Supported Plan Shapes

- `micro-plan`
- `short-plan`
- `full-plan`
- `debugging-plan`

## Planning Rule

Choose the smallest plan shape that still reflects the risk and uncertainty of the task.

- `micro-plan`: narrow, low-risk, one domain, minimal steps
- `short-plan`: one feature or fix with a small set of concrete tasks
- `full-plan`: broader scope, multiple touched areas, or design work that needs clearer decomposition
- `debugging-plan`: diagnosis-first work where the root cause is not yet known

## What The Plan Must Include

- Exact files or modules to inspect or change
- The order of work
- The validation evidence for each task
- The exit condition for the whole request

## Commit Granularity

- Default delivery size is one complete feature or one complete fix.
- Do not describe tiny step-by-step delivery slices as if they were separate outcomes.
- Do not split one request into many partial handoffs unless the pieces are independently complete and clearly separable.
- If the task is still in discovery, it is not ready for delivery.

## Validation Guidance

- Define the evidence that will prove each task before writing the task itself.
- Prefer the cheapest reliable evidence that actually proves the change.
- Use compile checks, repro steps, logs, targeted checks, or tests as needed.
- Do not force a test-first workflow when another form of evidence is the better fit.

## Plan Writing Notes

- Keep tasks concrete enough that another agent can execute them without inventing scope.
- Avoid placeholder language.
- Do not include step-level commit language.
- If the work is diagnostic, keep the plan rooted in evidence collection and root cause confirmation first.

## Handoff

When the plan is complete, hand off the routed plan shape together with the required validation evidence and the delivery boundary.

