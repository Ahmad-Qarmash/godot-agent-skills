---
name: write-plan
description: Turn a feature request into a written, phased implementation plan (.md) before any code is written — where each phase is one AI coding-agent session. Use whenever a task will touch more than about two files, when the user describes a feature rather than a specific change, when requirements are ambiguous, or when the user says "add", "build", "implement", or "let's do" about something non-trivial. Plans are cheap to change; half-built systems are not.
category: productivity
---

# Write Plan

The expensive failure in agent-assisted development is not bad code. It is confidently building
the wrong thing for forty minutes. A plan costs a few minutes and makes the disagreement happen
before the work instead of after it.

The reader of the plan is **an AI coding agent in a fresh session** told "build phase N of this
plan" — not a human project manager. Every choice below follows from that.

## When to plan

Plan when: more than two files change, the request names a feature rather than a change, there
are multiple viable approaches, or the work touches saved data, networking, or anything with a
migration cost.

Skip the plan when: the fix is localized, the user already specified the approach, or the whole
task is smaller than the plan would be. Announcing a plan for a one-line change is theatre.

## Before writing: align, then research

1. If the task has decisions that shape the whole approach — architecture, node/scene structure,
   data model, save format, addon choice, scope boundaries — settle them with the user **before**
   drafting. Ask one question at a time, leading with your recommended option (`grill-me` is the
   tool for this when the fork is real — and when the feature is an economy, progression, or
   balance system, pair it with `loop-and-economy` so the design is critiqued for inflation,
   dead ends, and dominant strategies before the plan records it as settled). Skip this when
   the direction is already clear from the request, the docs, or prior decisions.
2. Research the entire change enough to establish every phase's boundaries, dependencies, and
   exit criteria. Research phase 1 deeply enough that you could implement it yourself. For later
   phases, specify exact contracts, scenes, and files where they are already knowable; do not
   invent internals that depend on earlier implementation results. Delegate heavy or open-ended
   research when the host supports it.
3. Facts you can look up are never questions for the user; decisions are.
4. Check `HANDOFF.md` and any existing plan for the same area before writing a new one. A
   decision already made there is not reopened here.

## Required skeleton

Only these four elements are mandatory. Adapt everything else — section names, extra sections,
depth, ordering — to what's being planned; a save-system rewrite and a new enemy type should not
look alike.

1. **Title + goal** — one paragraph on what exists when the plan is done: what is true after
   this that isn't true now. Include a one-line **non-goals** statement: what this plan
   deliberately does not do.
2. **Progress tracker**, directly under the goal: a phase/status table using only
   `not started`, `in progress`, `done`, or `blocked`, plus "current phase" and "recommended
   next phase" lines. End it with a literal instruction that the executing agent updates the
   tracker at the end of its run, noting any deviations in one line each.
3. **Decisions & context** — everything a fresh session needs that it can't get from the repo:
   load-bearing decisions made, rejected alternatives that would otherwise be relitigated,
   constraints (target Godot version, multiplayer or not, designer-tunable or hardcoded), and
   pointers to the scenes, scripts, resources, and docs that matter. If rationale already has a
   durable home in a design doc or `HANDOFF.md`, link it instead of duplicating it.
4. **Phases** — each with: goal, what to build (concrete — `.gd` / `.tscn` / `.tres` paths,
   node names, signal names, resource shapes), a coarse task checklist, and exit criteria
   another agent or the user can verify, including the exact commands to run. Every phase
   leaves the project green: it imports, parses, loads, and the tests pass (see
   `godot-verify`). A phase that ends with a scene that won't open is not done.

Include this standing execution rule in the plan: at the start of each phase, verify the plan
against the live repo and prior-phase deviations. Do not reopen settled decisions without new
evidence. If an assumption is invalidated, update the plan and surface the deviation rather
than silently changing direction.

