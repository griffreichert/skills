#!/usr/bin/env bash
# Install these skills into ~/.claude/skills/ as symlinks.
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$dest"
for d in "$repo"/skills/*/; do
  n="$(basename "$d")"
  ln -sfn "$d" "$dest/$n"
  echo "linked $n"
done
