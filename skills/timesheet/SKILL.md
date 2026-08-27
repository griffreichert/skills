---
name: timesheet
description: Build a day-by-day work summary from daily notes and git commits over a date range. Use for "what did I do last week", "help me fill my timesheet", "summarise my week", or any recap of work that has to carry its evidence.
---

# Timesheet

Reconstruct a week of work from two evidence sources: the daily notes say what
happened, the commits prove what landed. Neither is complete on its own, so read
both and match them by date. This skill is **read-only** — it writes no notes,
no commits, and files nothing.

The note conventions — where the notes live, the symlink layout, the dated-note
pattern, the steer-me fallback — live in
[`references/notes-workflow.md`](../daily-capture/references/notes-workflow.md).
Read them before hunting for files.

## Steps

### 1. Resolve the range

Convert the request to two absolute local dates before anything else. "Last
week" means the **previous Monday through Sunday**. Seven days back from today
is a different range, so resolve it properly:

```bash
python3 -c "import datetime as d; t=d.date.today(); m=t-d.timedelta(days=t.weekday()); print(m-d.timedelta(days=7), m-d.timedelta(days=1))"
```

"This week" runs from the current Monday to today. Anything vaguer than that —
"recently", "the last while" — gets one question before you start. State the
resolved range in the output so the user can catch a wrong reading.

### 2. Read the notes

One note per date, `notes/daily/<YYYY-MM-DD>.md`. Read every date in the range,
including weekends. Sort what you find into two piles and keep them apart:

- **Completed** — checked items, Done bullets, Decisions, dated outcomes.
- **Planned** — unchecked boxes, next-steps, carryovers, anything phrased as
  intent. Planned stays planned unless a commit or another note proves it landed.

Note the dates with no file. A missing note is a gap to report, never a licence
to fill the day from commits alone.

### 3. Read the commits

Use the repos the user named. Default to the current repo when they named none,
and ask once if the request clearly spans work you can't see from here. Filter
to their own commits, across all branches, over the local-date range:

```bash
git -C <repo> log --all --no-merges --author="$(git config user.email)" \
  --since="<start> 00:00" --until="<end> 23:59:59" \
  --date=short --pretty="%h %ad %s"
```

A repo that doesn't exist or won't read is reported as unavailable, and the
range still gets summarised from what's left.

### 4. Open the vague ones

A subject like `fix tests` or `wip` carries no outcome. For those, and only
those, pull the body and the changed files:

```bash
git -C <repo> show --stat --pretty="%h%n%s%n%n%b" <hash>
```

The changed paths usually name the workstream when the subject doesn't.

### 5. Collapse duplicates

One piece of work is one entry. Amends, rebases, cherry-picks, and
`fix typo` follow-ups to the same change collapse together: same subject or same
patch across branches is one item. Merge commits are already excluded by
`--no-merges`.

### 6. Match and fill the gaps

Pair each commit with the note for its date by project, issue, MR, release, or
workstream. Then add the work that leaves no commits at all: meetings, reviews,
investigations, incidents, ops chores. That is most of what the notes are for,
and it is the half a git log can never show.

## Output

One heading per date in the range, oldest first, no date skipped. Under each,
group by project or workstream, and describe the outcome: what is now true that
wasn't true that morning. Carry the identifier when one exists — issue, MR,
release tag, short hash.

```markdown
## 2026-08-18 · Tuesday

**upload-service**
- Resume now reads the manifest the client wrote, five private helpers gone.
  `a1b2c3d`, MR !412
- Reviewed the retry-budget MR, blocked on the fixture question. [[2026-08-18]]

**Planned, not landed**
- Checksum backfill, carried to Wednesday.
```

Above the days, state the resolved range and every gap in one place: notes that
don't exist, repos that wouldn't read. Below them, a short weekly summary when
the week has a shape worth naming; skip it when it would just re-list the days.

Days with nothing say so explicitly — `No daily note`, `No relevant commits` —
so a blank Thursday reads as missing evidence. Phrase every bullet by the
**write-clearly** skill: front-loaded, one idea, no padding.

## Rules

- **Evidence or nothing.** Every claim traces to a note line or a commit. A
  plausible-sounding day that no source supports is fabrication, and it is worse
  than a gap because the user will sign it.
- **Commit count is not effort.** One commit can be a week; forty can be an
  afternoon of rebasing. Never rank or size a day by how many there are.
- **No hours.** Estimate time only when the user asks *and* supplies the basis
  to estimate from.
- **Read-only.** Editing notes, submitting a timesheet, or touching a tracker
  needs a separate, explicit ask.
- **Summarise, don't leak.** Notes hold unrelated threads, personal entries,
  secrets, and internal URLs. Pull the work relevant to the range and leave the
  rest in the file.

## Done when

Every date in the range appears with either work or a named gap, every claim
carries its note link, hash, or identifier, planned work sits apart from
completed work, duplicate commits appear once, and the result needs only light
editing before it goes into the timesheet.
