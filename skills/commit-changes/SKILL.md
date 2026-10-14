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
Match the repo's style and voice, and explain why the change exists in words the
author would use. This skill outranks any other commit-message skill in the
session.

Two checks gate every commit, and step 7 holds the scripts: the body wraps at
72 characters, and the repo's pre-commit hooks run when it has them.

Apply `write-clearly` to every message. Apply `write-technical-english` only
when the message carries commands, migration steps, a breaking contract, or
real ambiguity risk, because its controlled language makes an ordinary body
formal and distant. Its **Ground the claim in code** rule always applies to a
body that claims what the code now does.

## Steps

### 1. Detect the repo convention

- A commitizen or commit lint config (`pyproject.toml` `[tool.commitizen]`,
  `package.json` `commitlint`/`commitizen`, `cz.toml`, `.cz.toml`,
  `.commitlintrc*`, `.pre-commit-config.yaml`) that enforces a format wins.
  Follow it exactly.
- Otherwise read `git log --oneline -30` for the subject pattern, types
  (`feat:`, `fix:`), issue references (`ref #649`, `#649`, `(#635)`), casing,
  mood, and trailers. A plain repo capitalises the subject. A Conventional
  Commits repo lowercases the summary after the type.

Done when you can state the exact subject template and the issue this commit
belongs to.

### 2. Gather context

Read the staged diff, the other commits on the branch with their messages, and
any local session or daily notes for this issue (such as `notes/daily/`). The
diff and history outrank memory.

Read each commit twice. `git diff <commit>^ <commit>` shows what it introduces.
`git diff <commit> <tip>` shows what later work undoes, which is where temporary
code surfaces. Undone work on an unmerged branch is a dead end, cleaned before
any message is written. [references/rewriting-history.md](references/rewriting-history.md)
lists what counts as one.

If the user names reference authors, read several of their substantive commits
(`git log --author=<name>`), skipping version bumps and WIP. Note vocabulary,
paragraph length, use of `we`, and treatment of risk, then match them. With no
author named, the recent history carries the voice.

Done when you can answer: what problem this solves, what it changed, why this
approach over the obvious alternative, and whether it breaks anything a caller
relied on.

### 3. Split before you write

One commit carries one kind of change. A mechanical change and a behavioural
change never share a commit. Writing the message reviews the commit: when one
body has to explain unrelated behaviour, compatibility code, an alias, and an
export together, the commit is wrong and prose cannot fix it. Reshape the
commit, then write.

**Move, then edit.** Git infers a rename from content similarity. Editing a file
in the commit that moves it drops similarity below the threshold, so the diff
shows a whole file deleted and a whole file added, and `git log --follow` and
`git blame` lose the thread. A bulk reformat, a mass symbol rename, and a
dependency bump that also changes call sites split the same way: mechanical
commit first, behavioural commit second.

Check before committing:

```bash
git diff --cached -M --stat
```

A move commit shows `rename` with `similarity index 100%`. A delete plus an add
means the split failed. [references/rewriting-history.md](references/rewriting-history.md)
holds the steps for a tangled move.

**Providers before consumers.** A commit may import, subclass, decorate, or call
only symbols it defines, inherits from an earlier commit, or takes from an
installed dependency. Order the split by what each commit provides: contracts,
then the code that reads them, then exports and callers. The read only walk that
checks it is in the same reference. Documentation only history skips it.

Done when each commit holds one kind of change, every changed file supports the
subject, every move shows a detected rename, and every symbol a commit uses
exists at that commit.

### 4. Write the subject

One line, in the repo's template.

- Imperative if the repo uses it ("add", "fix", "move"), matching the subjects
  git generates (`Merge branch 'main'`, `Revert "Add retry"`). The test: the
  subject completes "If applied, this commit will _____".
- Say what the change does. The diff lists the files.
- About 50 characters after any prefix, 72 at the limit. No trailing period.

Done when the subject reads as one clear action in the repo's format and passes
the "If applied" test.

### 5. Write the body only when it adds signal

A version bump or one line rename needs no body.

**Cold reviewer bar.** A reviewer with no code context must understand the
problem, change, result, and scope from the body alone. Open with the commit's
overall goal, in terms a user or operator would recognise, since a small symptom
or implementation detail cannot carry that opening. Name preserved behaviour
when a reviewer could ask whether it changed. The body states the intent first,
and the diff confirms how the code implements it.

Default shape, for every commit that needs a body including a reword, matching
the author's recent length and vocabulary:

```text
<subject>

<goal>. <problem>. <change/result>.
```

Add detail only for a real behaviour boundary, a test result, or a migration
step. Name a symbol only when the reviewer needs the exact contract, seam,
migration, or risk. A list of internal functions with no user visible reason is
jargon the reader does not need.

Shapes beyond the default:

- **Ordered operations.** When order affects the result (request flows,
  migrations, retries, persistence, lifecycle, API contracts), state the
  problem, then `Apply the change in this order:` with a numbered list, then the
  result and scope boundary. A one line fix, pure rename, formatting change, or
  mechanical change keeps the default shape with no list.
