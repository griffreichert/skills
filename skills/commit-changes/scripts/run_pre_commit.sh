#!/usr/bin/env bash
# Run the repo's pre-commit hooks against staged files, whether or not
# pre-commit is installed into .git/hooks. `git commit -F -` triggers
# installed hooks like any other commit, but a repo that has
# .pre-commit-config.yaml without `pre-commit install` run once has no
# hook to trigger, so this calls the tool directly.
#
# Runner order: PATH, the repo's .venv, then uv when uv.lock pins a runner.
# Both runners read the same config and arguments.
set -euo pipefail

[ -f .pre-commit-config.yaml ] || exit 0

staged=$(git diff --cached --name-only --diff-filter=ACM)
[ -n "$staged" ] || exit 0

if command -v pre-commit >/dev/null 2>&1; then
  runner=(pre-commit)
elif command -v prek >/dev/null 2>&1; then
  runner=(prek)
elif [ -x .venv/bin/pre-commit ]; then
  runner=(.venv/bin/pre-commit)
elif [ -x .venv/bin/prek ]; then
  runner=(.venv/bin/prek)
elif [ -f uv.lock ] && grep -qx 'name = "pre-commit"' uv.lock \
  && command -v uv >/dev/null 2>&1; then
  # pre-commit can sit in any dependency group or extra, so sync all of them.
  uv sync --frozen --all-packages --all-groups --all-extras
  runner=(uv run --no-sync pre-commit)
elif [ -f uv.lock ] && grep -qx 'name = "prek"' uv.lock \
  && command -v uv >/dev/null 2>&1; then
  # prek can sit in any dependency group or extra, so sync all of them.
  uv sync --frozen --all-packages --all-groups --all-extras
  runner=(uv run --no-sync prek)
else
  cat >&2 <<'EOF'
run_pre_commit.sh: .pre-commit-config.yaml exists but no hook runner was found.
Checked: PATH, .venv/bin, then both runners in uv.lock with uv.
Install one (`uv tool install pre-commit` or `uv tool install prek`), or add
a runner to the repo's dev dependencies, then rerun.
EOF
  exit 1
fi

# shellcheck disable=SC2086
"${runner[@]}" run --files $staged
