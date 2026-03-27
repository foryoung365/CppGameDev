# Lightweight Router Fixture

Gameplay subdomain: Dungeon encounter scripting
Main entry point: `GuardPatrolReset::ApplyCooldownTune()`
State and lifecycle impact: Updates one encounter timer without changing persistence or session flow
Data and config impact: Tweak a single patrol cooldown value in the encounter tuning table
Event chain and call path: zone event -> guard patrol reset -> timer refresh -> encounter resume
Current evidence source: server traces from the Blacksmith District encounter logs
Risk level: low
Recommended next path: micro-plan
Scope note: This is a single-domain low-risk change.
