---
name: pydantic-principles
description: Structure pydantic code so the model does the work. Construction validates, settings own the knobs, contracts live at boundaries. Use when writing or reviewing pydantic models, settings or config classes, or data contracts.
---

# Pydantic principles

Pydantic already parses, validates, coerces, defaults and reports errors, so
every hand built version is slop. The model is the loader, the validator and the
error message. Write the class, and skip the machinery around it.

## Structure

- **Construction is loading.** `Config()` is the loader, so no `load_config()`
  beside a model that validates itself. Env vars, files, defaults, coercion and
  derived values live inside the class. Catching `ValidationError` to re-raise
  it as `ConfigError` adds a stack frame and nothing else.
- **Settings own the knobs.** Tunables (token caps, TTLs, retries, timeouts,
  model names) are fields on the settings model, with `Field(description=...)`
  where the name does not carry it, never `_MAX_SUMMARY_TOKENS = 120` halfway
  down a module. Fixed facts (enum members, model keyed lookup tables) stay at
  module level.
- **Contracts are models, plumbing is plain.** Use pydantic where data crosses a
  boundary: LLM structured output, files on disk, API payloads, queue messages,
  config. Use plain classes for stateful workers, parsers, adapters and
  transient algorithm state. Do not model what never leaves the function, and
  repository consistency never justifies modelling behaviour as data.
- **The package's convention outranks the boundary test.** Before swapping a
  model for a plain class, read what its neighbours in `schema.py` use. A value
  inside an established contract family stays in it, even when every producer
  and consumer is internal, since a second model system gives one package
  parallel validation, serialization and equality paths.
- **`frozen=True` earns its place with a bug.** Name the mutation it prevents and
  the caller that would have made it. It holds for an observed mutation bug, a
  cached identity, a value shared across threads, or a public value object
  documented as immutable. A model frozen on principle beside mutable
  neighbours in one `schema.py` gives the package two conventions and no reason.
  Where nothing mutates and construction validates, leave it mutable.
- **Group contracts in `schema.py`**, one per package. Stateful classes with
  behaviour stay in their own module.
- **One model per contract.** No parallel plain class or `TypedDict` mirroring a
  model to "decouple" from pydantic, and no hand written `to_dict()` or
  `from_dict()`: `model_dump()` and `model_validate()` are the API.
- **Validate at the edge, once.** Data that entered as a model stays a model, and
  downstream functions take the model, not a dict they re-validate.

## Use the native feature

| Instead of | Use |
| --- | --- |
| `if not isinstance(...)` or manual coercion in `__init__` | `field_validator(mode="before")` to coerce, `mode="after"` to check |
| cross field checks in a caller | `model_validator(mode="after")` |
| bounds checks in a validator | `Field(ge=…, max_length=…, pattern=…)` |
| a property computed in `__init__`, or a `get_x(cfg)` helper | `@computed_field` + `@property` |
| a default that depends on another field | `Field(default_factory=lambda data: data["default"])` |
| `json.loads()` then `Model(**data)` | `Model.model_validate_json()` |
| a wrapper model with one `items: list[X]` field | `TypeAdapter(list[X])`, or `RootModel` |
| rebuilding a model from a mutated dict | `model_copy(update=…)` |
| `str` with a custom `__repr__` mask | `SecretStr` (+ `field_serializer(when_used="json")` if it must dump) |
| free floating string literals for a closed set | `StrEnum` |
| `os.getenv()` + manual cast + default | `BaseSettings` + `SettingsConfigDict(env_file=…, toml_file=…, extra="ignore")` |
| flat `DB_HOST` / `DB_PORT` settings fields | nested models + `env_nested_delimiter="__"` |
| bespoke precedence logic across env, file, args | `settings_customise_sources` |
| a "don't mutate this" comment | `ConfigDict(frozen=True)`, once you have the reason above |
| `snake_case` shims for a camelCase API | `ConfigDict(alias_generator=to_camel, validate_by_name=True)` |

**Let `ValidationError` fly.** It names the field, the input and the reason
better than your message. Catch it only where you have a real recovery.

**`Field(description=…)` is the prompt.** For LLM structured output, the class
docstring and field descriptions are what the model reads, and constraints
(`ge`, `max_length`, enums) enforce what "please return valid JSON" only asks.

## Defers

- Code that survives deletion with nothing lost: **purge-slop**.
- Speculative abstraction, a base class with one subclass, config for a value
  that never changes: **ponytail**.
- Anything shaped like test work: **test-stickler**.

## Done when

Every model you touched validates its own inputs, every knob lives on a settings
class, and no line re-implements something in the table. Every model you
proposed converting sits outside its package's contract family, and every one
you kept holds data. Every `frozen=True` you added or left names the mutation it
prevents and the caller that would have made it.