```markdown
# <Feature> — implementation plan

## Goal
One paragraph. What exists when this is done. **Non-goals:** one line.

## Progress
| Phase | Status |
|---|---|
| 1. <name> | not started |
| 2. <name> | not started |

Current phase: 1 · Recommended next: 1
> Executing agent: update this table at the end of your run and note any
> deviation from the plan in one line each, below this block.

## Decisions & context
- <decision> — because <reason>; rejected <alternative> because <reason>
- Constraints: Godot <x.y>, <single-player / multiplayer>, <save-format facts>
- Read first: `path/to/scene.tscn`, `path/to/script.gd`, `docs/<thing>.md`

## Execution rule
At the start of each phase, verify this plan against the live repo and any
deviations recorded above. Do not reopen settled decisions without new evidence.
If an assumption is invalidated, update this file and say so.

## Phase 1 — <name>
**Goal:** one sentence.
**Build:**
- `path/to/file.gd` — what changes and why
- (new) `scenes/thing.tscn` — nodes, signal wiring
**Checklist:**
- [ ] outcome-level item
- [ ] outcome-level item
**Exit criteria:**
- `godot --headless --path . --import && godot --headless --path . --quit` exits 0
- `<test command>` passes, including new test `<name>`
- <a specific thing to look at or do in-game>

## Phase 2 — <name>
...
```

## Sizing phases

A phase is **one agent session**, not a human workday. A capable model implements a multi-file
feature — scene, script, resource, signal wiring, tests — in a single run, managing its own
todo list. Never phase by kind of work (a scaffolding phase, a testing phase, a "polish"
phase); phase only at real seams:

- The user should review output or make a decision before the next part starts — a new
  mechanic needs to be *felt* in-game before its tuning and content are built on top of it.
- The output of one phase genuinely determines the design of the next.
- The work is too large for one session's context even executed efficiently.

Merge test: if an agent could execute two adjacent phases in one session with no ambiguity and
no lost checkpoint, they are one phase. Most features land at 2–4 phases; more is fine for
genuinely large work, but each extra seam must be one of the three above.

Front-load the risky and unknown parts — the migration, the addon integration, the physics
interaction nobody has tried — into early phases (fail fast). Keep task checklists coarse —
outcomes ("`InventoryComponent` with stack-merge + tests"), not micro-steps. The implementing
agent plans its own steps; the checklist exists so the user can see the shape of the run and
the agent can self-verify coverage.

## Open questions are still the point

Anything the user must decide before a phase can start goes in that phase, marked as a
blocker, not buried in prose. Surface real forks in the road:

- "Should saves carry over from the old format, or is wiping saves acceptable at this stage?"
- "Is this multiplayer-facing? It changes whether state can live on the client."
- "Do you want this tunable by designers in a `.tres`, or is hardcoded fine for now?"

Do not pad with fake uncertainty about things you can just decide. One real question beats
five performative ones. If there are none, say "none".

## Saving

Follow the repo's existing convention for plan location. If it has none, default to
`docs/plans/<feature>.md`, or `docs/plans/<area>/<feature>.md` when plans are naturally grouped
by area. If `docs/plans/` is unavailable or inappropriate, ask where plans should live. Make the
final phase move any lasting architecture or design facts into their canonical docs; retire or
archive the plan only when the repo's convention requires it.

## After the plan

Wait for a response before implementing. If the user says "go", build phase 1 with
`build-loop`, and say so when you deviate from the plan — silent deviation is how a reviewed
plan stops meaning anything. If the plan turns out to be wrong mid-implementation, stop and
say so rather than improvising around it.

End your final message with the kickoff prompt for phase 1, in a code block so it can be copied
into a fresh session. Keep it dead simple — the plan carries the context, the prompt just points
at it:

```
Read <plan-path> and build phase 1.
```

Add a trailing sentence of extra context only when something matters that the plan can't know
(e.g. "the `.godot/` cache is stale, re-import first"). Later phases reuse the same prompt shape
with the phase number changed, so only show phase 1's.

## Scale the ceremony to the stakes

A three-file refactor gets a one-phase plan a few lines long — goal, changes, exit criteria,
done. A save-system rewrite gets the full skeleton plus a migration phase. Reading which one is
in front of you is part of the skill.
