---
name: lightweight-change-flow
description: Use when a small gameplay change should be handled with a micro-plan and a tight validation loop.
---

# Lightweight Change Flow

Use only after `task-intake-router` has already produced a `pre-plan` whose `selected plan name` is `micro-plan`.
Do not skip `gameplay-context-guard -> task-intake-router` or choose this flow directly.
Do not edit code until the host-project task directory contains `03-plan.md`.

Use a `micro-plan` with 3-5 steps.

Checklist:

- Write or update `<task-dir>/03-plan.md` before edits begin.
- List the exact files to read before editing.
- Name the exact points to change in those files.
- Include the exact validation steps to run after the edits.
- Include a fresh compile step whenever code changes.
- Update `<task-dir>/04-progress.md` after meaningful progress and before pausing.
- End with a final handoff note that names the files changed, what was validated, and any known gaps.

Keep the plan narrow, action-oriented, and limited to the minimum files needed for the request.
