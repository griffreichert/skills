---
name: write-clearly
description:
  Cut writing to the bone. Clear, human, no AI slop. Use when writing or
  reviewing prose, docs, comments, commit messages, PR text, or display copy
  (titles, taglines, headlines, captions, UI microcopy), or when asked to make
  text clearer, tighter, or less AI-sounding.
---

# Write clearly

CUT ALL FLESH. LEAVE ONLY BONE.

The best sentences are the ones you delete. More text buries the point and loses
the reader, so convey the message in as few words as possible without losing the
key bits.

Writing steps a reader will execute, a runbook, or reference docs? Use
`write-technical-english` for the sentence mechanics. This skill still decides
how much you say.

## The rules

- **Start from the reader's need.** Write what they need to do or decide, not
  what you want to say.
- **Front load everything.** The most important point comes first in the
  document, the section, the paragraph and the sentence: conclusion, detail,
  background.
- **One idea per sentence, one topic per paragraph.** Split a sentence that
  carries two ideas.
- **Be specific.** Give the number, name, date, path. Cut vague abstractions
  ("a range of", "going forward", "in terms of").
- **Name the subject.** A claim opening on "It", "This" or "That" sends the
  reader hunting backwards for a referent, and they guess wrong. Repeat the
  noun.
- **Prefer the short word.** Use over utilize or leverage, full over
  comprehensive, help over facilitate, method over methodology. Same for jargon
  and foreign phrases when an everyday word carries the meaning.
- **Assume no prior context in an explanation.** Plain words over jargon, with
  every technical fact kept. Simplifying language is not cutting substance.
- **Use the active voice.** "We added error handling to every endpoint", never
  "error handling has been implemented across all endpoints". Passive only when
  the actor is unknown.
- **Say it once.** Restating the point a second way is padding, however good the
  second way sounds.
- **Abstract glue is a symptom.** When a paragraph needs abstract terms to
  connect several changes, the changes are unrelated and the writing covers for
  them. Inspect the work, then remove or split it before rewriting the
  paragraph.
- **Write examples that travel.** An example works only when the reader has the
  context it assumes. Internal names, private repos and in house jargon do not
  survive the trip.

Break any rule before writing something barbarous or machine shaped.

```text
before: Comprehensive error handling has been implemented across all
        API endpoints to ensure robust and reliable performance.
after:  We added error handling to every API endpoint.
```

## The two tics to kill first

Both give a sentence the shape of insight while adding no fact. Insight is a
property of the content, and sentence level shape cannot add it. The same urge
drives corrective pivots, em dash pivots, "genuinely" and the punchline closer.

### Corrective juxtaposition

```text
the answer isn't X, it's Y
X isn't the problem, Y is
it's not just X, it's Y
X, not Y      /      X rather than Y
```

The X half is usually a straw man nobody raised. Delete X and the sentence
loses nothing. The form is fine once in a piece, spent only where the reader
holds the belief you are correcting. Everywhere else: cut X, state Y.

### Aphoristic register

```text
Vim was never inadequate, it was never wired.
Plugins move on :Lazy update + commit, never behind your back.
It means the pool is won by avoiding bad picks.
```

Balanced clause, closing beat, a flourish where a fact belongs. Test: a line
that would work as a standalone tweet is decoration. A section that ends on a
plain fact has ended. Rewriting is mostly deletion: `Vim was never wired, so
edits fell back to a GUI.` The flourish went and the causal fact arrived.

### Display copy stands alone

A title, tagline, subhead, caption, callout or axis label is read on its own,
ahead of its body. Cover the body and read the line. If you cannot say what it
claims, the line is the body's opening sentence, so cut it or write the claim.

```text
before: Three numbers from the upload run. The last one is the fix.
after:  Resumed uploads dropped parts whenever the manifest checksum was
        stale.
```

