# GP Review Command

Run the plugin review flow for gameplay work.

1. Run `cpp-reviewer` for C++ correctness, ownership, override safety, and project-local coding rules.
2. Run `gameplay-reviewer` for state, lifecycle, config, event-chain, and cross-module gameplay risk.
3. Combine the findings into one focused review pass.
4. Keep the review anchored to the local plugin rules, not imported generic defaults.
