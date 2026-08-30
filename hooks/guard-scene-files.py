#!/usr/bin/env python3
"""PreToolUse hook — deny structural hand-edits to Godot scene and resource files.

Mirrors the "do not do by hand" list in the godot-scene-surgery skill. Scalar property
edits and [connection] lines pass through untouched; the edits that silently corrupt a
project (ids, load_steps, uid://, node blocks) are blocked with the reason attached.

Blocking beats advising here: a skill has to trigger, a hook does not.
"""
import json
import re
import sys

SCENE_EXT = (".tscn", ".tres")

# (regex, what the model should do instead)
STRUCTURAL = [
    (re.compile(r"uid://"),
     "uid:// is the file's stable identity. Never invent, copy, or edit one — two files "
     "sharing a uid corrupts the project's uid cache in .godot/. If a uid looks wrong, "
     "delete the whole line and let the editor regenerate it."),
    (re.compile(r"^\s*\[gd_(scene|resource)\b.*load_steps\s*=", re.M),
     "load_steps must match the number of resource blocks. Do not compute it by hand — "
     "open and resave the scene in the editor, which regenerates it correctly."),
    (re.compile(r"^\s*\[(ext_resource|sub_resource)\b", re.M),
     "Adding, removing, or renumbering an ext_resource/sub_resource block also changes "
     "load_steps and every ExtResource(\"id\")/SubResource(\"id\") reference. Do it in the "
     "editor, or from a @tool script using ResourceSaver.save()."),
    (re.compile(r"^\s*\[node\b", re.M),
     "Adding, removing, or renaming a node means every child's parent= path, every "
     "[connection], and every NodePath() property pointing at it must change in the same "
     "pass. Use the editor, or a @tool script / EditorScript with add_child()."),
]


def payload_text(tool_name, ti):
    if tool_name == "Write":
        return ti.get("content", "") or ""
    if tool_name == "MultiEdit":
        parts = []
        for e in ti.get("edits", []) or []:
            parts.append(e.get("old_string", "") or "")
            parts.append(e.get("new_string", "") or "")
        return "\n".join(parts)
    return (ti.get("old_string", "") or "") + "\n" + (ti.get("new_string", "") or "")


def deny(reason):
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason,
    }}, sys.stdout)
    sys.exit(0)


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        sys.exit(0)  # never block on a parse failure

    tool = data.get("tool_name", "")
    ti = data.get("tool_input") or {}
    path = ti.get("file_path", "") or ""
    if not path.endswith(SCENE_EXT):
        sys.exit(0)

    if tool == "Write":
        deny(
            f"Blocked: Write would replace all of {path} wholesale. Regenerating a scene "
            "file from scratch loses uids, ids, and load_steps consistency, and the "
            "resulting load error points at the wrong place. Change it in the editor, or "
            "build it from a @tool script with add_child() + ResourceSaver.save(). See the "
            "godot-scene-surgery skill. Use Edit for a scalar property change instead."
        )

    text = payload_text(tool, ti)
    for pattern, guidance in STRUCTURAL:
        if pattern.search(text):
            deny(
                f"Blocked: structural edit to {path}. {guidance}\n\n"
                "Safe to edit by hand: scalar property values on an existing node "
                "(position = Vector2(10, 20)), and [connection] lines for a signal that "
                "already exists. Everything else goes through the editor or a @tool "
                "script. Read the godot-scene-surgery skill before retrying."
            )

    sys.exit(0)


if __name__ == "__main__":
    main()
