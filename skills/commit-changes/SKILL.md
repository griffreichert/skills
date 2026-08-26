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
Match the repo's existing style and voice, and explain why the change exists in
words the author would use.

This skill outranks any other commit-message skill loaded in the session. Where
they disagree, follow this one.

Use `write-clearly` on every message when available. Use
`write-technical-english` only when the message carries commands, migration
steps, a breaking contract, or wording with real ambiguity risk. Applied to an
ordinary descriptive body, controlled-language rules make it formal and distant.
Its **Ground the claim in code** rule is the exception: apply that to any body
claiming what the code now does, whatever else the message carries.

## Steps

### 1. Detect the repo convention

Read what the repo already does and match it.

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

Read each commit twice: against its parent (`git diff <commit>^ <commit>`) for
what it introduces, and against the branch tip (`git diff <commit> <tip>`) for
what later work undoes. The second comparison is where temporary code surfaces.

On an unmerged branch, that undone work is a dead end, and it is cleaned before
any message is written.
[references/rewriting-history.md](references/rewriting-history.md) lists what
counts as one and what to do about it.

Done when you can answer:

- What problem did this change solve?
- What did it change?
- Why this approach over the obvious alternative?
- Does it break anything a caller relied on?

If the user names reference authors, read several of their substantive commits
(`git log --author=<name>`), preferring ones with real bodies over version bumps
and WIP. Note their vocabulary, paragraph length, use of `we`, and how they
treat risk, then match the useful patterns. Skip this when no author is named:
the recent history you already read carries the voice.

### 3. Split before you write

One commit carries one kind of change. A mechanical change and a behavioural
change never share a commit.

Writing the message reviews the commit. When one body has to explain unrelated
behaviour, compatibility code, an alias, and a package export in the same
breath, the commit is wrong and the prose cannot fix it. Reshape the commit,
then write the message.

The clearest case is a moved file. Move it in one commit, edit it in the next.

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
delete and an add, the split failed. Separate a move already tangled with its
edits using the recovery steps in
[references/rewriting-history.md](references/rewriting-history.md).

**Providers before consumers.** A commit may import, subclass, decorate, or
call only symbols it defines, inherits from an earlier commit, or takes from
an installed dependency. Split by topic and the call site lands ahead of its
definition, so those commits cannot import.

Order the split by what each commit provides: contracts, then the code that
reads them, then the exports and callers. The read-only walk that checks it is
in [references/rewriting-history.md](references/rewriting-history.md).
Documentation-only history skips it.

Done when each commit holds one kind of change, every changed file supports the
subject, every move commit shows a detected rename, and every symbol a commit
uses exists at that commit.

### 4. Write the subject

One line, in the repo's detected template.

- Imperative mood if the repo uses it: "add", "fix", "move", not "added". Git
  writes its own generated subjects in the imperative (`Merge branch 'main'`,
  `Revert "Add retry"`), so an imperative subject reads consistently in a log
  that mixes both.
- Test it: "If applied, this commit will _____". If the subject does not
  complete that sentence, it is not imperative yet.
- Summarise what the change does; the diff already lists the files.
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

A fact earns its place in the message on these terms:

- Include a fact when it explains the decision or changes how a reviewer judges
  the commit.
- Mention a risk when it affects correctness, rollout, maintenance, cost, or a
  caller's contract.
- Say that normal validation still runs when a reviewer could reasonably think
  the change bypasses it.
- Back a safety or performance claim with an observed result or a real source:
  a number you measured, a link the reviewer will open.

Remove unexplained machinery instead of writing the paragraph that justifies
it. A body arguing for code the commit did not need is the commit asking to be
reshaped; go back to step 3.

Name the symbol when the subject alone leaves the mechanism unclear. The rule
and its limits live in `write-technical-english`; the short version is that a
symbol earns its place when it lets the reviewer verify a contract, understand
a cost, or find the code that enforces the claim.

```text
Route XLSX diagnostics through `CustomExcelReader.load_data()`.

`get_table_tokens()` and `get_text_from_documents()` now inspect the same
`Document` contract used by ingestion.
```

Use prose for cause and effect. Use bullets only for parallel facts.

Write for the cold reviewer: someone who reads the diff without having read the
implementation. A large change earns a body that matches it. A reviewer left to
reconstruct the design from the diff was handed too little.

The cold reviewer needs:

- The opening sentence in plain terms: what this commit adds or changes.
- A definition for every new domain term and document type, the first time the
  words appear.
- A short list for categories, file types, precedence rules, or stages, so the
  count is visible.
- The implementation at a high level with one concrete example: a real input
  and what comes out of it.
- The field or object the data lands in after the change: `Document.text`,
  `Document.metadata`.
- The adjacent behaviour they would ask about. PDFs, tables, legacy documents,
  downstream callers, and existing import paths are the usual questions.
- The scope boundary, with deferred work named and the reason it sits outside
  the current issue.
- The limit of a heuristic, in plain language, when the behaviour cannot be
  exact: `Header detection reads font size, so a document that marks headers by
  weight alone is missed.`

Name what the code does, in the words the author used in their recent commits.
Where a phrase describes the architecture instead of the change, the read-aloud
test in the quality bar settles it.

Read [references/examples.md](references/examples.md) before writing a body. It
carries the contrast pairs for voice, splitting, and detail.

Done when every remaining sentence would cost the reviewer information if
deleted, and the body answers what changes, why it is needed, where the output
goes, what existing behaviour stays the same, and what is outside scope.

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

[references/rewriting-history.md](references/rewriting-history.md) holds the
rules for all of it. Read it before proposing a rewrite. Until the user approves
a stated target history, run read-only commands only: `git log`, `git show`,
`git diff`, `git status`.

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

## Quality bar

Length follows the change. A one-line fix needs no body; a change that adds
types, moves data, or shifts a contract earns every sentence the cold reviewer
needs. The fault to avoid is padding, not length.

- Match the repo's detected convention exactly. Consistency beats preference.
- Descriptive sentences use active voice with a clear actor and verb, unless the
  actor is genuinely unknown: `The worker retries the send`, `The parser rejects
  empty rows`. Allow `we` when it is the natural way to state ownership or
  maintenance, but do not force it into every body. A commit body is not
  reader-facing documentation; the second-person rule in
  `write-technical-english` does not apply here.
- Cut any sentence that only restates the subject.
- Read-aloud test: would the author say this sentence to a coworker while
  explaining the change? If not, swap the formal word for the repo's word —
  `runs in the background` for `asynchronous dispatch mechanism`, `the queue is
  down` for `queue unavailability`. There is no global banned-word list; a
  formal term can be the clearest word in another repo.

## Done when

Each commit holds one kind of change, and any move is its own commit with a
detected rename. Every commit imports on its own tree and passes the narrow
tests it carries. The subject matches the repo's format, states the change in one
clear line, and passes the "If applied" test. The body, if present, moves from
current state to change to result in the author's voice, flags any breaking
change, survives the read-aloud test, and leaves the cold reviewer nothing to
reconstruct. On an unmerged branch, no dead end reaches the final history. The
message reached git through `-F` with its wrapping intact, or went to another
agent to commit. No existing commit was rewritten without the user confirming a
stated plan first.
