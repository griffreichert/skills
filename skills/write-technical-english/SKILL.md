---
name: write-technical-english
description: Shape technical text so it has exactly one reading. Sized sentences, imperative steps, one term per thing, no phrasal verbs. Use when writing or reviewing a README, runbook, install or migration steps, operator notes, API reference, commit message, or MR text, or when the reader may be a non-native English speaker or a translator.
---

# Write technical English

ONE SENTENCE. ONE READING.

Prose can afford ambiguity because the reader can reread. A reader following
your steps at 3am cannot. They execute what the sentence appears to say.

These rules are the useful subset of ASD-STE100 Simplified Technical English,
the controlled-language standard aerospace has used for maintenance manuals
since 1986. Rule numbers below refer to Issue 9. The rules are mechanical and
countable, so you can check your own output.

Use `write-clearly` when available. That skill decides how much you say. This
one decides how you shape it. Run both.

For an MR, a PR, an RFC summary or an architecture note, run
`draft-mr-description` for the document-level story. This skill governs the
sentences inside it.

## Size the sentence

- **Instructions: 20 words maximum** (5.1). Count them. Over the line, split.
- **Descriptions: 25 words maximum** (6.3).
- **One instruction per sentence** (5.2). Two actions in one sentence only when
  they happen at the same time.
- **Paragraphs: one topic, six sentences maximum** (6.5, 6.6).
- **Anything with more than two conditions goes in a vertical list** (4.3).

## Shape the verb

- **Imperative for every instruction** (5.3). "Run the migration." Never "the
  migration should be run" or "you will want to run the migration".
- **Active voice** (3.6). Passive only in descriptive text, and only when the
  actor is genuinely unknown.
- **Simple tenses only** (3.2, 3.4). No "has been", no "will have been", no "is
  being". Present, past, future, imperative, infinitive.
- **No `-ing` as a verb** (3.5). "The service starts", never "the service is
  starting".
- **No phrasal verbs** (9.3). Install over set up, start over kick off, remove
  over take out, continue over carry on. The single-word form survives
  translation and saves characters.

## Fix the words

- **One term per thing, forever** (1.11). Job, task and run are one concept with
  three names, or they are three concepts. Pick one word and never vary it,
  however repetitive it reads.
- **Name the logical thing and the physical thing separately** (1.11 again).
  When one domain object produces several stored objects, fix both names before
  the first paragraph: the logical table a person sees, the physical chunk that
  stores part of it. Use those exact words for identity, ordering, ownership,
  and transformation. A reader working out which "table" a sentence means has
  stopped reading the argument.
- **Noun clusters: three words maximum** (2.1). "Pipeline config validation
  error handler" is a sentence pretending to be a noun. Unpack it.
- **Keep the articles** (4.2, 4.5). "Check that the config file exists", never
  "Check config file exists". Dropped articles read as a different grammar.
- **Keep the helper words.** `that`, `then` and `of` cost four characters and
  remove a second reading. "If the row is found, then the loader returns it",
  never "If found, the loader returns it".
- **Put `only` next to what it limits.** "Request only one token" and "Only
  request one token" are different instructions.
- **Spell out an abbreviation on first use**, then use it consistently. One
  term per thing applies to the short form too.
- **No idiom, slang, or humour.** "Under the hood", "out of the box" and "a
  breeze" do not survive a non-native reader or a translator. Say the mechanism.
- **No semicolons** (8.1). Two sentences.
- **Inclusive language** (GR-7).

## Ground the claim in code

Applies to any sentence claiming what code does: commit bodies, MR
descriptions, design notes, code comments. Reader-facing instructions are
exempt, because the operator does not care which class runs.

A sentence can pass every rule above and still hide the mechanism.

```text
The application reads the file during diagnostics and upload.
```

Grammatical, inside the cap, one reading, and useless to a reviewer. It does
not say what runs, or that the file gets read twice.

Name four things: the **actor** that performs the behaviour, the **action** it
takes, the **data** in and out, and the **consequence** for the reader.

```text
`UploadDiagnostics.report()` calls `PartReader.load()` and receives `Part`
objects. The uploader calls the same reader again through
`UploadSession.start()`, so the file is read twice.
```

The shape is `SYMBOL` performs ACTION on DATA. CONSEQUENCE.

**Audit the abstract verbs after the first draft.** Search for `handles`,
`uses`, `processes`, `supports`, `routes`, `preserves`, `manages`,
`evaluates`, `transforms`, `integrates`, and `remains separate`. Each one is a
placeholder where a mechanism should be. Where the mechanism matters, swap the
abstract subject for the symbol responsible and name what it does. Where it
does not, leave the verb alone.

**Ground every claim at a seam.** Name the symbol when data changes shape,
when ownership changes, when an ID is created or replaced, when a
compatibility fallback picks a path, when a branch bypasses normal processing,
when an expensive operation happens, when temporary data becomes stored data,
when one object fans out into several, and when several objects combine into
one operation.

**Stay selective.** Naming every private helper is a code tour, and a reviewer
skims a code tour. A symbol earns its place when it lets the reader verify a
contract, understand a cost, trace ownership, or find the code that enforces
the claim. Leave the rest out.

