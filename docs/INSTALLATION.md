# Installation

Two halves: the **skills** (portable SKILL.md, any agent) and the **control layer**
(hooks, Claude Code only). The skills work without the hooks; the hooks are what make the
rules stick when other packs are installed alongside.

## Skills

The `skills` CLI is the shortest path and needs no clone:

```bash
npx skills add Qb-Lab/godot-agent-skills             # pick from a list
npx skills add Qb-Lab/godot-agent-skills --list      # names only, no install
npx skills add Qb-Lab/godot-agent-skills --all       # everything, every agent
npx skills add Qb-Lab/godot-agent-skills -s godot-verify -g -a claude-code
```

Project installs land in `./.claude/skills/`; `-g` uses your home directory. Bundled scripts
(`godot-verify/scripts/verify.sh`) come along with the skill and keep their executable bit.
`npx skills update` pulls newer versions.

### From a clone

`scripts/install.sh` does the same thing without npx, which is useful offline or in CI:

```bash
./scripts/install.sh                       # all -> ~/.claude/skills/
./scripts/install.sh ./.claude/skills      # all -> project-local, committed with the game
./scripts/install.sh ~/.cursor/skills      # all -> another agent
```

Project-local is usually better for a game repo: the skills version alongside the code, and
everyone on the team gets them from the clone.

### Installing specific skills

Name the target directory first, then one or more skill names:

```bash
./scripts/install.sh --list                                   # available names
./scripts/install.sh ~/.claude/skills godot-verify            # one
./scripts/install.sh ./.claude/skills godot-verify godot4-api-guard
```

The target is required when selecting, so an argument is never ambiguous between a directory
and a skill name. Unknown names abort before anything is copied and print the valid list —
a half-finished install is worse than none. Re-running replaces only the skills you name.

Skills are independent and can be installed in any combination, with one exception:
`using-godot-skills` references the others by name, so install it last or edit its tables to
match what you took. `install.sh` prints a reminder when you install a subset.

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
