---
name: purge-slop
description: Purge Python slop, code that adds no value. Use when writing or refactoring Python, cleaning up code, when code is called hard to maintain or helper-heavy, or when the agent reaches for defensive type checks, fake tests, needless private helpers, wrappers around a library's own API, or missing and dishonest type hints.
---

# Purge slop

Slop is code that survives deletion with nothing lost. Optimize for reviewable,
maintainable code and cut everything that does not serve that.

## Rules to check

### Validate once, at the owner

- **No defensive type checking.** `isinstance` and `hasattr` are almost never
  needed. Assume the expected types and let a wrong one raise, since a crash
  beats a silent check that hides the bug.
- **A model, parser, reader or API schema that validated the data owns that
  contract.** Downstream code reads its fields directly. A re-check is slop even
  when spelled as a helper:

  ```python
  # slop: the parser already guaranteed this shape
  source = metadata.get("source")
  return source if isinstance(source, Mapping) else None

  # the whole helper
  source_id = record.metadata["source"]["id"]
  ```

  Re-validate only where a caller can hand over a partial or untrusted set, such
  as cross record checks over results you assembled. The same trust covers data
  your own code produces: a `frozen=True` dataclass or pydantic validator
  guarding a shape only your writer builds, and a `try`/`except` or `if`/`else`
  fallback chain around a file type, format or path your code produced, are
  re-checks in different clothes. `dict.get(key, default)` is a plain
  substitution and stays, and an `if`/`else` chain guarding the same lookup is
  the fallback in disguise. Contracts that are pydantic models defer to
  **pydantic-principles**.
- **A test must be able to fail.** A test that passes whatever the code does is
  slop. Mutation, mocks, missing edge cases and fixtures belong to
  **test-stickler**.

### Types are contracts

- **Annotate every signature**, parameters and returns, including `None`
  returns and private functions. Then keep them honest, since a type that
  widens what the code knows lies to the checker and the next reader. `Any` in a
  signature, `cast()`, `# type: ignore`, and `dict[str, Any]` standing in for a
  real model each discard a fact you had.
- **A widened collection or domain type is the same lie.**
  `Sequence[Sequence[object]]` for a `tuple[Row, ...]` the repo builds, or
  `Path | PurePosixPath` where neighbours take `Path`. Where the repo owns both
  sides, annotate the concrete type it enforces, match the neighbours, and alias
  a nested collection so the shape survives a glance. Abstract types earn a place
  at a public extension point, where several representations are the contract.

  ```python
  # slop: both signatures discard what the caller knew
  def summarise(item: Any) -> dict[str, Any]: ...
  def write_rows(rows: Sequence[Sequence[object]]) -> str: ...

  Row = tuple[object, ...]  # the caller freezes each row

  def summarise(item: Item) -> ItemSummary: ...
  def write_rows(rows: tuple[Row, ...]) -> str: ...
  ```

- **Keep the escape hatch where the type is unknowable**: untyped third party
  returns, dynamic dispatch, a real `object` boundary. Name the reason in a
  comment on the same line.
- **A `Protocol` or abstract stub body is `...`.** `raise NotImplementedError`
  defends against a call that cannot happen.
- **Annotate a local only when the right side hides the shape**: an unclear
  helper or factory return, or an empty, nested or branch dependent collection.
  `items: list[Item] = []` and `path: Path = Path(raw)` repeat what the right
  side and name already say, and an annotation that only repeats is slop.

### Names and wrappers

- **Privatize only what needs it.** Private methods belong inside a class for
  real internals. Standalone module functions default to importable, with no `_`
  prefix. Slop names ride along with the prefix: `_short`, `_handle`, `_in_kb`.
  Name the function for what it does (`truncate_title`, `handle_update`,
  `has_graph_node`).
- **A name that needs a comment is the wrong name.** One that reads "X but
  really Y" is worse, since the reader trusts it until it burns them. Rename the
  thing after what it holds. Use a plain phrase over a coined compound: `IDs the
  reader supplies` reads to every maintainer, and a coined term reads only to
  its writer.
- **Read the library's API before you wrap it.** A helper that renames, unwraps
  or forwards one native call is slop, so call the native operation:

  ```python
  # slop: Path already reads
  def read_file(path: Path) -> str:
      with path.open() as handle:
          return handle.read()

  text = path.read_text()
  ```

  A helper earns its name by owning what the library cannot: a multi step domain
  rule, an error or resource policy, an unstable third party contract pinned
  behind one name, or one operation shared by several callers. One caller, one
  return expression and no domain rule goes inline.

