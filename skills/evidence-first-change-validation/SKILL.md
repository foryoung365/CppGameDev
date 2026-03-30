---
name: evidence-first-change-validation
description: Use when choosing how to validate a change, fix, or refactor and you want the proof defined before the edit is considered complete.
---

# Evidence-First Change Validation

This skill replaces blanket test-first thinking with evidence-first thinking.
Not every task needs a test-first workflow, but every change needs a defined proof.

## Core Rule

Define the evidence before the change, then collect the same evidence after the change.

Historical experience can inform validation choices, but current validated evidence outranks historical experience every time.

## Evidence Types

Use whichever proof is best for the change:

- Compile success
- A failing repro that now passes
- Logs that show the right behavior
- Targeted checks for the affected path
- Tests, when they are the most reliable proof
- Targeted tests for behavior changes, regressions, ownership edges, or lifetime-sensitive paths

## Validation Flow

1. State what behavior or failure you expect to prove.
2. Choose the smallest reliable evidence that proves it.
3. Record the baseline if the problem currently reproduces.
4. Make the change.
5. Re-run the same evidence fresh.
6. Compare the before and after result.
7. If the evidence is still weak, add a better check before calling the work done.

## Commit-Ready Gate

A fresh successful compile is mandatory before anything can be described as commit-ready.
Use the host project's standard build script or build command for that proof rather than inventing a new build entry point inside this plugin.
Targeted validation still matters after compile success.

## Practical Guidance

- Do not force tests when compile, repro, or log evidence is a better fit.
- Do not skip evidence because a change seems small.
- Do not rely on memory or stale runs.
- Prefer concrete checks that another person could repeat.
- Use targeted tests when behavior, regression risk, ownership, or lifecycle edges need stronger proof than logs or compile output alone.
- If a prior learning conflicts with current verified evidence, keep the conflict visible and trust the current verified evidence.
