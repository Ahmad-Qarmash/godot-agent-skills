#!/usr/bin/env bash
# Wire the godot-agent-skills control layer into a settings.json.
#
# Usage: ./scripts/install-hooks.sh [settings-file]
#   default: ./.claude/settings.json  (project-local, commit it with the game)
#   user-wide: ./scripts/install-hooks.sh ~/.claude/settings.json
#
# Not needed if the pack is installed as a Claude Code plugin — hooks/hooks.json is
# picked up automatically. This is for the install.sh / copied-skills path.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$PWD/.claude/settings.json}"
mkdir -p "$(dirname "$TARGET")"

python3 - "$ROOT" "$TARGET" <<'PY'
import json, os, sys, shutil

root, target = sys.argv[1], sys.argv[2]
src = json.load(open(os.path.join(root, "hooks", "hooks.json")))["hooks"]

settings = {}
if os.path.exists(target) and os.path.getsize(target):
    with open(target) as f:
        settings = json.load(f)
    shutil.copy(target, target + ".bak")
    print(f"  backed up {target} -> {target}.bak")

hooks = settings.setdefault("hooks", {})
marker = os.path.join(root, "hooks")
added = replaced = 0

for event, groups in src.items():
    existing = hooks.setdefault(event, [])
    # Drop any prior entries from this pack so re-running is idempotent and does not
    # disturb hooks other packs registered on the same event.
    before = len(existing)
    existing[:] = [
        g for g in existing
        if not any(marker in str(h.get("command", "")) for h in g.get("hooks", []))
    ]
    replaced += before - len(existing)
    for g in groups:
        g = json.loads(json.dumps(g).replace("${CLAUDE_PLUGIN_ROOT}", root))
        existing.append(g)
        added += 1

with open(target, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")

print(f"  {added} hook group(s) installed" + (f", {replaced} previous replaced" if replaced else ""))
print(f"  events: {', '.join(src)}")
for event, groups in hooks.items():
    other = sum(1 for g in groups for h in g.get("hooks", []) if marker not in str(h.get("command", "")))
    if other:
        print(f"  note: {other} hook(s) from other packs on {event} left in place")
PY

echo
echo "Wrote $TARGET"
echo "Restart Claude Code, or run /hooks to confirm they are registered."
