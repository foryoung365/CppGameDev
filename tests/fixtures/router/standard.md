# Standard Router Fixture

Gameplay subdomain: Mounted movement and stamina
Main entry point: `CMountedMovementState::UpdateStaminaRecovery()`
State and lifecycle impact: Adjusts mounted sprint recovery during active movement sessions
Data and config impact: Tunes stamina recovery rules and movement-state thresholds
Event chain and call path: mount state -> sprint tick -> recovery gate -> movement sync
Current evidence source: combat replay notes and server movement traces
Risk level: medium
Recommended next path: short-plan
Scope note: This is one gameplay subdomain feature with regression risk.
