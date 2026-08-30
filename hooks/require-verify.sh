#!/usr/bin/env bash
# Stop hook — refuse to end the turn while Godot source changed and nothing was verified.
#
# This is the pack's founding rule ("never claim done without running it") turned from
# prose into enforcement. Exit 2 blocks the stop and hands stderr back to the model.
set -uo pipefail

payload="$(cat)"

# Never block twice for the same turn — one nudge, then get out of the way.
active="$(printf '%s' "$payload" \
  | python3 -c 'import json,sys;print(json.load(sys.stdin).get("stop_hook_active",False))' 2>/dev/null || echo True)"
[ "$active" = "True" ] && exit 0

d="${CLAUDE_PROJECT_DIR:-$PWD}"; ROOT=""
for _ in 1 2 3 4 5; do
  [ -f "$d/project.godot" ] && { ROOT="$d"; break; }
  [ "$d" = "/" ] && break
  d="$(dirname "$d")"
done
[ -n "$ROOT" ] || exit 0

# Can't enforce what can't be run. If no engine binary is reachable, stay silent —
# the UserPromptSubmit hook has already stated the rule.
GODOT="${GODOT_BIN:-}"
if [ -z "$GODOT" ]; then
  for c in godot godot4 /Applications/Godot.app/Contents/MacOS/Godot; do
    command -v "$c" >/dev/null 2>&1 && { GODOT="$c"; break; }
    [ -x "$c" ] && { GODOT="$c"; break; }
  done
fi
[ -n "$GODOT" ] || exit 0

STAMP="$ROOT/.godot/verify-stamp"
[ -f "$STAMP" ] || exit 0   # no baseline yet (SessionStart hook not installed) — don't block

# Resolve verify.sh for both repo layout and post-install flattened layout.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERIFY=""
for p in "$HERE/../skills/engineering/godot-verify/scripts/verify.sh" \
         "$HERE/../skills/godot-verify/scripts/verify.sh" \
         "$HERE/../godot-verify/scripts/verify.sh"; do
  [ -f "$p" ] && { VERIFY="$(cd "$(dirname "$p")" && pwd)/$(basename "$p")"; break; }
done

changed="$(find "$ROOT" \
  \( -path "$ROOT/.godot" -o -path "$ROOT/addons" -o -name '.git' \) -prune -o \
  -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) -newer "$STAMP" -print 2>/dev/null)"
[ -n "$changed" ] || exit 0

count="$(printf '%s\n' "$changed" | grep -c .)"
{
  echo "Stop blocked by godot-agent-skills: $count Godot source file(s) changed this session"
  echo "and no verification has run since. Unverified GDScript is a guess with syntax highlighting."
  echo
  printf '%s\n' "$changed" | sed "s|^$ROOT/|  |" | head -8
  [ "$count" -gt 8 ] && echo "  ... and $((count - 8)) more"
  echo
  if [ -n "$VERIFY" ]; then
    echo "Run:  $VERIFY \"$ROOT\""
  else
    echo "Run:  $GODOT --headless --path \"$ROOT\" --import && $GODOT --headless --path \"$ROOT\" --quit"
  fi
  echo
  echo "Then report what it actually printed — the real error text, not a paraphrase."
  echo "If it genuinely cannot run here, say that explicitly in your reply and stop."
} >&2
exit 2
