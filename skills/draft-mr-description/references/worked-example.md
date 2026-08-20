# Worked example: a change narrative

One annotated MR for a change that crosses several stages and turns one domain
object into several stored objects. The domain is invented. Copy the moves, not
the headings.

The change: a session recorder used to write one document per shipper flush, so
one user session could arrive as four fragments with no shared identity and four
separate enrichment calls. The recorder now detects the complete session first,
then splits it for storage.

## The Overview does four jobs

```markdown
## Overview

This MR changes the session shipper so that stored documents represent the
sessions a person actually had, not the flush boundaries of the shipper.

The current shipper writes one document per flush. A long session arrives as
several fragments, each without the session header, and each fragment gets its
own enrichment call. One session can therefore cost four LLM calls for
incomplete content.

The recorder now closes a complete logical session before storage. It then
splits large sessions between complete events. Every physical segment repeats
the session header and carries the same logical session ID. Enrichment groups
by that ID and makes one call for the whole session.
```

1. **Problem first, in the reader's terms.** Flush boundaries leaking into
   stored data, not "refactored the shipper".
2. **Old shape, then new shape.** Three sentences each, no file names.
3. **Both names fixed immediately.** `logical session` and `physical segment`
   appear here and never vary again.
4. **The consequence is concrete.** "One call for the whole session" beats
   "improves enrichment quality".

## The reviewer map comes after the story

```markdown
<details>
<summary>Reviewer map</summary>

1. `recorder/base.py` owns buffering and recorder orchestration.
2. `recorder/boundary.py` decides where one session ends.
3. `recorder/document_builder.py` builds header, segments, and IDs.
4. `shipper.py` preserves recorder-owned IDs through staging.
5. `enrichment.py` groups segments into one logical session.

</details>
```

Ordered by lifecycle, one responsibility per file, collapsed. It answers "which
file do I open first", and it never becomes the story itself.

## Each section explains a choice, then its effect

```markdown
### 1. Logical session detection

The recorder closes a session on an idle gap or an explicit logout. Detection
runs before storage chunking, so a session that outgrows the size limit still
splits between complete events. Every segment repeats the session header and
records its physical order, which lets enrichment rebuild the session without
re-reading the source stream.
```

Problem, contract, downstream effect. No sentence rates the design.

## Durable and temporary are separated

```markdown
The recorder emits final stored documents. The reassembled session exists only
inside the enrichment worker and is never written back. Segment IDs stay stable
across reruns, because they derive from the session ID and the segment index.
```

The reviewer now knows what to look for in storage and what to ignore.

## The diagram marks the lifecycle boundary

```text
event stream
      |
      v
recorder buffer
      |
      +-- logical session (in memory, closed on idle gap)
            |
            +-- physical segments (stored)
                  |-- session.id  = shared logical ID
                  |-- id_         = per-segment ID
                  |-- header repeated on each segment
                  |
                  v
            enrichment worker
                  |-- groups by session.id
                  |-- orders by segment_index
                  +-- one call per logical session
```

Under 80 columns, durable and temporary labelled, both IDs visible. Prose above
it stays authoritative.

## Compatibility is stated, not implied

```markdown
Documents written before this MR carry no `session.id`. The enrichment worker
treats a document without that field as its own logical session, which is the
existing behaviour. No migration and no dual write is required.
```

Detection rule, unchanged behaviour, migration answer. Three sentences.

## Testing hands over runnable commands

```markdown
Run the recorder suite from `services/recorder`:

    uv run pytest tests/recorder -m "not integration" -q

Run enrichment grouping tests from `services/enrichment`:

    uv run pytest -k session_grouping -q

With staging credentials, replay one long session and confirm one enrichment
call, stable segment IDs, and a repeated header on every segment.
```

Working directory, marker, and what the reviewer should eyeball. No claimed
pass count that was not recorded from this tree.
