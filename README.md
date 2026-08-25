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

**Explaining**

- [`explain-visually`](skills/explain-visually/SKILL.md) — one worked example,
  the data shapes, an ASCII lifecycle diagram, and a table of what is stored
  versus what is temporary. For when the parts are clear and the wiring is not.

**Reporting** — *two shapes for the same findings.*

- [`review-comments`](skills/review-comments/SKILL.md) — label and group findings
  as conventional comments: issue, todo, suggestion, quibble, praise. For a
  reader who must verify.
- [`decision-brief`](skills/decision-brief/SKILL.md) — a prioritised list of
  decisions: the problem in plain language, the action you recommend, the exact
  approval needed. Evidence held back until asked. For a reader who must choose.

**Python hygiene**

- [`purge-slop`](skills/purge-slop/SKILL.md) — write Python without slop: no
  defensive checks, no re-validating what the owner already proved, no fake
  tests, honest type hints on every signature. Matches the file it lands in,
  and escalates a helper chain to the flow it hides. Has a scoped mode for
  stripping an agent's fingerprints off a diff.
- [`review-slop`](skills/review-slop/SKILL.md) — flag that same slop in a diff
  or PR as review comments, no edits. Switches to a decision brief when the
  question is what to fix.
- [`test-stickler`](skills/test-stickler/SKILL.md) — audit pytest tests for the
  ones that cannot go red. Flags the smell by name, suggests the fix, names the
  missing edge cases. Reports as a decision brief by default, or as a full
  evidence-backed audit on request.
- [`pydantic-principles`](skills/pydantic-principles/SKILL.md) — structure
  pydantic code so the library does the work: construction validates, settings
  own the knobs, contracts live at boundaries.

**Shipping** — *the gate between written and submitted.*

- [`prove-it`](skills/prove-it/SKILL.md) — you ran it, you automated it, you
  reverted the change and watched the test go red, you named the edges. Hands
  back an evidence block that pastes into the MR.
- [`commit-changes`](skills/commit-changes/SKILL.md) — write a commit matching
  the repo's convention, split moves from edits, then commit it.
- [`draft-mr-description`](skills/draft-mr-description/SKILL.md) — turn a finished
  branch into a reviewer-ready MR description: old shape, new shape, why.

**Session handover** — *yesterday's agent leaving tomorrow's a note.*

- [`log-decisions`](skills/log-decisions/SKILL.md) — model invokable background skill to
  capture a decision or pivot the moment it lands, with its why.
- [`daily-capture`](skills/daily-capture/SKILL.md) — snapshot the session (done,
  decisions, open questions, working tree) into the day's note.
- [`orient`](skills/orient/SKILL.md) — start cold? Read the notes, open issues,
  and working tree, then propose where to begin.
- [`timesheet`](skills/timesheet/SKILL.md) — what did I do last week? Rebuild
  the days from the daily notes and your commits, every claim carrying its
  evidence and every blank day named as a gap.

**Skill upkeep**

- [`skill-ci`](skills/skill-ci/SKILL.md) — end of session, turn the friction you
  hit into a copyable blurb the skills-repo agent can implement. Evidence
  required, three proposals maximum, "nothing this session" allowed.


## Inspiration

[Matt Pocock skills](https://github.com/mattpocock/skills) - incredible resource, very 
helpful while I have iterated on my own skills, if you do not use these you are missing
out!

[`prove-it`](skills/prove-it/SKILL.md) started from a gist on
[meaningful contribution](https://gist.github.com/bdsqqq/1e7e6f454271d5f856a1176d0e800d89)
by [@bdsqqq](https://github.com/bdsqqq), which takes its opening line from
[Simon Willison](https://simonwillison.net/2025/Dec/18/code-proven-to-work/):
"your job is to deliver code you have proven to work".

[`purge-slop`](skills/purge-slop/SKILL.md) picked up its typing rule, its
match-the-neighbours principle, and its diff-scoped mode from the anti-slop
skills going around. Worth reading in full:

- [dmmulroy/anti-slop](https://github.com/dmmulroy/anti-slop) - 16 oxlint rules
  built on one idea: never discard type evidence the code already had.
- [cursor/plugins deslop](https://github.com/cursor/plugins) and
  [brianlovin/agent-config](https://github.com/brianlovin/agent-config) - strip
  what the agent added, match the file, summarise in three sentences.
- [AsyrafHussin/agent-skills](https://github.com/asyrafhussin/agent-skills) -
  `code-slop`, 24 patterns over six categories, where the snapshot-abuse smell
  in [`test-stickler`](skills/test-stickler/SKILL.md) came from.

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

[`write-technical-english`](skills/write-technical-english/SKILL.md) also takes its
document-furniture rules from the **Google developer documentation style guide**.

- [Style guide highlights](https://developers.google.com/style/highlights)
- [Writing for a global audience](https://developers.google.com/style/translation)
- [Timeless documentation](https://developers.google.com/style/timeless-documentation)

Google's American-spelling rule is dropped. This corpus writes British English.

[`commit-changes`](skills/commit-changes/SKILL.md) takes its formatting numbers,
and the reasons behind them, from the two canonical posts on the subject.

- [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) -
  Tim Pope, 2008. Where 50/72 comes from.
- [How to Write a Git Commit Message](https://cbea.ms/git-commit/) - Chris Beams,
  2014. The seven rules, and the "If applied, this commit will" test.