---
name: vault-graph
description: Add wikilinks among existing notes in a vault subtree. Use when the user asks to graphify notes, connect related notes, cross link a folder, or improve an existing knowledge graph.
---

# Vault graph

Connect notes that already exist. The job adds links and nothing else: the
wording, the folders, and every index stay as the user left them. The link
conventions live in
[`references/notes-workflow.md`](../daily-capture/references/notes-workflow.md);
read its section on disambiguating links before you write one.

Skip this skill when you create a note, capture a session, or reorganize a
vault. Those belong to `daily-capture`, or to an explicit request.

## Steps

### 1. Map the subtree

List every note in the subtree the user named, with its existing links. Collect
the basenames across the whole vault too, since a name unique in the subtree can
recur elsewhere.

### 2. Find the missing edges

Read each note for a named topic, dependency, decision, or continuation that
another note in the vault covers. Each candidate link needs its evidence: the
passage that names the topic, and the note that holds it. Drop a candidate that
only shares a keyword.

### 3. Place each link

- When a passage names the topic, link the name in that passage.
- When no passage names it, add the link to a short `Related notes` section at
  the bottom of the note, one line each.
- Path qualify any basename that recurs vault wide:
  `[[projects/upload/daily/2026-07-08|2026-07-08]]`.

An index note gains a link only where it already lists that kind of note. Its
order, headings, and grouping stay.

> Before: a request to link the upload notes turns into a rewrite of the upload
> index as a reading path.
>
> After: the resumable upload handoff note links its "parts" passage to the part
> runner note and its "manifest" passage to the manifest storage note. The index
> is unchanged.

## Done when

Every added link resolves to a note that exists, every recurring basename is
path qualified, and the diff of each note adds links and touches no other text.
