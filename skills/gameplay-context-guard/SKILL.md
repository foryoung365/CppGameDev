---
name: gameplay-context-guard
description: Use when a request touches gameplay work and must be converted into a short 8-field context card before routing or editing.
---

# Gameplay Context Guard

Before any gameplay edit or plan, output a context card with exactly these 8 fields:

1. Gameplay subdomain
2. Main entry point
3. State and lifecycle impact
4. Data and config impact
5. Event chain and call path
6. Current evidence source
7. Risk level
8. Recommended next path

Keep each field concrete and tied to the current request. If a field is still unknown, say so directly instead of guessing. Pass the completed card to `task-intake-router`.

Prefer stable domain words that can help later experience retrieval:

- subdomain names
- component names
- module or class names
- config names
- event-chain verbs

## What The Guard Must Surface

When filling the card, explicitly look for:

- state consistency across the gameplay path
- lifecycle cleanup on reset, shutdown, abort, and transition
- config compatibility with existing content, saves, and defaults
- cross-module impact outside the touched file
- event-chain and call-path risk, including ordering, duplication, or missed notifications
