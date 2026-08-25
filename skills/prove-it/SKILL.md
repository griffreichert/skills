---
name: prove-it
description: Prove a change works before it is submitted. Run it, test it, watch the test go red when the change is reverted, then hand over the evidence. Use when a change is finished, before pushing, before opening an MR, or before saying it is done.
---

# Prove it

Your job is to deliver code you have proven to work. A patch is cheap; anyone
can generate a thousand lines of it. What carries value is the evidence that the
lines do what they claim.

Untested code does not work. Code that happens to work is luck. This skill turns
"I think it's done" into something a reviewer can check, and it runs **before**
the commit and the MR description, because both of those consume its output.

A computer cannot be held accountable. The change carries your name, so the
proof is yours to produce.

## The four proofs

Answer all four, or name the one you skipped and why.

1. **You ran it.** Not the type checker, not a read-through. The behaviour, in
   the real path, with real input. Record the command and what you saw.
2. **You automated what you ran.** The manual check becomes a test, so the next
   person gets it for free. Defer to the **test-stickler** skill for whether
   that test is any good.
3. **You watched it go red.** Revert the change, run the test, see it fail.
   This is the only step that proves the test is bound to your work.
4. **You named the edges.** What happens off the happy path: empty, `None`,
   zero, the limit, the limit plus one, the second call, the timeout, the worst
   input a caller could hand you. Test them, or state which you left and why.

## The revert check

The load-bearing step, and the one that gets skipped. A green suite proves
nothing on its own, because a test that never went red was never bound to the
code.

Stash the source and keep the test:

```bash
git stash push -- path/to/source.py
pytest tests/path/to/test_source.py::test_the_case   # expect red
git stash pop
```

For a new file, or a change that spans the test and the source together, break
the behaviour by hand instead: change the return value, delete the branch, and
put it back after. Record what the failure said. `KeyError: 'table'` is
evidence; "it failed" is not.

If the test stays green with the change reverted, the test is asserting on its
own inputs, its mocks, or a literal. Fix the test before you go further.

## Explain it cold

Correctness is half of it. The other half is whether the shape holds up, and
names are the surface where it shows. `VersionedStructuredRequestWithOptions`
carrying unversioned requests is a name that lies, and a reviewer pays for it
every time they read it.

Three questions, answered out loud, with no notes:

- Can you explain the flow start to finish, and each part on its own?
- What are the inputs and the outputs of each part, and what happens when one
  arrives unexpected?
- Does every name describe what the thing holds? A name that needs a comment,
  or reads as "X but really Y", is the wrong name.

Any answer that comes out muddled is a finding about the code. Take it back to
the **purge-slop** skill, or to **codebase-design** when the seam is wrong.

## Output

An evidence block, written so it pastes into the MR `## Testing` section
unedited. Commands carry the directory they ran from.

```markdown
**Ran** — `uv run pytest tests/ingest/test_tables.py -q` from the repo root.
14 passed.

**Red on revert** — stashed `ingest/tables.py`, `test_groups_by_table_id`
failed with `KeyError: 'table'`. Restored, green again.

**By hand** — ingested `fixtures/two-table.xlsx`. Both tables land as separate
chunks, `chunk_index` 0 and 1, checked in the retrieval output.

**Edges** — empty sheet returns no chunks (tested). Missing `table` key raises
at the reader (tested). Merged cells untested, out of scope, flagged in the MR.
```

When the change is not ready, say so first and report per the
**decision-brief** skill: what is unproven, what it would take to prove it, and
the decision you need.

## Rules

- **Unrun is unproven.** "The code looks right" is not evidence, and neither is
  a passing type check.
- **A gap is reported, never assumed.** An edge you did not test is a line in
  the output. A day of guessing beats one sentence of invention.
- **Volume is not proof.** Fifty proven lines beat a thousand unproven ones.
  Never offer the size of a patch as a reason to trust it.
- **One agent pass is a draft.** Read it, run it, improve it, run it again.
  Agent-written code raises the bar on scrutiny, since neither the reviewer nor
  the agent is accountable for it.
- **Record from this tree.** Never quote a passing count you did not just see.

## Done when

Each of the four proofs is answered or named as a gap. The revert check ran and
you saw the failure it produced. Every name in the change survives being
explained out loud. The evidence block is concrete enough that a reviewer could
rerun it, and it goes into the MR without editing.
