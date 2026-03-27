# Gameplay Context Card

This document is the human-readable mirror of the context card required by `skills/gameplay-context-guard/SKILL.md`.

Before changing gameplay code, capture these eight fields:

1. Gameplay subdomain
2. Main entry point
3. State and lifecycle impact
4. Data and config impact
5. Event chain and call path
6. Current evidence source
7. Risk level
8. Recommended next path

The card should be short, concrete, and specific enough that another agent can decide the next step without rereading the whole request. Use the same field names everywhere so the guard and router stay aligned.

Runtime authority still lives in the plugin skill and router, not in this document alone.
