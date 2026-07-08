---
name: orient
description: Orient at the start of a session — read the handover notes, open issues, and working tree, then propose where to begin.
disable-model-invocation: true
---

# Orient

Pick up where the last session left off. This skill is **read-only** — it
gathers the fog-of-war away and proposes a plan; it writes nothing. The note
conventions live in
[`references/notes-workflow.md`](../daily-capture/references/notes-workflow.md);
read them for destination discovery, the vault/symlink layout, and the `_index`
map.

## Steps

### 1. Find the notes

Resolve the notes destination per the reference. If none is configured or the
folder can't be found, **ask the user to steer** — but still run steps 3–4 (git
and working tree orient you even without notes).

### 2. Read the handover

- Read `_index.md` at the notes-folder root as the map, then follow its links.
- Read the **most recent 1–2 daily notes**, weighted to **Open questions** and
  **Decisions** — that's where the last session left its thread and its *why*.
  **Done** is mostly stale; skim it.
- Read any active **project plan** the `_index` points to.

Never write or heal `_index.md` — reading only.

### 3. Pull open issues

If a git remote and `gh` are present, `gh issue list` for open issues. These are
small personal repos, so pull them all — but **cap at ~20**: past that, report
the count and the newest few rather than dumping every one. No remote or no
`gh` → skip silently.

### 4. Read the working tree

One line of ground truth: current branch, dirty state, unpushed commits
(`git status -sb`, `git log @{u}..`). "Where I left off" is often the
uncommitted diff itself.

### 5. Propose

Print an orientation **brief** in chat, then **stop and wait** — do not act, do
not enter plan mode:

- **Where you left off** — from Open questions + last Decisions + working tree.
- **Live threads** — from `_index`, the project plan, and open issues.
- **Proposed start** — 2–4 concrete, ranked next steps.

## Done when

The brief covers all three sections and ends with a ranked proposed start, and
the session waits for the user to pick — with nothing written to disk.