- **Non trivial test commit.** A subject naming only mechanics ("check X
  survives Y") reads as generated. State the behaviour under protection and the
  change that put it at risk, what the test change asserts, and any retained
  compatibility case. Applies to dependency upgrades, changed expectations,
  replaced fixtures, and compatibility tests. A one line assertion whose subject
  already names the contract skips it. A cold reviewer can name the protected
  behaviour, why the test changed, and the legacy case still covered.
- **Escalated body.** A breaking contract, data migration, operational risk, or
  new domain concepts the diff will not teach follow the drafting order in
  [references/body-detail.md](references/body-detail.md), which also holds what
  earns a fact a place.

[references/examples.md](references/examples.md) carries the contrast pairs for
voice, splitting, detail, ordered operations and the test shape. Read it before
writing a body.

Tense follows the timeline: present for the state before the commit (`The
importer loads the whole file into memory before parsing.`), present or
imperative for the change (`Stream the file in fixed size chunks.`), past only
for historical facts or measured tests (`In a load test, peak memory dropped
from 2 GB to under 200 MB.`).

Use prose for cause and effect, a numbered list for ordered operations, and
bullets for parallel facts only. Remove unexplained machinery rather than write
the paragraph that justifies it: a body arguing for code the commit did not need
means the commit needs reshaping, so go back to step 3.

Done when a cold reviewer can reconstruct the changed flow from the body, every
sentence would cost that reviewer information if deleted, and the body answers
what changes, why, where the output goes, what existing behaviour stays, and
what is out of scope.

### 6. Call out breaking changes

A change that alters a contract, renames or removes an interface, or breaks
behaviour a caller relied on says so in the body, in the repo's convention (for
example a `BREAKING CHANGE:` footer under Conventional Commits). State what
breaks and the migration.

Done when no breaking change is hidden.

### 7. Commit

You may run `git commit`. The session's own rules decide whether a commit was
asked for. This skill decides what the message says and how it reaches git
intact.

1. Write the message to a file.
2. Run `<skill-dir>/scripts/check_wrap.py <message-file>`, fix every line it
   reports, and recheck. The scripts sit in `scripts/` beside this file, so call
   them by that path whichever agent loaded the skill. A script owns the count
   because eyeballing 72 characters has been the recurring miss.
3. When the repo has a `.pre-commit-config.yaml`, run
   `<skill-dir>/scripts/run_pre_commit.sh` against the staged files. `pre-commit
   run` fires hooks, and `git commit` does not unless `pre-commit install` wired
   one into this clone. The script finds `pre-commit` or `prek` on PATH, then in
   `.venv/bin`, then via `uv.lock` after `uv sync`, and names what to install
   when none exist. Fix what it flags and re-stage. An installed hook runs
   again on `git commit`, which is harmless.
4. Commit with `git commit -F <message-file>`. Repeated `-m` flags and shell
   quoting flatten the wrapping and blank lines, so a body never goes through
   `-m`.
5. Check `git log -1`: subject on its own line, blank line, wrapped body.

To hand the commit to another agent, give it the finished text, the `-F`
instruction, and both scripts to run first.

Done when `check_wrap.py` reports nothing, the hooks passed or the repo has
none, and the commit exists with the message intact, or the text is handed off.

## Rewriting history

A split sometimes has to happen after the fact: a move and an edit share a
commit, the branch carries fixups, or a commit adds a file a later commit
deletes so a squash would drag the dead file through history.
[references/rewriting-history.md](references/rewriting-history.md) holds the
rules, and you read it before proposing a rewrite. Until the user approves a
stated target history, run read only commands: `git log`, `git show`,
`git diff`, `git status`.

## Format

Every number has a reason. Keep them.

- **Blank line between subject and body.** `git log`, `shortlog`,
  `format-patch`, and `rebase` read the first paragraph as the subject, so
  running them together mis-parses the commit.
- **Subject under 50 characters.** `git shortlog`, `rebase --interactive`, merge
  summaries, gitk, and patch email subjects truncate longer ones.
- **Body wrapped at 72.** Git never wraps, and `git log` indents the body four
  spaces. 72 plus the indent fits 80 columns and leaves room for reply markers
  in `format-patch` mail.
- **Bullets** use a hyphen, one space, a blank line between items, and a hanging
  indent on wrapped lines.
- **Footers last.** One `Key: value` per line after a blank line, exempt from
  the wrap, with URLs never broken. Reference the issue the way the repo does,
  in the subject or here. Leave harness trailers such as `Co-Authored-By:`
  exactly as injected.

```text
<subject in repo's template>

<body, wrapped, only if it adds signal>

<trailers, if the repo or harness uses them>
```

## Quality bar

- Length follows the change. A one line fix needs no body, and a contract shift
  earns every sentence step 5 demands. Padding is the fault, and length is not.
- Match the repo's detected convention exactly. Consistency beats preference.
- Descriptive sentences are active with a clear actor: `The worker retries the
  send`, `The parser rejects empty rows`. `we` is fine for ownership or
  maintenance. A commit body is not reader facing documentation, so the second
  person rule in `write-technical-english` does not apply.
- Cut any sentence that only restates the subject.
- **Read aloud test.** Would the author say this sentence to a coworker? If not,
  swap the formal word for the repo's: `runs in the background` for
  `asynchronous dispatch mechanism`, `the queue is down` for `queue
  unavailability`. No global banned word list exists, since a formal term can be
  the clearest word in another repo.

## Done when

Every step's done condition holds and the message reached git through `-F` or
went to another agent to commit. No existing commit was rewritten without the
user confirming a stated plan first.
