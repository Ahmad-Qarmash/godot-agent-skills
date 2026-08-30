# godot-agent-skills

A control layer for AI agents working in Godot 4.x, plus the few skills no other pack covers.

The same `SKILL.md` format loads in Claude Code, Cursor, Codex, Copilot, and other agents that
support Agent Skills. The hooks are Claude Code specific.

## Why

Generated GDScript fails in three predictable ways:

1. **Godot 3 API leaks in.** Most GDScript online is Godot 3, so `yield`, `.instance()`, and
   `export var` come out fluently and break immediately.
2. **Scene files get corrupted.** `.tscn` looks like editable INI. It is full of
   cross-references that must stay consistent.
3. **Nothing gets verified.** Code is written, declared working, and never run.

Other packs cover Godot's API surface well and in more depth than anything here would.
None of them covers these three. So this pack does these three, enforces them with hooks,
and delegates the rest.

## The control layer

Rules written in a `SKILL.md` only apply if that skill triggers — and with several packs
installed, ~140 skill descriptions compete for the same slot. Hooks do not compete. They run.

| Hook | Event | Effect |
|---|---|---|
| `godot-context.sh` | `UserPromptSubmit` | Injects the standing rules and the project's real engine version into every prompt. Full rules once per session, one line after that. Silent outside a Godot project. |
| `guard-scene-files.py` | `PreToolUse` | Denies structural `.tscn`/`.tres` edits — `uid://`, `load_steps`, `ext_resource`/`sub_resource` ids, node blocks — with the reason attached. Scalar property edits and `[connection]` lines pass through. |
| `require-verify.sh` | `Stop` | Blocks ending the turn while `.gd`/`.tscn`/`.tres` changed and nothing was verified. Nudges once per turn, never loops. |
| `verify-baseline.sh` | `SessionStart` | Marks the verification baseline for the session. |

The `PreToolUse` and `Stop` hooks are the pack's two founding rules turned from prose into
enforcement. Both degrade quietly: no Godot project, no engine binary, or malformed input and
they exit silently rather than blocking work.

## Skills

### engineering/ — what nothing else covers

| Skill | Purpose |
|---|---|
| `godot-scene-surgery` | Safe `.tscn`/`.tres` editing, uid and `load_steps` rules, merge-conflict handling |
| `godot4-api-guard` | Godot 3 → 4 translation tables, plus drift inside Godot 4's own minor versions |
| `godot-verify` | The verify-before-claiming rule; headless import, parse checks, GdUnit4/GUT, honest exit-code reading |

### productivity/ — workflow, engine-agnostic

| Skill | Purpose |
|---|---|
| `write-plan` | Reviewable plan before non-trivial work |
| `grill-me` | Stress-test a design before committing to it |
| `build-loop` | One change per verification cycle, so failures stay attributable |
| `session-handoff` | Compact state snapshot for resuming later |

### design/ — game design judgment

| Skill | Purpose |
|---|---|
| `game-feel-review` | Input buffering, coyote time, hitstop, camera, response curves |
| `loop-and-economy` | Core loop, sources/sinks, progression pacing, dominant strategies |

### router/

`using-godot-skills` — precedence rules and the delegation map for composing with other packs.

## Composing with other packs

This pack is built to sit **on top of** the larger Godot packs, not to replace them:

| Concern | Owner |
|---|---|
| GDScript idiom, nodes, physics, UI, shaders, audio, tilemaps, 3D, multiplayer | [GodotPrompter](https://github.com/jame581/GodotPrompter) (55 skills), [awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) (68) |
| Performance, export, CI, distribution | either of the above |
| Running tests — GdUnit4, PlayGodot, E2E | [Randroids-Dojo/Godot-Claude-Skills](https://github.com/Randroids-Dojo/Godot-Claude-Skills) |
| Scene-file surgery, Godot 3→4 guard, verification discipline, workflow, design | this pack |

**Known name collisions** if you install more than one pack into a flat skills directory:
this pack previously shipped `gdscript-patterns` (collides with GodotPrompter) and
`godot-export` (collides with awesome-gamedev). Both were removed for exactly that reason.

**Version skew is real.** awesome-gamedev pins Godot 4.7; GodotPrompter targets 4.3+. The
`UserPromptSubmit` hook reads `config/features` from your `project.godot` and states the actual
version every prompt, so advice pinned to another version gets treated as unverified.

## Install

```bash
git clone https://github.com/Qb-Lab/godot-agent-skills.git
cd godot-agent-skills
./scripts/install.sh ./.claude/skills      # skills, project-local
./scripts/install-hooks.sh                 # control layer -> ./.claude/settings.json
```

`install-hooks.sh` is idempotent and merges alongside hooks other packs registered on the same
event — it will not clobber GodotPrompter's `SessionStart` entry. As a Claude Code plugin,
`hooks/hooks.json` is picked up automatically and no hook install step is needed.

See [docs/INSTALLATION.md](docs/INSTALLATION.md) for manual paths and per-agent details.

## A note on the category folders

Skills live in `skills/<category>/<skill-name>/SKILL.md` for readability. Some agents discover
skills only one level deep, which is why `install.sh` flattens them to
`<skills-dir>/<skill-name>/SKILL.md` on install. The categories are a repo convention, not a
runtime feature — each skill also carries a `category:` field in its frontmatter.

## Status

Early. The hooks are tested against synthetic payloads; the skills are not yet eval-tested
against a real project. Version-specific claims are accurate to Godot 4.3 as far as they have
been checked. Verify against your engine version before relying on any specific API detail.

## Security

Read every `SKILL.md`, hook, and script before installing this or any other skill pack — this
one included, and with more care than usual, because it registers hooks that see every prompt
and can block tool calls. Agent skills are executable instructions with repository-level trust;
treat them as third-party code. Snyk's ToxicSkills research found prompt injection in a
substantial fraction of published skills across the ecosystem.

## License

MIT
