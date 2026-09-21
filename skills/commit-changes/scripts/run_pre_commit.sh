#!/usr/bin/env bash
# Run the repo's pre-commit hooks against staged files, whether or not
# pre-commit is installed into .git/hooks. `git commit -F -` triggers
# installed hooks like any other commit, but a repo that has
# .pre-commit-config.yaml without `pre-commit install` run once has no
# hook to trigger, so this calls the tool directly.
set -euo pipefail

[ -f .pre-commit-config.yaml ] || exit 0

if ! command -v pre-commit >/dev/null 2>&1; then
  echo "run_pre_commit.sh: .pre-commit-config.yaml exists but pre-commit is not installed" >&2
  exit 1
fi

staged=$(git diff --cached --name-only --diff-filter=ACM)
[ -n "$staged" ] || exit 0

# shellcheck disable=SC2086
pre-commit run --files $staged
