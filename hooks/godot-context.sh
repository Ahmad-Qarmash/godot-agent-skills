#!/usr/bin/env bash
# UserPromptSubmit hook — the control layer.
#
# A router SKILL.md only routes if it wins a triggering contest against every other
# installed pack's router. This does not: it runs on every prompt, before the model
# sees anything, and its stdout is added to the prompt as context.
#
# Full rules once per session; a one-line reminder after that, to stay cheap.
set -uo pipefail

payload="$(cat)"

find_root() {
  local d="${CLAUDE_PROJECT_DIR:-$PWD}"
  for _ in 1 2 3 4 5; do
    [ -f "$d/project.godot" ] && { printf '%s' "$d"; return 0; }
    [ "$d" = "/" ] && break
    d="$(dirname "$d")"
  done
  return 1
}

ROOT="$(find_root)" || exit 0   # not a Godot project — stay silent

VERSION="$(grep -m1 '^config/features' "$ROOT/project.godot" 2>/dev/null \
           | grep -oE '4\.[0-9]+' | head -1)"
: "${VERSION:=unknown}"

SID="$(printf '%s' "$payload" \
       | python3 -c 'import json,sys;print(json.load(sys.stdin).get("session_id","x"))' 2>/dev/null || echo x)"
STATE="${TMPDIR:-/tmp}/godot-agent-skills-$SID.seen"

if [ -f "$STATE" ]; then
  echo "[godot-agent-skills] Godot $VERSION project. Standing rules still apply: verify before claiming done; no structural .tscn/.tres edits by hand; treat non-$VERSION API advice as unverified."
  exit 0
fi
: > "$STATE"

cat <<CTX
[godot-agent-skills] Godot project detected at $ROOT — engine version $VERSION.

Standing rules for this session. These come from the installed control layer, not from a
skill that may or may not have loaded, and two of them are enforced by hooks:

1. VERIFY BEFORE CLAIMING. Never write "works", "fixed", or "done" about Godot code you
   have not executed. Run the verification and report what it actually printed, or say
   plainly that you could not run it. A Stop hook blocks the turn if source files changed
   and nothing was verified.

2. DO NOT HAND-EDIT SCENE STRUCTURE. Changing a scalar property in a .tscn/.tres is fine.
   Touching ext_resource / sub_resource ids, load_steps, uid://, or node blocks is not —
   a PreToolUse hook denies those edits. Use the editor or a @tool script instead, and
   read the godot-scene-surgery skill first.

3. THIS PROJECT IS GODOT $VERSION. Other installed packs pin different versions
   (awesome-gamedev pins 4.7). Treat any API detail from them as unverified here and
   check it against $VERSION before using it. Godot 3 API leaking into generated GDScript
   is the single most common failure — see the godot4-api-guard skill.

4. PLAN THEN LOOP. Non-trivial work gets a plan first (write-plan). Implementation runs
   one verifiable increment at a time (build-loop), never a large unverified batch.

Skill precedence when installed packs overlap or disagree:
  .tscn / .tres / uid://        -> godot-scene-surgery   (no other pack covers this)
  Godot 3 -> 4 API translation  -> godot4-api-guard      (no other pack covers this)
  running, testing, verifying   -> godot-verify, then the Randroids godot skill
                                   (GdUnit4, PlayGodot) for the actual mechanism
  planning, critique, handoff   -> write-plan, grill-me, build-loop, session-handoff
  GDScript idiom, nodes, physics, UI, shaders, audio, export, optimization
                                -> defer to godot-prompter / awesome-gamedev skills,
                                   subject to rule 3
CTX
