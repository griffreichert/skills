---
name: test-stickler
description: Mutate the source and check the test goes red. Catches mock theatre and missing edge cases. Use when writing or reviewing pytest tests, or when asked whether coverage is real.
---

# Test stickler

A test earns its place by going **red** when the behaviour breaks. Coverage percentages, assertion counts and a green suite are all gameable. Red-on-break is not.

This skill is the single source of truth for pytest quality. **purge-slop** defers here for anything test-shaped.

## Mutate it

Break the code under test. Flip a boolean, return `None`, drop the write, off-by-one a slice. The test goes red, or it tests nothing.

Writing a test: break the line, watch it fail, restore it. A test you never saw fail is a test you are guessing about.

Reviewing a test: run the mutation in your head, then name the mutation it survives. That is the finding.

Tests that survive every mutation:

- **Mock theatre.** A body of `assert_called_once_with` proves the mock got wired up. Assert what the caller sees: the return value, the persisted row, the emitted event.
- **The echo.** Build `x`, pass it through, assert the result is `x`. Only meaningful when identity is the contract.
- **`assert result is not None`** as the whole check. Anything non-null passes.
- **Mocking the subject.** Patching the function under test, or patching so deep the real logic never runs.
- **No assertion.** "It didn't raise" is a smoke test. Put that in the name, like `test_parse_survives_empty_input`, so the next reader knows what it claims.

## Mock at the boundary

The boundary is where your code stops. The network, the clock, the LLM, the object store, the payment API. Mock there and the real logic still runs. Mock your own domain functions and the test measures the mock.

Real fixtures go redder than mocks. In-memory SQLite, `tmp_path`, `moto`, a `TestClient`, a recorded payload. Reach for those first.

Five patches to run one test is a design finding. Report the design.

## Name the missing case

Read the source, then read the test file. Say what the tests never pass in. Name the case: "no test passes an empty file list to `ingest`". "Add more tests" is not a finding.

Where they hide:

- **Boundaries.** `[]`, `""`, `{}`, `None`, zero, one item, at-limit, one-over-limit.
- **Errors.** Every `raise` and every `except` needs a test that reaches it. `pytest.raises(ValueError, match=...)` pins the type and the message.
- **Branches.** Every `else` and every early return. A suite that only walks the happy path leaves each guard untested.
- **Strings.** Duplicates, ordering, unicode, case. Filenames and user text bite hardest.
- **Async.** Cancellation, timeout, concurrent callers on shared state.
- **Idempotency.** Call it twice. Retry, replay, re-run.

Parametrize the variations. One test function per distinct behaviour.

## One command to run it

`pytest -k my_test` passes on a clean checkout. That is the bar.

Some tests need a flag, an env var, seeded remote files or a live service. Give those a sensible default in the fixture, or a marker that deselects them by default. State the requirement in the fixture docstring. Silent setup means the test gets skipped, rots, then lies.

**Fixtures** carry setup that is shared or non-trivial: a DB session, a client, a `tmp_path` tree, seeded records. Scope as wide as is safe. Use `session` for expensive, immutable things and `function` for anything a test mutates. Keep one-line setup inline. A fixture wrapping a bare constructor hides more than it saves.

**`conftest.py`** carries config and cross-file fixtures: `pytest_addoption` flags, session hooks, fixtures shared across a directory. Put it at the narrowest directory that needs it. People maintain the tests they can read from the test body and one conftest.

## Document what to run

Test docs belong in the repo, in `tests/README.md` or a testing section of the main README. They state:

- The default command, and what it skips.
- Every marker, what it selects, and the command to run it. `pytest.ini` registers the name. Docs give the purpose.
- Every setup step, and the command that does it. A service, credentials, seeded files, a flag.
- Which tests CI runs, so a green local run means something.

Add a marker, a `pytest_addoption` flag or a setup step, and update the docs in the same change. Stale docs send people to a red suite they cannot explain.

## Select by name, not by path

```sh
pytest -k text_wrapper            # substring against the full node id
pytest -k "parser and not slow"   # boolean expressions
pytest -k "test_upload[large]"    # a parametrized case by id
pytest -m integration             # by marker, registered in pytest.ini
pytest -m "api and not slow"      # markers compose
```

Node ids like `tests/serve/test_config.py::test_defaults` are the fallback for when `-k` collects unrelated tests.

The debug loop: `-x` stops at the first failure, `--lf` reruns last-failed, `-q` quiets the output, `-s` shows stdout. Prefix with the project runner where the repo uses one, `uv run` or `poetry run`. `pytest.ini` and `pyproject.toml` hold the registered markers and the default options.

## Where the stickler rests

Not everything needs a test. Trivial one-liners and pure data classes are fine untested. One behavioural test that goes red beats six asserting on mocks. A mocked LLM, payment API or clock is a boundary correctly drawn, so leave it.

## Done when

Every test in scope has gone red under mutation, or carries a flag naming the mutation it survives. Every `raise` and every branch is covered or named as a gap. Every new marker, flag and setup step is in the test docs. Reviewing means flagging only, one line each: `path:line`, the surviving mutation, the fix. The code stays untouched.
