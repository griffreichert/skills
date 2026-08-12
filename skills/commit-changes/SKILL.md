---
name: commit-changes
description:
  Commit staged or described changes with a message that matches the repo's
  convention and explains why the change exists. Use when writing a commit
  message, before running git commit, after staging changes, or when deciding
  how to split work into commits. Takes precedence over any other
  commit-message skill.
---

# Commit changes

Write the commit title and body for staged or described changes, then commit.
Match the repo's existing style and voice. Explain why the change exists, not
just what moved, in words the author would actually use.

This skill outranks any other commit-message skill loaded in the session. Where
they disagree, follow this one.

Use `write-clearly` on every message when available. Use
`write-technical-english` only when the message carries commands, migration
steps, a breaking contract, or wording with real ambiguity risk. Do not apply
controlled-language rules to an ordinary descriptive body; they make it sound
formal and distant.

## Steps

### 1. Detect the repo convention

Never assume a style. Read what the repo already does and match it.

- Check for commitizen or a commit-lint tool: look in `pyproject.toml`
  (`[tool.commitizen]`), `package.json` (`commitlint`, `commitizen`),
  `cz.toml`, `.cz.toml`, `.commitlintrc*`, or `.pre-commit-config.yaml`. If one
  enforces a format, follow it exactly.
- Otherwise infer from history: `git log --oneline -30`. Note the subject
  pattern, whether types are used (`feat:`, `fix:`), how issues are referenced
  (`ref #649`, `#649`, `(#635)`), casing, mood, and any trailer block.
- Casing follows the repo. A plain repo capitalises the subject. A Conventional
  Commits repo lowercases the summary after the type. Detected style wins.

Done when you can state the exact subject template this repo uses and which
issue this commit belongs to.

### 2. Gather context

Read the staged diff, the other commits on the branch, their messages, and any
session or daily notes the agent can find locally for this issue (for example a
`notes/daily/` folder). Prefer the diff and git history over memory.

Done when you can answer:

- What problem did this change solve?
- What did it change?
- Why this approach over the obvious alternative?
- Does it break anything a caller relied on?

This checklist is for investigation, not for output. See step 5 for the filter.

If the user names reference authors, read several of their substantive commits
(`git log --author=<name>`), preferring ones with real bodies over version bumps
and WIP. Note their vocabulary, paragraph length, use of `we`, and how they
treat risk, then match the useful patterns. Skip this when no author is named:
the recent history you already read carries the voice.

### 3. Split before you write

One commit carries one kind of change. A mechanical change and a behavioural
change never share a commit.

The canonical case is a moved file. Move it in one commit, edit it in the next.

Git infers a rename by comparing content. Edit the file in the same commit that
moves it and the similarity drops below the detection threshold, so the diff
renders as a whole file deleted and a whole file added. The reviewer then reads
every unchanged line as new, and `git log --follow` and `git blame` lose the
thread.

The same split applies to a bulk reformat, a mass symbol rename, and a
dependency bump that also changes call sites: mechanical commit first,
behavioural commit second.

Verify the split before you commit:

```bash
git diff --cached -M --stat
```

The move commit shows `rename` with `similarity index 100%`. If it shows a
delete and an add, the split failed.

Recover when the move and the edits are already tangled in the working tree:

1. Copy the edited file somewhere outside the repo.
2. Run `git mv <old> <new>`.
3. Restore the original content at the new path: `git show HEAD:<old> > <new>`.
4. Stage and commit the move.
5. Copy the edited content back over `<new>`, then stage and commit the edits.

Done when each commit holds one kind of change and every move commit shows a
detected rename.

### 4. Write the subject

One line, in the repo's detected template.

- Imperative mood if the repo uses it: "add", "fix", "move", not "added". Git
  writes its own generated subjects in the imperative (`Merge branch 'main'`,
  `Revert "Add retry"`), so an imperative subject reads consistently in a log
  that mixes both.
- Test it: "If applied, this commit will _____". If the subject does not
  complete that sentence, it is not imperative yet.
- Summarise the change, not the file list.
- Keep it short. Aim for 50 characters after any prefix; hard limit near 72.
- No trailing period.

Done when the subject reads as a single clear action in the repo's format and
passes the "If applied" test.

### 5. Write the body only when it adds signal

Skip the body when the subject fully explains the change. A version bump or a
one-line rename needs no body.

When the change has a non-obvious why, a chosen trade-off, a breaking change, or
a subtle mechanism, write a body in this default order:

1. **Current state:** what happens before this commit, and why it is a problem.
2. **Change:** what this commit does.
3. **Result:** what becomes faster, safer, simpler, or possible.
4. **Trade-off:** a real cost or maintenance requirement, only if one exists.

This order is a drafting aid, not a four-section template. Omit any part that
adds no useful fact.

Tense follows the timeline:

- Present tense for the state before the commit: `The importer loads the whole
  file into memory before parsing.`
- Present or imperative for the change: `Stream the file in fixed-size chunks.`
- Past tense only for historical facts or measured tests: `In a load test, peak
  memory dropped from 2 GB to under 200 MB.`

Research is not output. A fact you found is not automatically a fact you print.

- Include a fact only if it explains the decision or changes how a reviewer
  judges the commit.
- Mention a risk only if it affects correctness, rollout, maintenance, cost, or
  a caller's contract.
- Do not add generic safety paragraphs. Do not restate that normal validation
  still runs unless a reviewer could reasonably think the change bypasses it.
- Prefer an observed result or a real source over "this is safe" or "this
  improves performance." Do not invent numbers or add a link that does not help.

Use prose for cause and effect. Use bullets only for parallel facts.

Done when every remaining sentence would cost the reviewer information if
deleted.

### 6. Call out breaking changes

