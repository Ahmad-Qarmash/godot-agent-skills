# Installation

Two halves: the **skills** (portable SKILL.md, any agent) and the **control layer**
(hooks, Claude Code only). The skills work without the hooks; the hooks are what make the
rules stick when other packs are installed alongside.

## Skills

```bash
./scripts/install.sh                       # -> ~/.claude/skills/
./scripts/install.sh ./.claude/skills      # project-local, committed with the game
./scripts/install.sh ~/.cursor/skills
```

Copies each skill into the target, flattening the category folders.

Project-local is usually better for a game repo: the skills version alongside the code, and
everyone on the team gets them from the clone.

## Control layer (hooks)

```bash
./scripts/install-hooks.sh                        # -> ./.claude/settings.json
./scripts/install-hooks.sh ~/.claude/settings.json # user-wide
```

It backs up the existing settings file, is safe to re-run (previous entries from this pack are
replaced, not duplicated), and leaves hooks registered by other packs on the same event alone —
GodotPrompter's `SessionStart` entry survives.

Requires `python3` and `bash`. All four hooks exit silently when the working directory is not a
Godot project, so they are harmless in a user-wide install.

Confirm with `/hooks` in Claude Code after restarting.

### What each hook can do to your session

Read these before installing — two of them can block your work:

- `guard-scene-files.py` **denies** `Edit`/`Write`/`MultiEdit` on `.tscn`/`.tres` when the edit
  touches `uid://`, `load_steps`, resource ids, or node blocks. Scalar property edits pass.
- `require-verify.sh` **blocks the end of a turn** when Godot source changed and nothing was
  verified. It nudges once per turn and never loops, and stays silent when no Godot binary is
  reachable.

To remove them, delete the entries from `settings.json` (or restore the `.bak`).

## Per-agent paths

| Agent | Skills directory | Hooks |
|---|---|---|
| Claude Code (user) | `~/.claude/skills/` | `~/.claude/settings.json` |
| Claude Code (project) | `<project>/.claude/skills/` | `<project>/.claude/settings.json` |
| Cursor | `~/.cursor/skills/` | not supported |
| Codex | `.agents/skills/` | not supported |
| Others | Check your agent's docs; the SKILL.md format is shared | — |

## As a Claude Code plugin

```bash
claude plugin marketplace add Qb-Lab/godot-agent-skills
claude plugin install godot@godot-agent-skills
```

`hooks/hooks.json` is picked up automatically — no `install-hooks.sh` step.

Skills sit at `skills/<name>/SKILL.md`, one level deep, which is what every discovery
implementation expects.

## Manual

```bash
mkdir -p ~/.claude/skills
cp -r skills/godot-verify ~/.claude/skills/
```

Skills are independent — install only the ones you want. The router
(`using-godot-skills`) references the others, so install it last or edit its tables to match.

## Verifying it worked

Restart your agent, then ask something that should trigger a skill:

> "I'm getting `Invalid call. Nonexistent function 'instance'` in my Godot project"

`godot4-api-guard` should load. If nothing triggers, the usual cause is the skill sitting one
directory too deep — check the path is `<skills-dir>/<skill-name>/SKILL.md` with no category
folder in between.

For the hooks, open a Godot project and send any prompt. The first response of the session
should be working from an injected block that names your engine version. If not, run `/hooks`.

## Requirements

- `bash` and `python3` for the hooks and install scripts
- Godot 4.x on PATH for the verification skills, or `GODOT_BIN` set to the binary path
- GdUnit4 or GUT in the project for test runs (optional; `godot-verify` degrades to load and
  parse checks without them)
