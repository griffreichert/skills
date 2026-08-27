---
name: skill-ci
description: Continuous improvement for the skills themselves. At the end of a session, turn the friction you hit into a copyable blurb the skills-repo agent can implement. Use when the user asks whether the skills used this session need tweaks, or whether a new skill is missing.
disable-model-invocation: true
---

# Skill CI

End-of-session review of the *skills*, not the work. You produce one thing: a
blurb, in a fenced block, that another agent can paste into the skills repo and
implement without this session's context.

You are the only witness to what went wrong. The implementing agent has the
repo and no memory. So the blurb must carry its own evidence.

**Most sessions warrant no blurb.** An agent asked "any improvements?" will
always find some, because it wants to be useful. That instinct is the failure
mode this skill exists to resist. Say "nothing this session" and stop.

## Steps

### 1. Inventory the skills

List every skill that touched this session, in three buckets:

- **Fired** — invoked, and shaped output.
- **Should have fired** — existed, was relevant, never came up.
- **Absent** — no skill covered the work at all.

The buckets are not cosmetic. They point at different edits: the body, the
`description:` frontmatter, and a new skill respectively.

### 2. Find the evidence

For each candidate, name the moment. A candidate without a moment is not a
candidate.

- The **instruction**: what the skill told you, quoted or cited by line.
- The **output**: what you produced under it.
- The **correction**: what the user said, quoted verbatim where you have it.

A user correction is the strongest signal in the session. An improvement you
thought of unprompted, with no moment behind it, is speculation. Drop it.

### 3. Classify the gap

Each class edits something different. Getting this wrong sends the implementing
agent to the wrong file.

| Class            | What happened                                | Edit target                |
| ---------------- | -------------------------------------------- | -------------------------- |
| **Wrong rule**   | Skill said X, X was bad advice here          | the rule                   |
| **Missing rule** | Skill applied fine, this case wasn't covered | new rule in body           |
| **Unclear rule** | Rule was right, you misread it               | wording of the rule        |
| **Didn't fire**  | Skill was relevant, never triggered          | `description:` frontmatter |
| **No skill**     | Nothing covered this, you improvised         | new skill                  |
| **Wrong home**   | Rule belongs in a skill it isn't in          | move or cross-reference    |

Two skills hitting the same friction means one shared rule plus two invocations,
not the rule copied twice.

### 4. Filter hard

Cap at **three** proposals. Hitting the cap means choosing, not appending.

Drop:

- One-off preferences, phrased as if general.
- Rules the skill already states, that you failed to apply. That's a you
  problem, unless the wording caused it, which is *unclear rule*.
- "Add more examples." Examples earn their place by fixing a named failure.
- Anything you cannot attach to step 2's evidence.

Growth is a cost. A proposal that adds lines should name the lines it replaces,
or justify the growth against what the skill already does.

### 5. Write the blurb

Open the report with one provenance line: which agent ran the session
(`claude`, `codex`, whichever harness), its session id, and the transcript
path. Claude Code writes it to
`~/.claude/projects/<project-slug>/<session-id>.jsonl`. The implementing agent
reads the source session when a blurb is thin, and without the path it has to
take every quoted moment on trust.

One fenced `text` block per proposal, self-contained, addressed to the
implementing agent. Above the fence, one line of your own naming the target
skill and the class from step 3.

Inside the fence, in this order:

1. **The ask.** One sentence: which skill, what kind of change.
2. **The observed failure.** The real moment. Quote the output that was wrong
   and the correction. Keep the domain detail, it's what makes the rule
   concrete.
3. **The rule**, stated narrowly. Narrow enough that a reader can tell when it
   does *not* apply.
4. **The shape**, if the rule has one. A sentence pattern or a template.
5. **A worked example.** Before and after, drawn from step 2's real moment,
   then stripped of it. The blurb keeps the session's names so the reader can
   check the claim. The lines that land in the skill use names a stranger
   would recognise, since a rule illustrated with one library or one repo's
   modules fires again only when that session repeats.
6. **When it applies.** The specific triggers. A list of seams, verbs, or
   conditions beats "when relevant".
7. **The scope guard.** When to *not* apply it. Every rule over-applied becomes
   noise, and the implementing agent cannot see that boundary from the repo.
8. **The completion check.** Questions the skill's own "done when" can absorb.
9. **Placement.** Which file the rule lives in, which skills invoke it, whether
   the `description:` needs to change too. Take the smallest structure that
   holds the rule: a clause in an existing rule, then a bullet, then a section,
   then a numbered step, then a reference file, then a new skill. Name the rung
   you picked and why the one below it fails. Flag any skill you have not
   opened this session, since a name you know only from a `defer to` line may
   live outside the repo.

Write the blurb in the target skill's voice, not as a report about it. The
implementing agent should be able to lift the rule straight into the file, and
should have to generalise nothing but the example.

New-skill proposals carry the same nine, plus a proposed `name:`, a
`description:` written to fire on the right sessions, and the reason it isn't a
section inside an existing skill.

## Done when

The report names the agent, session id, and transcript path it came from. Every
proposal traces to a quoted moment from this session, carries its class and its
edit target, and reads as a standalone brief to an agent with the repo and no
context. Or you reported that nothing this session warranted one.
