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
- [`write-technical-english`](skills/write-technical-english/SKILL.md) — one
  reading only. Sized sentences, imperative steps, one term per thing, no
  phrasal verbs. The useful subset of ASD-STE100.
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

## Sources

[`write-technical-english`](skills/write-technical-english/SKILL.md) paraphrases the
subset of **ASD-STE100 Simplified Technical English** that applies to software docs.

- [ASD-STE100 specification](https://www.asd-ste100.org/) - Issue 9, 2025-01-15. Free
  download. 53 writing rules in 9 sections, plus a dictionary of ~900 approved words.
- [STEMG](https://www.asd-ste100.org/about_STE.html) - the ASD Simplified Technical
  English Maintenance Group, who have maintained the standard since 1983.
- [ASD](https://www.asd-europe.org/standards-specifications/simplified-technical-english/) -
  Aerospace, Security and Defence Industries Association of Europe, the copyright holder.
- [@geogristle](https://x.com/geogristle/status/2078492579511906771) - the tweet that
  pointed out STE constrains LLMs away from AI-slop documentation.

The specification is copyright ASD and is not reproduced in this repo. Rules are
paraphrased with their rule numbers cited. Part 2, the approved-word dictionary, is out
of scope. Download the spec when you need a rule's exact wording.