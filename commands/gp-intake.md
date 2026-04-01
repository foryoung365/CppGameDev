# GP Intake Command

Route the current request through the plugin intake path.

1. Use `gp-task-stage-discipline` to resolve the host-project task-doc root and create a new dated task directory `YYYY-MM-DD-<task-slug>`, unless the user explicitly told you to continue an existing task.
2. Run `gameplay-context-guard` and produce the full 8-field context card.
3. Write the context card to `<task-dir>/00-context.md`.
4. Pass the completed context card to `task-intake-router`.
5. Emit the router's `pre-plan` output with `goal`, `impact`, `unknowns`, `validation`, and `selected plan name`.
6. Run `gp-experience-check` after `pre-plan` and attach the `Experience summary` as secondary context only; prior learnings can suggest leads, but they do not advance the stage or replace router judgment.
7. Treat the main agent as the only decision-maker for whether intake is complete enough to move forward, and treat any subagent output as candidate evidence that still needs acceptance.
8. Write the routed result, plus the main agent's accepted conclusion, to `<task-dir>/01-pre-plan.md`.
9. Continue with the selected plan-specific flow only after the main agent accepts the router output and the router chooses `micro-plan`, `short-plan`, `full-plan`, or `debugging-plan`.
10. If subagents are used during intake, limit them to routine support tasks such as collecting context, summarizing logs, extracting candidates, or surfacing prior learnings; they must not make the stage call or write the accepted stage conclusion.

Keep project conventions ahead of imported defaults.
