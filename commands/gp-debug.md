# GP Debug Command

Use this command when a gameplay symptom needs diagnosis before a fix is chosen.

1. Run the normal intake path first: `request -> gameplay-context-guard -> task-intake-router -> pre-plan`.
2. Use `gp-task-stage-discipline` to resolve the current task directory and write or update `<task-dir>/02-debug.md`.
3. Run `gp-experience-check` before or alongside `systematic-debugging` and collect relevant prior bug or pattern summaries.
4. Enter `systematic-debugging` only if the router selects `debugging-plan`.
5. Treat prior learnings as candidate leads, not proof.
6. Define the symptom, reproduction, and evidence before choosing a fix, and keep them current in `<task-dir>/02-debug.md`.
7. Use log, boundary, and call-path evidence to explain the failure.
8. If the root cause becomes clear, record it explicitly in `<task-dir>/02-debug.md`, then write `<task-dir>/03-plan.md` before any code edit starts.
