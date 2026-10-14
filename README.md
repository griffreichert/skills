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
- [`explain-root-cause`](skills/explain-root-cause/SKILL.md) — a confirmed bug
  cause as an ordered chain, from the first changed contract to the exact
  failure, with a pinned primary source beside every link.

**Reporting**

- [`review-comments`](skills/review-comments/SKILL.md) — label and group findings
  as conventional comments: issue, todo, suggestion, quibble, praise. For a
  reader who must verify.

**Python hygiene**

- [`purge-slop`](skills/purge-slop/SKILL.md) — write Python without slop: no
  defensive checks, no re-validating what the owner already proved, no fake
  tests, honest type hints on every signature, no wrapper around what the
  library already does. Matches the file it lands in, and escalates a helper
  chain to the flow it hides. Has a scoped mode for stripping an agent's
  fingerprints off a diff.
- [`review-slop`](skills/review-slop/SKILL.md) — flag that same slop in a diff
  or PR as review comments, no edits. Switches to a priority report when the
  question is what to fix.
- [`test-stickler`](skills/test-stickler/SKILL.md) — audit pytest tests for the
  ones that cannot go red. Flags the smell by name, suggests the fix, names the
  missing edge cases. Reports as a priority list by default, or as a full
  evidence-backed audit on request.
- [`pydantic-principles`](skills/pydantic-principles/SKILL.md) — structure
  pydantic code so the library does the work: construction validates, settings
  own the knobs, contracts live at boundaries, the package's own model
  convention outranks the boundary test, and `frozen=True` earns its place with
  a bug.

**Shipping** — *the gate between written and submitted.*

- [`prove-it`](skills/prove-it/SKILL.md) — you ran it, you automated it, you
  reverted the change and watched the test go red, you named the edges. Hands
  back an evidence block that pastes into the MR.
- [`commit-changes`](skills/commit-changes/SKILL.md) — write a commit matching
  the repo's convention, split moves from edits, order providers before
  consumers, then commit it.
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

**Engineering principles** — *adapted from [pstack](NOTICE-pstack.md).*

- [`principles`](skills/principles/SKILL.md) — index of the 24
  `principle-*` skills with when each applies. Start here.
- The leaves, read on demand: [`principle-attack-the-premise`](skills/principle-attack-the-premise/SKILL.md), [`principle-boundary-discipline`](skills/principle-boundary-discipline/SKILL.md), [`principle-build-the-lever`](skills/principle-build-the-lever/SKILL.md), [`principle-encode-lessons-in-structure`](skills/principle-encode-lessons-in-structure/SKILL.md), [`principle-exhaust-the-design-space`](skills/principle-exhaust-the-design-space/SKILL.md), [`principle-experience-first`](skills/principle-experience-first/SKILL.md), [`principle-explain-the-number`](skills/principle-explain-the-number/SKILL.md), [`principle-fix-root-causes`](skills/principle-fix-root-causes/SKILL.md), [`principle-foundational-thinking`](skills/principle-foundational-thinking/SKILL.md), [`principle-guard-the-context-window`](skills/principle-guard-the-context-window/SKILL.md), [`principle-laziness-protocol`](skills/principle-laziness-protocol/SKILL.md), [`principle-make-operations-idempotent`](skills/principle-make-operations-idempotent/SKILL.md), [`principle-migrate-callers-then-delete-legacy-apis`](skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md), [`principle-minimize-reader-load`](skills/principle-minimize-reader-load/SKILL.md), [`principle-model-the-domain`](skills/principle-model-the-domain/SKILL.md), [`principle-never-block-on-the-human`](skills/principle-never-block-on-the-human/SKILL.md), [`principle-outcome-oriented-execution`](skills/principle-outcome-oriented-execution/SKILL.md), [`principle-prove-it-works`](skills/principle-prove-it-works/SKILL.md), [`principle-redesign-from-first-principles`](skills/principle-redesign-from-first-principles/SKILL.md), [`principle-separate-before-serializing-shared-state`](skills/principle-separate-before-serializing-shared-state/SKILL.md), [`principle-sequence-verifiable-units`](skills/principle-sequence-verifiable-units/SKILL.md), [`principle-subtract-before-you-add`](skills/principle-subtract-before-you-add/SKILL.md), [`principle-test-behavior-not-implementation`](skills/principle-test-behavior-not-implementation/SKILL.md), [`principle-type-system-discipline`](skills/principle-type-system-discipline/SKILL.md).
- [`how`](skills/how/SKILL.md) — explore a subsystem and explain how it works,
  with explorer and explainer subagents.
- [`architect`](skills/architect/SKILL.md) — sketch types and signatures with
  competing runners before code, then implement against the sketch.
- [`interrogate`](skills/interrogate/SKILL.md) — adversarial multi-model
  review that ends in a lead verdict.
- [`no-comments`](skills/no-comments/SKILL.md) — delete narration and
  workaround comments, then fix or encode what they were hiding.

**Skill upkeep**

- [`skill-ci`](skills/skill-ci/SKILL.md) — end of session, turn the friction you
  hit into a copyable blurb the skills-repo agent can implement. Evidence
  required, three proposals maximum, "nothing this session" allowed.
- [`harness-ci`](skills/harness-ci/SKILL.md) — end of session, turn the
  papercuts you hit (env vars, setup, failed commands, failed notes writes)
  into proposed `AGENTS.md`, `CLAUDE.md`, dotfiles, and skill edits. Project
  scope first, you decide what to apply and what to hand off.


## Inspiration

[Matt Pocock skills](https://github.com/mattpocock/skills) - incredible resource, very 
helpful while I have iterated on my own skills, if you do not use these you are missing
out!

[pstack](https://github.com/cursor/plugins/tree/main/pstack) by
[Lauren Tan (poteto)](https://github.com/poteto) - the engineering principles,
`how`, `architect`, `interrogate` and `no-comments` are adapted from it, and
[`write-technical-english`](skills/write-technical-english/SKILL.md) took its
mode picking and rhythm rules. The `poteto-mode` skill in that plugin shows how
the pieces fit together, and it is worth reading in full. MIT licensed, see
[NOTICE-pstack.md](NOTICE-pstack.md).

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