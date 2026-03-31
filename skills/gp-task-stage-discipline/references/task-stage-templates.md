# Task Stage Templates

Use these as compact templates inside the host project task directory.

Task directory shape:

```text
docs/cpp-mmorpg-gameplay/tasks/YYYY-MM-DD-<task-slug>/
```

## `00-context.md`

```markdown
# Context

Gameplay subdomain:
Main entry point:
State and lifecycle impact:
Data and config impact:
Event chain and call path:
Current evidence source:
Risk level:
Recommended next path:
```

## `01-pre-plan.md`

```markdown
# Pre-Plan

Goal:
Impact:
Unknowns:
Validation:
Selected plan name:
Experience summary:
```

## `02-debug.md`

```markdown
# Debug

Symptom:
Reproduction:
Evidence gathered:
Hypotheses tested:
Rejected explanations:
Root-cause conclusion:
```

## `03-plan.md`

```markdown
# Plan

Files to inspect:
Files to modify:
Implementation steps:
Validation steps:
Compile requirement:
Notes:
```

## `04-progress.md`

```markdown
# Progress

Completed:
Remaining:
Blocker:
Next action:
Corrected mistakes:
```

## `05-review.md`

```markdown
# Review

Findings:
Residual risks:
Validation gaps:
Prior learnings alignment:
```

## `06-handoff.md`

```markdown
# Handoff

Purpose:
Affected modules:
Validation evidence:
Fresh compile evidence:
Corrected pitfalls:
Transferable lesson candidates:
Commit suggestion:
Rollback or risk note:
```
