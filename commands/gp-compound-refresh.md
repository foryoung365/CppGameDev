# GP Compound Refresh Command

Use this command to maintain the active host project's verified gameplay experience library.

1. Load `gp-compound-refresh`.
2. Resolve the host-project experience library root:
   - explicit root from the active host project's `claude.md`, if present
   - otherwise `docs/cpp-mmorpg-gameplay/solutions/bugs/` and `docs/cpp-mmorpg-gameplay/solutions/patterns/`
3. Review the selected scope using only verified current evidence.
4. Allow only these actions:
   - `keep`
   - `update`
   - `consolidate`
   - `delete`
5. Refuse inferred successor docs and speculative rewrites.

If the host project has no experience library yet, report that and stop cleanly.
