---
name: draft-mr-description
description: Draft an MR or PR description that explains why the change exists, how it lands, what assumptions it makes, and how reviewers should validate it.
disable-model-invocation: true
---

# Draft MR Description

Turn a finished issue branch into an MR description ready for review. It reads
as a change story and never as a commit dump. The same shape covers a PR
description, an RFC summary and an architecture note, with only the headings
changing.

Apply `write-clearly` and `write-technical-english`, the second hardest to the
operator notes and testing steps the reader executes. Overview and Description
are descriptive writing and run as prose.

Read [references/worked-example.md](references/worked-example.md) when the MR
crosses three or more stages, or when one domain object produces several stored
objects. It shows the causal order and reviewer map on one annotated change.

## Steps

### 1. Gather the pile

Read the issue branch's commits and messages, the relevant diff, tests, deploy
or operator notes, any local session or daily notes for this issue (such as
`notes/daily/`), and earlier drafts and review comments. Local files and git
history outrank memory. Commit messages are evidence of intent and the diff is
evidence of fact. Where they disagree the diff wins, and the gap usually earns a
sentence in the MR.

Done when you can answer: the problem solved, the shape before, the shape now,
why that shape, the assumptions it relies on, what reviewers or operators must
do, and how to test it.

### 2. Find the reader

Decide what the reviewer already knows. Treat project basics as known and ground
issue specific concepts before using them.

Done when the opening stands without the reader inspecting commits.

### 3. Match the voice and the skeleton

The commit messages, issue text and earlier drafts are a voice corpus. Take
vocabulary, spelling, register and rhythm from them, and fix errors while
keeping the voice. When the author supplies a skeleton or an earlier MR to
follow, draft inside it with their headings, order and emphasis. Say what you
would change about the structure and let them decide.

Done when a paragraph you wrote would pass as the author's.

### 4. Pick the thesis

Write the MR around one sentence: "This changes X from old shape to new shape
because Y." With several commits, lead with the behaviour or operational
problem they resolve and keep the commit list out of the opening.

Done when the first paragraph says what changed and why it matters.

### 5. Order the story by causality

Group changes into clusters, one per subsystem or concern, and order them by
dependency: what others build on first, then its consumers, then supporting
refactors and cleanup. Where the skeleton leaves order open, most changes fit:

1. the problem the reviewer must hold
2. the invariant or contract the change introduces
3. the mechanism that enforces it
4. the downstream consumers affected
5. compatibility and migration behaviour
6. known limits and follow up work
7. the commands a reviewer can run

Never narrate the diff file by file, since files come later as a map. Use prose
for cause and effect and lists for parallel facts. Name unchanged behaviour
where reviewers may worry it moved.

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
created, a fallback picks a path, or one object fans out. Leave the symbol out
when it only pads. The full rule, with the abstract verbs worth auditing, lives
in `write-technical-english`.

**Name the logical and the physical thing separately.** When one domain object
produces several stored objects, fix both names in the Overview and never vary
them: the logical upload a person starts, the physical part that stores a slice,
the manifest that lists them. Explain identity, ordering, ownership and
transformation in those exact words.

**Separate final state from temporary processing.** Say which object owns the
source content, which IDs stay stable, which metadata survives serialization,
which values are rebuilt in memory and discarded, and which consumer receives
each output.

Cut any claim of "cleaner", "more robust" or "better architecture" unless the
next sentence names the concrete effect.

Done when every design decision is followed by what it causes.

### 7. Give reviewers a reading path

When the change crosses three or more stages or produces several document
shapes, add one compact ASCII diagram: source, parser, shared model, stored
objects, consumer. Label durable and temporary objects, and logical and physical
IDs. `explain-visually` draws it. Prose stays authoritative, because diagrams go
stale.

For a large diff, add a reviewer map after the Overview: files ordered by
concept or lifecycle, one responsibility each, collapsed in a `<details>` block.
Skip both on a small change, since a map of four files is noise.

Done when a reviewer knows which file to open first and why.

### 8. Write the risk, assumption and compatibility surface

- **Assumptions** when the change depends on external behaviour, runtime inputs,
  historical data, permissions, feature flags, or deployment sequencing.
- **Limitations** when old data cannot be reconstructed or a path falls back to
  existing behaviour on purpose.
- **Compatibility**: how old records are detected, which fields stay readable,
  whether a migration or dual write is required, which caller owns adoption, and
  which behaviour is unchanged.
- **Breaking changes** in their own labelled block: an altered contract, a
  renamed or removed interface, a required config or schema migration, or
  behaviour a caller relied on that no longer holds. State what breaks, who it
  affects, and the migration or upgrade step. When nothing breaks, say nothing.
- **Scope exclusions**, one line each, naming the boundary and the follow up
  issue where one exists.

Done when no hidden reviewer question remains, such as "who runs this
migration?" or "what happens to old data?".

### 9. Add operator notes only when needed

Skip this section when the MR has no operator action. Otherwise give the exact
action, with SQL or commands where they are the safest handoff, and state who
runs it, where, whether it is one off or repeated, in what order, and what
cannot be inferred or repaired later.

Done when the operator section can be handed off without searching the code.

### 10. Write Testing

Split local checks from runtime validation.

- **Local checks** name runnable commands with the working directory, markers or
  filters, and the credentials or extras they need. Keep local suites apart from
  anything needing cloud access. Claim a passing count only when you recorded it
  from the current tree. **prove-it** produces this evidence, so paste its block
  when the author ran it.
- **Runtime validation** proves the behaviour in the real path: where to look
  for logs, what to query, what result changes on a rerun, and what artifact or
  status stays stable.
- Close with what a reviewer should eyeball in the output.

Done when testing proves both correctness and the operational claim behind the
MR.

## Output shape

Use these headings unless the repo or the author asks for another template. A
skeleton the author supplies replaces this one, and their headings never fold
back into the default.

```markdown
## Overview

<old shape, new shape, why it matters>

## Description

<ordered change story with invariants and assumptions>

## Testing

<local checks and runtime validation>
```

Add a heading only when the MR needs it: `## Breaking Changes`, `## Migration`,
`## Deployment`, `## Rollback`, `## Next Steps`. A contract break puts
`## Breaking Changes` near the top, before `## Description`.

## Quality bar

Longer is not better. The best descriptions are short, clear and to the point
with the relevant detail kept, and deleting any sentence should lose meaning.

- Prefer "old shape, new shape, why" over a feature list.
- Name invariants explicitly.
- Call out breaking changes in their own block, never buried in prose.
- Remove any sentence that says "this improves" without saying how.

## Done when

- The opening states the problem and the outcome.
- Every domain concept has one name.
- Each major design choice is followed by its consequence.
- Every major claim names code a reviewer can open.
- Durable and temporary data are distinguished.
- Compatibility behaviour is explicit, and scope exclusions are one line each.
- Test commands run from named directories.
- Every claim matches the code and the test evidence from this tree.
- The result still sounds like the author.
- Deleting any paragraph would cost the reviewer something.
