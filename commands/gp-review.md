# GP Review Command

Run the plugin review flow for gameplay work.

1. Use `gp-task-stage-discipline` to resolve the current task directory.
2. Run the C++ review using the agent prompt in `agents/cpp-reviewer.md` for correctness, ownership, override safety, and project-local coding rules.
3. Run the gameplay review using the agent prompt in `agents/gameplay-reviewer.md` for state, lifecycle, config, event-chain, and cross-module gameplay risk.
4. Run the checklist review using the agent prompt in `agents/checklist-reviewer.md` and the checklist items in `skills/gp-review-checklist/references/code-review-checklist.md`.
5. Run `gp-experience-check` against the current review scope and collect relevant prior learnings from the host project as secondary context only.
6. When the review scope is stable, prefer running the C++ review, gameplay review, checklist review, and prior-learning alignment in parallel whenever they are independent.
7. Combine reviewer output, experience output, and any subagent findings into one focused review pass, but let the main agent decide which findings are accepted and severity-ranked.
8. Include a `Relevant prior learnings` section that says whether the current change aligns with or conflicts with known learnings.
9. Include a `Checklist coverage` section that records covered checklist categories, checked item IDs, core high-risk item status, and not-applicable notes.
10. If subagents are used, limit them to routine support tasks such as pulling evidence, organizing reviewer notes, running the checklist review draft, or checking for matching prior learnings; they must not finalize the review.
11. Write the accepted review result to `<task-dir>/05-review.md` with findings, checklist coverage, residual risks, validation gaps, and prior-learning alignment.
12. Keep the review anchored to the local plugin rules, not imported generic defaults, and do not let reviewer outputs move the workflow forward until the main agent has accepted them.
