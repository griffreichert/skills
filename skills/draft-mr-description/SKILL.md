---
name: draft-mr-description
description: Draft an MR or PR description that explains why the change exists, how it lands, what assumptions it makes, and how reviewers should validate it.
disable-model-invocation: true
---

# Draft MR Description

Turn a finished issue branch into a reviewer-ready MR description. The output
must read like a change story, not a commit dump.

The same shape covers a PR description, an RFC summary, and an architecture
note. Only the headings change.

Use `write-clearly` and `write-technical-english` when available. Apply the
second one hardest to the operator notes and the testing steps, which the
reader executes. Overview and Description are descriptive writing, so let them
run as prose.

[references/worked-example.md](references/worked-example.md) shows the causal
order and the reviewer map on one annotated change. Read it when the MR crosses
three or more stages, or when one domain object produces several stored objects.

## Steps

### 1. Gather the pile

Read the commits on the issue branch, their messages, the relevant diff, tests,
and any deploy or operator notes. Also read any session or daily notes the agent
can find locally for this issue (for example a `notes/daily/` folder), plus
earlier drafts and review comments. Prefer local files and git history over
memory.

Commit messages are evidence of intent. The diff is evidence of fact. Where the
two disagree, the diff wins, and the disagreement usually deserves a sentence in
the MR.

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

### 3. Match the voice and the skeleton

The commit messages, the issue text, and any earlier draft are a voice corpus.
Take vocabulary, spelling, register, and sentence rhythm from them. Fix errors
and keep the voice.

When the author supplies a skeleton or an earlier MR to follow, draft inside it.
Keep their headings, their section order, and the emphasis they asked for. Say
what you would change about the structure and let them decide.

Done when a paragraph you wrote would pass as one the author wrote.

### 4. Pick the thesis

Write the MR around one thesis:

```text
This changes X from old shape to new shape because Y.
```

If the branch has several commits, do not lead with the commit list. Lead with
the behaviour or operational problem the commits resolve.

Done when the first paragraph tells the reviewer what changed and why it matters.

### 5. Order the story by causality

Group changes into logical clusters, one per subsystem or concern. Order the
clusters by dependency: the thing others build on first, then its consumers,
then supporting refactors and cleanup last.

Where the supplied skeleton leaves the order open, this sequence carries most
changes:

1. the problem the reviewer needs to hold;
2. the invariant or contract the change introduces;
3. the mechanism that enforces it;
4. the downstream consumers affected;
5. compatibility and migration behaviour;
6. known limits and follow-up work;
7. the commands a reviewer can run.

Never narrate the diff file by file. Files come later, as a map.

Use prose for cause and effect. Use lists only for parallel facts. Name
unchanged behaviour explicitly when reviewers may worry it moved.

Done when a reviewer can follow the change without reading the commits.

### 6. Explain each choice with its consequence

Each design decision gets one paragraph in three moves: the problem, the
contract you chose, the effect downstream.

```text
Network limits can split one upload into several parts. The client records the
complete upload before splitting it. Every physical part therefore carries the
checksum and shares one upload ID.
```

**Name the code that implements it.** State the domain behaviour, name the
symbol that carries it, then state the consequence for the reviewer.

```text
Resumed uploads bypass re-chunking. `UploadSession.resume()` checks
`part_state` and adds every completed part to `skipped_parts`. The checksums
the client computed therefore reach the manifest unchanged.
```

Ground the claim wherever data changes shape, ownership moves, an ID is
created, a fallback picks a path, or one object fans out into several. Leave
the symbol out when it would only pad the sentence. The full rule, including
the abstract verbs worth auditing, lives in `write-technical-english`.

Two more rules keep those paragraphs honest.

**Name the logical thing and the physical thing separately.** When one domain
object produces several stored objects, fix both names in the Overview and never
vary them: the logical upload a person starts, the physical part that stores a
slice of it, the manifest that lists them. Identity, ordering, ownership, and
transformation all get explained in those exact words.

