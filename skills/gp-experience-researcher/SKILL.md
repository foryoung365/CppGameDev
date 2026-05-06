---
name: gp-experience-researcher
description: Use when gameplay work should search the host project's verified experience library and return a concise relevance summary.
---

# GP Experience Researcher

Use this skill to pull verified prior learnings into the current task as **secondary context**.

## Priority Rule

Historical experience never outranks:

- current code
- current logs
- current reproduction evidence
- current validation results

If a prior learning conflicts with current verified evidence, report the conflict and defer to the current evidence.
The skill may inform the main agent, but it never makes the stage decision, never writes the accepted conclusion, and never advances the workflow by itself.

## Library Resolution

Search only the active host project's fixed experience library subtree:

- `docs/cmg/solutions/**`

Do not expand the search to task docs, source files, logs, build output, the plugin repository, or any other directory. Do not use `claude.md` or local configuration to widen the search root for this researcher.

Within that fixed subtree, the supported tracks are:

- `docs/cmg/solutions/bugs/`
- `docs/cmg/solutions/patterns/`

If neither path exists, return `No relevant learnings found` and note that the host project has no experience library yet.

## Inputs

Prefer structured inputs:

- gameplay context card
- `pre-plan`
- current task stage docs when they exist
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

1. Search only under `docs/cmg/solutions/**`.
2. Search bug and pattern tracks in parallel.
3. Narrow by `subdomain` first when available.
4. Prefer frontmatter matches on:
   - `subdomain`
   - `component`
   - `problem_type`
   - `knowledge_type`
   - `keywords`
   - `related_modules`
   - `related_configs`
5. Use body-content search only as a fallback, still only inside `docs/cmg/solutions/**`.
6. Return only strong matches and the smallest useful set of medium matches.
7. Skip weak matches.
8. If a subagent is used to search or summarize, it may only gather candidate learnings, matched files, and short takeaways from `docs/cmg/solutions/**`; the main agent must decide what is relevant and whether it should be carried forward.

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

- `gp-intake`
- `gp-debug`
- `gp-review`
- `gp-svn-handoff`

It informs the current task, but it does not make the final decision for the current task.
Main-agent rule: experience-researcher output is secondary context only; any accepted conclusion must be written into the active stage document by the main agent.
