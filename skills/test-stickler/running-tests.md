# Running the suite

Disclosed reference for [test-stickler](SKILL.md). Read it when running tests or
changing markers, setup, or test docs.

## Two commands, two costs

The default command selects the **unit lane**. It runs from a clean checkout
without I/O or credentials. Prefer the narrowest relevant `-k` selector.

The integration command selects the **integration lane**. It may start owned
resources and incur I/O. Select it through a registered marker or dedicated
command. Keep live third-party tests opt-in.

Example pytest shape:

```ini
# pytest.ini
[pytest]
markers =
    integration: real owned-component or adapter boundary
```

```sh
pytest -m 'not integration'       # default unit lane
pytest -m integration             # integration lane
```

Follow repository and framework conventions. Retain the lane split and document
the commands.

## Select by name, not by path

```sh
pytest -k text_wrapper            # substring against the full node id
pytest -k "parser and not slow"   # boolean expressions
pytest -k "test_upload[large]"    # a parametrized case by id
pytest -m integration             # by marker, registered in pytest.ini
pytest -m "api and not slow"      # markers compose
```

Node ids like `tests/serve/test_config.py::test_defaults` are the fallback for when `-k` collects unrelated tests.

Debug: `-x` first failure, `--lf` last failed, `-q` quiet, `-s` stdout. Use the
project runner where required, such as `uv run` or `poetry run`.

## Harness contract

`pytest -k my_test` passes on a clean checkout. That is the unit bar.

Integration fixtures own setup, unique names or ports, and cleanup. State
required setup in the fixture docstring.

Run both lanes deliberately in CI. Docs state when each runs and what green
covers.

## Document what to run

Test docs belong in the repo, in `tests/README.md` or a testing section of the main README. They state:

- The default unit command, and what it skips.
- The integration command, resources it starts, and any live-system opt-in.
- Every marker, its command, and its purpose. Register markers in `pytest.ini`.
- Every setup step and command.
- Which lanes CI runs and when, so a green local run means something.

Update docs with every marker, `pytest_addoption` flag, or setup change.
