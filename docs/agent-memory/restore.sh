#!/usr/bin/env bash
# Seed Claude Code's per-project memory for this repository from docs/agent-memory/.
# Claude Code keys memory by the absolute project path (every non-alphanumeric character becomes "-"),
# so notes written while TrashScribe lived in ~/LENTE are invisible from the new location.
# Usage: bash docs/agent-memory/restore.sh [--dry-run]     (run it after the folder is in its final place)
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
slug="$(printf '%s' "$repo" | sed 's#[^A-Za-z0-9]#-#g')"
dest="$HOME/.claude/projects/$slug/memory"
dry=0; [ "${1:-}" = "--dry-run" ] && dry=1
echo "repository : $repo"
echo "memory dir : $dest"
[ $dry -eq 1 ] || mkdir -p "$dest"
for f in "$here"/*.md; do
  b="$(basename "$f")"
  [ "$b" = README.md ] && continue
  if [ -e "$dest/$b" ]; then
    echo "kept       : $b (already there, not overwritten)"
  elif [ $dry -eq 1 ]; then
    echo "would copy : $b"
  else
    cp "$f" "$dest/$b"; echo "copied     : $b"
  fi
done
echo "If Claude Code does not show these notes, open it once in the repository, run"
echo "  ls -t ~/.claude/projects | head -3"
echo "and copy the .md files into the memory/ folder of the newest entry."
