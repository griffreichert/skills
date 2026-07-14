# Running the suite

Disclosed reference for [test-stickler](SKILL.md). Read this when running tests, when a test needs setup before it can pass, or when a change adds a marker or a flag.

## Select by name, not by path

```sh
pytest -k text_wrapper            # substring against the full node id
pytest -k "parser and not slow"   # boolean expressions
pytest -k "test_upload[large]"    # a parametrized case by id
pytest -m integration             # by marker, registered in pytest.ini
pytest -m "api and not slow"      # markers compose
```

Node ids like `tests/serve/test_config.py::test_defaults` are the fallback for when `-k` collects unrelated tests.

The debug loop: `-x` stops at the first failure, `--lf` reruns last-failed, `-q` quiets the output, `-s` shows stdout. Prefix with the project runner where the repo uses one, `uv run` or `poetry run`.

## One command to run it

`pytest -k my_test` passes on a clean checkout. That is the bar.

Some tests need a flag, an env var, seeded remote files or a live service. Give those a sensible default in the fixture, or a marker that deselects them by default. State the requirement in the fixture docstring, so the next reader learns it from the test rather than from a failure.

## Document what to run

Test docs belong in the repo, in `tests/README.md` or a testing section of the main README. They state:

- The default command, and what it skips.
- Every marker, what it selects, and the command to run it. `pytest.ini` registers the name. Docs give the purpose.
- Every setup step, and the command that does it. A service, credentials, seeded files, a flag.
- Which tests CI runs, so a green local run means something.

Add a marker, a `pytest_addoption` flag or a setup step, and update the docs in the same change. Stale docs send people to a red suite they cannot explain.
