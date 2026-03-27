---
name: lightweight-change-flow
description: Use when a small gameplay change should be handled with a micro-plan and a tight validation loop.
---

# Lightweight Change Flow

Use only after `task-intake-router` has already produced a `pre-plan` whose `selected plan name` is `micro-plan`.
Do not skip `gameplay-context-guard -> task-intake-router` or choose this flow directly.

Use a `micro-plan` with 3-5 steps.

Checklist:

- List the exact files to read before editing.
- Name the exact points to change in those files.
- Include the exact validation steps to run after the edits.
- End with a final handoff note that names the files changed, what was validated, and any known gaps.

Keep the plan narrow, action-oriented, and limited to the minimum files needed for the request.
