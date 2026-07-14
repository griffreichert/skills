---
name: pydantic-principles
description: Structure pydantic code so the model does the work — construction validates, settings own the knobs, contracts live at boundaries. Use when writing or reviewing pydantic models, settings/config classes, or data contracts.
---

# Pydantic principles

Pydantic already parses, validates, coerces, defaults, and reports errors. Every hand-rolled version of that is slop. The model is the loader, the validator, and the error message — write the class, not the machinery around it.

## Structure

- **Construction is loading.** No `load_config()` beside a self-validating model — `Config()` *is* the loader. Env vars, files, defaults, coercion, and derived values live inside the class. Catching `ValidationError` to re-raise it as `ConfigError` adds a stack frame and nothing else.
- **Settings own the knobs.** Tunables — token caps, TTLs, retries, timeouts, model names — are fields on the settings model, with a `Field(description=...)` where the name doesn't carry it. Not `_MAX_SUMMARY_TOKENS = 120` halfway down a module. Fixed facts (enum members, model-keyed lookup tables) stay module-level; a knob someone will want to turn does not.
- **Contracts are models, plumbing is plain.** Pydantic where data crosses a boundary: LLM structured output, files on disk, API payloads, queue messages, config. Plain classes for internal machinery. Don't model what never leaves the function.
- **Group contracts in `schema.py`.** Data contracts live in a per-package `schema.py`. Stateful classes with behavior stay in their own module.
- **One model per contract.** No parallel dataclass or `TypedDict` mirroring a model to "decouple" from pydantic. No hand-written `to_dict()`/`from_dict()` — `model_dump()` and `model_validate()` are the API.
- **Validate at the edge, once.** Data that entered as a model stays a model. Downstream functions take the model, not a dict they re-validate.

## Use the native feature

Reach for the library before writing the code:

| Instead of | Use |
| --- | --- |
| `if not isinstance(...)` / manual coercion in `__init__` | `field_validator(mode="before")` to coerce, `field_validator(mode="after")` to check |
| cross-field checks in a caller | `model_validator(mode="after")` |
| bounds checks in a validator | `Field(ge=…, max_length=…, pattern=…)` |
| a property computed in `__init__`, or a `get_x(cfg)` helper | `@computed_field` + `@property` |
| a default that depends on another field | `Field(default_factory=lambda data: data["default"])` |
| `json.loads()` then `Model(**data)` | `Model.model_validate_json()` |
| a wrapper model with one `items: list[X]` field | `TypeAdapter(list[X])`, or `RootModel` |
| rebuilding a model from a mutated dict | `model_copy(update=…)` |
| `str` + custom `__repr__` masking | `SecretStr` (+ `field_serializer(when_used="json")` if it must dump) |
| free-floating string literals for a closed set | `StrEnum` |
| `os.getenv()` + manual cast + default | `BaseSettings` + `SettingsConfigDict(env_file=…, toml_file=…, extra="ignore")` |
| flat `DB_HOST` / `DB_PORT` settings fields | nested models + `env_nested_delimiter="__"` |
| bespoke precedence logic across env/file/args | `settings_customise_sources` |
| a "don't mutate this" comment | `ConfigDict(frozen=True)` |
| `snake_case` shims for a camelCase API | `ConfigDict(alias_generator=to_camel, validate_by_name=True)` |

**Let `ValidationError` fly.** It already names the field, the input, and the reason — better than the message you'd write. Catch it only where you have a real recovery, never to reword it.

**`Field(description=…)` is the prompt.** For LLM structured output, the class docstring and field descriptions are what the model reads. Constraints (`ge`, `max_length`, enums) enforce what "please return valid JSON" only asks for.

## Defers

- Code that survives deletion with nothing lost → **purge-slop**.
- Speculative abstraction, a base class with one subclass, config for a value that never changes → **ponytail**.
- Anything test-shaped → **test-stickler**.

## Done when

Every model you touched validates its own inputs, every knob lives on a settings class, and no line re-implements something in the table above.
