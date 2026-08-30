---
name: grill-me
description: Interrogate an idea, design, or plan before committing to it — surfacing unstated assumptions, missing edge cases, and cheaper alternatives — then turn what survives into decisions offered as pickable options with a recommendation. Use when the user asks you to challenge, critique, poke holes in, stress-test, review, or "grill" a design; when they ask which approach to take or say they can't decide; when they seem about to commit to something large; or when they present a plan and ask what you think. The goal is finding the flaw now rather than after a week of building on it, and leaving with a decision rather than a list of worries.
category: productivity
---

# Grill Me

Agreement is cheap and mostly useless. This skill exists for the moments when the user explicitly wants the opposite: to have the idea tested hard before it becomes code.

It runs in two movements. **Grill** — find what is actually wrong. **Decide** — turn what survived into a call the user can make, with your recommendation on the table. A critique that ends in a list of worries has done half the job; the user still has to decide, and now with more anxiety than they started with.

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

## Format for the critique

Lead with the one thing that matters most. If there is a single objection that could change the decision, it goes first and everything else is secondary.

```markdown
**The main risk:** [one paragraph — the thing most likely to hurt]

**Also worth resolving:**
- [specific concern] → [what would settle it]
- [specific concern] → [what would settle it]

**Solid as-is:** [what genuinely doesn't need changing — be specific, not polite]

**Decisions this leaves open:** [the 1–3 forks the critique actually opened, named in one line each]
```

Then move to deciding them.

## From critique to decision

Not every concern is a decision. A concern becomes a decision point when **the answer changes what gets built** — different code, different data shape, different scope. Everything else is context you state once and move past.

Expect one to three real decisions from a grilling. If you find yourself with six, most of them are consequences of one upstream fork — find it and ask that instead. If you find zero, say the design is sound and stop; inventing a fork to have something to ask is the same failure as inventing an objection.

Order them by reversal cost, hardest-to-undo first, and take the upstream one first when a later decision depends on how an earlier one lands.

Never ask about something you could find out. Facts are for looking up — open the file, check the engine version, read the existing system. Only decisions go to the user.

## How to ask

**One decision per turn, then stop and wait.** Never batch. A wall of questions gets one answer to the last one.

For each decision, offer **2–4 concrete options**, your recommendation first and marked as such, each with one line saying what it costs or buys — the consequence, not a restatement of the label. Picking an option must be a complete answer on its own; if an option only works once the user explains what they meant by it, it is not an option, it is a prompt for an essay.

Beyond the listed options, two doors stay open every single time:

- **Their own answer, in their words** — an approach you didn't list, or a variant of one you did.
- **Talking it through** — "let's discuss this one" is always a legitimate response, and worth saying out loud when the decision is genuinely close or the options feel like they're missing something.

If the host offers a structured multiple-choice prompt with selectable options and a built-in free-text "other" (Claude Code's is one), ask through it — put the recommended option first with `(recommended)` in the label, and use the option descriptions for the consequence lines. Free text is already available there, so don't burn an option slot on "something else"; do spend one on discussing it when the decision is close. Otherwise present the options as a lettered list and close by inviting their own answer or a conversation instead.

```markdown
**Decision 1 of 2 — save format.** [one line: what actually hangs on this]

**A. Binary via `FileAccess.store_var` (recommended)** — smallest and fastest; unreadable when a save breaks, and version migrations are hand-written.
**B. JSON** — debuggable by eye and trivially diffable; roughly 4× the file size and you own the schema validation.
**C. `Resource` + `ResourceSaver`** — engine handles serialisation and versioning; couples the save file to your class names, so renaming a script breaks old saves.

Or tell me an option I've missed — or say "let's talk about it" if this one feels close.
```

## The recommendation

Recommend the option you would actually take, and give the one reason that decided it — usually the reversal cost, not the elegance.

Rules that keep the recommendation worth something:

- **It's a position, not a verdict.** The user overriding it is the system working. When they pick something else, take the pick and build on it — don't re-argue a settled call.
- **Don't default to the safest-sounding option.** Sometimes the right recommendation is the riskier one because the cheap reversal makes the risk affordable.
- **No preference is a real answer.** If the options are genuinely tied, say so rather than marking one at random — a false recommendation costs more than none. Then say what evidence would break the tie, and offer to go get it.
- **Say it once when it's the "this will break" tier.** If they pick an option you think is actually broken rather than merely not-your-taste, say that plainly, once, with the specific failure — then follow their call. Repeating an objection they've already heard and overruled is nagging, not rigour.

## When the answer is "let's talk"

Free text, a pushback on the framing, a question back at you, or an explicit "let's discuss" — all of them mean the same thing: **drop the menu**. Answer in prose, at whatever length the point needs.

- If they're questioning the framing, the framing is probably wrong. Chase that before defending the options.
- The most valuable outcome of a discussion is usually an option neither of you started with. When it shows up, name it and re-offer the set with it included.
- Don't re-ask the same question with the same options after a discussion. Either the options changed, the decision dissolved, or it's settled — say which.
- If the conversation reveals the premise is wrong, go back to grilling, not to the menu. A better answer to the wrong question is still the wrong question.
- Re-open earlier decisions when a later one invalidates them. Say which one you're reopening and why, rather than quietly assuming the old answer still holds.

Discussion is also the right mode when the user wants to build something a different way entirely — that is not a failed decision, it is the grilling working.

## Ending

Stop when the decisions are settled or parked, when the user says stop in any phrasing, or when the whole thing needs a rethink and they agree to restart.

Close with the record, so a fresh session — yours or another agent's — can pick it up without re-litigating anything:

```markdown
## Decided
- [decision] → **[what was chosen]** — [why, and what it rules out]

## Parked
- [decision] → [what would settle it, and what to assume meanwhile]

## Where I still disagree
- [any recommendation the user overrode that you think is a real risk — one line, stated once, no argument]
```

Leave the "where I still disagree" section out entirely when there's nothing in it. An empty section that exists to be filled invites filling it.

## Calibration

Distinguish "this will break" from "this might get awkward later" from "I'd do it differently". Flagging a taste preference with the same intensity as a real defect makes both unreadable. The same scale applies to decisions: only the first two tiers deserve a question, the third deserves a sentence.

And if the design is good, say so and stop. Padding a solid plan with five soft concerns to look thorough — or five ceremonial decisions to look collaborative — is a failure of this skill, not a success.
