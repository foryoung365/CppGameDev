---
name: gp-review-checklist
description: Use during gp-review when a dedicated checklist-based review pass should run as bounded support work.
---

# GP Review Checklist

Use this skill during `gp-review` to run a dedicated checklist-based review pass without replacing the C++ reviewer, gameplay reviewer, or the main agent's final judgment.

## Core Rule

This skill is mandatory support work inside `gp-review`.

- It supplements `cpp-reviewer` and `gameplay-reviewer`; it does not replace them.
- It returns candidate findings and checklist coverage only.
- The main agent decides which findings are accepted and what final severity they carry.

## Checklist Source

Use only this checklist source for the pass:

- `references/code-review-checklist.md`

Do not invent extra checklist sections or reintroduce the source file's removed frontmatter, guide text, or provenance sections.

## Review Method

1. Identify the checklist categories that are relevant to the current diff.
2. Check the applicable item IDs against the edited code and nearby call sites.
3. Always account for these core high-risk items by marking each one as checked or not applicable:
   - `2.1`
   - `2.2`
   - `4.1`
   - `5.1`
   - `5.2`
   - `6.1`
   - `6.4`
   - `7.4`
   - `8.3`
4. Report only evidence-backed candidate findings.
5. Produce checklist coverage that the main agent can copy into `05-review.md`.

## Output Requirements

- Candidate findings must cite checklist item IDs.
- `Checklist coverage` must record:
  - categories covered
  - item IDs checked
  - core high-risk items checked or marked not applicable
  - not-applicable items or categories
- Keep the output concise; do not emit a full 37-item pass/fail report.
- Do not issue final review judgment.
