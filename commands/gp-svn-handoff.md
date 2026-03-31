# GP SVN Handoff Command

Use this command when one complete feature or one complete fix is ready for SVN delivery.

1. Check the working copy state with `svn-workspace-discipline`.
2. Confirm the change is feature-sized and self-contained.
3. Require a fresh successful compile before the handoff is considered ready, using the host project's standard build script or build command from its `claude.md` or equivalent project-local config.
4. Run `gp-experience-check` and note any relevant prior learnings from the host project as secondary context.
5. State whether the completed work conflicts with known learnings and whether the completed work merits `gp-compound`.
6. Produce the `svn-delivery-handoff` summary with purpose, affected modules, validation evidence, fresh successful compile evidence, commit message suggestion, and rollback or risk note.
7. Do not present partial work as delivery-ready.
