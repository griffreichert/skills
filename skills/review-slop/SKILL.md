---
name: review-slop
description: Review a diff or PR for Python slop — flag it, don't fix it. Use when reviewing code, a pull request, or a teammate's changes for defensive checks, fake tests, or needless private helpers.
---

# Review slop

Apply the slop rules from the **purge-slop** skill to a diff — but as review comments, not edits. You are reviewing, so leave the code alone and report.

The rules live in purge-slop (single source of truth): no defensive type-checking, no re-validating what an upstream owner already guaranteed, tests that can't fail, over-privatized helpers, wrappers around a library's own API, missing or dishonest type hints, module docstrings the repo's own files don't use, helper chains that hide one flow, style the surrounding file doesn't use, and its "don't purge" carve-out for validation, data-safety, and security. Read that skill for the full rule set.

## How to review

- **Comment, don't change.** Never edit the code under review. Output findings only.
- **Respect the carve-out.** A type check at a trust boundary (API edge, user input, deserialization) is not slop — don't flag it.

## Report

One sweep, two shapes. Find everything either way, then pick the shape from what the user asked for.

**Detailed review — the default.** "Review this diff", "review the PR", "what did I miss". Label and group the findings per the **review-comments** skill, worst first inside each label.

**Decision brief.** "What should I fix", "is this mergeable", "what's blocking", "where do we stand". Report per the **decision-brief** skill: a numbered priority list, each item carrying the problem in plain language, the action you recommend, and the exact decision you need. Order what already breaks first, then risky slop, then structural slop, then preference. State the finding count once. Hold back file paths, line numbers, and diff quotes until they ask, then hand over the labelled review for the items they picked.

The labelled comments are the deliverable — they get pasted onto the MR, one per finding, and the author works through them. That is why they are the default. The brief is for whoever decides whether the MR merges, who wants the call and not the thread.

## Done when

Every instance of the purge-slop patterns in the diff is flagged, or the diff is clean and you say so. Don't stop at the first one. The report shape matches what the user asked for.
