---
name: draft-git-commit
description: Draft a git commit title and body that match the repo's existing convention and explain why the change exists. Drafts the message only; does not commit.
disable-model-invocation: true
---

# Draft Git Commit

Draft a commit title and body for staged or described changes. Match the repo's
existing style. Explain why the change exists, not just what moved.

Draft the message only. Do not run `git commit`. Hand the text back for the user
to commit.

Use `write-clearly` and `write-technical-english` when available. The second one
governs the imperative form, the sentence length, and using one word per
concept. It waives its own article rule for the subject line.

## Steps

### 1. Detect the repo convention

Never assume a style. Read what the repo already does and match it.

- Check for commitizen or a commit-lint tool: look in `pyproject.toml`
  (`[tool.commitizen]`), `package.json` (`commitlint`, `commitizen`),
  `cz.toml`, `.cz.toml`, `.commitlintrc*`, or `.pre-commit-config.yaml`. If one
  enforces a format, follow it exactly.
- Otherwise infer from history: `git log --oneline -30`. Note the subject
  pattern, whether types are used (`feat:`, `fix:`), how issues are referenced
  (`ref #649`, `#649`, `(#635)`), casing, and mood (imperative vs past).

Common patterns you may find:

- Conventional Commits: `type(scope): summary`.
- Issue-ref style: `ref #<issue> <summary>`.
- Chore/version style: a fixed prefix like `no-ticket <summary>`.

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

### 3. Write the subject

One line, in the repo's detected template.

- Imperative mood if the repo uses it: "add", "fix", "move", not "added".
- Summarise the change, not the file list.
- Keep it short. Aim for 50 characters after any prefix; hard limit near 72.
- No trailing period.

Done when the subject reads as a single clear action in the repo's format.

### 4. Write the body only when it adds signal

Skip the body when the subject fully explains the change. A version bump or a
one-line rename needs no body.

Write a body when the change has a non-obvious why, a chosen trade-off, a
breaking change, or a subtle mechanism. Explain:

- why the change exists (the problem or trigger)
- how it works when the mechanism is not obvious
- what a reader would otherwise get wrong

Use prose for cause and effect. Use bullets only for parallel facts.

Done when the body answers the "why" the subject cannot carry.

### 5. Call out breaking changes

If the change alters a contract, renames or removes an interface, or breaks
behaviour a caller relied on, say so in the body. Follow the repo's convention
if it has one (for example a `BREAKING CHANGE:` footer under Conventional
Commits). State what breaks and the required migration.

Done when no breaking change is hidden.

## Formatting

- Blank line between subject and body.
- Wrap body lines at about 72 characters. Break long lines; do not let one line
  run the width of the terminal.
- Reference the issue the way the repo does, in the subject or a footer,
  matching detected style.

## Output shape

Return the message as text the user can paste or pass to `git commit`. Do not
commit it.

```text
<subject in repo's template>

<body, wrapped, only if it adds signal>
```

## Quality bar

Longer is not better. The best commit messages are short, clear, and to the
point while keeping the relevant detail. Deleting any sentence should lose
meaning; if it would not, the sentence is already gone.

- Match the repo's detected convention exactly. Consistency beats preference.
- Say why, not just what.
- Cut any sentence that only restates the subject.
- Wrap lines; no single long line.

## Done when

The subject matches the repo's format and states the change in one clear line.
The body, if present, explains why the change exists and flags any breaking
change. Nothing is committed.
