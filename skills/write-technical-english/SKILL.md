---
name: write-technical-english
description: Shape technical text so it has exactly one reading. One document mode, sized sentences, imperative steps, one term per thing, no phrasal verbs. Use when writing or reviewing a README, runbook, install or migration steps, operator notes, API reference, commit message, or MR text, or when the reader may be a non-native English speaker or a translator.
---

# Write technical English

ONE SENTENCE. ONE READING.

A reader can reread prose. A reader following steps at 3am executes what the
sentence appears to say. These rules are the useful subset of ASD-STE100
Simplified Technical English, the controlled language aerospace has used for
maintenance manuals since 1986. Rule numbers refer to Issue 9. The rules are
mechanical and countable, so you can check your own output.

Run `write-clearly` too: it decides how much you say, and this skill decides
the shape. For an MR, PR, RFC summary or architecture note, run
`draft-mr-description` for the document story. This skill governs the sentences
inside it.

## Pick the mode

A document has one mode. Two questions pick it: does the reader act or
understand, and are they learning or working?

| Mode | Reader | Rule |
| --- | --- | --- |
| Tutorial | acts, learning | Every step shows the output to expect. Explanation shrinks to a clause and a link. |
| How-to | acts, working | Action only, for one goal. Name it by the task: "How to resume an upload". |
| Reference | understands, working | Describe, never instruct or persuade. Mirror the structure of the thing described. |
| Explanation | understands, learning | Context, constraints, alternatives. Opinion belongs here only. |

A table in a tutorial, or an argument in a how-to, becomes its own document and
a link.

## Size the sentence

- **Instructions: 20 words maximum** (5.1). Count. Over the line, split.
- **Descriptions: 25 words maximum** (6.3).
- **One instruction per sentence** (5.2), unless the actions happen together.
- **Paragraphs: one topic, six sentences maximum** (6.5, 6.6).
- **More than two conditions go in a vertical list** (4.3).

## Shape the verb

- **Imperative for every instruction** (5.3). "Run the migration", never "the
  migration should be run".
- **Active voice** (3.6). Passive only in description, and only when the actor
  is unknown.
- **Simple tenses** (3.2, 3.4): present, past, future, imperative, infinitive.
  No "has been", "will have been", "is being".
- **No `-ing` as a verb** (3.5). "The service starts", never "is starting".
- **No phrasal verbs** (9.3). Install over set up, start over kick off, remove
  over take out, continue over carry on. The single word survives translation.

## Fix the words

- **One term per thing, forever** (1.11). Job, task and run are one concept with
  three names or three concepts. Pick one word and never vary it. Abbreviations
  follow the same rule: spell out on first use, then use one short form.
- **Name the logical and the physical thing separately** (1.11). When one domain
  object produces several stored objects, fix both names before the first
  paragraph: the logical upload a person starts, the physical part that stores
  a slice. Use those exact words for identity, ordering, ownership and
  transformation, so the reader never works out which "upload" a sentence means.
- **Noun clusters: three words maximum** (2.1). Unpack "pipeline config
  validation error handler".
- **Keep articles and helper words** (4.2, 4.5). "Check that the config file
  exists", "If the row is found, then the loader returns it". Repeat the article
  in a pair: "the client and the host".
- **Keep the verb.** "Step 2 uploads the manifest", never "step 1 uploads the
  parts and step 2 the manifest".
- **Put `only` next to what it limits.** "Request only one token" and "Only
  request one token" differ.
- **Settle grouping.** "Both X and Y", "either X or Y", "a, b, or both". Never
  `a/b` or `and/or`.
- **One referent per `it`, `they`, `this`.** Repeat the noun when in doubt.
  Never point `this` or `which` at a whole clause.
- **No idiom, slang, humour, metaphor or Latin abbreviation** (`e.g.`, `i.e.`,
  "under the hood", "out of the box"). Say the mechanism. Use the words a
  developer says aloud: "move", "delete", "a budget that only goes down", not
  "evacuate" or "ratchet". A named pattern is fine when the text says what it
  means on first use.
