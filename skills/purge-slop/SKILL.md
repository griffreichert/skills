---
name: purge-slop
description: Purge Python slop — code that adds no value. Use when writing or refactoring Python, cleaning up code, when code is called hard to maintain or helper-heavy, or when the agent reaches for defensive type checks, fake tests, needless private helpers, wrappers around a library's own API, or missing and dishonest type hints.
---

# Purge slop

Slop is code that adds no value: it survives deletion with nothing lost. Optimize for reviewable, maintainable code — cut everything that doesn't serve that.

## Rules to check

- **No defensive type-checking.** `isinstance`/`hasattr` are almost never needed. Assume the types you expect and let it error when they're wrong. A wrong-attribute crash is better than a silent check that hides the bug.
- **Validate once, at the owner.** A model, parser, reader, or API schema that already validated the data owns that contract. Downstream code reads its fields directly and trusts them. Re-checking is slop even when the check is spelled as a helper:

  ```python
  # slop — the reader already guaranteed this shape
  table = metadata.get("table")
  return table if isinstance(table, Mapping) else None

  # the whole helper
  table_id = node.metadata["table"]["id"]
  ```

  Re-validate only where a caller can hand you a partial or untrusted set: cross-record checks over results you assembled yourself. A fact an upstream model already proved needs no second proof. For contracts that are pydantic models, defer to the **pydantic-principles** skill.
- **A test must be able to fail.** A test that passes no matter what the code does is slop. Defer to the **test-stickler** skill for anything test-shaped — mutation, mocks, missing edge cases, fixtures — that's its job, not this one.
- **Don't over-privatize.** Private methods only inside a class, for genuine internals. Standalone module functions don't need a `_` prefix — default to importable. Slop names ride along with the prefix: `_short`, `_handle`, `_in_kb` say nothing — name the function for what it does (`truncate_title`, `handle_update`, `has_graph_node`).
- **Types are contracts. Write them, and don't fake them.** Every signature gets parameter and return annotations, including `None` returns and private functions. Then keep them honest: a type that widens what the code already knows is a lie to the checker and to the next reader. `Any` in a signature, a `cast()`, a `# type: ignore`, or a `dict[str, Any]` standing in for a real model each throw away a fact you had. The same goes for names: one that needs a comment to be understood, or reads as "X but really Y", is the wrong name.

  ```python
  # slop — the caller knows the model, the signature discards it
  def summarise(node: Any) -> dict[str, Any]: ...

  def summarise(node: TableNode) -> TableSummary: ...
  ```

  Keep the escape hatch where the type isn't knowable: untyped third-party returns, dynamic dispatch, a genuine `object` boundary. Name the reason in a comment on the same line, the way you would for a removed check.
- **Read the library's API before you wrap it.** A helper that renames, unwraps, or forwards one native call is slop. Delete it and call the native operation directly.

  ```python
  # slop — Path already reads
  def read_file(path: Path) -> str:
      with path.open() as handle:
          return handle.read()

  text = path.read_text()
  ```

  A helper earns its name by owning what the library can't: a multi-step domain rule, error or resource policy, an unstable third-party contract pinned behind one name, or one operation shared by several callers. One caller, one return expression, no domain rule, and it goes inline.
- **No comments that restate the code.** Comment the *why*, never the *what* the line already says. Docstrings earn their place on complex logic, edge cases, or non-obvious decisions; every function still gets a one-line docstring for ruff format. Delete what you left behind while working: `print()`, `breakpoint()`, commented-out code, `# TODO: implement`.
- **The function-docstring rule stops at the function.** "Every function gets a docstring" says nothing about modules and packages. Before topping a file with `"""Retry helpers for the shared HTTP client contract."""`, match the neighbours. Where they start at the imports, so does yours:

  ```python
  # slop — the filename and the imports already say this
  """Date parsing built on the standard library."""

  from datetime import datetime
  ```

  Keep the module docstring where the repo's tooling demands it (ruff `D100`, generated docs), where local style is consistent about it, or where the module carries a public contract its names can't convey.
- **No `from __future__ import annotations`.**

For over-engineering, speculative abstraction, reinvented stdlib, or trivial single-use helpers, defer to the **ponytail** skill — that's its job, not this one.

## Match the neighbours

Every rule above bends to the file it lands in. Before you add something the surrounding code doesn't have, and before you cut something it does, read `AGENTS.md` / `CLAUDE.md` and open two neighbouring modules. A file whose comment density, error handling, import style, or docstring habit differs from its neighbours reads as slop even when each line defends itself.

This runs both ways. Consistency is no licence to spread a bad pattern, so when you diverge, say what the neighbours do and why this file doesn't.

## When cleanup isn't enough

Three or more helpers translating one contract, validating the same data, or shuttling state between stages is one broken flow. Each helper reads as small on its own, so fixing them one at a time never lands. Stop editing helpers and trace the flow: who owns the data, what transforms it, who consumes it. Put each rule with its owner, then keep the top-level function readable top to bottom.

```
before:  metadata helper → fallback helper → ID helper → validator → grouping
after:   validated reader metadata → group by table ID → parser → retrieval pairs
```

The trigger is the shape, and the words the user reaches for: hard to maintain, helper-heavy, fragmented, hard to follow. Leave alone the module whose helpers are independent domain operations that stand up on their own. For the vocabulary of the seam this restructuring lands on, defer to the **codebase-design** skill.

## Scope: a diff you didn't write

An agent wrote it and you are stripping its fingerprints before anyone reviews it. Scope to `git diff main` and touch changed lines only.

- Match the neighbours. The target is the file's existing style. These rules describe what you would write from scratch; the neighbours describe what belongs here.
- Cut what the agent added on top: comments the file wouldn't carry, `try`/`except` the area doesn't use, a `cast()` or `# type: ignore` papering over a type problem, helpers called once.
- Keep the behaviour. Fix a real bug you find, and report that separately from the cleanup.
- Surgical edits. A rewrite belongs in "When cleanup isn't enough" above, with the user's agreement first.
- Report in two or three sentences: what you removed, and anything you left because the neighbours do it too.

## Don't purge

Never remove, even when it looks defensive:

- **Input validation at trust boundaries** — API edges, user input, deserialization, config parsing, partial results from an external call.
- **Error handling that prevents data loss** — writes, migrations, transactions.
- **Security and auth checks.**

Removing a check on purpose is fine when the assumption is safe. If it isn't obvious, leave a short comment naming the assumption.

Defensiveness in the wrong place is its own slop. The common shape: safe internal code wrapped in `try`/`except Exception` that only logs, while the network call three lines down has no timeout and no retry. Move the handling onto the call that can fail.

## Done when

Every file you touched is free of the slop patterns above, or each deliberate exception is a justified carve-out. Then ask:

- For each check that survived, which trust boundary does it protect? If an upstream validated model already guarantees the fact, it goes.
- Can a maintainer read each main path top to bottom without opening a chain of single-use helpers?
- Does every module docstring you added match what the neighbouring modules do, or something the tooling requires?
- Is every signature annotated, and does every `Any`, `cast()`, and `# type: ignore` name the reason it survived?
- Did you read the API of every library object you wrapped, and does each surviving wrapper own a rule the library lacks?
