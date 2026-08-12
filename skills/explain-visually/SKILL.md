---
name: explain-visually
description: Explain a technical design through one worked example, the data shapes at each stage, and an ASCII lifecycle diagram. Use when the user asks how objects, IDs, state, transformations, storage, or consumer paths connect, or asks to see a system visually.
---

# Explain Visually

Prose explains parts. A diagram explains connections. Use this when the parts
are already clear and the wiring is not.

Trigger on "explain this visually", "show me how these pieces connect", "draw
the data flow", "where does each value live", "give me an ASCII diagram", "I
can't picture this architecture" — or unprompted when the discussion holds
three or more connected stages, representations, stores, or record types and
the wiring is doing the work.

A diagram earns its place only if it reveals **ownership, sequence, hierarchy,
fan-out, or linkage**. A diagram that redraws the paragraph above it is
decoration; cut it.

The examples below are illustrations of shape. Take the field names, IDs, and
stage names from the system in front of you.

## Steps

### 1. Pick one concrete example

Choose the smallest example that still exercises the behaviour in question.
Aim for a case with real tension in it: two siblings sharing a parent, one
temporary artifact, one persisted derivative, one branch.

Use real-looking values — `order_2481`, `attempt=2`, an actual line of input —
over `foo` and `<placeholder>`. Reuse exactly the same example through every
later step. A second example halves the reader's grip on the first.

**Done when** one example covers every branch you plan to draw.

### 2. Show the data shapes

Before drawing the flow, show the objects flowing. Print a representative
instance of each distinct shape, carrying only the fields that decide
**identity, grouping, ordering, ownership, storage, or dispatch**. Drop the
rest.

Use the codebase's exact field and type names. A renamed field in a diagram is
a bug the reader inherits.

**Done when** every field on show is one a later arrow depends on.

### 3. Draw the lifecycle

Fenced `text`, source to consumer:

```text
SOURCE -> PARSE -> DOMAIN OBJECTS -> TRANSFORM -> STORAGE -> CONSUMER
```

Boxes are objects, stores, or services. Arrows are transformations,
references, and fan-out. Label every arrow with the operation it performs, not
with a restatement of its target:

```text
group by order_id
order by created_at
resolve through payment_intent_id
```

Keep boxes narrower than 80 columns. When the flow outgrows a terminal, split
it into two or three linked diagrams rather than shrinking the labels — name
the seam box identically in both so the reader can stitch them.

Put assumptions beside the box or arrow they constrain, not in a footnote. Mark
proposed behaviour separately from current behaviour, and draw the legacy path
when backwards compatibility shapes the design.

**Done when** a reader can trace one value from input to consumer without
leaving the diagram.

### 4. Mark what survives

Diagrams hide lifetime. Add a table that does not:

| Content | Lifetime | Location |
| --- | --- | --- |
| Submitted payload | Persistent | Request log |
| Validated command | Temporary | Handler memory |
| Emitted event | Persistent | Event store |
| Projected read model | Derived, rebuildable | Query database |

It must answer: what is stored, what exists only during processing, what
crosses a process or service boundary, what reaches the consumer, and which
object owns each value.

**Done when** every box in the diagram appears in the table or is obviously a
store.

### 5. Separate the identities

Systems with several IDs confuse readers at the ID, not at the flow. Give each
one its scope:

| ID | Scope |
| --- | --- |
| `source_id` | The original input |
| `group_id` | A set of related records |
| `record_id` | One stored row or object |
| `ref_id` | A pointer from one record to another |

Then trace those same IDs through the diagram. Same name, same spelling.

**Done when** the reader can say which ID does grouping and which does linking.

### 6. Show the runtime paths

One compact flow per consumer action, each starting at something a user or
caller does:

```text
Read a record   -> query index -> record_id -> stored row

Cancel an order -> emit event  -> ref_id    -> refund handler
```

**Done when** each path starts at a real action and ends at a returned result
or a committed effect.

### 7. Name what the picture exposed

Close with benefits, tradeoffs, compatibility constraints, and the questions
the diagram opened. Tie every point to something visible above — "one command
writes three rows because the read model denormalises per recipient" beats
"there is some duplication".

The tradeoff nobody could see in prose is the reason to have drawn it.

**Done when** every listed consequence points at a box or an arrow.

## Output rules

- Lead with the diagram when the user knows the domain. Lead with the worked
  example when the domain is still forming.
- One term per concept, start to finish. Renaming mid-diagram costs the reader
  a re-read.
- Short labels. The box says what it is; the arrow says what happened.
- Plain Markdown and terminals are the target. Avoid Mermaid unless the user
  asks or the renderer is known.
- Save the diagram to a file when the user will come back to it, and link it
  from the relevant index note.

## Done when

The explanation answers all of these:

1. What objects exist, and when does each one exist?
2. Where does each value live, and which object owns it?
3. Which IDs group, and which link?
4. What is temporary, what is persisted, and what is derived?
5. What crosses a process, service, or trust boundary?
6. What reaches the consumer, and how does it follow the stored links?
7. Which compatibility path handles old records?
8. Which tradeoff got clearer once it was drawn?
