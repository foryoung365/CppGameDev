---
name: svn-delivery-handoff
description: Use when one complete feature or one complete fix is ready to be handed off for SVN delivery.
---

# SVN Delivery Handoff

Use this skill only when the work boundary is complete.
One handoff equals one complete feature or one complete fix.
SVN delivery stays feature-sized.

## Required Handoff Content

- Purpose
- Affected modules
- SVN diff summary
- Validation evidence
- Fresh successful compile evidence
- Relevant prior learnings, when any exist
- Commit message suggestion
- Rollback or risk note

## Handoff Rule

Do not hand off partial work as if it were a finished delivery.
If the work is still missing validation or compile evidence, it is not ready.
Historical experience can inform the handoff, but it does not override current verified evidence.

## Suggested Shape

```markdown
Purpose:
Affected modules:
SVN diff summary:
Validation evidence:
Fresh successful compile evidence:
Relevant prior learnings:
Commit message suggestion:
Rollback/risk note:
```

## Quality Bar

- The handoff should stand on its own.
- A reviewer should be able to understand what changed and why it is safe.
- The fresh compile evidence must be explicit, not implied.
