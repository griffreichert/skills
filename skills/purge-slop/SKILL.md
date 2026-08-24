---
name: purge-slop
description: Purge Python slop — code that adds no value. Use when writing or refactoring Python, cleaning up code, when code is called hard to maintain or helper-heavy, or when the agent reaches for defensive type checks, fake tests, or needless private helpers.
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
- **No comments that restate the code.** Comment the *why*, never the *what* the line already says. Docstrings earn their place on complex logic, edge cases, or non-obvious decisions; every function still gets a one-line docstring for ruff format.
- **No `from __future__ import annotations`.**

For over-engineering, speculative abstraction, reinvented stdlib, or trivial single-use helpers, defer to the **ponytail** skill — that's its job, not this one.

## When cleanup isn't enough

Three or more helpers translating one contract, validating the same data, or shuttling state between stages is one broken flow. Each helper reads as small on its own, so fixing them one at a time never lands. Stop editing helpers and trace the flow: who owns the data, what transforms it, who consumes it. Put each rule with its owner, then keep the top-level function readable top to bottom.

```
before:  metadata helper → fallback helper → ID helper → validator → grouping
after:   validated reader metadata → group by table ID → parser → retrieval pairs
```

The trigger is the shape, and the words the user reaches for: hard to maintain, helper-heavy, fragmented, hard to follow. Leave alone the module whose helpers are independent domain operations that stand up on their own. For the vocabulary of the seam this restructuring lands on, defer to the **codebase-design** skill.

## Don't purge

Never remove, even when it looks defensive:

- **Input validation at trust boundaries** — API edges, user input, deserialization, config parsing, partial results from an external call.
- **Error handling that prevents data loss** — writes, migrations, transactions.
- **Security and auth checks.**

Removing a check on purpose is fine when the assumption is safe. If it isn't obvious, leave a short comment naming the assumption.

## Done when

Every file you touched is free of the slop patterns above, or each deliberate exception is a justified carve-out. Then ask:

- For each check that survived, which trust boundary does it protect? If an upstream validated model already guarantees the fact, it goes.
- Can a maintainer read each main path top to bottom without opening a chain of single-use helpers?