### Comments and docstrings

- **Comment the why, never the what the line already says.** Docstrings earn
  their place on complex logic, edge cases and non obvious decisions, and every
  function still gets a one line docstring for ruff format. Delete what you left
  behind: `print()`, `breakpoint()`, commented out code, `# TODO: implement`.
  Leave a human written docstring's voice alone and fix only the wrong line.
- **The function docstring rule stops at the function.** It says nothing about
  modules and packages, so match the neighbours before topping a file with
  `"""Retry helpers for the shared HTTP client contract."""`. Where they start
  at the imports, so does yours:

  ```python
  # slop: the filename and the imports already say this
  """Date parsing built on the standard library."""

  from datetime import datetime
  ```

  Keep a module docstring where tooling demands it (ruff `D100`, generated
  docs), where local style is consistent about it, or where the module carries a
  public contract its names cannot convey.
- **No `from __future__ import annotations`.**

Over engineering, speculative abstraction, reinvented stdlib and single use
helpers belong to **ponytail**.

## Match the neighbours

Every rule bends to the file it lands in. Before you add what the surrounding
code lacks, or cut what it has, read `AGENTS.md` and `CLAUDE.md` and open two
neighbouring modules. A file whose comment density, error handling, import style
or docstring habit differs from its neighbours reads as slop even when each
line defends itself.

This runs both ways. Consistency is no licence to spread a bad pattern, so when
you diverge, say what the neighbours do and why this file does not.

## When cleanup is not enough

Three or more helpers translating one contract, validating the same data, or
shuttling state between stages is one broken flow. Each helper reads as small,
so fixing them one at a time never lands. Stop editing helpers and trace the
flow: who owns the data, what transforms it, who consumes it. Put each rule with
its owner, and keep the top level function readable top to bottom.

```text
before:  metadata helper → fallback helper → ID helper → validator → grouping
after:   validate on load → group by owner ID → transform → emit pairs
```

The trigger is the shape, and the user's words: hard to maintain, helper heavy,
fragmented, hard to follow. Leave a module whose helpers are independent domain
operations that stand alone. The seam vocabulary comes from **codebase-design**.

## Scope: a diff you did not write

An agent wrote it and you are stripping its fingerprints before review. Scope to
`git diff main` and touch changed lines only.

- **Target the neighbours' style.** The rules describe what you would write from
  scratch, and the neighbours describe what belongs here.
- **Cut what the agent added on top**: comments the file would not carry,
  `try`/`except` the area does not use, a `cast()` or `# type: ignore` papering
  over a type problem, helpers called once, and any comment calling this
  branch's own code "legacy". Code the diff introduces or changes is current,
  even mid migration.
- **Keep the behaviour.** Fix a real bug you find and report it apart from the
  cleanup.
- **Edit surgically.** A rewrite belongs to "When cleanup is not enough", with
  the user's agreement first.
- **Report in two or three sentences**: what you removed, and anything you left
  because the neighbours do it too.

## Do not purge

Keep these even when they look defensive:

- **Input validation at trust boundaries**: API edges, user input,
  deserialization, config parsing, partial results from an external call.
- **Error handling that prevents data loss**: writes, migrations, transactions.
- **Security and auth checks.**

Removing a check on purpose is fine when the assumption is safe. When it is not
obvious, leave a short comment naming the assumption.

Defensiveness in the wrong place is its own slop. The common shape is safe
internal code wrapped in `try`/`except Exception` that only logs, while the
network call three lines down has no timeout and no retry. Move the handling
onto the call that can fail.

## Done when

Every file you touched is free of these patterns, or each exception is a
justified carve out. Then ask:

- Which trust boundary does each surviving check protect? A fact an upstream
  validated model guarantees goes.
- Can a maintainer read each main path top to bottom without a chain of single
  use helpers?
- Does each module docstring you added match the neighbours or the tooling?
- Is every signature annotated, and does every `Any`, `cast()` and
  `# type: ignore` name the reason it survived?
- Can a reviewer name the runtime collection from the annotation, and does every
  abstract one mark a caller who may pass its own?
- Did you read the API of every library object you wrapped, and does each
  surviving wrapper own a rule the library lacks?
- Has every symbol and return shape named for removal disappeared, with its
  callers and tests? A replacement added beside the original leaves both alive,
  which is the seam you were asked to close.
