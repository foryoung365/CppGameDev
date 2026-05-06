# GP Review Command

Run the plugin review flow for gameplay work.

First choose the review mode.

## In-Flow Review

Use this mode when the user is continuing a normal task-stage workflow, preparing delivery, or asking whether current work is ready to move forward.

1. Use `gp-task-stage-discipline` to resolve the active task directory.
2. Resolve the review scope from the user request, current diff, relevant task docs, changed files, validation evidence, and nearby call sites already identified by the main agent.
3. Run the `code-reviewer` agent only when a bounded draft review would help; otherwise the main agent may perform the review directly.
4. Run the `gp-experience-researcher` agent against the current review scope, and collect relevant prior learnings from the host project as secondary context only.
5. When the review scope is stable, prefer running independent support work such as draft review, evidence collation, and prior-learning alignment in parallel whenever they are independent.
6. Combine reviewer output, experience output, and any subagent findings into one focused review pass, but let the main agent decide which findings are accepted and severity-ranked.
7. Include a `Relevant prior learnings` section that says whether the current change aligns with or conflicts with known learnings.
8. Include a `Review scope coverage` section that records reviewed files, evidence used, validation status, and any areas intentionally not reviewed.
9. If subagents are used, limit them to routine support tasks such as pulling evidence, organizing reviewer notes, drafting a bounded review, or checking for matching prior learnings; they must not finalize the review.
10. Write the accepted review result to `<task-dir>/05-review.md` with findings, review scope coverage, residual risks, validation gaps, and prior-learning alignment.
11. Keep the review anchored to the local plugin rules, not imported generic defaults, and do not let reviewer outputs move the workflow forward until the main agent has accepted them.

## Independent Review

Use this mode when the user asks for review of a diff, file set, commit snippet, current working copy, or other bounded target without asking to continue the full task-stage workflow.

1. Use `gp-task-stage-discipline` to resolve the task-doc root.
2. If there is no active task directory, create a review-only directory such as `<task-root>/YYYY-MM-DD-review-<slug>/`.
3. Do not mechanically require `00-context.md`, `01-pre-plan.md`, `03-plan.md`, or `04-progress.md` before reviewing.
4. If missing context would materially weaken the review, the main agent may create the smallest necessary stage documents and must state why they are needed.
5. Resolve the review scope from the user request, current diff, named files, validation evidence, and nearby call sites relevant to the review target.
6. Run the `code-reviewer` agent only when a bounded draft review would help; otherwise the main agent may perform the review directly.
7. Run `gp-experience-researcher` when prior host-project learnings may affect the review, and treat those learnings as secondary context only.
8. Include `Relevant prior learnings` when applicable, and always include `Review scope coverage`.
9. Record missing task-stage context as a review scope limitation when it matters.
10. Independent review may report findings without fresh compile or validation evidence, but missing fresh compile, targeted validation, or other proof must be recorded in `Validation gaps`.
11. Write the accepted independent review result to `<task-dir>/review.md`.
12. Do not present an independent review as handoff-ready, delivery-ready, or commit-ready. If the user asks for those conclusions, return to the full task-stage workflow.
