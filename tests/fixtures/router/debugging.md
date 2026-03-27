# Debugging Router Fixture

Gameplay subdomain: Quest progression recovery
Main entry point: `CQuestStateMachine::Advance()`
State and lifecycle impact: Progression stalls during quest state transitions and needs diagnosis before any fix
Data and config impact: Possibly touches quest flags, reward gates, or state persistence, but the cause is not yet known
Event chain and call path: quest update -> state advance -> progress stall -> log review
Current evidence source: log-driven server traces with no stable repro
Risk level: high
Recommended next path: debugging-plan
Scope note: The unknown root cause is still under investigation.
