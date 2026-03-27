# GP Debug Command

Use this command when a gameplay symptom needs diagnosis before a fix is chosen.

1. Run the normal intake path first: `request -> gameplay-context-guard -> task-intake-router -> pre-plan`.
2. Enter `systematic-debugging` only if the router selects `debugging-plan`.
3. Define the symptom, reproduction, and evidence before choosing a fix.
4. Use log, boundary, and call-path evidence to explain the failure.
5. If the root cause becomes clear, hand the work back to the right implementation shape.
