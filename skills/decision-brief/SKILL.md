---
name: decision-brief
description: Report findings as a prioritised list of decisions the user must make — the problem in plain language, the recommended action, the exact approval needed. Use when reporting an audit, review, or investigation to someone choosing what happens next, or when another skill needs a format for findings that need a decision rather than verification.
---

# Decision brief

A report someone reads to **decide** carries different content from one they read
to **verify**.

Verification needs the evidence: paths, line numbers, quoted code, commands.
Deciding needs the choice: what is wrong, what you recommend, what you need from
them. Hand over the first when they asked for the second and the choice is buried
in an audit trail.

Use `review-comments` for the verification shape. Use this skill when the reader
has to choose what happens next.

## Pick the shape

| The user asks | Shape |
| --- | --- |
| "what's wrong", "what should I fix", "what are the gaps", "where do we stand", "what would you do" | Decision brief |
| "audit this", "review the diff", "show me the evidence", "walk me through it" | `review-comments` |

When you cannot tell, brief first and offer the evidence.

## The shape

A numbered list, highest priority first. Each item carries three things and
nothing else:

1. **The problem**, in words that survive without the code open.
2. **The action you recommend.** One. You did the reading.
3. **The decision you need**, named exactly.

```
1. S3 tests crash on optional metadata. Recommend fixing the marker filter.
   Need: approval.
2. Retry path has no test that can go red. Recommend one integration test for
   the second call. Need: a decision on whether retries are in scope.
3. Config loader silently falls back to defaults. Recommend raising instead.
   Need: confirmation that no deployment relies on the fallback.
```

Three lines per item is the ceiling. An item that needs a paragraph is two
items, or it is evidence you are meant to be holding back.

## Order by what it costs to leave

1. **Already broken.** Failing, crashing, or producing wrong output now.
2. **High-risk gap.** Behaviour that will break with real consequence, and
   nothing catches it.
3. **Structural.** The thing that makes the next change harder or hides the next
   failure.
4. **Preference.** Readability, naming, tidiness.

Rank inside each band by blast radius.

## Rules

- **One item per decision, not per finding.** Group findings that resolve
  together. Six items a person can decide on beat twenty they cannot.
- **Every item names a decision.** Nothing to decide means it is not an item.
  Either do it, or say it once in a closing note.
- **The decision must be theirs.** Approval, priority, scope, or a fact only
  they hold: does this run in production, is retry in scope, who owns that
  pipeline. Never manufacture a decision for something you should settle
  yourself.
- **Recommend, do not survey.** Offer two options only when the choice is
  genuinely theirs, and say which one you would take.
- **State totals once.** "94 tests, 3 failing" at the top, then never again.
- **Hold the evidence.** No file paths, line numbers, commands, diff quotes, or
  stack traces in the brief. Offer them in one closing line.
- **Plain language.** The problem line must read to someone who has not opened
  the file. Keep the jargon that names the thing exactly; cut the jargon that
  performs.
- **Cap it.** Past seven items, split into **decide now** and **later**.

## Expand on request

When the user picks items, hand over the evidence for those items only, in the
calling skill's detailed format. Keep the brief's numbering so they can follow
which item they are reading.

## Done when

Every line names a decision the user owns, the order matches what it costs to
leave each one unfixed, and nothing in the brief needs the file open to be
understood.
