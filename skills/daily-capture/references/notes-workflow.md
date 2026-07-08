# Notes workflow — shared conventions

The `orient`, `daily-capture`, and `log-decisions` skills all read and write
the same session notes. These are the conventions they share.

## Where notes live

Notes live in the **Obsidian vault**, not the code repo. A project's `notes/`
folder is usually a **symlink** into the vault. File operations follow the
symlink transparently — read and write `notes/...` as normal; the bytes land in
the vault. Never assume notes are git-tracked, and never commit them with code.

## Finding the destination

Read the project's `CLAUDE.md` / `AGENTS.md` for where session notes go: the
folder (often `notes/daily/`), the dated-note pattern (`<YYYY-MM-DD>.md`), the
headings to write under, and house style (bullets, `[[wikilinks]]`, absolute
dates). Resolve every relative date to an absolute one.

## Steer-me fallback

If no destination is configured, or the `notes/` folder can't be found, **stop
and ask the user** to point you at the notes folder or vault. Do not guess a
path and do not silently write elsewhere. `orient` may still orient from git and
the working tree while it asks.

## The daily note

One note per day: `notes/daily/<YYYY-MM-DD>.md`. Sections:

- **Done** — high-level work that landed.
- **Decisions** — decisions, pivots, realisations, each with its *why*.
  (`log-decisions` appends here live; `daily-capture` consolidates at session end.)
- **Open questions** — anything unresolved or deferred for next session.

Filter every bullet by the **altitude test**: log only what still matters in a
month — scope boundaries, architecture choices, hard constraints, direction
changes, and *why*. Skip task-level mechanics. Unsure it survives a month? Leave
it out.

## The _index map

Each notes folder has an `_index.md` at its **root** (the symlink target in the
vault) — a flat list of `[[wikilinks]]` to the live plans, issues, and dated
notes in that folder. It is a table of contents, not a state dump: the dated
notes remain the source of truth.

- `daily-capture` **maintains** it — when it creates a new note or plan, it adds
  or refreshes that file's `[[wikilink]]` in `_index.md`, seeding the file if
  absent.
- `orient` **reads** it as a cheap entry point, then follows the links. `orient`
  never writes or heals `_index.md`; a missing one just means it falls back to
  scanning the folder and asking the user to steer.
