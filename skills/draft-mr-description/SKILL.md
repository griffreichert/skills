---
name: draft-mr-description
description: Draft an MR or PR description that explains why the change exists, how it lands, what assumptions it makes, and how reviewers should validate it.
disable-model-invocation: true
---

# Draft MR Description

Turn a finished issue branch into a reviewer-ready MR description. The output
must read like a change story, not a commit dump.

Use `write-clearly` and `write-technical-english` when available. Apply the
second one hardest to the operator notes and the testing steps, which the
reader executes. Overview and Description are descriptive writing, so let them
run as prose.

## Steps

### 1. Gather the pile

Read the commits on the issue branch, their messages, the relevant diff, tests,
and any deploy or operator notes. Also read any session or daily notes the agent
can find locally for this issue (for example a `notes/daily/` folder). Prefer
local files and git history over memory.

Done when you can answer:

- What problem did this solve?
- What shape existed before?
- What shape exists now?
- Why was that shape chosen?
- What assumptions does the change rely on?
- What must reviewers or operators do?
- How should it be tested?

### 2. Find the reader

Decide what the reviewer already knows. Treat project basics as known. Ground
issue-specific concepts before using them.

Done when the opening can stand without requiring the reader to inspect commits.

### 3. Pick the thesis

Write the MR around one thesis:

```text
This changes X from old shape to new shape because Y.
```

If the branch has several commits, do not lead with the commit list. Lead with
the behaviour or operational problem the commits resolve.

Done when the first paragraph tells the reviewer what changed and why it matters.

### 4. Shape the Description as a sequence

Group changes into logical clusters, one per subsystem or concern. Order the
clusters by dependency, not chronology: the thing others build on first, then
its consumers, then supporting refactors and cleanup last.

For each cluster, explain:

- what changed
- why it changed
- what invariant or assumption now holds
- what stays the same

Use prose for cause and effect. Use lists only for parallel facts. Name
unchanged behaviour explicitly when reviewers may worry it moved.

Done when a reviewer can follow the change without reading the commits.

### 5. Write the risk and assumption surface

Add assumptions when the change depends on external behaviour, runtime inputs,
historical data, permissions, feature flags, or deployment sequencing.

Add limitations when old data cannot be reconstructed or a path intentionally
falls back to existing behaviour.

Call out breaking changes explicitly in their own labelled block. A breaking
change is any altered contract, renamed or removed interface, config or schema
migration required, or behaviour a caller relied on that no longer holds. State
what breaks, who it affects, and the required migration or upgrade step. If
nothing breaks, say nothing.

Done when there are no hidden reviewer questions like "who runs this migration?"
or "what happens to old data?"

### 6. Add operator notes only when needed

If the change needs an operator action, include the exact action. Use SQL or
commands when they are the safest handoff.

State:

- who runs it
- where it runs
- whether it is one-off or repeated
- what order it must happen in
- what cannot be inferred or repaired later

Skip this section entirely when the MR has no operator action.

Done when any required operator section can be handed off without searching the
code.

### 7. Write Testing

Split local checks from runtime validation.

Local checks should name the exact commands already run or expected.

Runtime validation should prove the behaviour in the real path. Include where
to look for logs, what to query, what result should change on a rerun, and what
artifact or status should remain stable.

Done when testing proves both correctness and the operational claim behind the
MR.

## Output shape

Use these headings unless the repo asks for a different template:

```markdown
## Overview

<old shape, new shape, why it matters>

## Description

<ordered change story with invariants and assumptions>

## Testing

<local checks and runtime validation>
```

Add another heading only when the MR needs it, for example `## Breaking Changes`,
`## Migration`, `## Deployment`, or `## Rollback`. When the change breaks a
contract, put `## Breaking Changes` near the top, before `## Description`.

## Quality bar

Longer is not better. The best descriptions are short, clear, and to the point
while keeping the relevant detail. Deleting any sentence should lose meaning; if
it would not, the sentence is already gone.

- Prefer "old shape -> new shape -> why" over a feature list.
- Name invariants explicitly.
- Call out breaking changes in their own block, never buried in prose.
- Remove any sentence that only says "this improves" without saying how.

## Done when

The MR description explains the problem, the new shape, the sequence of changes,
the assumptions, any breaking change, any operator action, and the validation
path. A reviewer should know what to inspect before opening the diff.
