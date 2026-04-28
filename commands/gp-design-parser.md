# GP Design Parser Command

Use this namespaced `gp-design-parser` command as a standalone parser for MMORPG or gameplay design-document parsing work.

1. Read and follow the installed `gp-design-parser` skill document (`SKILL.md`); do not invoke `/cmg:gp-design-parser` from inside this command.
2. Treat `$ARGUMENTS` as the target design-doc path, filename, attachment hint, or parsing brief.
3. If `$ARGUMENTS` is empty, fall back to the document, attachment, screenshot set, or file path the user explicitly points to in the current request.
4. Keep this command standalone under the plugin namespace: do not route it through `gp-intake`, `gp-debug`, `gp-review`, `gp-svn-handoff`, task-stage docs, or the host-project experience workflow unless the user explicitly asks for a combined flow.
5. Use the bundled `implementation-doc-template.md` when organizing the final implementation doc.
6. When the input is PDF, use the bundled `pdf-to-annotated-markdown.exe` from the plugin installation directory under `skills/gp-design-parser/bin/`. Do not build or rebuild the tool.
7. Produce the final implementation doc and report the written output path back to the user.