**Separate final state from temporary processing.** Say which object owns the
source content, which IDs stay stable, which metadata survives serialization,
which values are rebuilt in memory and thrown away, and which consumer receives
each output.

Cut any claim of "cleaner", "more robust" or "better architecture" unless the
next sentence names the concrete effect.

Done when every design decision in the MR is followed by what it causes.

### 7. Give reviewers a reading path

When the change crosses three or more stages or produces several document
shapes, add one compact ASCII diagram: source, parser, shared model, stored
objects, consumer. Label durable objects, temporary objects, logical IDs, and
physical IDs. Run `explain-visually` for the diagram itself. Prose stays
authoritative, because diagrams go stale.

For a large diff, add a reviewer map: files ordered by concept or lifecycle, one
responsibility each, collapsed in a `<details>` block. Put it after the
Overview, once the story is clear.

Skip both on a small change. A map of four files is noise.

Done when a reviewer knows which file to open first and why.

### 8. Write the risk, assumption and compatibility surface

Add assumptions when the change depends on external behaviour, runtime inputs,
historical data, permissions, feature flags, or deployment sequencing.

Add limitations when old data cannot be reconstructed or a path intentionally
falls back to existing behaviour.

State compatibility explicitly: how old records are detected, which fields stay
readable, whether a migration or dual write is required, which caller owns
adoption, and which behaviour is unchanged.

Call out breaking changes explicitly in their own labelled block. A breaking
change is any altered contract, renamed or removed interface, config or schema
migration required, or behaviour a caller relied on that no longer holds. State
what breaks, who it affects, and the required migration or upgrade step. If
nothing breaks, say nothing.

Keep scope exclusions to one line each. Name the boundary and the follow-up
issue where one exists.

Done when there are no hidden reviewer questions like "who runs this migration?"
or "what happens to old data?"

### 9. Add operator notes only when needed

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

### 10. Write Testing

Split local checks from runtime validation.

Local checks name runnable commands: the working directory they run from, the
markers or filters they use, and the credentials or extras they need. Keep local
suites separate from anything that needs cloud access. Do not claim a passing
count unless you recorded it from the current tree. The **prove-it** skill
produces exactly this evidence; paste its block in here when the author ran it.

Runtime validation should prove the behaviour in the real path. Include where
to look for logs, what to query, what result should change on a rerun, and what
artifact or status should remain stable.

Close with what a reviewer should eyeball in the output.

Done when testing proves both correctness and the operational claim behind the
MR.

## Output shape

Use these headings unless the repo, or the author, asks for a different
template:

```markdown
## Overview

<old shape, new shape, why it matters>

## Description

<ordered change story with invariants and assumptions>

## Testing

<local checks and runtime validation>
```

Add another heading only when the MR needs it, for example `## Breaking Changes`,
`## Migration`, `## Deployment`, `## Rollback`, or `## Next Steps`. When the
change breaks a contract, put `## Breaking Changes` near the top, before
`## Description`.

A skeleton the author supplies replaces this one. Do not fold their headings
back into the default.

## Quality bar

Longer is not better. The best descriptions are short, clear, and to the point
while keeping the relevant detail. Deleting any sentence should lose meaning; if
it would not, the sentence is already gone.

- Prefer "old shape -> new shape -> why" over a feature list.
- Name invariants explicitly.
- Call out breaking changes in their own block, never buried in prose.
- Remove any sentence that only says "this improves" without saying how.

## Done when

- The opening states the problem and the outcome.
- Every domain concept has exactly one name.
- Each major design choice is followed by its consequence.
- Every major claim names code a reviewer can open.
- Durable data and temporary data are distinguished.
- Compatibility behaviour is explicit.
- Scope exclusions are one line each.
- Test commands are runnable from named directories.
- Every claim matches the code and the test evidence from this tree.
- The result still sounds like the author.
- Deleting any paragraph would cost the reviewer something.
