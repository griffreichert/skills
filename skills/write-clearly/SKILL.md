---
name: write-clearly
description: Cut writing to the bone. Clear, human, no AI slop. Use when writing or reviewing prose, docs, comments, commit messages, or PR text, or when asked to make text clearer, tighter, or less AI-sounding.
---

# Write clearly

CUT ALL FLESH. LEAVE ONLY BONE.

Mark Twain once said "I didn't have time to write a short letter, so I wrote a long one instead."

The best sentences are the ones you delete. More text buries the point and loses the reader. Convey the message in as few words as possible without losing the key bits.

Writing steps a reader will execute, a runbook, or reference docs? Use
`write-technical-english` for the sentence mechanics. This skill still decides
how much you say.

## The rules

- **Start from the reader's need.** Write what they need to know to do or decide, not what you want to say.
- **Front-load everything.** Most important point first, in the document, the section, the paragraph, the sentence. Conclusion first, then detail, then background.
- **One idea per sentence, one topic per paragraph.** More than one idea in a sentence? Split it.
- **Be specific.** Give the number, the name, the date, the path. Cut vague abstractions ("a range of", "going forward", "in terms of").
- **Prefer the short word.** Use over utilize, use over leverage, full over comprehensive, help over facilitate, method over methodology. Same for jargon and foreign phrases when an everyday word carries the meaning.
- **Use the active voice.** "We added error handling to every endpoint", never "error handling has been implemented across all endpoints". Passive only when the actor is genuinely unknown.
- **Say it once.** Make the point, then move on. Restating it a second way is padding, however good the second way sounds.
- **Write examples that travel.** An example only works if the reader already has the context it assumes. Internal names, private repos and in-house jargon do not survive the trip.

Break any of these rules before writing something barbarous or machine-shaped.

Same facts, before and after:

```text
before: Comprehensive error handling has been implemented across all
        API endpoints to ensure robust and reliable performance.
after:  We added error handling to every API endpoint.
```

## Corrective juxtaposition

Kill this one first. It is the tic you can recognise on sight.

```text
the answer isn't X, it's Y
X isn't the problem, Y is
it's not just X, it's Y
X, not Y      /      X rather than Y
```

Every shell above is the same move. It gives a plain statement the shape of
insight while adding no fact, and the X half is usually a straw man nobody
raised. Delete X and the sentence loses nothing.

Rhetoricians call the family antithesis, and this corrective form *correctio*.
"Ask not what your country can do for you" is the same figure. It served for
two thousand years. LLMs wore it out in three.

The structure is fine in speech and fine once in a piece of writing. Budget one,
and spend it only where the reader actually holds the belief you are correcting.
Everywhere else: cut X, state Y.

## AI slop to strip

- **Em-dashes.** Obvious AI tell. Delete or replace with a period.
- **Needless punctuation.** Avoid reaching for a hyphen or semicolon when regular commas would suffice. If a comma won't do, the sentence should be two.
- **Restating after punctuation.** Assert, dash, assert the same thing again in different words. The cadence is the tell. Keep the first half.
- **Puffery adjectives.** Comprehensive, robust, seamless, powerful, rich. They assert quality without earning it. Cut the word or give the number.
- **"This is genuinely / truly / really."** Show it, don't assert it.
- **Announcing before saying.** "Let's look at", "In this section we'll cover", "It's worth noting". Say the thing.
- **The third example.** Two examples make the point. A third is padding wearing the costume of thoroughness.
- **Machine cadence.** Punchlines two paragraphs running, or six sentences of the same length and shape. Vary the rhythm or cut one.
- **Achievement language in reports.** No ✅, no "Successfully", no "Perfect". Say what changed, what failed, what comes next, in plain sentences.
- **Long list items.** Keep list elements to a label and a simple sentence. A list item running to a full paragraph belongs in prose.

## Done when

- **Writing:** deleting any sentence would lose meaning. If it wouldn't, it's already gone.
- **Reviewing:** name each violation before you rewrite, so the author sees the pattern and not just the patch. Every slop pattern above is removed or flagged, and every sentence passes the no-op test.
