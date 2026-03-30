# GP Review Command

Run the plugin review flow for gameplay work.

1. Run `cpp-reviewer` for C++ correctness, ownership, override safety, and project-local coding rules.
2. Run `gameplay-reviewer` for state, lifecycle, config, event-chain, and cross-module gameplay risk.
3. Run `gp-experience-check` against the current review scope and collect relevant prior learnings from the host project.
4. Combine the findings into one focused review pass.
5. Include a `Relevant prior learnings` section that says whether the current change aligns with or conflicts with known learnings.
6. Keep the review anchored to the local plugin rules, not imported generic defaults.
