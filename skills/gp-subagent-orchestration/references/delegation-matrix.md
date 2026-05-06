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
  - run independent support tasks in parallel when the context card inputs are stable

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
  - run independent reproductions, log extraction, trace comparison, and related-learning retrieval in parallel when they do not depend on each other

## `03-plan.md`

- Main agent must do:
  - approve implementation scope
  - approve exact edit boundary
  - decide whether code edits may start
- Subagents may do:
  - draft file lists
  - draft performance impact notes
  - draft validation steps
  - draft compile entry notes
  - perform bounded implementation work after approval
  - run independent planning support tasks in parallel after the main agent approves scope

## `gp-review`

- Main agent must do:
  - accept or reject findings
  - determine residual risk
  - finalize `05-review.md` for workflow review or `review.md` for independent review
- Subagents may do:
  - bounded review draft
  - evidence collation
  - prior-learning alignment summary
  - run `bounded review draft`, `evidence collation`, and `prior-learning alignment summary` in parallel whenever the review scope is stable

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
  - prior-learning alignment summary
  - run diff summary, build output summary, validation evidence collation, and prior-learning alignment in parallel once inputs are stable

## `gp-compound`

- Main agent must do:
  - decide whether the lesson is general enough
  - decide the final track
  - approve library write
- Subagents may do:
  - extract lesson candidates from `05-review.md` and `06-handoff.md`
  - search for overlapping existing docs
  - draft a candidate knowledge or bug entry
  - run lesson-candidate extraction and overlap search in parallel when they are independent

## `gp-compound-refresh`

- Main agent must do:
  - decide whether evidence supports `keep`, `update`, `consolidate`, or `delete`
  - approve each refresh action
  - finalize the accepted refresh result
- Subagents may do:
  - bug-track scan
  - knowledge-track scan
  - duplicate-cluster detection
  - evidence collation
  - run independent track scans or doc reviews in parallel when the evidence sources do not overlap
