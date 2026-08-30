#!/usr/bin/env bash
# SessionStart hook — mark the verification baseline for this session.
#
# Anything edited after this point counts as unverified until verify.sh runs.
# Edits made outside a session (by a human, in the editor) are not policed.
set -uo pipefail
cat >/dev/null 2>&1 || true

d="${CLAUDE_PROJECT_DIR:-$PWD}"
for _ in 1 2 3 4 5; do
  if [ -f "$d/project.godot" ]; then
    mkdir -p "$d/.godot" 2>/dev/null && : > "$d/.godot/verify-stamp" 2>/dev/null
    exit 0
  fi
  [ "$d" = "/" ] && break
  d="$(dirname "$d")"
done
exit 0