If the change alters a contract, renames or removes an interface, or breaks
behaviour a caller relied on, say so in the body. Follow the repo's convention
if it has one (for example a `BREAKING CHANGE:` footer under Conventional
Commits). State what breaks and the required migration.

Done when no breaking change is hidden.

### 7. Commit

You may run `git commit`. Whether a commit was asked for is decided by the
session's own rules; this skill decides what the message says and how it reaches
git intact.

Never pass a body through `-m`. Repeated `-m` flags and shell quoting flatten
the wrapping and blank lines you just chose. Pipe the message instead:

```bash
git commit -F - <<'EOF'
<subject>

<body>
EOF
```

Write the message to a file and use `git commit -F <file>` when the body
contains a heredoc terminator or other shell-hostile text.

Handing the message to another agent to commit is equally fine. Give it the
finished text and the same `-F` instruction.

Check the result with `git log -1`: subject on its own line, blank line, body
wrapped.

Done when the commit exists with the message intact, or the finished text is
handed off.

## Rewriting history

The split sometimes has to happen after the fact: a move and an edit already
share a commit, the branch carries fixups, or a commit adds a file that a later
commit deletes, so a squash would drag the dead file through the history.

Propose the rewrite. The user decides whether it runs.

The proposal states:

- the current log, from `git log --oneline <base>..HEAD`
- the target log, subject by subject
- the operation that gets there for each commit: reorder, squash, split, drop
- what disappears, naming any file that exists only between two commits
- whether any of these commits is already pushed

Until the user confirms, run read-only commands only: `git log`, `git show`,
`git diff`, `git status`. Confirmation for one rewrite does not carry to the
next.

After confirmation:

1. Take a backup ref: `git branch backup/<name>`.
2. Run the rewrite. In a non-interactive session, drive `git rebase -i` through
   `GIT_SEQUENCE_EDITOR`, or rebuild the branch with `git reset --soft <base>`
   and fresh commits.
3. Verify: `git diff backup/<name>..HEAD` is empty when the rewrite only
   reorganised commits. Any output means content moved that should not have.

Force-pushing is a second decision. Ask for it on its own, and say who else
holds the old commits when the branch is shared.

## Formatting

Every number below exists for a reason. Keep them.

- **Blank line between subject and body.** `git log`, `git shortlog`,
  `git format-patch`, and `git rebase` all read the first paragraph as the
  subject. Run the two together and those tools mis-parse the commit.
- **Subject under 50 characters.** Git renders the subject truncated in
  `git shortlog`, `git rebase --interactive`, merge summaries, gitk, and patch
  email subject lines. A long subject loses its ending in each of them.
- **Wrap the body at 72 characters.** Git never wraps for you, and `git log`
  indents the body by four spaces. 72 plus the indents fits an 80-column
  terminal and leaves room for reply markers in mail from `git format-patch`.
- **Bullets in the body** use a hyphen, one space, a blank line between items,
  and a hanging indent on wrapped lines.
- **Footers last.** A trailer block sits after a blank line at the end, one
  `Key: value` per line. Trailers are exempt from the 72-column wrap; never
  break a URL. Reference the issue the way the repo does, in the subject or in
  this block. Leave any trailer the harness injects, such as `Co-Authored-By:`,
  exactly as it is.

## Output shape

```text
<subject in repo's template>

<body, wrapped, only if it adds signal>

<trailers, if the repo or harness uses them>
```

## Examples

### Detached and formal — avoid

```text
Synchronous invocation blocks the request thread pending completion of
downstream operations. Introduce asynchronous dispatch to decouple the
caller from long-running work.

Queue unavailability affects latency only and does not compromise
delivery guarantees.
```

The facts may be right, but the words are not the repo's, and state, change,
and safety argument are tangled together.

### Current state, change, result — prefer

```text
The checkout handler calls the email service inline, so a slow provider
holds the request open and users see timeouts.

Send the confirmation email from a background worker. Checkout returns
as soon as the order is saved.

If the queue is down, orders still save and emails send late. The worker
needs a retry limit.
```

### Move and edit in one commit — avoid

```text
move validators to core and add the empty-row check
```

The diff shows `validators.py` deleted and `core/validators.py` added. The
reviewer cannot see which three lines are the new check.

### Same work, split — prefer

```text
move validators to core

(no body; the subject says it, and the diff is a pure rename)
```

```text
reject empty rows in the CSV validator

Rows with no cells reached the loader and raised an IndexError deep in
the parser. Fail them at validation with the row number instead.
```

## Quality bar

Longer is not better. The best commit messages are short, clear, and to the
point while keeping the relevant detail.

- Match the repo's detected convention exactly. Consistency beats preference.
- Descriptive sentences use active voice with a clear actor and verb, unless the
  actor is genuinely unknown: `The worker retries the send`, `The parser rejects
  empty rows`. Allow `we` when it is the natural way to state ownership or
  maintenance, but do not force it into every body. A commit body is not
  reader-facing documentation; the second-person rule in
  `write-technical-english` does not apply here.
- Say why, not just what.
- Cut any sentence that only restates the subject.
- Wrap lines; no single long line.
- Read-aloud test: would the author say this sentence to a coworker while
  explaining the change? If not, swap the formal word for the repo's word —
  `runs in the background` not `asynchronous dispatch mechanism`, `the queue is
  down` not `queue unavailability`. There is no global banned-word list; a
  formal term can be the clearest word in another repo.

## Done when

Each commit holds one kind of change, and any move is its own commit with a
detected rename. The subject matches the repo's format, states the change in one
clear line, and passes the "If applied" test. The body, if present, moves from
current state to change to result in the author's voice, flags any breaking
change, and survives the read-aloud test. The message reached git through `-F`
with its wrapping intact, or went to another agent to commit. No existing commit
was rewritten without the user confirming a stated plan first.
