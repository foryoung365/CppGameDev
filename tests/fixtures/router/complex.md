# Complex Router Fixture

Gameplay subdomain: Party combat and world state
Main entry point: `CPartyAuraService::ApplyAuraPulse()`
State and lifecycle impact: Spans combat modifiers, NPC reactions, and shared world-state updates
Data and config impact: Extends aura definitions, buff tables, and zone reaction rules
Event chain and call path: party formed -> aura pulse -> combat buffs -> NPC reaction -> world broadcast
Current evidence source: cross-system server traces and combat balance review notes
Risk level: high
Recommended next path: full-plan
Scope note: This is a cross-module gameplay feature.
