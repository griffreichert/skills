---
name: daily-capture
description: Manually capture an end-of-session snapshot into the project's session note.
disable-model-invocation: true
---

# Daily capture

End-of-session snapshot of what happened. This skill owns the *capture*; the
note conventions — where it lands, the vault/symlink layout, the `_index` map —
live in [`references/notes-workflow.md`](references/notes-workflow.md). Read that
first.

## Steps

### 1. Gather from this session

Pull four things from the conversation, filtered by the **altitude test** (see
the reference): log only what still matters in a month.

- **Done** — the high-level work that landed.
- **Decisions** — decisions, pivots, realisations, each with its *why*. Some may
  already sit in the note from `log-decisions` running live this session;
  consolidate and dedupe against those rather than repeat them.
- **Open questions** — anything unresolved or deferred for next session.
- **Working tree** — one line of handover state: current branch, whether the
  tree is dirty, and any unpushed commits (`git status -sb`, `git log @{u}..`).
  This is often where "next session" actually resumes.

Cap ~3-5 bullets per section. Hitting the cap means consolidate, not expand.
Omit a section that's genuinely empty; don't pad.

Phrase every bullet by the **write-clearly** skill's guidelines if it's
available: front-loaded, one idea each, cut to the bone. If it isn't, still keep
bullets terse.

### 2. Find the destination

Follow the reference's destination-discovery and steer-me rules. If no
destination is configured or the notes folder can't be found, **ask the user to
steer** — do not guess a path.

### 3. Write it

Edit the note file directly with your file-editing tools. Never write a script
(Python, shell, sed, etc.) to do the edit — this is a plain text edit.

- Append the snapshot to the dated note, under the configured headings, in the
  house style. Create the file if missing.
- If you created the note (or a new plan), **refresh `_index.md`** at the notes
  folder root — add the new file's `[[wikilink]]`, seeding `_index.md` if it
  doesn't exist. See the reference for the `_index` convention.

## Done when

The snapshot carries every non-empty section from step 1, has landed in the
configured destination (or been returned in chat with a steer-me ask), and any
newly created file is linked from `_index.md`.
