---
name: test-stickler
description: Audit pytest tests for the ones that cannot go red, flag the smell by name, suggest the fix. Use when writing or reviewing tests, or when asked whether the coverage is real.
---

# Test stickler

Ask one question of every test: **if the behaviour it covers broke, would this test go red?**

The tests that stay green are the findings. Coverage percentages, assertion counts and a passing suite all stay green too, so none of them can answer this for you.

Report what you find. The code and the tests stay as they are, unless you are asked to fix them.

Single source of truth for pytest quality, so **purge-slop** defers here for anything test-shaped.

## The audit

Work in this order. Each step feeds the next.

**1. Read the source first, and list its behaviours.** Every branch, every `raise`, every early return, every boundary the code cares about. This list is the yardstick, and it comes from the code. Derive it from the test names instead and you inherit whatever the tests already missed.

**2. Read each test body before its name.** Names promise, bodies deliver. Judge what the body checks, then read the name and see whether it agrees. A gap between the two is a finding.

**3. Bind every assertion to a line of source.** Follow each assert back to the line that produces the value it checks. This answers the red question statically, with nothing run and nothing edited. An assertion that binds to a mock, to its own input, or to a literal binds to no source at all, and a test built only from those can never go red.

**4. Map the behaviours from step 1 onto the tests.** A behaviour with no test is a missing case. Name each one. The cases that hide from a plain read of the source are listed under [Where the missing cases hide](#where-the-missing-cases-hide).

**5. Rank, then report.** Tests that cannot go red come first, because they are worse than no test: they buy false confidence. Untested error paths and branches next. Readability smells last.

## Smells

Flag by name. These names are standard, so they carry weight in review.

| Smell | How it shows up in pytest | Suggest |
| --- | --- | --- |
| **Unknown test** | No assertion. Calls the function and ends. | Assert the observable result. If "it didn't raise" really is the contract, say so in the name. |
| **Redundant assertion** | `assert x == x`, `assert True`. Green under every possible change. | Assert the value the code actually computed. |
| **Testing the mock** | The body is `assert_called_once_with` and friends. It checks the mock got wired up. | Assert what the caller sees: the return value, the persisted row, the emitted event. |
| **Mocking the subject** | The function under test is patched, or patched so deep no real logic runs. | Mock at the boundary: the network, the clock, the LLM, the object store. |
| **Eager test** | One test exercises five functions. The first failure hides the rest. | One behaviour per test. |
| **Assertion roulette** | Twenty bare asserts. A failure gives a line number and no reason. | Split it, parametrize it, or add assertion messages. |
| **Conditional test logic** | `if` or `for` inside the test, so a branch quietly skips the assert. | Parametrize the cases instead of branching through them. |
| **Vague name** | `test_upload`, `test_it_works`. The failure line names a function and no behaviour. | Name the behaviour and the condition: `test_upload_rejects_zero_byte_file`. |
| **Mystery guest** | Depends on a file, DB row or bucket object that something else created. | `tmp_path`, a fixture, or a sample payload committed to the repo. |
| **Resource optimism** | Assumes the external thing exists. Green locally, red in CI. | Build the resource in a fixture, or mark the test and deselect it by default. |
| **Sleepy test** | `time.sleep` to wait for async work. Slow, and flaky under load. | Await the event, poll with a timeout, or freeze the clock. |
| **General fixture** | A conftest builds things most of its tests never touch. | Move the fixture down to the tests that use it. |
| **Sensitive equality** | Compares `str(obj)` or `repr(obj)`. Breaks when formatting changes. | Compare the fields, or give the object a real `__eq__`. |
| **Ignored test** | `skip` or `xfail` with no reason and no date. | Fix it or delete it. A permanently skipped test is a lie with a green tick. |

## Where the missing cases hide

Step 1 catches most of them. These are the ones that hide from a plain read of the source.

- **Boundaries.** `[]`, `""`, `{}`, `None`, zero, one item, at-limit, one-over-limit.
- **Errors.** `pytest.raises(ValueError, match=...)` pins the type and the message. A bare `pytest.raises(Exception)` goes green on a typo.
- **Strings.** Duplicates, ordering, unicode, case. Filenames and user text bite hardest.
- **Async.** Cancellation, timeout, concurrent callers on shared state.
- **Idempotency.** Call it twice. Retry, replay, re-run.

Parametrize the variations. One test function per distinct behaviour.

## Fixtures and conftest

**Fixtures** carry setup that is shared or non-trivial: a DB session, a client, a `tmp_path` tree, seeded records. Scope as wide as is safe. Use `session` for expensive, immutable things and `function` for anything a test mutates. Keep one-line setup inline, since a fixture wrapping a bare constructor hides more than it saves.

**`conftest.py`** carries config and cross-file fixtures: `pytest_addoption` flags, session hooks, fixtures shared across a directory. Put it at the narrowest directory that needs it. People maintain the tests they can read from the test body and one conftest.

## Running the suite

Selectors, markers, the setup a test is allowed to need, and what the test docs must state: **[running-tests.md](running-tests.md)**. Read it when running tests, when a test needs setup before it can pass, or when a change adds a marker or a flag.

## Where the stickler rests

Not everything needs a test. Trivial one-liners and pure data classes are fine untested. A mocked LLM, payment API or clock is a boundary correctly drawn, so leave it.

Say when a suite is good. One line is enough. Padding a clean audit with weak findings to prove it ran is its own failure.

## Report

Rank by severity. One line per finding: the location, the smell by name, the suggested change.

```
tests/io/test_upload.py:42   testing the mock   assert the uploaded key, not upload_file.assert_called_once
tests/io/test_upload.py:88   vague name         test_upload -> test_upload_retries_on_timeout
io/upload.py:17              missing case       zero-byte file hits the early return, no test reaches it
```

## Done when

Every behaviour listed in step 1 is covered by a test that can go red, or named as a gap. Every test in scope is sound, or carries a named smell and a suggested fix.
