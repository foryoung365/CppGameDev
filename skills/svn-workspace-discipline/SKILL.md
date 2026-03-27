---
name: svn-workspace-discipline
description: Use when starting or continuing work in an SVN working copy and you need hygiene checks before editing or isolation for parallel work.
---

# SVN Workspace Discipline

Use this skill before editing in a working copy.

## Working Copy Hygiene

1. Run `svn update` first when you need the latest state.
2. Run `svn status` before editing so you know what is already dirty.
3. Treat unexpected local changes as shared context, not something to overwrite.
4. If related files need grouping, use `svn changelist` optionally to keep the working copy organized.

## Isolation Rule

If the task needs a separate line of work or you need to avoid colliding with another in-progress change, use a separate directory or a separate checkout.

## Editing Rule

- Do not edit blindly into an unreviewed working copy.
- Re-check `svn status` after your changes.
- Keep the working copy clean enough that you can explain every modification.

## Practical Checklist

- Update first when freshness matters.
- Inspect status before you touch files.
- Group related files if that helps clarity.
- Isolate when the current working copy is too noisy for safe work.
- Keep delivery boundaries feature-sized rather than step-sized.
