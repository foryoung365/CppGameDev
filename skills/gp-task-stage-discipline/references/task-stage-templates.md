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
Delegated support:
Main-agent accepted context summary:
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
Delegated support:
Main-agent accepted routing conclusion:
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
Delegated support:
Main-agent accepted debugging conclusion:
```

## `03-plan.md`

```markdown
# Plan

Files to inspect:
Files to modify:
Implementation steps:
Validation steps:
Compile requirement:
Delegated subtasks:
Main-agent approved edit boundary:
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
Delegated returns:
Main-agent acceptance notes:
```

## `05-review.md`

```markdown
# Review

Findings:
Residual risks:
Validation gaps:
Prior learnings alignment:
Delegated review drafts:
Main-agent accepted review conclusion:
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
Delegated support outputs:
Main-agent accepted readiness conclusion:
Commit suggestion:
Rollback or risk note:
```
