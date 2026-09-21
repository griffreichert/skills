---
name: harness-ci
description: End of session, turn the papercuts the agent hit into proposed edits to the project and global instructions, hooks, settings, dotfiles, and skills. Also harvests transcripts.
disable-model-invocation: true
---

# Harness CI

The harness is everything that shapes the agent before the work starts: the
project's `AGENTS.md` or `CLAUDE.md`, the global instructions, the hooks and
settings that enforce them, the scripts, and the skills. This skill improves
it from evidence and routes each finding to the file that owns it.

[`skill-ci`](../skill-ci/SKILL.md) owns the rules for skill proposals:
inventory, classes, and the handoff blurb. Run them whenever a finding traces
to a skill.

Most sessions have no finding worth a proposal. Report "nothing this session"
when that is true.

## Two modes

- **`/harness-ci`** reviews the session you are in. You are the only witness,
  so the evidence is what you can quote. Proposals go in chat and the user
  decides.
- **`/harness-ci harvest`** scans transcripts for evidence no one recorded.
  Cheap enough for a small model: hand it this file and a date range. Findings
  go to a note.

## Steps

### 1. Collect the evidence

Every finding carries its moment: the command or error as it appeared, the
attempt count, and the step that fixed it. For a correction, quote the user.
Session mode looks for:

- A command that failed before it worked.
- Setup found by trial: install, activate, start a service, export a variable.
- An env var, credential, or path that was missing or wrong.
- A notes vault write that failed or landed in the wrong place: path tried,
  error, path that worked.
- A permission prompt that blocked the flow.
- A skill that misfired, stayed silent, or was missing.
- A fact the user supplied that the repo could have supplied.
- A user correction of how the agent wrote or behaved.

Harvest mode lets the scanner find the moments and never opens a transcript
whole:

```bash
~/code/dot-g/claude/scripts/harness-scan.sh --since YYYY-MM-DD --agent all
```

Flags: `--since`, `--agent claude|codex|all`, `--project SLUG`. Output is TSV
of kind, agent, timestamp, transcript, assistant text, user reaction. A
`pushback` row is an assistant message the user answered with a complaint, and
it is strong evidence. A `pattern` row matches a construct banned in the global
instructions and has no reaction, so it counts only as a repeat: three hits
across different sessions make a tic. Discard pushback about the work itself,
such as a scope correction.

Done when every finding has a quoted moment, and any without one is dropped.

### 2. Check what is written

Read the project file, the global instructions, and any skill involved. Sort
each finding:

- **Absent.** A candidate.
- **Present and ignored.** Your miss. It becomes a proposal only when the
  wording misled you, and then the proposal is a rewording.
- **Present and wrong.** The proposal is a correction.

Done when every finding is sorted against the text of the files it touches.

### 3. Route each finding

Pick the narrowest home that catches the next occurrence. Project first.

| Finding                                       | Home                                   |
| --------------------------------------------- | -------------------------------------- |
| Setup, env vars, test command of one repo     | Project `AGENTS.md` or `CLAUDE.md`     |
| Would hit a second repo you can name          | Global instructions, a named section   |
| Permission, env, or hook wiring               | Settings or hooks                      |
| A command sequence the agent should run       | A script                               |
| Mechanically checkable in the final message   | A hook                                 |
| What a subagent is told                       | The subagent's prompt file             |
| A skill's body, or a skill that never fired   | The skills repo, as a `skill-ci` blurb |
| A prose tic with no rule yet                  | A harvest note, never the papercuts file |
| A variable or tool truly absent               | The user's machine, no file            |

A script or hook beats a written rule, since a rule depends on the agent
remembering it. Take the lowest structural rung that holds the fix: a clause,
then a bullet, then a section, then a new file.

**Codex parity.** A rule about how the agent talks, asks, or shapes a response
governs both agents. Name both instruction files or say why one is exempt.
Rules about Claude Code hooks, skills, or settings are Claude only.

Done when every finding has one home and one rung.

### 4. Cut to five

Rank by how often the next session will hit it and keep five, at most three of
them skill proposals. Keep findings with a concrete command, path, or value to
write down. A proposal that adds lines names the lines it replaces.

### 5. Report

Open with a provenance line: agent, session id or date range, and transcript
path (`~/.claude/projects/<project-slug>/<session-id>.jsonl` for Claude Code,
`~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl` for Codex).

Then, per proposal, numbered:

1. **The finding**, one sentence with the command, error, or correction quoted.
2. **The fix**, the exact text or command to paste, in the file's voice and
   run through `write-clearly`. For a skill: the target, the class, and the
   rule text.
3. **Where it goes**, file and scope, with one clause on why not the narrower
   home.
4. **Recommended disposition**: apply now or hand off, with the reason.

Session mode reports in chat. Harvest mode writes one note to
`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/G/g/projects/dot-g/harness-ci-YYYY-MM-DD.md`
with frontmatter `author`, `date`, and a `description` marking it unmerged, and
links it from the nearest `_index.md`. Prose tics go to
`g/projects/skills/papercuts-harvest-YYYY-MM-DD.md`, each as the fenced prose,
one or two lines on what is wrong, and the provenance. `papercuts.md` is append
only, and the user merges it.

Done when a reader can accept any proposal without asking what it says.

### 6. Let the user decide

Session mode only. Ask which proposals to apply here, then which of the rest to
hand off. The remainder is dropped.

- **Apply now.** Edit the file, show the diff, stop. Commit on request.
- **Hand off.** A skill proposal becomes a `skill-ci` step 5 blurb for the
  skills repo. Any other proposal takes the same shape addressed to the repo
  that owns the file: provenance line, the ask, the moment, the exact text, the
  file, and how to verify it took. The receiving agent has the repo and no
  memory.

Done when every proposal is applied, handed off, or dropped, and each handoff
stands alone.
