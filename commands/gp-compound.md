# GP Compound Command

Use this command to write a verified gameplay experience document into the active host project's experience library.

1. Load `gp-compound`.
2. Resolve the host-project experience library root:
   - explicit root from the active host project's `claude.md`, if present
   - otherwise `docs/cpp-mmorpg-gameplay/solutions/bugs/` and `docs/cpp-mmorpg-gameplay/solutions/patterns/`
3. Refuse to write anything unless evidence, conclusion, and validation are all explicit.
4. Choose exactly one track:
   - `Bug track`
   - `Knowledge track`
5. Search for strong overlap first.
6. Update the canonical existing doc when overlap is strong; otherwise create a new host-project experience doc.
7. Create missing host-project directories only when the write is actually going to happen.
8. Refuse to write if the result is really a feature implementation note, feature architecture note, or task walkthrough rather than a reusable technical pattern, root-cause pattern, or engineering guardrail.
9. Only promote learnings from the current task's `05-review.md` and `06-handoff.md`; do not promote raw execution notes directly from implementation flow.
10. Treat `gp-compound` as a main-agent decision point: subagents may suggest candidate learnings or overlap matches, but only the main agent may accept the final lesson and write it into the experience library.

Do not store speculative notes, exploratory observations, or suggested experiments in the experience library.
Do not store "how this feature was implemented" in the experience library.
