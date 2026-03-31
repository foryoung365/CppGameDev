# GP Review Command

Run the plugin review flow for gameplay work.

1. Use `gp-task-stage-discipline` to resolve the current task directory.
2. Run `cpp-reviewer` for C++ correctness, ownership, override safety, and project-local coding rules.
3. Run `gameplay-reviewer` for state, lifecycle, config, event-chain, and cross-module gameplay risk.
4. Run `gp-experience-check` against the current review scope and collect relevant prior learnings from the host project.
5. Combine the findings into one focused review pass.
6. Include a `Relevant prior learnings` section that says whether the current change aligns with or conflicts with known learnings.
7. Write the review result to `<task-dir>/05-review.md` with findings, residual risks, validation gaps, and prior-learning alignment.
8. Keep the review anchored to the local plugin rules, not imported generic defaults.