The before promises a payoff the reader has not reached, and the after states
the finding with the bullets beneath it as evidence. Running prose is exempt: a
sentence in a paragraph can lean on the one before. Apply the rule to a line set
in a different size or weight from its body.

## AI slop to strip

### Openers and labels

- **Answer labels.** "Short answer:", "TL;DR", "Bottom line", "In short"
  announce the answer. Delete the label and keep the answer.
- **Ruling on the message before answering it.** Praise ("Good question",
  "Fair", "Makes sense") and verdicts ("Whole class", "Two things went wrong
  here", "That's the same bug") spend the first line on your assessment of what
  you were sent. Open on the fact: "Repo does it 6 times."
- **Announcing before saying.** "Let's look at", "In this section we'll cover",
  "It's worth noting". Say the thing.
- **Sorting a decision into whose call it is.** "Your call", "my call", "yours
  to decide", "I shouldn't decide this". Give the facts, the options and a pick.

### Assertion without content

- **Puffery adjectives.** Comprehensive, robust, seamless, powerful, rich. Cut
  the word or give the number.
- **"This is genuinely / truly / really / actually."** Show it. "Actually" is
  the worst of the four, since it implies the reader believed otherwise.
- **Condescension words.** "Simply", "just", "easy", "obviously", "of course"
  rate the step's difficulty for the reader, who concludes the fault is theirs
  when it fails. Deleting the word leaves the instruction unchanged.
- **Grading your own output.** "That's the whole finding in one sentence." "Put
  simply." Brevity that needs pointing out was not brevity.
- **Anointing one part as the whole.** "X is the whole fix", "the real problem
  is X", "which is the property this buys". The frame awards a status the reader
  never granted, runs hottest at a paragraph's end, and adds no fact. Delete the
  frame and keep the item: "Widening the description makes the skill fire."
- **Achievement language in reports.** No ✅, "Successfully", "Perfect". Say what
  changed, what failed, what comes next.

### Words one level too grand

- **Grand register words.** "Canonical", "ephemeral". Keep a term the domain
  uses exactly (a canonical URL, an ephemeral container). Elsewhere the plain
  word carries it: the usual one, short lived.
- **Naming a thing one level above what it is.** "Pipeline seam" for where the
  parser hands off, "physical unit" for a page, "persisted sidecar" for a file
  beside the original. Name the thing, then say what it does.

### Punctuation and hyphens

- **Em dashes** are an obvious AI tell. Delete them or use a period.
- **Needless punctuation.** Use commas before a hyphen or semicolon. If a comma
  will not do, write two sentences.
- **Restating after punctuation.** Assert, dash, assert again in different
  words. Keep the first half.
- **Hyphens standing in for prepositions.** "Reader-owned IDs", "fixture-owned
  setup", "parent-field" bury the relation: owned can mean assigns, holds or
  frees. Write "IDs the reader assigns", "setup the fixture creates", "the
  field on the parent".
- **Hyphenated words built for the occasion**: "well-suited", "context-aware",
  "purpose-built", "reviewer-ready". Use plain words: "fits the case", "reads the
  context", "built for this", "ready for review". Leave established technical
  compounds ("read-only", "no-op", "type-checking", "in-memory") and hyphens in
  code, paths, flags, dates and names.

### Shape

- **The third example.** Two make the point. A third is padding in the costume of
  thoroughness.
- **Machine cadence.** Punchlines two paragraphs running, or six sentences of
  one length and shape. Vary the rhythm or cut one.
- **Long list items.** Keep items to a label and a simple sentence. An item that
  runs to a paragraph belongs in prose.

## Done when

- **Writing:** deleting any sentence would lose meaning, so one that would not
  is already gone.
- **Reviewing:** name each violation before you rewrite, so the author sees the
  pattern and not only the patch. Every slop pattern is removed or flagged, and
  every sentence passes the no op test.
- **Display copy:** every heading, tagline and caption carries its claim with the
  body covered.
