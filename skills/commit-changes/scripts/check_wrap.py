#!/usr/bin/env python3
"""Flag a commit message's subject or body lines that break the wrap limits
in commit-changes/SKILL.md: subject <= 72 chars, body <= 72 chars, trailers
and URLs exempt.

Usage: check_wrap.py <file>   (or pipe the message on stdin)
Exit 0 and silent when the message is clean. Exit 1 and print every
offending line otherwise.
"""

import re
import sys

SUBJECT_LIMIT = 72
BODY_LIMIT = 72
TRAILER = re.compile(r"^[A-Za-z][A-Za-z-]*:\s")


def check(lines: list[str]) -> list[str]:
    problems = []
    if lines and len(lines[0]) > SUBJECT_LIMIT:
        problems.append(f"subject: {len(lines[0])} chars: {lines[0]}")

    in_code = False
    for i, line in enumerate(lines[2:], start=3):
        if line.startswith("```"):
            in_code = not in_code
            continue
        if in_code or TRAILER.match(line) or "://" in line:
            continue
        if len(line) > BODY_LIMIT:
            problems.append(f"line {i}: {len(line)} chars: {line}")
    return problems


def main() -> int:
    text = open(sys.argv[1]).read() if len(sys.argv) > 1 else sys.stdin.read()
    problems = check(text.splitlines())
    for problem in problems:
        print(problem)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
