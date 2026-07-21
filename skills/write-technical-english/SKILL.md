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
- **Noun clusters: three words maximum** (2.1). "Pipeline config validation
  error handler" is a sentence pretending to be a noun. Unpack it.
- **Keep the articles** (4.2, 4.5). "Check that the config file exists", never
  "Check config file exists". Dropped articles read as a different grammar.
- **No semicolons** (8.1). Two sentences.
- **Inclusive language** (GR-7).

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

## Where it bends

Three deliberate exceptions. Everything else holds.

- **Commit subjects drop articles.** `fix auth token expiry check` is the git
  convention and it beats rule 4.5. The commit body keeps its articles.
- **Narrative sections are descriptive writing.** An MR Overview or a README
  intro tells a change story. Give it the 25-word cap, not the imperative form.
  Do not turn a paragraph of reasoning into a list of commands.
- **Code, identifiers, error strings and log lines are quoted, never edited.**
  Reproduce them exactly. The rules govern the prose around them.

## Done when

- **Writing:** every instruction is imperative and under 20 words, every concept
  has exactly one name throughout, and no sentence has a second possible
  reading.
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
