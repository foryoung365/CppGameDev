# Upstream Mapping

This file records which upstream ideas influenced this plugin and which project-local rule wins when there is a conflict. The plugin does not vendor upstream repository copies; this document is internal maintainer provenance only and is not required for plugin runtime.

| Toolkit file | Upstream source | Decision | Notes |
| --- | --- | --- | --- |
| `skills/cpp-coding-standards/SKILL.md` | project skill + ECC cpp-coding-standards | merged, project-first | Full merged project standard; project naming, formatting, explicit-memory, and legacy buffer conventions win; accepted ECC items are limited exceptions: `nullptr`, `using`, `virtual`/`override`/`final`, and Rule of Zero/Five |
| `agents/cpp-reviewer.md` | merged C++ standard | aligned reviewer | Project-aware C++ reviewer that preserves local naming, formatting, and ownership culture while still blocking real defects |
| `agents/gameplay-main.md` | local toolkit governance | runtime authority | Main runtime entry point replacing root governance files |
| `docs/operator/quickstart.md` | local operator docs | published human doc | Human quickstart for loading the plugin and using namespaced commands |

## Resolution Rule

- Project-local governance wins when upstream guidance conflicts with it.
- ECC defaults are only authoritative when this toolkit explicitly marks them as accepted.
- Preserve the project's Hungarian naming and brace/tab formatting.
- Accept only the documented ECC exceptions for `nullptr`, `using`, virtual-function keywords, and Rule of Zero/Five; this does not mean the toolkit adopts the full modern ECC default style.
- Reject ECC defaults that require `clang-format` as the style authority or that reject the project's naming culture.

## Documentation Boundary

- Runtime authority comes from plugin root runtime files such as `skills/`, `agents/`, `commands/`, `settings.json`, and `.claude-plugin/plugin.json`.
- `docs/workflow/request-lifecycle.md`, `docs/svn/commit-policy.md`, and `docs/gameplay/context-card.md` are operator mirrors for humans and must not be the only place a runtime rule exists.
- Historical design docs under `docs/superpowers/` are internal reference artifacts, not runtime entry points.
