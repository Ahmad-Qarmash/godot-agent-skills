---
name: session-handoff
description: Write a compact handoff note capturing project state, decisions, and next steps so the next session resumes without re-deriving context. Use when the user says they're stopping, wrapping up, or continuing tomorrow; when a conversation is getting long enough that context may be lost; or when the user asks where things stand or what's left.
category: productivity
---

# Session Handoff

Context does not survive between sessions. Without a handoff, the next session rediscovers the same constraints, re-proposes rejected approaches, and re-breaks things that were already fixed once.

## When to write one

At natural stopping points, when the user signals they're done for now, or when a long session has accumulated decisions that would be expensive to reconstruct. Also worth writing mid-session when a large piece completes.

Do not write one after a short exchange with nothing durable in it.

## Format

Write to `HANDOFF.md` at the project root, or wherever the project already keeps notes. Overwrite it rather than appending — a handoff is a snapshot, and a growing log stops being read.

```markdown
# Handoff — YYYY-MM-DD

## State
What works right now. Be specific about what has been verified versus
what has been written but not run.

## Decisions made
- [decision] — because [reason]
- [decision] — because [reason]

## Rejected approaches
- [approach] — didn't work because [reason]

## Next
1. [concrete next action]
2. [concrete next action]

## Known issues
- [thing that is broken or unfinished, and where]

## Environment
Anything non-obvious needed to run this — engine version, binary path,
required addons, commands that are easy to get wrong.
```

## The rejected-approaches section earns its keep

This is the part that saves the most time. Without it, the next session confidently proposes the thing that already failed, and it takes a full cycle to rediscover why. One line prevents that entirely.

## Be honest about verification status

"Implemented and tests pass" and "implemented, not yet run" are very different states, and conflating them means the next session builds on a foundation nobody checked. Mark them differently, every time.

## Keep it short

A handoff that runs three pages will not be read, which makes it worse than a short one. Aim for something scannable in under a minute. If a section has nothing in it, delete the section rather than writing "N/A".
