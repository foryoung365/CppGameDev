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
/plugin install cpp-mmorpg-gameplay@foryoung365-plugins
```

Or, if you want Claude Code to fetch the marketplace from GitHub:

```text
/plugin marketplace add foryoung365/CppGameDev-skill
/plugin install cpp-mmorpg-gameplay@foryoung365-plugins
```

## Start With These Commands

- `/cpp-mmorpg-gameplay:gp-intake`
- `/cpp-mmorpg-gameplay:gp-debug`
- `/cpp-mmorpg-gameplay:gp-review`
- `/cpp-mmorpg-gameplay:gp-svn-handoff`
- `/cpp-mmorpg-gameplay:gp-compound`
- `/cpp-mmorpg-gameplay:gp-compound-refresh`

## When To Use Each One

- `gp-intake`: start normal gameplay work and get the context card plus `pre-plan`
- `gp-debug`: diagnose a gameplay symptom when the root cause is still unknown
- `gp-review`: run project-aware C++ review plus gameplay-risk review
- `gp-svn-handoff`: prepare a feature-sized SVN delivery handoff with validation evidence
- `gp-compound`: write a verified gameplay experience document into the host project
- `gp-compound-refresh`: maintain verified gameplay experience documents in the host project

## Human Reading Order

If you want the human-readable policy mirrors, read:

- `docs/workflow/request-lifecycle.md`
- `docs/gameplay/context-card.md`
- `docs/svn/commit-policy.md`

Runtime authority still lives in plugin assets such as `skills/`, `agents/`, and `commands/`, not in docs alone.

## Host-Project Experience Library

This plugin can retrieve and write verified gameplay experience docs, but the library lives in the **host project**, not in this plugin repository.

Default host-project locations:

- `docs/cpp-mmorpg-gameplay/solutions/bugs/`
- `docs/cpp-mmorpg-gameplay/solutions/patterns/`

If the active host project's `claude.md` defines a different experience root, that override wins.

Historical experience is secondary context only. Current code, current evidence, and current validation remain authoritative.

## Offline Packaging

To create a local offline release zip, run from the repository root:

```powershell
scripts\package-plugin.bat
```

The package is written to `dist\cpp-mmorpg-gameplay-<version>.zip`.
It contains plugin runtime assets only, not host-project experience docs, test fixtures, or internal maintainer docs.

## Build Integration Boundary

This plugin enforces the rule that commit-ready work needs a fresh successful compile, but it does not define project-specific build commands.
Use the active project's standard build script or build command from that project's `claude.md` or equivalent local runtime config.
