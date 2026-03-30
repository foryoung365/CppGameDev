---
name: gp-experience-check
description: Use when gameplay work should search the host project's verified experience library and return a concise relevance summary.
---

# GP Experience Check

Use this skill to pull verified prior learnings into the current task as **secondary context**.

## Priority Rule

Historical experience never outranks:

- current code
- current logs
- current reproduction evidence
- current validation results

If a prior learning conflicts with current verified evidence, report the conflict and defer to the current evidence.

## Library Resolution

Search the host project's experience library, not the plugin repository.

Resolve the library root in this order:

1. explicit root from the active host project's `claude.md`
2. default namespaced root:
   - `docs/cpp-mmorpg-gameplay/solutions/bugs/`
   - `docs/cpp-mmorpg-gameplay/solutions/patterns/`

If neither path exists, return `No relevant learnings found` and note that the host project has no experience library yet.

## Inputs

Prefer structured inputs:

- gameplay context card
- `pre-plan`
- current symptom description
- current review scope
- current handoff summary

Extract stable search terms from:

- `subdomain`
- `main entry point`
- `component`
- `symptoms`
- `related modules`
- `related configs`
- event-chain terms

## Search Rules

1. Search bug and pattern tracks in parallel.
2. Narrow by `subdomain` first when available.
3. Prefer frontmatter matches on:
   - `subdomain`
   - `component`
   - `problem_type`
   - `knowledge_type`
   - `keywords`
   - `related_modules`
   - `related_configs`
4. Use body-content search only as a fallback.
5. Return only strong matches and the smallest useful set of medium matches.
6. Skip weak matches.

## Output Format

Use this exact structure:

```markdown
## Experience Summary

### Relevant Prior Learnings

#### 1. [Title]
- Track:
- File:
- Relevance:
- Key takeaway:
- Priority: strong|medium

### Conflict Note
- [Only include when a prior learning conflicts with current verified evidence]
```

If nothing relevant is found:

```markdown
## Experience Summary

No relevant learnings found.
```

## Runtime Use

This skill is used at:

- `intake`
- `gp-debug`
- `gp-review`
- `svn-handoff`

It informs the current task, but it does not make the final decision for the current task.
