# skills

*Author: Griffin Reichert*

The skills I actually use, in one repo. Small instruction modules that teach
Claude Code and Codex my habits: write tighter, cut the Python slop, hand off
cleanly between sessions so tomorrow's agent isn't starting from scratch.
Install once, they follow you into every project. Steal the ones you like.

## Install

Basic install using [vercel-labs/skills](https://github.com/vercel-labs/skills).

```bash
npx skills add griffreichert/skills
```
One line, both agents, everywhere:

```bash
npx skills add griffreichert/skills -g -a claude-code -a codex
```

`-g` makes them global. Drop it to scope to the current repo. `-a` picks the
agent. Repeat it, or drop it to install for whatever agents you have.

No `npx`? `git clone` it and run `./skills/install.sh`.

## Skills

**Writing**

- [`write-clearly`](skills/write-clearly/SKILL.md) — cut prose to the bone.
  Clear, human, no AI slop.
- [`draft-mr-description`](skills/draft-mr-description/SKILL.md) — turn a finished
  branch into a reviewer-ready MR description: old shape, new shape, why.
- [`draft-git-commit`](skills/draft-git-commit/SKILL.md) — draft a commit title
  and body matching the repo's convention. Drafts only, does not commit.

**Python hygiene**

- [`purge-slop`](skills/purge-slop/SKILL.md) — write Python without slop: no
  defensive checks, no fake tests, no needless private helpers.
- [`review-slop`](skills/review-slop/SKILL.md) — flag that same slop in a diff
  or PR as review comments, no edits.
- [`test-stickler`](skills/test-stickler/SKILL.md) — audit pytest tests for the
  ones that cannot go red. Flags the smell by name, suggests the fix, names the
  missing edge cases.
- [`pydantic-principles`](skills/pydantic-principles/SKILL.md) — structure
  pydantic code so the library does the work: construction validates, settings
  own the knobs, contracts live at boundaries.

**Session handover** — *yesterday's agent leaving tomorrow's a note.*

- [`log-decisions`](skills/log-decisions/SKILL.md) — model invokable background skill to
  capture a decision or pivot the moment it lands, with its why.
- [`daily-capture`](skills/daily-capture/SKILL.md) — snapshot the session (done,
  decisions, open questions, working tree) into the day's note.
- [`orient`](skills/orient/SKILL.md) — start cold? Read the notes, open issues,
  and working tree, then propose where to begin.


## Inspiration

[Matt Pocock skills](https://github.com/mattpocock/skills) - incredible resource, very 
helpful while I have iterated on my own skills, if you do not use these you are missing
out!

[@Voxyz_ai](https://x.com/Voxyz_ai) - for pointing out that banning words one at a time
is not a writing system, and for naming corrective juxtaposition, the "not X, it's Y"
tic. Both landed in [`write-clearly`](skills/write-clearly/SKILL.md), which also leans
on Orwell's six rules from "Politics and the English Language" (1946).