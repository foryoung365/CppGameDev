# GP Intake Command

Route the current request through the plugin intake path.

1. Use `gp-task-stage-discipline` to resolve the host-project task-doc root and create a new dated task directory `YYYY-MM-DD-<task-slug>`, unless the user explicitly told you to continue an existing task.
2. Run `gameplay-context-guard` and produce the full 8-field context card.
3. Write the context card to `<task-dir>/00-context.md`.
4. Pass the completed context card to `task-intake-router`.
5. Emit the router's `pre-plan` output with `goal`, `impact`, `unknowns`, `validation`, and `selected plan name`.
6. Run `gp-experience-check` after `pre-plan` and attach the `Experience summary` as secondary context.
7. Write the routed result to `<task-dir>/01-pre-plan.md`.
8. Continue with the selected plan-specific flow only after the router chooses `micro-plan`, `short-plan`, `full-plan`, or `debugging-plan`.

Keep project conventions ahead of imported defaults.
