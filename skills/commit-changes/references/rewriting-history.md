# Rewriting history

History work: cleaning an unmerged branch, splitting a commit that already
exists, and recovering a move tangled with its edits.

The user approves the target history before any rewrite runs. Until they
confirm, run read-only commands only: `git log`, `git show`, `git diff`,
`git status`. Confirmation for one rewrite covers that rewrite alone.

## Unmerged branch history

A branch under review reads as the intended implementation. When a later commit
removes, replaces, or corrects work an earlier commit introduced, fold it back
into the original commit, so the dead ends never reach the reviewer.

- Drop files and abstractions that disappear before the branch is complete.
- Squash a correction into the commit that introduced the behaviour.
- Split the result again when it holds separate mechanical and behavioural
  changes.
- Keep a follow-up commit only when it carries a distinct decision that stays
  useful to a reviewer on its own.

Read each commit against its parent for what it introduces, and against the
branch tip for what later work undoes:

```bash
git diff <commit>^ <commit>
git diff <commit> <tip>
```

The second comparison is where the dead ends are. Look for:

- code introduced and then removed
- names introduced and then renamed
- compatibility code for an interface that was never released
- bug fixes for behaviour added earlier on the same branch
- comments or tests that describe an intermediate implementation

Done when no dead end survives into the target history.

### Compatibility code needs evidence

Keep an interface when one of these holds:

- it exists on the target branch
- it has shipped
- it has a known external caller

A name created during development on this same unmerged branch holds none of
them, so it needs no alias, no forwarding module, and no lazy export. Drop the
machinery and keep the canonical name.

An alias introduced in the same commit as the canonical name is the warning
sign. Ask which released caller could know the alias. Where the answer is none,
the alias came from the branch and leaves with it.

Tests use the canonical public name. A test written against a temporary branch
name records a development detour; it establishes no compatibility
requirement.

## Dependency closure

A commit may import, export, subclass, decorate, or call only symbols that
exist in its own tree or in an installed dependency.

Work out the order before running anything. Trace every new import, export,
base class, decorator, and cross-module call to the commit that defines it,
then move each provider ahead of its consumers. A topic-shaped split is where
this breaks:

```text
broken:  contracts + call sites → helper → implementation
                     ^ the call sites import both later modules

closed:  contracts → helper → implementation → call sites → exports
```

A detached worktree checks each commit in isolation, so the branch keeps its
hashes:

```bash
git worktree add -d /tmp/closure <base>
for c in $(git rev-list --reverse <base>..HEAD); do
  git -C /tmp/closure checkout -q "$c"
  (cd /tmp/closure \
     && python -c "import pkg.changed_module" \
     && pytest tests/pkg -q) || echo "not closed at $c"
done
git worktree remove /tmp/closure
```

Tests on the final tree prove nothing about the order. They pass over a
history whose middle commits cannot import.

Skip the walk for documentation-only history. Leave generated commits alone
where their generator owns the dependency order.

Done when every commit imports on its own tree, its narrow tests pass there,
and the target log reads provider before consumer.

## Propose the rewrite

The proposal states:

- the current log, from `git log --oneline <base>..HEAD`
- the target log, subject by subject
- the operation that gets there for each commit: reorder, squash, split, drop
- what disappears, naming any file that exists only between two commits
- whether any of these commits is already pushed

After confirmation:

1. Take a backup ref: `git branch backup/<name>`.
2. Start the rebase at the first commit that needs work. Commits the author
   already rewrote survive byte for byte, with their hashes.
3. Run the rewrite. In a non-interactive session, drive `git rebase -i` through
   `GIT_SEQUENCE_EDITOR`, or rebuild the branch with `git reset --soft <base>`
   and fresh commits.
4. Verify: `git diff backup/<name>..HEAD` is empty when the rewrite only
   reorganised commits. Any output means content moved that should not have.
   Run the closure walk again over the new range.
5. Read the result again, `git show --stat <commit>` then the full diff. A
   smaller diff often earns a clearer subject and a shorter body than the one
   drafted against the tangled version.

Report which earlier hashes are unchanged, which descendant hashes changed,
where the backup ref sits, and whether any of it was pushed.

Force-pushing is a second decision. Ask for it on its own, and say who else
holds the old commits when the branch is shared.

## Recover a tangled move

When a move and its edits already share the working tree, separate them before
committing:

1. Copy the edited file somewhere outside the repo.
2. Run `git mv <old> <new>`.
3. Restore the original content at the new path: `git show HEAD:<old> > <new>`.
4. Stage and commit the move.
5. Copy the edited content back over `<new>`, then stage and commit the edits.