- **Parentheses hold a full sentence or nothing.** No "(s)" plurals.
- **No semicolons** (8.1). Write two sentences. An em dash becomes a new
  sentence.
- **Inclusive language** (GR-7).

## Ground the claim in code

Applies to any sentence claiming what code does: commit bodies, MR descriptions,
design notes, code comments. Reader facing instructions are exempt, since the
operator does not care which class runs.

A sentence can pass every rule above and hide the mechanism: "The application
reads the file during diagnostics and upload." One reading, inside the cap, and
useless to a reviewer. Name four things: the **actor**, the **action**, the
**data** in and out, and the **consequence**.

```text
`UploadDiagnostics.report()` calls `PartReader.load()` and receives `Part`
objects. The uploader calls the same reader again through
`UploadSession.start()`, so the file is read twice.
```

The shape is `SYMBOL` performs ACTION on DATA. CONSEQUENCE.

- **Audit abstract verbs after the first draft.** `handles`, `uses`,
  `processes`, `supports`, `routes`, `preserves`, `manages`, `evaluates`,
  `transforms`, `integrates`, `remains separate` each stand where a mechanism
  belongs. Where the mechanism matters, swap the abstract subject for the symbol
  responsible and name what it does.
- **Ground a claim at a seam.** Name the symbol when data changes shape,
  ownership changes, an ID is created or replaced, a compatibility fallback
  picks a path, a branch bypasses normal processing, an expensive operation
  runs, temporary data becomes stored data, one object fans out, or several
  combine into one operation.
- **Stay selective.** Naming every private helper is a code tour and a reviewer
  skims it. A symbol earns its place when it lets the reader verify a contract,
  understand a cost, trace ownership, or find the code that enforces the claim.

## Order the step

- **Condition first** (5.4). "Before you restart the service, drain the queue."
  The reader acts on the first thing they read.
- **Common case first, exceptions after.** An early stop still gives the step
  that applies to most readers.
- **Warnings before the step** (7.1 to 7.3): signal word, command, risk.

  ```text
  WARNING: Stop the writer before you truncate the table.
  Truncation during a write loses the in-flight batch.
  ```

- **Notes inform, never instruct** (5.5). Anything the reader must do goes in a
  numbered step they cannot skip.

## Fit out the document

- **Write timelessly.** Cut `currently`, `now`, `new`, `newer`, `latest`, `old`,
  `older`, `existing`, `soon`, `eventually`, `at present`, `as of this writing`.
  They date the document the week it ships and carry no fact. Give a version
  number when a fact belongs to one release.
- **Address the reader as `you`.** `you` names who acts, and `we` or "the user"
  leaves the reader guessing whether the step is theirs.
- **Link text names the target.** `See the [retry policy](…)`, never `click
  here`, `read more` or a bare URL. A reader scanning only links still knows
  where each goes.
- **Code font for anything typed or read literally**: commands, flags, paths,
  filenames, identifiers, literal values.
- **Placeholders in capitals, with the substitution stated.** `gcloud config
  set project PROJECT_ID`, then one line saying what `PROJECT_ID` is.
- **Sentence case headings that carry the point.** `Configure the worker`, and
  "Pick the mode first" over "Modes". A task heading is a bare verb phrase, a
  concept heading a noun phrase. One h1 per page, no skipped levels.
- **Numbered list for a sequence, bullets for the rest.** Introduce a list with
  a complete sentence and keep items parallel.
- **No `please`, `simply`, `easy`, `quickly` in a procedure.**
- **Make every count or tree claim true at the commit that lands it**, and give
  the command that regenerates it.

## Vary the rhythm

Text can obey every rule and still read machine written: one clipped length, no
view, nothing specific.

- **Mix lengths on purpose.** A short sentence lands a point, and a longer one
  carries a fact with its condition. The caps bound one thought and leave the
  variety alone.
- **Split a sentence that carries two thoughts, keep one that carries one.**
- **Take a position in explanation.** Weigh the trade-off and say what you make
  of it. Reference stays dry.
- **Prefer the specific.** "A column rename fails the build", never "schema
  changes can cause issues".

