---
title: Only compound gameplay learnings after evidence and validation are explicit
date: 2026-03-30
subdomain: workflow
knowledge_type: workflow-guardrail
component: workflow
severity: high
applies_when:
  - a completed gameplay task appears to contain a reusable lesson
keywords: [compound, evidence, validation, workflow]
related_modules: [workflow]
related_configs: [none]
---

# Only compound gameplay learnings after evidence and validation are explicit

## Context
Gameplay tasks often generate plausible observations before the final root cause or guardrail is fully proven.

## Guidance
Do not write a gameplay experience document until the task has explicit evidence, a clear conclusion, and a validated outcome.

## Why This Matters
An experience library is only useful when later agents can trust it more than a guess. Speculative documents create false confidence and repeated mistakes.

## When To Apply
- when deciding whether a completed task deserves a new learning doc

## Counterexamples
- do not use this rule to block a current debugging note inside a live task context; the rule only governs what enters the long-lived experience library

## Validation Notes
- the rule is trustworthy only when the source task itself had explicit evidence and explicit post-change validation

## Related
- workflow
