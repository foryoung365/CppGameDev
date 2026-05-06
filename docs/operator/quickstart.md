# Operator Quickstart

This plugin is packaged for Claude Code and is meant to be loaded from the plugin root.

## Load The Plugin

Use:

```powershell
claude --plugin-dir I:\CppGameDev
```

After Claude Code starts, use `/help` to confirm the plugin namespace is visible.

If you want to consume it through the marketplace flow instead of `--plugin-dir`, use:

```text
/plugin marketplace add I:\CppGameDev
/plugin install cmg@foryoung365-plugins
```

Or, if you want Claude Code to fetch the marketplace from GitHub:

```text
/plugin marketplace add foryoung365/CppGameDev-skill
/plugin install cmg@foryoung365-plugins
```

## Start With These Commands

- `/cmg:gp-intake`
- `/cmg:gp-debug`
- `/cmg:gp-review`
- `/cmg:gp-svn-handoff`
- `/cmg:gp-compound`
- `/cmg:gp-compound-refresh`
- `/cmg:gp-design-parser`

## Optional Standalone Parser

Use `/cmg:gp-design-parser` when you want the plugin namespace to invoke the standalone `gp-design-parser` skill directly.

- It parses annotated MMORPG or gameplay design docs and rewrites them into implementation docs for gameplay programmers.
- It stays outside the normal `gp-intake` / task-stage flow unless you explicitly ask to combine them.

## Main-Agent Orchestrated Model

This plugin is not a fully autonomous subagent pipeline.

- The main agent owns all final decisions.
- Subagents are used for bounded support work such as search, evidence gathering, draft reviews, log tracing, build-output summarization, and lesson-candidate extraction.
- When two or more bounded support tasks are independent, prefer parallel delegation and converge them at the next main-agent decision point.
- A subagent result does not move the task forward until the main agent accepts it and records that acceptance in the task docs.

## When To Use Each One

- `gp-intake`: start normal gameplay work and get the context card plus `pre-plan`
- `gp-debug`: diagnose a gameplay symptom when the root cause is still unknown
- `gp-review`: run project-aware code review, gameplay-risk review, and prior-learning alignment; it can run inside the full task flow or as independent review
- `gp-svn-handoff`: prepare a feature-sized SVN delivery handoff with validation evidence
- `gp-compound`: write a verified gameplay experience document into the host project
- `gp-compound-refresh`: maintain verified gameplay experience documents in the host project
- `gp-design-parser`: run the standalone design-doc parser without entering the normal gameplay workflow

## Human Reading Order

If you want the human-readable policy mirrors, read:

- `docs/workflow/request-lifecycle.md`
- `docs/gameplay/context-card.md`
- `docs/svn/commit-policy.md`

Runtime authority still lives in plugin assets such as `skills/`, `agents/`, and `commands/`, not in docs alone.

## Host-Project Task Docs

This plugin now treats task-stage documents as required runtime anchors for large codebases and compressed contexts.

Default host-project task-doc root:

- `docs/cmg/tasks/`

Each task lives under:

- `docs/cmg/tasks/YYYY-MM-DD-<task-slug>/`

Create a new dated directory when intake starts a new task instance.
Reuse the active task directory when later stages continue that same task.

Stage files:

- `00-context.md`
- `01-pre-plan.md`
- `02-debug.md`
- `03-plan.md`
- `04-progress.md`
- `05-review.md`
- `06-handoff.md`

`03-plan.md` must exist before code edits begin.
`03-plan.md` must include `Performance impact`; no fixed target is required, but performance impact must be considered or marked not applicable.
`04-progress.md` must be updated during execution and before pausing.
`04-progress.md` should include `Performance notes` when implementation confirms, changes, or dismisses a performance concern.
`05-review.md` should record findings, `Review scope coverage`, residual risks, validation gaps, and prior-learning alignment.
`06-handoff.md` cannot claim ready state without fresh compile evidence when code changed.

Independent `gp-review` writes `<task-dir>/review.md` in a review-only task directory when no active task directory exists. It may add minimal context documents when the review needs them, but it is not a delivery-ready or commit-ready claim.

## Host-Project Experience Library

This plugin can retrieve and write verified gameplay experience docs, but the library lives in the **host project**, not in this plugin repository.

Default host-project locations:

- `docs/cmg/solutions/bugs/`
- `docs/cmg/solutions/patterns/`

`gp-experience-researcher` search is fixed to the active host project's `docs/cmg/solutions/**` subtree. It must not expand into task docs, source files, logs, build output, the plugin repository, or a custom path from `claude.md`.

Historical experience is secondary context only. Current code, current evidence, and current validation remain authoritative.

## Offline Packaging

To create a local offline release zip, run from the repository root:

```powershell
scripts\package-plugin.bat
```

The package is written to `dist\cmg-<version>.zip`.
It contains plugin runtime assets only, not host-project experience docs, host-project task-stage docs, test fixtures, or internal maintainer docs.

## Build Integration Boundary

This plugin enforces the rule that commit-ready work needs a fresh successful compile, but it does not define project-specific build commands.
Use the active project's standard build script or build command from that project's `claude.md` or equivalent local runtime config.