## Match the author's voice

The author's commit messages, earlier descriptions, and nearby notes form a
voice corpus. Read it before you draft.

- Take vocabulary from it: `retry budget` stays `retry budget`.
- Keep their spelling, register and rhythm. British spelling stays British, `we
  kept the old path` does not become `it was determined that`, and short
  declaratives stay short.
- Fix errors and keep the voice. Correcting a run on is editing, and rewriting
  the paragraph into corporate prose is a substitution nobody asked for.
- Inside an author's skeleton (headings, order, emphasis), draft inside it.
  Propose a structural change, never perform one.

## Where it bends

Everything else holds.

- **A rule yields to a better sentence.** When a rule yields text that reads as
  machine written, rewrite the sentence another way or leave it. In a review,
  name the rule you bent.
- **Commit subjects drop articles.** `fix auth token expiry check` follows git
  convention over rule 4.5. The body keeps its articles.
- **Narrative sections are descriptive writing**, such as an MR Overview or
  README intro. Give them the 25 word cap and the descriptive form, and keep
  reasoning as a paragraph, never a list of commands.
- **In narrative, the word count is a diagnostic.** The caps hold absolutely for
  instructions and safety critical steps. In an Overview, split a long sentence
  that carries two decisions or two consequences. Leave one that identifiers
  and a single causal clause carry, since splitting one causal claim into
  fragments drops the link.
- **Design uncertainty stays in.** "Part matching is heuristic, so an upload
  retried outside the window stores a duplicate" is a fact. Jokes, slogans and
  punchlines go.
- **Code, identifiers, error strings and log lines are quoted exactly.** The
  rules govern the prose around them.
- **`we` survives where the writer owns the change**: commit bodies, MR
  descriptions, session notes. Reader facing documentation uses `you`.
- **Dated records keep their time words**: release notes, changelogs, daily
  notes. Timeless writing governs documentation of how the thing works.

## Worked example

Before:

> The resumable upload part checksum retry limit is configured through
> upload.toml. It should be noted that raising it, which may be needed for
> flaky links, is not recommended because failures could be hidden. If
> exceeded, the upload gets failed.

After:

> `upload.toml` sets `max_part_retries`, the number of times the uploader
> resends a part whose checksum does not match. Raise it only on an unreliable
> link, because a higher limit hides real corruption. When a part exceeds the
> limit, the upload fails.

## Done when

- **Writing:** every instruction is imperative and under 20 words, every concept
  has one name throughout, and no sentence has a second reading.
- **Claiming what code does:** a reviewer can find the enforcing code from each
  major claim. A cost claim names the repeated call or allocation, a
  compatibility claim the branch and fallback field, an identity claim the
  function and its inputs, a data flow claim the input and output types.
  Abstract verbs are gone where the mechanism mattered, and low value symbols
  never went in.
- **Reviewing:** name the rule each violation breaks, then give the rewrite.

## Source

ASD-STE100 Simplified Technical English, Issue 9 (2025-01-15), maintained by the
ASD Simplified Technical English Maintenance Group, free from
[asd-ste100.org](https://www.asd-ste100.org/). The rules above are paraphrased
and cut down to what applies to software documentation. The specification is
copyright ASD and is not reproduced here. Part 2, the dictionary of roughly 900
approved words each locked to one meaning, is out of scope. Read the
specification for the exact wording of a rule.

`Fit out the document`, and the four ambiguity rules that carry no STE number,
come from the [Google developer documentation style
guide](https://developers.google.com/style), mainly [writing for a global
audience](https://developers.google.com/style/translation) and [timeless
documentation](https://developers.google.com/style/timeless-documentation).
Google's American spelling rule is dropped, since this corpus writes British
English.

`Pick the mode` follows [Diátaxis](https://diataxis.fr) by Daniele Procida.
That section, `Vary the rhythm` and the added ambiguity rules are adapted from
the `technical-writing` skill in pstack by Lauren Tan (MIT). See
[external/pstack/NOTICE.md](../../external/pstack/NOTICE.md).
