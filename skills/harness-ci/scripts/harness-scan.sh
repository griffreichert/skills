#!/usr/bin/env bash
# Harness evidence scanner. Walks Claude Code and Codex transcripts and emits
# candidates for harness-ci: assistant prose the user pushed back on, and
# assistant prose matching a construct the global instructions ban, and the
# assistant prose before a user message tagged PAPERCUT.
#
# Usage: harness-scan.sh [--since YYYY-MM-DD] [--agent claude|codex|all] [--project SLUG]
# Output: TSV — kind, agent, timestamp, transcript, assistant text, user reaction
#
# Rows dedupe on the user reaction (pushback) or sentence (pattern), keeping
# the earliest. Codex copies a thread's history into every forked rollout.
#
# LC_ALL=C throughout: transcripts carry non-UTF8 bytes and sort rejects them.
set -uo pipefail
export LC_ALL=C

claude_root="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
codex_root="${CODEX_SESSIONS_DIR:-$HOME/.codex/sessions}"
since="0000-00-00"
agent="all"
project="*"

while [ $# -gt 0 ]; do
  case "$1" in
    --since)   since="$2"; shift 2 ;;
    --agent)   agent="$2"; shift 2 ;;
    --project) project="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Claude Code: ~/.claude/projects/<slug>/<session-id>.jsonl, one JSON object
# per event, message text under .message.content.
extract_claude() {
  for f in "$claude_root"/$project/*.jsonl; do
    [ -f "$f" ] || continue
    jq -r --arg file "$f" '
      select(.type=="user" or .type=="assistant")
      | . as $m
      | ($m.message.content
         | if type=="string" then . else (map(select(.type=="text").text) | join(" ")) end
         | gsub("<system-reminder>.*?</system-reminder>"; ""; "s")) as $t
      | select($t != null and ($t | length) > 0)
      | [$m.type, "claude", ($m.timestamp // ""), $file,
         ($t | gsub("[\\t\\n\\r]"; " ") | gsub("  +"; " "))]
      | @tsv' "$f" 2>/dev/null
  done
}

# Codex: ~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl, message text under
# .payload.content[].text. The date is in the path, so prune there — the tree
# is ~1GB and jq over all of it is the slow part.
extract_codex() {
  find "$codex_root" -name "rollout-*.jsonl" 2>/dev/null | while read -r f; do
    d=$(printf '%s' "$f" | sed -n 's|.*/\([0-9]\{4\}\)/\([0-9]\{2\}\)/\([0-9]\{2\}\)/.*|\1-\2-\3|p')
    [ -n "$d" ] && [ "$d" \< "$since" ] && continue
    jq -r --arg file "$f" '
      select(.type=="response_item" and .payload.type=="message")
      | select(.payload.role=="user" or .payload.role=="assistant")
      | . as $m
      | ([$m.payload.content[]? | (.text // "")] | join(" ")) as $t
      | select($t != null and ($t | length) > 0)
      | [$m.payload.role, "codex", ($m.timestamp // ""), $file,
         ($t | gsub("[\\t\\n\\r]"; " ") | gsub("  +"; " "))]
      | @tsv' "$f" 2>/dev/null
  done
}

extract() {
  case "$agent" in
    claude) extract_claude ;;
    codex)  extract_codex ;;
    all)    extract_claude; extract_codex ;;
    *) echo "unknown agent: $agent" >&2; exit 2 ;;
  esac
}

# Prose constructs from ~/.claude/CLAUDE.md "How you talk", the same set the
# prose-check.sh Stop hook enforces, when the dotfiles carry one. No \b: macOS awk is POSIX ERE only.
banned=', not [a-z]|rather than|—|(^| )(short answer|tl;?dr|bottom line|in short)|(^| )(good|great|fair) (question|point)|(^| )(makes sense|you.?re right|exactly)( |,)|( |^)(actually|genuinely|truly|obviously|simply)( |,|\.)|(is|.s) the whole [a-z]|the whole (fix|finding|point|content|thing) (is|here)|the real (problem|question|issue|answer|point) is|the only (thing|part|one) that (matters|counts)|which is the propert|(your|my) call|(is|are) (genuinely |all )?yours|shouldn.t decide|is not( just)? [a-z]+, it.?s|not( just)? [a-z-]+ but'

# User reactions that mark a papercut, however they are phrased.
pushback='(^| )(stop|dont|don.t|do not|no need|unnecessary|uneccesary|hate|annoying|cut|shorter|too long|wtf|fuck|preamble|robotic|slop|waste of words|get to the point|speak normally|i don.?t care)( |,|\.|!|$)'

tmp=$(mktemp -t harness-scan)
trap 'rm -f "$tmp"' EXIT
extract > "$tmp"

# The tag as a standalone token. A quoted mention in a message about the tag
# does not match, and neither does the rule text.
tag='(^| )PAPERCUT([ ,.;:!?]|$)'

# Tagged: a user message carrying the tag, with the assistant prose before it.
# Pushback: an assistant message the next user message complained about.
awk -F'\t' -v since="$since" -v pushback="$pushback" -v tag="$tag" '
  $5 ~ /^(<|Caveat:|# AGENTS.md|\[Request interrupted)/ { next }   # injected context, not prose
  substr($3,1,10) < since { next }
  {
    if ($1 == "assistant") { at=$5; ag=$2; ts=$3; tf=$4; next }
    if ($1 == "user") {
      react = " " tolower($5) " "
      if ($5 ~ tag)
        printf "tagged\t%s\t%s\t%s\t%s\t%s\n", $2, $3, $4, substr(at,1,600), substr($5,1,600)
      else if (at != "" && length($5) < 400 && react ~ pushback)
        printf "pushback\t%s\t%s\t%s\t%s\t%s\n", ag, ts, tf, substr(at,1,600), substr($5,1,300)
      at=""
    }
  }
' "$tmp" | sort | awk -F'\t' '!seen[$6]++'

# Pattern: a banned construct, with no user reaction attached.
awk -F'\t' -v since="$since" -v banned="$banned" '
  $1 != "assistant" { next }
  substr($3,1,10) < since { next }
  {
    n = split($5, s, /\. /)
    for (i = 1; i <= n; i++) {
      line = " " tolower(s[i]) " "
      if (line ~ banned)
        printf "pattern\t%s\t%s\t%s\t%s\t\n", $2, $3, $4, substr(s[i],1,300)
    }
  }
' "$tmp" | sort | awk -F'\t' '!seen[$5]++'
