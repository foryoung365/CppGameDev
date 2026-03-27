# SVN Commit Policy

This plugin uses feature-sized commits. A commit must represent one complete feature or one complete fix, not a slice-by-slice implementation step. This document is a human-facing mirror of the runtime delivery rules in the plugin assets.

## Commit Granularity

- Do not commit per micro-step.
- Do not split a request into multiple commits unless the pieces are independently complete and clearly separable.
- Prefer one commit per complete feature or one commit per complete fix.
- If a task is still in discovery, it is not commit-ready.

## Compile Before Commit-Ready

A fresh successful compile is required before any commit-ready conclusion.
Use the host project's standard build script or build command for that proof. This plugin does not define project-specific build commands and should defer to the active project's `claude.md` or equivalent local runtime config.

This gate means:

- no commit-ready claim without the latest successful compile
- compile success does not replace targeted validation
- a change still needs the right functional checks, even if it compiles cleanly

## Delivery Rule

When a request is ready for SVN delivery, the handoff should include:

- the feature or fix boundary
- the validation evidence
- the fresh successful compile result
- any remaining risk or follow-up

## Operator Note

If this document and the runtime delivery skills ever disagree, the runtime plugin files must be corrected first and this mirror updated second.
