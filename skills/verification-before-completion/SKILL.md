---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or ready for delivery and you must verify that claim with fresh evidence first.
---

# Verification Before Completion

Use this skill before any completion claim, delivery claim, or commit-ready claim.

## Core Principle

Evidence before claims, always.

## Verification Gate

Before saying the work is done:

1. Identify the command or check that proves the claim.
2. Run it now, fresh.
3. Read the complete output.
4. Decide whether the output actually proves the claim.
5. Only then make the claim.

If the command has not been run in this session, the claim is not verified.

## Hard Requirements

- A fresh successful compile is required before any commit-ready conclusion.
- Use the host project's standard build script or build command for that proof; the active project's `claude.md` or equivalent local runtime config defines the concrete build entry point.
- Compile success does not replace targeted validation.
- You still need the right proof for the change, whether that is a repro, log, targeted check, or test.
- Delivery stays feature-sized: one complete feature or one complete fix per commit-ready handoff.
- If the work changed code, `03-plan.md`, `04-progress.md`, and `06-handoff.md` must all be current before a ready-for-delivery claim is valid.

## Do Not Say

- "small change, no compile needed"
- "looks safe enough to commit"
- anything that implies commit-ready status without a fresh successful compile

## Acceptable Evidence

- Compile output showing success
- A failing repro that now passes
- Logs that show the corrected behavior
- Targeted checks that prove the affected path works
- Tests that exercise the behavior

## Completion Rule

If the evidence is fresh and supports the claim, state the claim with the evidence.
If it does not, report the actual status instead of guessing.
If stage documents are missing or stale, report that gap instead of claiming readiness.
