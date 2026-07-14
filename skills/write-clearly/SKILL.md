---
name: write-clearly
description: Cut writing to the bone. Clear, human, no AI slop. Use when writing or reviewing prose, docs, comments, commit messages, or PR text, or when asked to make text clearer, tighter, or less AI-sounding.
---

# Write clearly

CUT ALL FLESH. LEAVE ONLY BONE.

Mark Twain once said "I didn't have time to write a short letter, so I wrote a long one instead."

The best sentences are the ones you delete. More text buries the point and loses the reader. Convey the message in as few words as possible without losing the key bits.

## The rules

- **Start from the reader's need.** Write what they need to know to do or decide, not what you want to say.
- **Front-load everything.** Most important point first, in the document, the section, the paragraph, the sentence. Conclusion first, then detail, then background.
- **One idea per sentence, one topic per paragraph.** More than one idea in a sentence? Split it.
- **Be specific.** Give the number, the name, the date, the path. Cut vague abstractions ("a range of", "going forward", "in terms of").
- **Say it once.** Make the point, then move on. Restating it a second way is padding, however good the second way sounds.
- **Write examples that travel.** An example only works if the reader already has the context it assumes. Internal names, private repos and in-house jargon do not survive the trip.

## AI slop to strip

- **Em-dashes.** Obvious AI tell. Delete or replace with a period.
- **Needless punctuation.** Avoid reaching for a hyphen or semicolon when regular commas would suffice. If a comma won't do, the sentence should be two.
- **Defining a thing by what it isn't.** "X, not Y." "X rather than Y." "It's not just X, it's Y." All the same slop. Cut Y and state X.
- **Restating after punctuation.** Assert, dash, assert the same thing again in different words. The cadence is the tell. Keep the first half.
- **"This is genuinely / truly / really."** Show it, don't assert it.
- **Long list items.** Keep list elements to a label and a simple sentence. A list item running to a full paragraph belongs in prose.

## Done when

- **Writing:** deleting any sentence would lose meaning. If it wouldn't, it's already gone.
- **Reviewing:** every slop pattern above is removed or flagged, and every sentence passes the no-op test.
