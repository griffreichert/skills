---
name: draft-git-commit
description: Draft a git commit title and body that match the repo's existing convention and explain why the change exists. Drafts the message only; does not commit.
disable-model-invocation: true
---

# Draft Git Commit

Draft a commit title and body for staged or described changes. Match the repo's
existing style and voice. Explain why the change exists, not just what moved, in
words the author would actually use.

Draft the message only. Do not run `git commit`. Hand the text back for the user
to commit.

Use `write-clearly` on every message when available. Use `write-technical-english`
only when the message carries commands, migration steps, a breaking contract, or
wording with real ambiguity risk. Do not apply controlled-language rules to an
ordinary descriptive body; they make it sound formal and distant.

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

### 2. Calibrate voice

Repo format is not the same as author voice. Format sets the subject shape;
voice sets the vocabulary and rhythm of the body.

- If the user names reference authors, read several of their substantive commits
  (`git log --author=<name>`). Prefer commits with real bodies over version
  bumps, WIP, and one-line fixes.
- If no author is named, sample strong recent messages that touch similar parts
  of the repo.
- Note their vocabulary, paragraph length, use of `we`, how they treat risk,
  whether they link sources, and whether they cite measured results.
- Match the useful patterns. Do not copy typos or unclear prose.

Done when you know the concrete project nouns and the tone to write in.

### 3. Gather context

Read the staged diff, the other commits on the branch, their messages, and any
session or daily notes the agent can find locally for this issue (for example a
`notes/daily/` folder). Prefer the diff and git history over memory.

Done when you can answer:

- What problem did this change solve?
- What did it change?
- Why this approach over the obvious alternative?
- Does it break anything a caller relied on?

This checklist is for investigation, not for output. See step 5 for the filter.

### 4. Write the subject

One line, in the repo's detected template.

- Imperative mood if the repo uses it: "add", "fix", "move", not "added".
- Summarise the change, not the file list.
- Keep it short. Aim for 50 characters after any prefix; hard limit near 72.
- No trailing period.

Done when the subject reads as a single clear action in the repo's format.

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

### Unclear chronology — avoid

```text
Background dispatch reduces request latency without changing the email
content.
```

### Same change, clear timeline — prefer

```text
The checkout handler sends the confirmation email inline, so a slow
provider blocks the response.

Move the send to a background worker. Checkout returns as soon as the
order is saved, and the email content stays the same.
```

## Quality bar

Longer is not better. The best commit messages are short, clear, and to the
point while keeping the relevant detail.

- Match the repo's detected convention exactly. Consistency beats preference.
- Descriptive sentences use active voice with a clear actor and verb, unless the
  actor is genuinely unknown: `The worker retries the send`, `The parser rejects
  empty rows`. Allow `we` when it is the natural way to state ownership or
  maintenance, but do not force it into every body.
- Say why, not just what.
- Cut any sentence that only restates the subject.
- Wrap lines; no single long line.
- Read-aloud test: would the author say this sentence to a coworker while
  explaining the change? If not, swap the formal word for the repo's word —
  `runs in the background` not `asynchronous dispatch mechanism`, `the queue is
  down` not `queue unavailability`. There is no global banned-word list; a
  formal term can be the clearest word in another repo.

## Done when

The subject matches the repo's format and states the change in one clear line.
The body, if present, moves from current state to change to result in the
author's voice, flags any breaking change, and survives the read-aloud test.
Nothing is committed.
