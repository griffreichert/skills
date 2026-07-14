---
name: purge-slop
description: Purge Python slop — code that adds no value. Use when writing or refactoring Python, cleaning up code, or when the agent reaches for defensive type checks, fake tests, or needless private helpers.
---

# Purge slop

Slop is code that adds no value: it survives deletion with nothing lost. Optimize for reviewable, maintainable code — cut everything that doesn't serve that.

## Rules to check

- **No defensive type-checking.** `isinstance`/`hasattr` are almost never needed. Assume the types you expect and let it error when they're wrong. A wrong-attribute crash is better than a silent check that hides the bug.
- **A test must be able to fail.** A test that passes no matter what the code does is slop. Defer to the **test-stickler** skill for anything test-shaped — mutation, mocks, missing edge cases, fixtures — that's its job, not this one.
- **Don't over-privatize.** Private methods only inside a class, for genuine internals. Standalone module functions don't need a `_` prefix — default to importable. Slop names ride along with the prefix: `_short`, `_handle`, `_in_kb` say nothing — name the function for what it does (`truncate_title`, `handle_update`, `has_graph_node`).
- **No comments that restate the code.** Comment the *why*, never the *what* the line already says. Docstrings earn their place on complex logic, edge cases, or non-obvious decisions; every function still gets a one-line docstring for ruff format.
- **No `from __future__ import annotations`.**

For over-engineering, speculative abstraction, reinvented stdlib, or trivial single-use helpers, defer to the **ponytail** skill — that's its job, not this one.

## Don't purge

Never remove, even when it looks defensive:

- **Input validation at trust boundaries** — API edges, user input, deserialization, config parsing.
- **Error handling that prevents data loss** — writes, migrations, transactions.
- **Security and auth checks.**

Removing a check on purpose is fine when the assumption is safe. If it isn't obvious, leave a short comment naming the assumption.

## Done when

Every file you touched is free of the slop patterns above, or each deliberate exception is a justified carve-out.
