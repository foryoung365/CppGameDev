---
name: gp-compound
description: Use when a completed gameplay fix or established gameplay pattern may deserve a verified experience document in the host project's experience library.
---

# GP Compound

Use this skill only after the relevant work has reached a stable conclusion.

The purpose is to capture **verified** gameplay experience for future reuse without turning guesswork into authority.

## Experience Library Location

Write experience documents into the **host project**, not into this plugin repository.

Resolve the library root in this order:

1. If the active host project's `claude.md` explicitly defines an experience library root, use that path.
2. Otherwise use the default host-project root:
   - `docs/cpp-mmorpg-gameplay/solutions/bugs/`
   - `docs/cpp-mmorpg-gameplay/solutions/patterns/`

Create missing directories lazily on first write. Do not pre-create empty library trees.

## Hard Gate

Do not create or update any experience document unless **all three** are true:

- the evidence is explicit
- the conclusion is explicit
- the validation is explicit

If any one of those is missing, refuse to write the document.

Forbidden inputs:

- speculation
- tentative observations
- "might be"
- "seems related"
- suggested experiments
- unverified best practices

Those can stay in the current task context, but they must not enter the experience library.

## What Qualifies

Only capture high-value items:

- a non-obvious bug root cause and verified fix
- a reusable gameplay design or implementation pattern
- a repeated engineering or delivery pitfall with a verified guardrail

Do not capture:

- obvious one-line fixes
- pure naming or formatting edits
- unproven debugging notes
- low-value local trivia

## Track Selection

Choose exactly one track:

- `Bug track`
  - use for diagnosed and verified failures
- `Knowledge track`
  - use for verified reusable patterns or verified workflow guardrails

Read the schema and templates on demand:

- `references/experience-schema.md`
- `assets/bug-track-template.md`
- `assets/knowledge-track-template.md`

## Overlap Handling

Before writing:

1. Search the resolved host-project experience library for related docs.
2. If a strong overlap already exists and the existing doc is still the canonical learning, update it in place.
3. Otherwise create a new doc.

Treat overlap as strong when the same verified problem or same verified pattern is already documented with the same practical guidance.

## Output Requirements

Every written document must:

- use the selected track template
- include only verified facts and verified guidance
- include evidence and validation sections or fields that show why the learning is trustworthy
- use stable search terms in `keywords`, `related_modules`, and `related_configs`

## File Naming

Use a stable, descriptive slug plus date:

- `bugs/<subdomain>/<slug>-YYYY-MM-DD.md`
- `patterns/<subdomain>/<slug>-YYYY-MM-DD.md`

Prefer searchable names over clever names.

## Completion Summary

When the write succeeds, return:

- selected track
- resolved host-project path
- whether the doc was created or updated
- one-sentence reason the learning qualified

When the write is refused, return:

- refusal reason
- which hard-gate element was missing: evidence, conclusion, or validation
