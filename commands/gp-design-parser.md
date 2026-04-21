# GP Design Parser Command

Use this namespaced command to invoke the standalone `gp-design-parser` skill for MMORPG or gameplay design-document parsing work.

1. Load `gp-design-parser`.
2. Pass `$ARGUMENTS` to the skill as the target design-doc path, filename, attachment hint, or parsing brief.
3. If `$ARGUMENTS` is empty, fall back to the document, attachment, screenshot set, or file path the user explicitly points to in the current request.
4. Keep this command standalone under the plugin namespace: do not route it through `gp-intake`, `gp-debug`, `gp-review`, `gp-svn-handoff`, task-stage docs, or the host-project experience workflow unless the user explicitly asks for a combined flow.
5. Read and follow `skills/gp-design-parser/SKILL.md` directly, including `implementation-doc-template.md`.
6. When the input is PDF, prefer `skills/gp-design-parser/bin/pdf-to-annotated-markdown.exe`; if the executable is missing or needs rebuilding, use `skills/gp-design-parser/build-pdf-tool.ps1`, which now rebuilds from the bundled `skills/gp-design-parser/pdf_to_annotated_markdown.py`.
7. Let the standalone parser skill produce the final implementation doc and report the written output path back to the user.
