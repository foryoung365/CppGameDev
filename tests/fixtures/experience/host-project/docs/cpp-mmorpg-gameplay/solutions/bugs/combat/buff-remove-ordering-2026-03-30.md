---
title: Buff removal ordering drops final cleanup notify
date: 2026-03-30
subdomain: combat
problem_type: state-desync
component: state-machine
severity: high
symptoms:
  - target retains stale combat state after buff expiry
root_cause: event-ordering
fix_type: ordering-fix
keywords: [buff, remove, notify, state-cleanup]
related_modules: [BuffManager, UnitState]
related_configs: [buff-timing]
---

# Buff removal ordering drops final cleanup notify

## Problem
Buff removal cleared state before the final cleanup notify, leaving dependent listeners with stale combat state.

## Symptoms
- target retained stale combat state after buff expiry

## Evidence
- log sequence showed notify firing after state had already been cleared

## What Didn't Work
- adding a second notify at the caller duplicated events and caused re-entry noise

## Fix
Move the cleanup notify earlier so dependent listeners observe the final valid removal state exactly once.

## Why This Works
The verified failure was ordering, not missing data. Reordering preserved the expected state snapshot at notify time.

## Validation
- compile passed after the change
- targeted buff-expiry repro showed the stale state no longer remained

## Prevention
- for lifecycle cleanup events, notify while the final valid state is still observable

## Related
- BuffManager
- UnitState
