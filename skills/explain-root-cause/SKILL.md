---
name: explain-root-cause
description: Explain a confirmed bug cause as an ordered causal chain, with primary evidence beside every link. Use once a root cause is confirmed, before reporting it to the user or writing it into a commit or MR, and especially after a dependency upgrade, a regression between known versions, a failure between interacting libraries, or an incident with a known deployment sequence.
---

# Explain the Root Cause

Use this once the cause is confirmed: a red loop, a bisect result, a probe that
split the hypotheses. The debugging found the cause. This skill shapes the
explanation handed to the user, the commit, and the MR.

"The upgrade broke uploads" names a suspect. A maintainer who was not in the
session cannot check it, and cannot tell which change to revert or which
assumption to fix. The chain gives them both.

## The chain

One sentence per link, in the order the behaviour changed:

1. **The old contract.** What the failing code relied on, and what promised it.
2. **The first change.** The version, commit, deployment, configuration change,
   or runtime event that changed behaviour, and the behaviour it produced.
3. **The later change.** What changed next, and how it interacts with the first.
4. **The stale assumption.** The code that still expects the old contract.
5. **The failure.** The exact error or wrong output, quoted.

Put the source beside each link. Drop a link that did not happen: a single
upstream change has no link 3. Never invent a link to fill the shape.

## Evidence

Cite primary sources, pinned so the link says the same thing next year:

- **Tagged source.** A file at the release tag or commit SHA. A link to the
  default branch moves.
- **The merged PR or commit** that made the change.
- **Official release notes or changelog.**
- **Standards and the library's own docs.**
- **Local evidence.** The loop output, a log line, a bisect result, `path:line`
  in this repo.

Issue threads, blog posts, forum answers, and memory are leads. Follow each to
one of the sources above, or leave it out.

A link with no source is an inference. Mark it **Inferred** and name what it
rests on.

## Without a version boundary

A stable internal bug has no release to cite. Keep the chain, and build its
links from requests, events, state transitions, or function boundaries, each
cited by `path:line` or loop output. Stop searching upstream once local evidence
proves the cause.

## Example

Before:

```text
The storage client upgrade broke resumed uploads.
```

After, with each bracket a link in the real report:

```text
Storage client 2.0 returned None from Uploader.resume() when the manifest
was unreadable [2.0 tagged source]. Version 2.1 made an unreadable manifest
raise ManifestError [2.1 release notes, PR]. Version 2.3 made resume() catch
ManifestError and return the raw manifest text [2.3 release notes, PR]. Our
resume handler still treats that return value as a parsed Manifest
[upload/resume.py:42]. The raw text reaches manifest.parts and raises
AttributeError: 'str' object has no attribute 'parts' [test output].
Inferred: a stale checksum makes the manifest unreadable, since every red run
carried one and no upstream source says so.
```

The same sentences go into the commit body and the MR, per **commit-changes**
and **draft-mr-description**.

## Done when

- Each sentence advances the chain from the old contract to the failure.
- Every external fact has a pinned primary source beside it.
- Every inference carries the **Inferred** mark and what it rests on.
- The chain names the first changed contract and the assumption that failed.
- A maintainer can verify every link without the debugging session.
