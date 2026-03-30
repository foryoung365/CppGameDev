```markdown
---
title: [Clear problem title]
date: [YYYY-MM-DD]
subdomain: [combat|quest|scene|player-lifecycle|activity|ai|social|cross-server|other]
problem_type: [runtime-bug|logic-bug|state-desync|performance-hotspot|config-regression|delivery-bug]
component: [manager|service|handler|state-machine|config-loader|persistence|scheduler|script-bridge|other]
severity: [critical|high|medium|low]
symptoms:
  - [Observable symptom 1]
root_cause: [state-transition-missing|lifecycle-cleanup-missing|event-ordering|duplicate-notify|config-default-mismatch|ownership-lifetime|cross-module-contract-drift|other]
fix_type: [code-fix|config-fix|validation-added|lifecycle-guard|ordering-fix|rollback-guard|other]
keywords: [keyword-one, keyword-two]
related_modules: [module-or-class-name]
related_configs: [config-name-or-none]
---

# [Clear problem title]

## Problem
[1-2 sentence description of the failure and gameplay impact]

## Symptoms
- [Observable symptom, log line, or player-visible failure]

## Evidence
- [Concrete code, log, repro, or diff evidence used to support the diagnosis]

## What Didn't Work
- [Only include failed paths that were actually tried and verified to be wrong]

## Fix
[Describe the verified fix with code details when useful]

## Why This Works
[State the verified root cause and why the fix closes it]

## Validation
- [Compile proof]
- [Targeted validation or repro that now passes]

## Prevention
- [Concrete future guardrail]

## Related
- [Related modules, configs, or experience docs]
```
