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

### Engineering — what nothing else covers

| Skill | Purpose |
|---|---|
| `godot-scene-surgery` | Safe `.tscn`/`.tres` editing, uid and `load_steps` rules, merge-conflict handling |
| `godot4-api-guard` | Godot 3 → 4 translation tables, plus drift inside Godot 4's own minor versions |
| `godot-verify` | The verify-before-claiming rule; headless import, parse checks, GdUnit4/GUT, honest exit-code reading |

### Productivity — workflow, engine-agnostic

| Skill | Purpose |
|---|---|
| `write-plan` | Reviewable plan before non-trivial work |
| `grill-me` | Stress-test a design before committing to it |
| `build-loop` | One change per verification cycle, so failures stay attributable |
| `session-handoff` | Compact state snapshot for resuming later |

### Design — game design judgment

| Skill | Purpose |
|---|---|
| `game-feel-review` | Input buffering, coyote time, hitstop, camera, response curves |
| `loop-and-economy` | Core loop, sources/sinks, progression pacing, dominant strategies |

### Router

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
```

### Everything, into your game repo

The recommended setup. Skills version alongside the code, and everyone who clones the game
gets them:

```bash
cd path/to/your-game
/path/to/godot-agent-skills/scripts/install.sh ./.claude/skills
/path/to/godot-agent-skills/scripts/install-hooks.sh
```

Then commit `.claude/`. First command installs all 10 skills; second wires the four hooks into
`./.claude/settings.json`.

### Everything, user-wide

Available in every project. The hooks stay silent outside Godot projects, so this is safe:

```bash
./scripts/install.sh                                # -> ~/.claude/skills/
./scripts/install-hooks.sh ~/.claude/settings.json
```

### One skill, or a few

Every skill is independent. Name the target directory, then the skills you want:

```bash
./scripts/install.sh --list                         # what is available

./scripts/install.sh ~/.claude/skills godot-verify  # just one

./scripts/install.sh ./.claude/skills \
  godot-scene-surgery godot4-api-guard godot-verify # the Godot guardrails only
```

Unknown names fail before anything is copied, and print the valid list. Re-running is safe —
each named skill is replaced, and skills you did not name are left alone.

Useful subsets:

| You want | Install |
|---|---|
| Only the Godot-specific guardrails | `godot-scene-surgery godot4-api-guard godot-verify` |
| Only the workflow discipline, any engine | `write-plan grill-me build-loop session-handoff` |
| Only the design review skills | `game-feel-review loop-and-economy` |
| Everything except the router (you use another pack's router) | omit `using-godot-skills` |

`using-godot-skills` references the others, so install it last or edit its tables to match what
you actually took — `install.sh` warns you when you install a subset.

### Hooks and skills are independent

Install either without the other:

- **Skills, no hooks** — works in Cursor, Codex, Copilot and anything else that reads
  `SKILL.md`. The rules become advisory rather than enforced.
- **Hooks, no skills** — the control layer still injects the standing rules, still gates scene
  files, still blocks unverified turns. Without `godot-verify` installed, the `Stop` hook falls
  back to printing raw `godot --headless` commands instead of pointing at `verify.sh`.

`install-hooks.sh` is idempotent and merges alongside hooks other packs registered on the same
event — it will not clobber GodotPrompter's `SessionStart` entry.

### As a Claude Code plugin

```bash
claude plugin marketplace add Qb-Lab/godot-agent-skills
claude plugin install godot@godot-agent-skills
```

Skills and `hooks/hooks.json` are both picked up automatically — no install script needed. This
is all-or-nothing; use the scripts above if you want a subset.

### Check it worked

Open a Godot project and send any prompt. The response should be working from an injected block
naming your engine version. `/hooks` lists what is registered. For the skills, ask something
that should trigger one:

> "I'm getting `Invalid call. Nonexistent function 'instance'` in my Godot project"

`godot4-api-guard` should load.

See [docs/INSTALLATION.md](docs/INSTALLATION.md) for per-agent paths, manual copying, and what
each hook can do to your session.

## A note on categories

Skills live flat at `skills/<skill-name>/SKILL.md`, which is the layout every agent's discovery
expects — nesting them under category folders puts them one level too deep for some, including
Claude Code's plugin loader. The grouping survives as a `category:` field in each skill's
frontmatter, and as the headings in the table above.

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
