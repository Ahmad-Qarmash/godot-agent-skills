#!/usr/bin/env bash
# Headless verification for a Godot 4 project.
# Usage: ./verify.sh [project-dir] [test-dir]
#
# Writes <project>/.godot/verify-stamp on completion. The Stop hook in this pack reads
# that stamp to decide whether anything changed since the last verification.
set -uo pipefail

PROJECT_DIR="${1:-.}"
TEST_DIR="${2:-res://test}"

GODOT="${GODOT_BIN:-}"
if [ -z "$GODOT" ]; then
  for c in godot godot4 /Applications/Godot.app/Contents/MacOS/Godot; do
    if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then GODOT="$c"; break; fi
  done
fi
if [ -z "$GODOT" ]; then
  echo "godot binary not found. Set GODOT_BIN to the full path." >&2
  exit 127
fi

LOG="$(mktemp -t godot_verify.XXXXXX)"
trap 'rm -f "$LOG"' EXIT
fail=0

# Real errors only. Godot prints plenty of benign "ERROR:" lines on startup (audio driver,
# vulkan, first-run cache), so matching bare ERROR: produces false failures.
ERR_RE='SCRIPT ERROR|Parse Error|Failed to load|Cannot open file|Resource file not found'

echo "== import assets =="
# A fresh clone has no .godot/ cache. Running the project does NOT import — importing is an
# editor pass. Without this, an export or run silently comes up with missing assets.
if ! "$GODOT" --headless --path "$PROJECT_DIR" --import 2>&1 | tee "$LOG"; then
  echo "-- --import unavailable on this build, falling back to --editor --quit"
  "$GODOT" --headless --path "$PROJECT_DIR" --editor --quit 2>&1 | tee "$LOG"
fi

echo "== project loads =="
"$GODOT" --headless --path "$PROJECT_DIR" --quit 2>&1 | tee "$LOG"
if [ "${PIPESTATUS[0]}" -ne 0 ] || grep -qE "$ERR_RE" "$LOG"; then
  echo "FAIL: project did not load cleanly" >&2
  fail=1
fi

if [ -d "$PROJECT_DIR/addons/gdUnit4" ]; then
  echo "== gdunit4 =="
  "$GODOT" --headless --path "$PROJECT_DIR" \
    -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a "$TEST_DIR" || fail=1
elif [ -d "$PROJECT_DIR/addons/gut" ]; then
  echo "== gut =="
  "$GODOT" --headless --path "$PROJECT_DIR" \
    -s res://addons/gut/gut_cmdln.gd -gdir="$TEST_DIR" -gexit || fail=1
else
  echo "no test framework detected (looked for addons/gdUnit4, addons/gut)"
  echo "load and parse checks only — say so rather than implying the tests passed"
fi

# Stamp on every run, pass or fail. The point of the gate is that verification happened;
# a failing run that gets reported honestly is a legitimate place to stop.
mkdir -p "$PROJECT_DIR/.godot" 2>/dev/null && : > "$PROJECT_DIR/.godot/verify-stamp" 2>/dev/null

exit "$fail"
