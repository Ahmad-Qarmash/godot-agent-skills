#!/usr/bin/env bash
# Install godot-agent-skills into an agent's skills directory.
# Skills are flat in this repo, so this is a straight copy of each skill folder.
# Usage: ./scripts/install.sh [target-dir]   (default: ~/.claude/skills)
set -euo pipefail

TARGET="${1:-$HOME/.claude/skills}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$TARGET"

count=0
while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"
  rm -rf "${TARGET:?}/$skill_name"
  cp -r "$skill_dir" "$TARGET/$skill_name"
  echo "  installed $skill_name"
  count=$((count + 1))
done < <(find "$ROOT/skills" -name SKILL.md -type f | sort)

echo
echo "$count skills installed to $TARGET"
echo "Restart your agent to pick them up."
echo
echo "The control layer (hooks) is installed separately:"
echo "  ./scripts/install-hooks.sh [settings.json]"
echo "Not needed if you installed this as a Claude Code plugin."