## Order the step

- **Condition first** (5.4). "Before you restart the service, drain the queue."
  The reader must know the condition before the action, because they act on the
  first thing they read.
- **Warnings before the step, never after** (7.1 to 7.3). Signal word, then the
  command, then the risk:

  ```text
  WARNING: Stop the writer before you truncate the table.
  Truncation during a write loses the in-flight batch.
  ```

- **Notes inform, they never instruct** (5.5). Anything the reader must do
  belongs in a numbered step, not in a note they may skip.

## Fit out the document

Sentence rules above. Document furniture here.

- **Write timelessly.** Cut `currently`, `now`, `new`, `newer`, `latest`, `old`,
  `older`, `existing`, `soon`, `eventually`, `at present` and `as of this
  writing`. They date the document the week it ships and they carry no fact:
  "The emulator now supports gzip" says what "The emulator supports gzip" says.
  When a fact belongs to one release, give the version number.
- **Address the reader as `you`.** "You must drain the queue first", never "we
  must" or "the user must". `you` names who acts. `we` hides the actor and
  leaves the reader guessing whether the step is theirs.
- **Link text names the target.** `See the [retry policy](…)`, never `click
  here`, `read more`, or a bare URL. The reader scanning only the links must
  still know where each one goes.
- **Code font for anything typed or read literally**: commands, flags, paths,
  filenames, identifiers, and literal values. Prose font for the concept.
- **Placeholders in capitals, with the substitution stated.** `gcloud config
  set project PROJECT_ID`, then one line saying what `PROJECT_ID` is.
- **Sentence case headings.** `Configure the worker`, not `Configure The
  Worker`.

## Match the author's voice

You are usually not the author. Their commit messages, their previous
descriptions, and the notes beside the file are a voice corpus. Read it before
you draft.

- Take vocabulary from the corpus. Where the author writes `retry budget`, do
  not write `attempt allowance`.
- Keep their spelling and their register. British spelling stays British. A
  writer who says `we kept the old path` does not want `it was determined that`.
- Keep their sentence rhythm. Short declaratives stay short declaratives.
- Fix the errors and keep the voice. Correcting a run-on is editing. Rewriting
  the paragraph into corporate prose is a substitution the author did not ask
  for.
- When the author supplies a skeleton, draft inside it: their headings, their
  order, their emphasis. Propose a structural change, never perform one.

## Where it bends

Deliberate exceptions. Everything else holds.

- **Commit subjects drop articles.** `fix auth token expiry check` is the git
  convention and it beats rule 4.5. The commit body keeps its articles.
- **Narrative sections are descriptive writing.** An MR Overview or a README
  intro tells a change story. Give it the 25-word cap and the descriptive form.
  Do not turn a paragraph of reasoning into a list of commands.
- **In narrative, the word count is a diagnostic.** The caps hold absolutely for
  instructions and safety-critical steps. In an Overview, a long sentence is a
  prompt to look. Split it when it carries two decisions or two consequences.
  Leave it when identifiers and one causal clause carry it over, because
  splitting a single causal claim into fragments drops the link that was the
  point of the sentence.
- **Uncertainty that belongs to the design stays in.** "Part matching is
  heuristic, so an upload retried outside the window stores a duplicate" is a
  fact the reader needs. Jokes, slogans and punchlines still go.
- **Code, identifiers, error strings and log lines are quoted, never edited.**
  Reproduce them exactly. The rules govern the prose around them.
- **`we` survives where the writer owns the change.** Commit bodies, MR
  descriptions and session notes state who did the work and who maintains it.
  Reader-facing documentation still uses `you`.
- **Dated records keep their time words.** A release note, a changelog and a
  daily note exist to say what changed and when. Timeless writing governs
  documentation of how the thing works.

## Done when

- **Writing:** every instruction is imperative and under 20 words, every concept
  has exactly one name throughout, and no sentence has a second possible
  reading.
- **Claiming what code does:** a reviewer can find the enforcing code from
  every major claim. Each cost claim names the repeated call or allocation,
  each compatibility claim names the branch and the fallback field, each
  identity claim names the function and its inputs, and each data-flow claim
  names the input and output types. Abstract verbs are gone where the mechanism
  mattered, and low-value symbols never went in.
- **Reviewing:** name the rule each violation breaks, then give the rewrite.

## Source

ASD-STE100 Simplified Technical English, Issue 9 (2025-01-15), maintained by the
ASD Simplified Technical English Maintenance Group. Free from
[asd-ste100.org](https://www.asd-ste100.org/).

The rules above are paraphrased and cut down to what applies to software
documentation. The specification is copyright ASD and is not reproduced here.
Part 2 of the standard, a dictionary of roughly 900 approved words each locked
to one meaning and one part of speech, is deliberately out of scope. Read the
specification itself when you need the exact wording of a rule.

`Fit out the document`, and the four ambiguity rules that carry no STE number,
come from the [Google developer documentation style
guide](https://developers.google.com/style), mainly its pages on [writing for a
global audience](https://developers.google.com/style/translation) and [timeless
documentation](https://developers.google.com/style/timeless-documentation).
Google's American-spelling rule is dropped; this corpus writes British English.
