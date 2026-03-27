# Intake Command

Route the current request through the plugin intake path.

1. Run `gameplay-context-guard` and produce the full 8-field context card.
2. Pass the completed context card to `task-intake-router`.
3. Emit the router's `pre-plan` output with `goal`, `impact`, `unknowns`, `validation`, and `selected plan name`.
4. Continue with the selected plan-specific flow only after the router chooses `micro-plan`, `short-plan`, `full-plan`, or `debugging-plan`.

Keep project conventions ahead of imported defaults.
