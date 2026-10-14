# Commit message examples

Contrast pairs for voice, splitting, and how much detail a change earns.

## Voice

### Detached and formal — avoid

```text
Synchronous invocation blocks the request thread pending completion of
downstream operations. Introduce asynchronous dispatch to decouple the
caller from long-running work.

Queue unavailability affects latency only and does not compromise
delivery guarantees.
```

The facts may be right, but the words are not the repo's, and state, change,
and safety argument are tangled together.

### Current state, change, result — prefer

```text
The checkout handler calls the email service inline, so a slow provider
holds the request open and users see timeouts.

Send the confirmation email from a background worker. Checkout returns
as soon as the order is saved.

If the queue is down, orders still save and emails send late. The worker
needs a retry limit.
```

## Splitting

### Move and edit in one commit — avoid

```text
move validators to core and add the empty-row check
```

The diff shows `validators.py` deleted and `core/validators.py` added. The
reviewer cannot see which three lines are the new check.

### Same work, split — prefer

```text
move validators to core

(no body; the subject says it, and the diff is a pure rename)
```

```text
reject empty rows in the CSV validator

Rows with no cells reached the loader and raised an IndexError deep in
the parser. Fail them at validation with the row number instead.
```

## Detail

### A change big enough to need it — prefer

```text
feat(ingest): store parsed transcripts and summaries

Wiki pages are the only document we parse today, so meeting transcripts
arrive as raw text and nothing downstream can tell them apart.

Add two document types:

- transcript: the timestamped speaker log the meeting tool exports

- summary: the short model-written recap we generate from a transcript

Both run through the existing parser. The parsed body lands in
`Document.text` as before, and the type, source file, and meeting date
land in `Document.metadata`, so anything that already reads
`Document.text` keeps working.

PDFs and wiki pages keep their current path. A legacy document with no
type in its metadata reads as a wiki page, which is what it was.

Speaker attribution is outside #412. The transcript parser splits on the
`HH:MM Name:` line the exporter writes, so a transcript edited by hand
loses the split and falls back to one block of text.
```

### The same commit, abstracted — avoid

```text
feat(ingest): introduce reader-owned document identity

Adds a pipeline seam between ingestion and parsing. Each physical unit
carries reader-owned identity, persisted as a sidecar next to the
existing artefact.
```

The cold reviewer learns no term, no storage location, and no scope boundary.
Sidecar and physical unit describe an architecture; `transcript` and
`Document.metadata` describe this change.

## Ordered operations

### Mechanism and symbols — avoid

```text
Reset the handoff state, save a checkpoint, and recover both context
paths.
```

### Problem, then the order, then scope — prefer

```text
The request can end after cancellation, leaving the saved operation
incomplete.

When cancellation occurs:
1. Stop the operation.
2. Save the current context and messages.
3. Mark the operation for recovery.

When the next request arrives:
1. Detect the recovery marker.
2. Load the saved history.
3. Resume without duplicating the request.
4. Clear the marker after success.

Normal requests keep their existing input path.
```

## Goal first

### Internals first — avoid

```text
Workflow.run() starts its handler task immediately. Creating handlers
before the route generator loses the route span from workflow child
spans. Create and consume event streams through
`stream_workflow_events`, which restores the route span around handler
creation, event reads, parsing, rewriting, completion, and cancellation.
```

### Observable problem, then change — prefer

```text
The workflow starts before the request trace is active, so agent and
tool work appears outside the request trace. Run workflow creation and
event handling inside one shared request-trace helper for both
streaming endpoints.
```

## Test commits

### Mechanics only — avoid

```text
check retry survives the client upgrade
```

### Contract, risk, assertion — prefer

```text
<behaviour under protection> because <the change that put it at risk>.
<test change> so <the contract is asserted>.
<compatibility case retained>, when one exists.
```
