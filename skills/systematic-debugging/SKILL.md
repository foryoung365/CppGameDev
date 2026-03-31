---
name: systematic-debugging
description: Use when a bug, regression, build failure, or unexpected behavior needs root-cause-first diagnosis before any fix is chosen.
---

# Systematic Debugging

Use this skill when the root cause is not yet known.
The goal is diagnosis first, not a quick patch.
Keep the diagnosis on disk in the host project's task directory as `02-debug.md`.

## Core Rule

Do not choose a fix before the evidence points to the root cause.

## Debugging Flow

1. Define the symptom precisely.
2. Reproduce it consistently.
3. Inspect recent changes and the current working copy state.
4. Gather evidence at component boundaries when the problem spans multiple layers.
5. Compare against working examples or known-good paths.
6. Form a single hypothesis.
7. Test the hypothesis with the smallest change or check that can confirm or reject it.
8. Record the current symptom, evidence, rejected paths, and root-cause conclusion in `02-debug.md`.
9. Once the root cause is known, switch to the appropriate plan shape in `writing-plans` and write `03-plan.md` before code changes.

## Evidence Rules

- Read the full error output.
- Prefer direct evidence over guesses.
- Instrument the path that is actually failing.
- When multiple components are involved, log what enters and exits each boundary.
- If the evidence is still ambiguous, collect more evidence before changing code.

## Relationship To Other Skills

- Pair this with `evidence-first-change-validation` for choosing the best proof of a fix.
- Use `writing-plans` with `debugging-plan` while the root cause is still unknown; once it is understood, switch to the appropriate implementation shape in `writing-plans` (`micro-plan`, `short-plan`, or `full-plan`, depending on risk and scope).
- Do not treat tests as mandatory unless a test is the best evidence for the specific problem.
- Do not leave debugging for implementation until `02-debug.md` explains the root cause clearly enough to support the next stage.

## Stop Condition

If you cannot explain why the symptom happens, keep investigating.
If you can explain it, plan the fix around the cause rather than the symptom.
