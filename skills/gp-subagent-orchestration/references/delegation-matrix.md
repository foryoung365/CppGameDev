# Delegation Matrix

## `gp-intake`

- Main agent must do:
  - approve task slug and task directory
  - finalize `00-context.md`
  - finalize `01-pre-plan.md`
  - accept the routed plan shape
- Subagents may do:
  - codebase search
  - related-module discovery
  - prior-learning retrieval

## `gp-debug`

- Main agent must do:
  - decide whether evidence is sufficient
  - accept or reject root-cause conclusions
  - decide whether debugging is over
- Subagents may do:
  - log extraction
  - call-path tracing
  - evidence collation
  - related-learning retrieval

## `03-plan.md`

- Main agent must do:
  - approve implementation scope
  - approve exact edit boundary
  - decide whether code edits may start
- Subagents may do:
  - draft file lists
  - draft validation steps
  - draft compile entry notes
  - perform bounded implementation work after approval

## `gp-review`

- Main agent must do:
  - accept or reject findings
  - determine residual risk
  - finalize `05-review.md`
- Subagents may do:
  - cpp review draft
  - gameplay review draft
  - prior-learning alignment summary

## `gp-svn-handoff`

- Main agent must do:
  - decide whether compile proof is sufficient
  - decide whether delivery is ready
  - finalize `06-handoff.md`
- Subagents may do:
  - diff summary
  - build output summary
  - validation evidence collation
  - draft commit message

## `gp-compound`

- Main agent must do:
  - decide whether the lesson is general enough
  - decide the final track
  - approve library write
- Subagents may do:
  - extract lesson candidates from `05-review.md` and `06-handoff.md`
  - search for overlapping existing docs
  - draft a candidate knowledge or bug entry
