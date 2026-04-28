# GP Design Parser Command

Use this namespaced `gp-design-parser` command as a standalone parser for MMORPG or gameplay design-document parsing work.

1. Resolve the plugin installation directory by reading `%USERPROFILE%\.claude\plugins\installed_plugins.json` and locating the installed `cmg` plugin record; use that record's `installPath` as the plugin root. Do not scan unrelated directories.
2. Read and follow `<installPath>\skills\gp-design-parser\SKILL.md`; do not invoke `/cmg:gp-design-parser` from inside this command.
3. Treat `$ARGUMENTS` as the target design-doc path, filename, attachment hint, or parsing brief.
4. If `$ARGUMENTS` is empty, fall back to the document, attachment, screenshot set, or file path the user explicitly points to in the current request.
5. Keep this command standalone under the plugin namespace: do not route it through `gp-intake`, `gp-debug`, `gp-review`, `gp-svn-handoff`, task-stage docs, or the host-project experience workflow unless the user explicitly asks for a combined flow.
6. Use the bundled `implementation-doc-template.md` when organizing the final implementation doc.
7. When the input is PDF, use `<installPath>\skills\gp-design-parser\bin\pdf-to-annotated-markdown.exe`. Do not build or rebuild the tool.
8. Produce the final implementation doc and report the written output path back to the user.
