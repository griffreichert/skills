---
name: prove-it
description: Prove a change works before it is submitted. Run it, test it, watch the test go red when the change is reverted, then hand over the evidence. Use when a change is finished, before pushing, before opening an MR, or before saying it is done.
---

# Prove it

Deliver code you have proven to work. A patch is cheap, and the evidence that
the lines do what they claim carries the value. Untested code does not work,
and code that happens to work is luck. A computer cannot be held accountable,
and the change carries your name, so the proof is yours to produce.

Run this once, at completion, before the commit and MR description that consume
its output. Rerunning the suite after each small edit proves nothing until the
change is finished. Automate only the test this change needs to prove itself.

## The four proofs

Answer all four, or name the one you skipped and why.

1. **You ran it.** The behaviour, in the real path, with real input. A type
   check or read through does not count. Record the command and what you saw.
2. **You automated what you ran.** The manual check becomes a test. Whether that
   test is any good belongs to **test-stickler**.
3. **You watched it go red.** Revert the change, run the test, see it fail. This
   is the only step that binds the test to your work.
4. **You named the edges.** Off the happy path: empty, `None`, zero, the limit,
   the limit plus one, the second call, the timeout, the worst input a caller
   could hand you. Test them, or state which you left and why.

## The revert check

A green suite proves nothing alone, because a test that never went red was
never bound to the code. This is the load bearing step and the one that gets
skipped. Stash the source and keep the test:

```bash
git stash push -- path/to/source.py
pytest tests/path/to/test_source.py::test_the_case   # expect red
git stash pop
```

For a new file, or a change spanning test and source together, break the
behaviour by hand (change the return value, delete the branch) and put it back.
Record what the failure said: `KeyError: 'checksum'` is evidence, and "it
failed" is not.

A test that stays green with the change reverted asserts on its own inputs, its
mocks, or a literal. Fix the test before you go further.

## Explain it cold

Correctness is half of it. The other half is whether the shape holds, and names
are where it shows: `VersionedStructuredRequestWithOptions` carrying unversioned
requests is a name that lies, and the reviewer pays each time they read it.
Answer out loud with no notes:

- Can you explain the flow start to finish, and each part on its own?
- What are each part's inputs and outputs, and what happens when one arrives
  unexpected?
- Does every name describe what the thing holds? A name that needs a comment, or
  reads "X but really Y", is the wrong name.

A muddled answer is a finding about the code. Take it to **purge-slop**, or to
**codebase-design** when the seam is wrong.

## Output

An evidence block that pastes into the MR `## Testing` section unedited.
Commands carry the directory they ran from.

```markdown
**Ran**: `uv run pytest tests/upload/test_session.py -q` from the repo root.
14 passed.

**Red on revert**: stashed `upload/session.py`, `test_resumes_from_manifest`
failed with `KeyError: 'checksum'`. Restored, green again.

**By hand**: uploaded a 12 MB file, killed the process after part 2, resumed.
Parts 1 and 2 skipped, 3 and 4 sent, manifest lists all four in order.

**Edges**: empty file writes one part (tested). A manifest missing `checksum`
raises at the reader (tested). Concurrent resumes untested, out of scope,
flagged in the MR.
```

When the change is not ready, say so first, then report what is unproven and
what it would take to prove it.

## Rules

- **Unrun is unproven.** "The code looks right" and a passing type check are not
  evidence.
- **Report a gap, never assume.** An untested edge is a line in the output.
- **Volume is not proof.** Fifty proven lines beat a thousand unproven ones, and
  the size of a patch is never a reason to trust it.
- **One agent pass is a draft.** Read it, run it, improve it, run it again.
  Agent written code raises the bar on scrutiny, since neither reviewer nor
  agent is accountable for it.
- **Record from this tree.** Quote only a passing count you just saw.
- **A scripted edit is unproven until you read it back.** `sed -i`, a heredoc
  calling `str.replace`, a codemod, and `jq` writing over its input each exit 0
  on no match. The build stays green because a no op leaves valid code, every
  downstream check passes, and the edit never happened. Assert the match before
  the write, then confirm the new text in the file or built artifact. A
  formatter run between two edits to one file invalidates the strings you
  matched earlier.

  ```python
  old = "timeout=30"
  assert old in text, f"no match: {old!r}"
  path.write_text(text.replace(old, "timeout=60"))
  ```

  The Edit tool and a patch you read already fail loudly on a missed match, so
  apply the rule where a failed match and a successful one exit the same way.

## Done when

Each of the four proofs is answered or named as a gap. The revert check ran and
you saw its failure. Every scripted substitution asserted its match or had its
result read back. Every name in the change survives being explained out loud.
The evidence block is concrete enough that a reviewer could rerun it, and it
goes into the MR unedited.
