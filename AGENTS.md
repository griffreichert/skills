# Working on this repo

Skills for Claude Code and Codex. Each one lives in `skills/<name>/SKILL.md`
with YAML frontmatter, and every skill is listed in
`.claude-plugin/plugin.json`.

## Implementing a skill-ci blurb

A blurb is a proposal written by a session that had the failure and not the
repo. The repo is the authority. Before editing:

- **Confirm this repo owns the target.** A skill named in a `defer to` line can
  be a third-party plugin, where an edit dies at the next version bump. Run
  `ls skills/<name>` first. Where the repo does not own it, re-home the rule in
  the local skill that defers to it, and say you moved it.
- **Take the lowest structural rung that holds the rule.** A clause in an
  existing rule, then a bullet, then a section, then a numbered step, then a
  reference file, then a new skill. A new numbered step renumbers every step
  after it. A new skill adds a sync burden across its callers and the README.
- **Generalise the example.** The blurb carries the session's names so its
  claim can be checked. The file gets names a stranger recognises. Examples
  here run on one domain: a resumable file upload, the parts that store slices
  of it, a manifest, a checksum.
- **Run the shipping lines through `write-clearly`.** Blurbs arrive in report
  register. The file is not a report.
- **Price the addition.** A rule that needs a second code block in one bullet
  is two rules, or one rule written twice. Merge the example into the block
  that is already there, or split the bullet. Name what the addition replaces.

Report what you moved and why, then run `python3 check.py`.

## check.py

`python3 check.py` enforces what this file can only ask for. It fails on a
skill missing from `plugin.json` or `README.md`, broken frontmatter, a retired
example name, two code blocks in one bullet, and a bullet over 250 words. It
warns on the prose patterns `write-clearly` bans and leaves the call to you,
since the skill budgets one deliberate contrast.

Retiring an example domain means adding its names to `RETIRED` in that file,
so the next session cannot reintroduce them.

## Conventions

- Prose wraps at 80 (`.prettierrc.json`). Some files are written as long
  single-line bullets instead. Match the file you are editing.
- A new skill takes three edits: `skills/<name>/SKILL.md`, an entry in
  `.claude-plugin/plugin.json`, and a line in `README.md`.
- `purge-slop` is the single source of truth for the Python rules.
  `review-slop` restates its summary and `test-stickler` owns anything
  test-shaped, so one rule change usually means three files.
- `notes/` is gitignored. Decisions go there and never reach a commit.
