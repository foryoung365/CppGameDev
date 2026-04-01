---
name: gp-subagent-orchestration
description: Use when gameplay work should delegate bounded supporting work to subagents while keeping all final judgments with the main agent.
---

# GP Subagent Orchestration

Use this skill when the workflow should benefit from subagents without surrendering control of the task.

## Core Rule

The main agent owns every judgment that changes task state.

Subagents may gather evidence, search code, summarize logs, draft reviews, propose plan details, or perform bounded implementation work, but they may not decide that a stage is complete.

## Main-Agent-Only Decisions

Only the main agent may decide:

- stage transitions
- router outcome acceptance
- root-cause acceptance
- plan approval
- permission to begin code edits
- review conclusion
- handoff readiness
- whether a learning is general enough for the experience library

## Allowed Subagent Work

Subagents may be used for:

- codebase search and related-module discovery
- prior-learning retrieval
- log extraction and call-path tracing
- compile/build output summarization
- review draft generation
- bounded implementation tasks inside the approved plan
- lesson-candidate extraction from `05-review.md` and `06-handoff.md`

## Task-Stage Interaction Rule

A subagent result is only supporting material until the main agent does both of these:

1. reviews the returned result
2. records the accepted conclusion in the task-stage docs

Without that main-agent acceptance step, the task has not advanced.

## Context Recovery Rule

When resuming after context compression or handoff:

- inspect what was delegated
- inspect what came back
- inspect what the main agent accepted or rejected
- continue only from the accepted stage state

Do not infer acceptance just because a subagent produced a plausible answer.

## Good Delegation Pattern

1. Main agent defines the current stage and what decision is pending.
2. Main agent delegates a bounded supporting task.
3. Subagent returns evidence, findings, or draft output.
4. Main agent evaluates the result.
5. Main agent writes the accepted outcome into the stage doc.
6. Only then may the task move to the next stage.

## Bad Delegation Pattern

Do not let a subagent:

- pick the final plan shape
- declare the root cause solved
- declare review passed
- declare handoff ready
- write directly to the experience library without main-agent approval

## Specialist Agent Guidance

Use existing specialist agents as worker roles:

- `gameplay-learnings-researcher`
- `cpp-reviewer`
- `gameplay-reviewer`
- `log-investigator`
- `cpp-build-resolver`

They provide inputs to the main agent, not final rulings.

See `references/delegation-matrix.md` for stage-by-stage delegation boundaries.
