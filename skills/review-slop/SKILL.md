---
name: review-slop
description: Review a diff or PR for Python slop — flag it, don't fix it. Use when reviewing code, a pull request, or a teammate's changes for defensive checks, fake tests, or needless private helpers.
---

# Review slop

Apply the slop rules from the **purge-slop** skill to a diff — but as review comments, not edits. You are reviewing, so leave the code alone and report.

The rules live in purge-slop (single source of truth): no defensive type-checking, tests that can't fail, over-privatized helpers, and its "don't purge" carve-out for validation, data-safety, and security. Read that skill for the full rule set.

## How to review

- **Comment, don't change.** Never edit the code under review. Output findings only.
- **One line per finding:** `path:line — slop → fix`. Point at the exact spot, commit hash, name the slop, give the replacement.
- **Respect the carve-out.** A type check at a trust boundary (API edge, user input, deserialization) is not slop — don't flag it.

## Done when

Every instance of the purge-slop patterns in the diff is flagged, or the diff is clean and you say so. Don't stop at the first one.
