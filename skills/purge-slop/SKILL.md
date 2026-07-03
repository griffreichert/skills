---
name: purge-slop
description: Purge Python slop — code that adds no value. Use when writing or refactoring Python, cleaning up code, or when the agent reaches for defensive type checks, fake tests, or needless private helpers.
---

# Purge slop

Slop is code that adds no value: it survives deletion with nothing lost. Optimize for reviewable, maintainable code — cut everything that doesn't serve that.

## Rules to check

- **No defensive type-checking.** `isinstance`/`hasattr` are almost never needed. Assume the types you expect and let it error when they're wrong. A wrong-attribute crash is better than a silent check that hides the bug.
- **A test must be able to fail.** Test real behaviour and edge cases, not mocked fakes. A test that passes no matter what the code does is slop — the check: does it fail if the behaviour breaks? No, delete it. Not everything needs a test. Use pytest fixtures; test distinct things.
- **Don't over-privatize.** Private methods only inside a class, for genuine internals. Standalone module functions don't need a `_` prefix — default to importable.

For over-engineering, speculative abstraction, reinvented stdlib, or trivial single-use helpers, defer to the **ponytail** skill — that's its job, not this one.

## Don't purge

Never remove, even when it looks defensive:

- **Input validation at trust boundaries** — API edges, user input, deserialization, config parsing.
- **Error handling that prevents data loss** — writes, migrations, transactions.
- **Security and auth checks.**

Removing a check on purpose is fine when the assumption is safe. If it isn't obvious, leave a short comment naming the assumption.

## Done when

Every file you touched is free of the three slop patterns above, or each deliberate exception is a justified carve-out.
