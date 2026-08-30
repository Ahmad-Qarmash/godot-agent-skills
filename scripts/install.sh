#!/usr/bin/env bash
# Install godot-agent-skills into an agent's skills directory.
# Skills are flat in this repo, so this is a straight copy of each skill folder.
#
# Usage:
#   ./scripts/install.sh                                   all -> ~/.claude/skills
#   ./scripts/install.sh <target-dir>                       all -> <target-dir>
#   ./scripts/install.sh <target-dir> <skill> [skill ...]   only those skills
#   ./scripts/install.sh --list                             show available skill names
#
# Selecting a subset requires naming the target explicitly, so the arguments are
# never ambiguous between "a directory" and "a skill".
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

available() { find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort; }

if [ "${1:-}" = "--list" ] || [ "${1:-}" = "-l" ]; then
  available
  exit 0
fi

TARGET="${1:-$HOME/.claude/skills}"
shift || true
WANTED=("$@")

# Fail before copying anything if a name is wrong — a half-install is worse than none.
if [ "${#WANTED[@]}" -gt 0 ]; then
  bad=0
  for name in "${WANTED[@]}"; do
    [ -f "$ROOT/skills/$name/SKILL.md" ] || { echo "unknown skill: $name" >&2; bad=1; }
  done
  if [ "$bad" -ne 0 ]; then
    echo >&2
    echo "available:" >&2
    available | sed 's/^/  /' >&2
    exit 1
  fi
fi

mkdir -p "$TARGET"

count=0
while IFS= read -r name; do
  if [ "${#WANTED[@]}" -gt 0 ]; then
    match=0
    for w in "${WANTED[@]}"; do [ "$w" = "$name" ] && { match=1; break; }; done
    [ "$match" -eq 1 ] || continue
  fi
  rm -rf "${TARGET:?}/$name"
  cp -r "$ROOT/skills/$name" "$TARGET/$name"
  echo "  installed $name"
  count=$((count + 1))
done < <(available)

echo
echo "$count skill(s) installed to $TARGET"

if [ "${#WANTED[@]}" -gt 0 ]; then
  echo "Note: using-godot-skills references the other skills; its tables will point at"
  echo "      skills you did not install. Edit them to match, or install it last."
fi

echo
echo "The control layer (hooks) is installed separately:"
echo "  ./scripts/install-hooks.sh [settings.json]"
echo "Not needed if you installed this as a Claude Code plugin."
