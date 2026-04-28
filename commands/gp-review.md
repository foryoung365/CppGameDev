# GP Review Command

Run the plugin review flow for gameplay work.

1. Use `gp-task-stage-discipline` to resolve the current task directory.
2. Run the `cpp-reviewer` agent for correctness, ownership, override safety, and project-local coding rules.
3. Run the `gameplay-reviewer` agent for state, lifecycle, config, event-chain, and cross-module gameplay risk.
4. Run the `checklist-reviewer` agent together with the `gp-review-checklist` skill for the dedicated checklist-based review pass.
5. Before dispatching gameplay or checklist review agents, prepare a bounded review packet: changed files, accepted diff summary, relevant task docs, known entry points, validation evidence, and any specific nearby call sites already identified by the main agent.
6. Tell gameplay and checklist review agents to stay inside that packet. If required evidence is missing, they must return `Needs main-agent input` with the missing file, diff, or call-site detail instead of scanning the repository broadly.
7. Run the `gp-experience-researcher` agent against the current review scope, and collect relevant prior learnings from the host project as secondary context only.
8. When the review scope is stable, prefer running the C++ review, gameplay review, checklist review, and prior-learning alignment in parallel whenever they are independent.
9. Combine reviewer output, experience output, and any subagent findings into one focused review pass, but let the main agent decide which findings are accepted and severity-ranked.
10. Include a `Relevant prior learnings` section that says whether the current change aligns with or conflicts with known learnings.
11. Include a `Checklist coverage` section that records covered checklist categories, checked item IDs, core high-risk item status, and not-applicable notes.
12. If subagents are used, limit them to routine support tasks such as pulling evidence, organizing reviewer notes, running the checklist review draft, or checking for matching prior learnings; they must not finalize the review.
13. Write the accepted review result to `<task-dir>/05-review.md` with findings, checklist coverage, residual risks, validation gaps, and prior-learning alignment.
14. Keep the review anchored to the local plugin rules, not imported generic defaults, and do not let reviewer outputs move the workflow forward until the main agent has accepted them.
