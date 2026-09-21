# Body detail

Read this when a commit escalates past the default body in step 5 of
`SKILL.md`: a breaking contract, a data migration, an operational risk, or a
change that introduces domain concepts the diff alone will not teach.

Write in this order instead of the default:

1. **Current state:** what happens before this commit, and why it is a problem.
2. **Change:** what this commit does. When order matters, list the operations as
   in step 5's ordered shape.
3. **Result:** what becomes faster, safer, simpler, or possible.
4. **Trade-off:** a real cost or maintenance requirement, only if one exists.

This order is a drafting aid, not a four-section template. Omit any part that
adds no useful fact. The escalated body also covers:

- A definition for every new domain term and document type, the first time the
  words appear.
- A short list for categories, file types, precedence rules, or stages, so the
  count is visible.
- The implementation at a high level with one concrete example: a real input
  and what comes out of it.
- The field or object the data lands in after the change: `Document.text`,
  `Document.metadata`.
- The adjacent behaviour they would ask about. PDFs, tables, legacy documents,
  downstream callers, and existing import paths are the usual questions.
- The scope boundary, with deferred work named and the reason it sits outside
  the current issue.
- The limit of a heuristic, in plain language, when the behaviour cannot be
  exact: `Header detection reads font size, so a document that marks headers by
  weight alone is missed.`

A fact earns its place in the message on these terms:

- Include a fact when it explains the decision or changes how a reviewer judges
  the commit.
- Mention a risk when it affects correctness, rollout, maintenance, cost, or a
  caller's contract.
- Say that normal validation still runs when a reviewer could reasonably think
  the change bypasses it.
- Back a safety or performance claim with an observed result or a real source:
  a number you measured, a link the reviewer will open.

Name the symbol when the subject alone leaves the mechanism unclear. The rule
and its limits live in `write-technical-english`; the short version is that a
symbol earns its place when it lets the reviewer verify a contract, understand
a cost, or find the code that enforces the claim.

```text
Route upload diagnostics through `UploadSession.resume()`.

`count_parts()` and `read_manifest()` now inspect the same `Part` contract
used by the uploader.
```
