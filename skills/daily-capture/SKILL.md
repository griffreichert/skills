---
name: daily-capture
description: Manually capture an end-of-session snapshot into the project's session note.
disable-model-invocation: true
---

# Daily capture

End-of-session snapshot of what happened. This skill owns the *capture*; where it lands is project config read from `CLAUDE.md` or `AGENTS.md`. If no destination is configured, hand the snapshot back in chat rather than guess.

## Steps

### 1. Gather from this session

Pull three things from the conversation. Signal only, not a task log.

- **Done** — the high-level work that landed, a few bullets. Not every edit.
- **Decisions** — decisions, pivots, realisations, each with its *why*.
- **Open questions** — anything unresolved or deferred for next session.

Omit a section that's genuinely empty. Don't pad.

### 2. Find the destination

Read the project's `CLAUDE.md` / `AGENTS.md` for where session notes go — the file path (often a dated note like `notes/daily/<YYYY-MM-DD>.md`), the heading to write under, and any house style (bullets, `[[wikilinks]]`, absolute dates). Resolve dates to absolute values.

If the config is present, that's your destination. If it's absent or ambiguous, take the **chat fallback** in step 3.

### 3. Write it

- **Destination found** — append the snapshot to that file, under the configured heading, in the style it specifies. Create the file if missing.
- **No destination / unsure** — do not guess a path. Print the snapshot as a fenced markdown block in chat for the user to paste, and say you couldn't find a configured destination.

## Done when

The snapshot carries every non-empty section from step 1, and has either landed in the configured destination or been returned in chat as a paste-ready block.
