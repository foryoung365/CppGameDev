---
name: gp-compound-refresh
description: Use when verified gameplay experience documents in the host project need maintenance for drift, duplication, or removal.
---

# GP Compound Refresh

Maintain the host project's experience library without introducing speculation.

## Scope

This skill works on the host project's experience library root:

1. Use the explicit override from the active host project's `claude.md` when present.
2. Otherwise use:
   - `docs/cpp-mmorpg-gameplay/solutions/bugs/`
   - `docs/cpp-mmorpg-gameplay/solutions/patterns/`

If the host project has no experience library yet, report that and stop cleanly.

## Allowed Actions

Only these actions are allowed:

- `keep`
- `update`
- `consolidate`
- `delete`

Read the detailed action boundaries in:

- `references/refresh-rules.md`

## Hard Refresh Rules

- Do not infer a replacement learning from partial evidence.
- Do not rewrite old docs into a new truth unless that new truth is fully evidenced.
- Do not create archive directories.
- Do not keep duplicated docs when one canonical verified doc can absorb the unique material safely.
- Do not change a doc just to polish wording.

## Evidence Requirement

Any `update`, `consolidate`, or `delete` action must be backed by explicit evidence from:

- current code reality
- current verified workflow reality
- current validated runtime or delivery behavior

If evidence is incomplete or contradictory, keep the doc unchanged and report the uncertainty instead of guessing.

## Output

For every reviewed doc, return:

- path
- action
- concise reason
- evidence source

For any rejected change, return:

- path
- reason the evidence was insufficient
