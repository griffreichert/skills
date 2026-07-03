# g-skills

Personal agent skills library. Works across Claude Code, Codex, and other
coding agents via [vercel-labs/skills](https://github.com/vercel-labs/skills),
and can be uploaded directly as a Skill in claude.ai (zip the skill folder).

## Install

```bash
npx skills add griffinreichert/g-skills -g -a claude-code -a codex
```

(`-g` installs globally, available in every project/session; drop it to scope
to one repo.)

No CLI? Clone and symlink instead:

```bash
git clone https://github.com/griffinreichert/g-skills && ./g-skills/install.sh
```

## Update

Edit a `SKILL.md`, commit, push, then wherever it's installed:

```bash
npx skills update
```

## Skills

- [`write-clearly`](skills/write-clearly/SKILL.md) — cut writing to the bone.
  Clear, human, no AI slop.
- [`purge-slop`](skills/purge-slop/SKILL.md) — write Python without slop:
  no defensive checks, no fake tests, no needless private helpers.
- [`review-slop`](skills/review-slop/SKILL.md) — flag the same slop in a diff
  or PR as review comments, no edits.

## Adding a new skill

```bash
mkdir -p skills/<name> && npx skills init <name>
```

Or copy the structure of an existing skill folder. Each skill is a folder
under `skills/` with a `SKILL.md` (frontmatter: `name`, `description`) plus
any disclosed reference files it needs.

Then add its path to `.claude-plugin/plugin.json`. That file is the promotion
list — the CLI only installs skills listed there.
