#!/usr/bin/env python3
"""Check the skills against the conventions in AGENTS.md."""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent
# Domain names retired from the examples. Add to this list when you retire more.
RETIRED = [
    "openpyxl", "XLSX", "Xlsx", "xlsx", "worksheet", "Worksheet", "tabular",
    "CustomExcelReader", "TableNode", "TableSummary", "CellRange",
    "chunk_index", "two-table", "DocumentStager",
]
BULLET_WORDS = 250
# Corrective juxtaposition and the other tics write-clearly bans.
BANNED = [
    r", not ", r" rather than ", r"isn't [a-z]+, it's", r"not just .*, it's",
    r"\bactually\b", r"\bgenuinely\b", r"\bsimply\b", r"\bobviously\b",
    r"Short answer", r"TL;DR", r"Bottom line",
]


def bullets(lines: list[str]) -> list[tuple[int, list[str]]]:
    """Split a SKILL.md into its top-level bullets, keyed by start line."""
    found, start = [], None
    for i, line in enumerate(lines):
        if line.startswith("- **"):
            if start is not None:
                found.append((start + 1, lines[start:i]))
            start = i
        elif start is not None and line and not line[0].isspace():
            found.append((start + 1, lines[start:i]))
            start = None
    if start is not None:
        found.append((start + 1, lines[start:]))
    return found


def main() -> int:
    problems: list[str] = []
    warnings: list[str] = []
    skills = sorted(p for p in (ROOT / "skills").iterdir() if p.is_dir())
    manifest = json.loads((ROOT / ".claude-plugin" / "plugin.json").read_text())
    registered = {s.rsplit("/", 1)[-1] for s in manifest["skills"]}
    readme = (ROOT / "README.md").read_text()

    for skill in skills:
        name = skill.name
        doc = skill / "SKILL.md"
        if not doc.exists():
            problems.append(f"{name}: no SKILL.md")
            continue

        text = doc.read_text()
        front = text.split("---")[1] if text.startswith("---") else ""
        for key in ("name:", "description:"):
            if key not in front:
                problems.append(f"{doc}: frontmatter has no {key}")

        if name not in registered:
            problems.append(f"{name}: missing from .claude-plugin/plugin.json")
        if f"skills/{name}/SKILL.md" not in readme:
            problems.append(f"{name}: missing from README.md")

        for term in RETIRED:
            for i, line in enumerate(text.split("\n"), 1):
                if term in line:
                    problems.append(f"{doc}:{i}: retired example name {term!r}")

        # write-clearly quotes every pattern it bans, so it is exempt.
        if name != "write-clearly":
            for i, line in enumerate(text.split("\n"), 1):
                if line.lstrip().startswith(("#", "|", "```")):
                    continue
                for pattern in BANNED:
                    if re.search(pattern, line):
                        warnings.append(
                            f"{doc}:{i}: write-clearly bans {pattern!r}"
                        )

        for line_no, block in bullets(text.split("\n")):
            body = "\n".join(block)
            fences = len(re.findall(r"^\s*```python", body, re.M))
            if fences > 1:
                problems.append(
                    f"{doc}:{line_no}: {fences} code blocks in one bullet, "
                    "merge them or split the rule"
                )
            words = len(body.split())
            if words > BULLET_WORDS:
                problems.append(
                    f"{doc}:{line_no}: bullet is {words} words "
                    f"(over {BULLET_WORDS}), name what it replaces"
                )

    for name in registered - {s.name for s in skills}:
        problems.append(f"{name}: in plugin.json, no such directory")

    for problem in problems:
        print(problem)
    if warnings:
        print("\nprose, decide case by case (write-clearly budgets one):")
        for warning in warnings:
            print(f"  {warning}")
    print(f"\n{len(skills)} skills, {len(problems)} problems, "
          f"{len(warnings)} prose warnings")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
