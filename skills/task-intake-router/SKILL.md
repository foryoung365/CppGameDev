---
name: task-intake-router
description: Use when a gameplay context card is ready and must be routed into a pre-plan with one of the four approved plan names.
---

# Task Intake Router

Use this only after `gameplay-context-guard`; this skill produces the `pre-plan` output.

Read the context card, then route in this exact order:

1. Root cause unknown -> `debugging-plan`
2. Cross-module / state-machine / protocol / persistence -> `full-plan`
3. Single domain with real regression risk -> `short-plan`
4. Otherwise -> `micro-plan`

Emit `pre-plan` with these fixed fields:

- `goal`
- `impact`
- `unknowns`
- `validation`
- `selected plan name`

`pre-plan` is the router's output stage, not a separate decision-maker.
Persist that output to the host-project task directory as `01-pre-plan.md` before any selected implementation flow starts.
