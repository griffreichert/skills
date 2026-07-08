---
name: log-decisions
description: Log a decision, pivot, or realisation to the day's session note as it lands mid-session. Use the moment a direction changes, a trade-off is settled, an approach is abandoned, or you realise something that reshapes the work — capture it with its why while it's fresh, before it's lost to the session.
---

# Log decisions

Continuous decision capture. Where `daily-capture` snapshots at session end,
this fires *live* — the moment a decision lands — so the *why* is recorded while
it's fresh. The note conventions live in
[`references/notes-workflow.md`](../daily-capture/references/notes-workflow.md);
read them for destination discovery, the vault/symlink layout, and steer-me.

## When it fires

A decision, pivot, realisation, or abandoned approach — anything that would make
next session ask "wait, why did we do it this way?". Apply the **altitude test**
(see the reference): if it won't matter in a month, don't log it. Task-level
mechanics, parameter values, and routine edits are not decisions.

## What to write

One bullet appended to the day's note under **Decisions**, carrying the *why*,
not just the *what*:

> - Split daily-capture into three skills — one was doing continuous logging and
>   end-of-session snapshotting at once. Why: scope creep, two triggers in one.

Front-loaded, one idea, terse (**write-clearly** if available). Append directly
to the dated note with your file-editing tools — never a script. Create the note
and its `_index.md` link only if `daily-capture` hasn't; otherwise just append.

If no destination is configured or the notes folder can't be found, **ask the
user to steer** rather than guess.

## Done when

The decision and its *why* sit as one bullet under Decisions in the day's note.
