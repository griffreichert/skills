---
name: test-stickler
description: Audit unit and integration pytest tests for coverage that can go red and a healthy test harness. Use when writing or reviewing tests, or when asked whether coverage is real.
---

# Test stickler

Ask of every test: **would it go red if the behaviour broke?**

The red question beats coverage, assertion counts, and a passing suite. Report
findings. Do not change code or tests unless asked. **purge-slop** defers here
for test-shaped work.

## Lanes

**Unit tests** prove one component's decisions. Keep the loop **tight**: in-memory
inputs, controlled boundaries, no I/O or credentials, fast and deterministic.
They must run repeatedly from a clean checkout.

**Integration tests** prove owned components and real boundaries work together:
serialization, persistence, queues, HTTP, framework wiring, or migrations. Keep
the loop **wide**: explicit setup, isolated resources, and known I/O cost.

Classify by execution, not directory:

| Lane | Proof | Default |
| --- | --- | --- |
| Unit | Component behaviour | Fast local loop |
| Integration | Boundary and wiring contract | Marker or CI lane |

Boundary mocks belong in unit tests. Integration tests run the adapter or
framework boundary they claim to prove. Local resources need fixture-owned setup
and teardown. Live third-party systems use a separate opt-in lane.

## Split review

When subagents exist, use two smallest capable subagents:

- **Unit reviewer:** component source and unit tests; red assertions, branches,
  errors, boundaries, mocks, and tight-loop cost.
- **Integration reviewer:** integration tests and harness; real contracts,
  lifecycle, isolation, cleanup, markers, I/O cost, and CI selection.

Give each only its lane's paths and source dependencies. Request ranked
`file:line`, smell, evidence, and fix. Combine duplicate findings yourself.

If subagents cannot run, ask the user to enable them. Then make sequential unit
and integration passes; state that the review was sequential.

## Audit

1. **Map lanes and harness.** Read test config, fixtures, docs, and CI. Classify
   every in-scope test and selector. Name wrong or invisible lanes.
2. **List source behaviours.** Read source before tests. List branches, raises,
   early returns, and boundaries.
3. **Read test bodies.** Judge assertions before names. Flag names that promise
   different behaviour.
4. **Bind assertions.** Trace each assertion to source. Assertions tied only to
   mocks, inputs, or literals cannot go red on source failure.
5. **Map behaviour to tests.** Name missing cases and put component decisions in
   unit tests, boundary contracts in integration tests.
6. **Audit harness.** Confirm narrow unit selection works cleanly; integration
   selection, resource ownership, cleanup, and CI coverage are explicit. Read
   [running-tests.md](running-tests.md) for commands and documentation.

## Smells

| Smell | Signal | Fix |
| --- | --- | --- |
| **Unknown test** | No assertion. | Assert the observable contract. |
| **Redundant assertion** | `assert x == x` or `assert True`. | Assert computed output. |
| **Testing the mock** | Only `assert_called_*`. | Assert caller-visible result. |
| **Mocking the subject** | Subject patched; no real logic runs. | Mock the boundary. |
| **Eager test** | Several behaviours share one test. | One behaviour per test. |
| **Assertion roulette** | Many unlabelled asserts. | Split, parametrize, or label. |
| **Conditional test logic** | Test branches or loops around assertions. | Parametrize cases. |
| **Vague name** | Name omits condition or behaviour. | Name behaviour and condition. |
| **Mystery guest** | Depends on leftover state. | Create state in a fixture. |
| **Resource optimism** | Assumes an external resource exists. | Own it in a fixture or opt in. |
| **Sleepy test** | Uses `time.sleep`. | Await, poll with timeout, or freeze time. |
| **General fixture** | Broad fixture hides simple setup. | Narrow fixture scope. |
| **Sensitive equality** | Compares `str` or `repr`. | Compare fields or equality. |
| **Ignored test** | Undated `skip` or `xfail`. | Fix or delete it. |
| **Lane leak** | Unit test uses services, credentials, or shared state. | Move boundary proof to integration. |
| **Fake integration** | Mocks claimed boundary. | Use real adapter and owned resource. |
| **Unowned resource** | Shared DB, port, bucket, queue, or service. | Use unique fixture-owned resources. |
| **Invisible lane** | Integration selector is unregistered, undocumented, or absent from CI. | Register, document, and run it. |

## Missing cases

- **Boundaries:** empty, `None`, zero, one, limit, and limit plus one.
- **Errors:** pin exception type and relevant message.
- **Strings:** duplicates, order, unicode, and case.
- **Async:** cancellation, timeout, and concurrent shared state.
- **Idempotency:** retry, replay, and second call.

Parametrize variations. One test per behaviour.

## Fixtures

Use fixtures for shared or non-trivial setup. Keep one-line construction inline.
Use the narrowest safe scope. Put shared config and cross-file fixtures in the
narrowest `conftest.py`.

## Report

Rank: tests that cannot go red; missing behaviours; lane or harness gaps;
readability. One line each:

```
tests/io/test_upload.py:42   testing the mock   assert the uploaded key
io/upload.py:17              missing case       zero-byte early return untested
```

## Done when

Every source behaviour can go red through a test or is named as a gap. Every
test has a deliberate lane. Unit and integration commands, resource ownership,
and CI coverage are evidenced or reported as harness gaps.
