# GP Compound Refresh Command

Use this command to maintain the active host project's verified gameplay experience library.

1. Load `gp-compound-refresh`.
2. Resolve the host-project experience library root:
   - explicit root from the active host project's `claude.md`, if present
   - otherwise `docs/cmg/solutions/bugs/` and `docs/cmg/solutions/patterns/`
3. Review the selected scope using only verified current evidence.
4. When multiple docs, tracks, or duplicate clusters can be reviewed independently, prefer parallel review work and combine the accepted conclusions only at the main-agent decision point.
5. Allow only these actions:
   - `keep`
   - `update`
   - `consolidate`
   - `delete`
6. Refuse inferred successor docs and speculative rewrites.

If the host project has no experience library yet, report that and stop cleanly.
