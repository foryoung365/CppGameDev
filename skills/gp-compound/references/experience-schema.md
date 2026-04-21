# Experience Schema

This is the canonical contract for gameplay experience documents written by `gp-compound`.

## Core Rules

- Experience documents belong to the **host project**, not the plugin repository.
- Only verified learnings are allowed.
- If evidence, conclusion, or validation is missing, do not write the document.
- Unverified observations, tentative suggestions, and exploratory ideas are forbidden.

## Library Layout

Default host-project roots:

- `docs/cmg/solutions/bugs/`
- `docs/cmg/solutions/patterns/`

The active host project's `claude.md` may override this root explicitly.

## Bug Track Required Fields

- `title`
- `date`
- `subdomain`
- `problem_type`
- `component`
- `severity`
- `symptoms`
- `root_cause`
- `fix_type`
- `keywords`
- `related_modules`
- `related_configs`

Required body sections:

- `Problem`
- `Symptoms`
- `Evidence`
- `Fix`
- `Why This Works`
- `Validation`
- `Prevention`

## Knowledge Track Required Fields

- `title`
- `date`
- `subdomain`
- `knowledge_type`
- `component`
- `severity`
- `applies_when`
- `keywords`
- `related_modules`
- `related_configs`

Required body sections:

- `Rule`
- `Why`
- `When To Apply`
- `When Not To Apply`
- `Evidence And Validation`
- `Incident Source`

## Recommended Enumerations

### `subdomain`

- `combat`
- `quest`
- `scene`
- `player-lifecycle`
- `activity`
- `ai`
- `social`
- `cross-server`
- `workflow`
- `other`

### `problem_type`

- `runtime-bug`
- `logic-bug`
- `state-desync`
- `performance-hotspot`
- `config-regression`
- `delivery-bug`

### `knowledge_type`

- `technical-pattern`
- `engineering-guardrail`
- `workflow-guardrail`
- `debugging-guideline`
- `delivery-guideline`
- `codebase-contract`

### `component`

- `build`
- `encoding`
- `workflow`
- `config-loader`
- `persistence`
- `scheduler`
- `script-bridge`
- `sql-location`
- `macro-pattern`
- `lifetime-pattern`
- `other`

### `severity`

- `critical`
- `high`
- `medium`
- `low`

## Trust Boundary

Historical experience is a reusable record of what has already been verified.
It is not a place to store:

- hypotheses
- open questions
- probable causes
- suggested experiments
- unconfirmed advice

If the current session has not proven it, the experience library must not claim it.
