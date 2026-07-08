---
name: daily-capture
description: Manually capture an end-of-session snapshot into the project's session note.
disable-model-invocation: true
---

# Daily capture

End-of-session snapshot of what happened. This skill owns the *capture*; where it lands is project config read from `CLAUDE.md` or `AGENTS.md`. If no destination is configured, hand the snapshot back in chat rather than guess.

## Steps

### 1. Gather from this session

Pull three things from the conversation, filtered by the **altitude test**: log only what still matters in a month — scope boundaries, architecture choices, hard constraints, direction changes, and *why*. Skip task-level mechanics (parameter values, per-field rules, routine edits, each thing the user asked for). Unsure it survives a month? Leave it out.

- **Done** — the high-level work that landed.
- **Decisions** — decisions, pivots, realisations, each with its *why*.
- **Open questions** — anything unresolved or deferred for next session.

Cap ~3-5 bullets per section. Hitting the cap means consolidate, not expand. Omit a section that's genuinely empty; don't pad.

Phrase every bullet by the **write-clearly** skill's guidelines if it's available: front-loaded, one idea each, cut to the bone. If it isn't, still keep bullets terse.

### 2. Find the destination

Read the project's `CLAUDE.md` / `AGENTS.md` for where session notes go — the file path (often a dated note like `notes/daily/<YYYY-MM-DD>.md`), the heading to write under, and any house style (bullets, `[[wikilinks]]`, absolute dates). Resolve dates to absolute values.

If the config is present, that's your destination. If it's absent or ambiguous, take the **chat fallback** in step 3.

### 3. Write it

Edit the note file directly with your file-editing tools. Never write a script (Python, shell, sed, etc.) to do the edit — this is a plain text edit, not a programming task.

- **Destination found** — append the snapshot to that file, under the configured heading, in the style it specifies. Create the file if missing.
- **No destination / unsure** — do not guess a path. Print the snapshot as a fenced markdown block in chat for the user to paste, and say you couldn't find a configured destination.

## Done when

The snapshot carries every non-empty section from step 1, and has either landed in the configured destination or been returned in chat as a paste-ready block.
