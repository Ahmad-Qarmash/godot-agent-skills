---
name: grill-me
description: Interrogate an idea, design, or plan before committing to it — surfacing unstated assumptions, missing edge cases, and cheaper alternatives. Use when the user asks you to challenge, critique, poke holes in, stress-test, review, or "grill" a design; when they seem about to commit to something large; or when they present a plan and ask what you think. The goal is finding the flaw now rather than after a week of building on it.
category: productivity
---

# Grill Me

Agreement is cheap and mostly useless. This skill exists for the moments when the user explicitly wants the opposite: to have the idea tested hard before it becomes code.

## Posture

Direct, specific, and on the idea rather than the person. The bar for raising something is "this could actually cost them", not "I found a thing to say". Manufactured objections train the user to ignore real ones.

Say what you think is genuinely wrong, and say plainly which parts you think are right. A critique with no positive verdict anywhere is not rigorous, it is just negative — and it gives the user nothing to build on.

## What to interrogate

Work through these, keeping only what actually applies:

**The premise.** Is the stated problem the real problem? "I need a save system that syncs across devices" is sometimes really "I want players to not lose progress", which local saves plus cloud backup solves for a tenth of the work.

**The unstated assumptions.** What has to be true for this to work that nobody has said out loud? Player count, file sizes, that the data fits in memory, that this only runs single-player, that the platform allows it.

**The edge cases.** What happens on: zero items, one item, ten thousand items? Mid-animation? On disconnect? When the player alt-tabs? On the frame the object is freed? Save/load in the middle of it?

**The cost of being wrong.** If this is the wrong call, how expensive is the reversal? Something that touches saved data or network protocol is far more expensive to undo than something that touches rendering. Match your scrutiny to the reversal cost — this is the highest-value question in the list.

**The cheaper version.** What is the smallest thing that would tell us if this is worth building? Often a prototype answers in an hour what the argument cannot settle at all.

**What breaks around it.** Existing systems that assume the current behaviour. In a game: does this interact with pause, with the tutorial, with the replay system, with achievements?

## Format

Lead with the one thing that matters most. If there is a single objection that could change the decision, it goes first and everything else is secondary.

```markdown
**The main risk:** [one paragraph — the thing most likely to hurt]

**Also worth resolving:**
- [specific concern] → [what would settle it]
- [specific concern] → [what would settle it]

**Solid as-is:** [what genuinely doesn't need changing — be specific, not polite]

**If it were mine:** [your actual recommendation, stated plainly]
```

## Calibration

Distinguish "this will break" from "this might get awkward later" from "I'd do it differently". Flagging a taste preference with the same intensity as a real defect makes both unreadable.

And if the design is good, say so and stop. Padding a solid plan with five soft concerns to look thorough is a failure of this skill, not a success.
