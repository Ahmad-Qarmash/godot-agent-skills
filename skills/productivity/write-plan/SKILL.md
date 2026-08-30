---
name: write-plan
description: Turn a vague feature request into a written, reviewable implementation plan before any code is written. Use whenever a task will touch more than about two files, when the user describes a feature rather than a specific change, when requirements are ambiguous, or when the user says "add", "build", "implement", or "let's do" about something non-trivial. Plans are cheap to change; half-built systems are not.
category: productivity
---

# Write Plan

The expensive failure in agent-assisted development is not bad code. It is confidently building the wrong thing for forty minutes. A plan costs two minutes and makes the disagreement happen before the work instead of after it.

## When to plan

Plan when: more than two files change, the request names a feature rather than a change, there are multiple viable approaches, or the work touches saved data, networking, or anything with a migration cost.

Skip the plan when: the fix is localized, the user already specified the approach, or the whole task is smaller than the plan would be. Announcing a plan for a one-line change is theatre.

## Format

Keep it short enough that the user actually reads it. Long plans get skimmed and rubber-stamped, which defeats the point.

```markdown
## Goal
One sentence. What is true after this that isn't true now.

## Approach
2–4 sentences. The shape of the solution and why this shape.

## Changes
- `path/to/file.gd` — what changes and why
- `scenes/thing.tscn` — new node / new signal wiring
- (new) `path/to/new_file.gd` — what it holds

## Verification
How we'll know it works. A specific command or a specific thing to look at.

## Open questions
- Anything you had to assume. If none, say "none".
- Anything the user must decide before this can proceed.
```

## The open questions section is the point

The rest of the plan is mostly for you. The open questions are for the user, and they are where the value is. Surface real forks in the road:

- "Should saves carry over from the old format, or is wiping saves acceptable at this stage?"
- "Is this multiplayer-facing? It changes whether state can live on the client."
- "Do you want this tunable by designers in a `.tres`, or is hardcoded fine for now?"

Do not pad this section with fake uncertainty about things you can just decide. One real question beats five performative ones.

## After the plan

Wait for a response before implementing. If the user says "go", follow the plan and say so when you deviate from it — silent deviation is how a reviewed plan stops meaning anything.

If the plan turns out to be wrong mid-implementation, stop and say so rather than improvising around it. A plan that survives contact with reality by being quietly abandoned was never a plan.

## Scale the ceremony to the stakes

A three-file refactor gets a five-line plan. A save-system rewrite gets the full template plus a migration section. Reading which one is in front of you is part of the skill.
