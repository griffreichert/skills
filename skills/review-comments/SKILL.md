---
name: review-comments
description: Label and group review findings as conventional comments — issue, todo, suggestion, quibble, praise. Use when reporting the result of any code, diff, or PR review, or when another skill needs a format for its findings.
---

# Review comments

Findings land as **conventional comments**: each carries a label saying what it demands of the author, and the report groups by label so the **binding** ones read first.

This is the shape for a reader who must **verify**. When the reader has to choose what happens next, use the **decision-brief** skill instead: a prioritised list of decisions, evidence held back until asked.

## The labels

Five **primary** labels carry the review; four **secondaries** exist for what the five can't say. Ranked by how binding each is — this is also the report order:

| Label | Tier | Binds | Means |
| --- | --- | --- | --- |
| **issue** | primary | Yes | Broken, wrong, or unsafe. Blocks the merge. |
| **chore** | secondary | Yes | Process, not code — changelog, migration, ticket link. Must happen before merge. |
| **todo** | primary | Yes | Small and mandatory. Trivial to do, still required. |
| **question** | secondary | Until answered | A real uncertainty you need the author to resolve. Never rhetorical. |
| **suggestion** | primary | No | A change worth making. Author may decline. |
| **quibble** | primary | No | Preference. Say out loud that it's optional. |
| **note** | secondary | No | Something the reader should know. No action asked. |
| **thought** | secondary | No | An idea the review threw up, worth saying, not worth doing now. |
| **praise** | primary | — | Genuinely good, and worth the author knowing why. |

Size doesn't decide a label, obligation does. A one-character fix that breaks production is an **issue**; a whole-file rewrite the author can refuse is a **suggestion**.

Three spec labels duplicate the five, so they stay unused: **nitpick** is **quibble**, **typo** is a **todo**, **polish** is a **suggestion**.

### Decorations

The label already carries the obligation, so two decorations survive:

- **issue (non-blocking)** — a real defect you're consciously not gating merge on.
- **suggestion (if-minor)** — do it only if the change turns out trivial.

## The report

Numbered within each group, worst first inside a label:

```
### issue

1. `src/auth/session.py:42` (a1b2c3d) — expiry check uses `<`, so a token
   expiring this second still passes → use `<=`.
2. ...

### todo

1. `src/auth/session.py:88` (a1b2c3d) — `TODO(gr)` left in shipped code → drop it.

### suggestion
...
```

Cite the commit that introduced the finding, not the one that touched the line last.

## Rules

- **Primary by default.** A secondary needs a reason no primary fits. "Not sure" is a **question**; unsure whether it's broken is still an **issue**.
- **Show only the groups you filled.** Three or four groups is a normal review, not nine.
- **Earn every finding**, praise most of all — one specific praise beats three hollow ones.
- **Label, don't fix.** Whether you edit the code is the calling skill's call.

## Done when

Every finding carries exactly one label — none dropped for want of a fit, none parked in **suggestion** to dodge the obligation call.
