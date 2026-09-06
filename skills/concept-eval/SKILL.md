---
name: concept-eval
description: Evaluate a game concept for commercial and creative viability and return a verdict — BUILD, PROTOTYPE, MODIFY, RESEARCH MORE, or KILL. Use when the user pitches a game idea, asks "should I build this", asks whether an idea is good or original, compares candidate concepts, or wants a game-director-level review of a concept before committing to it. Requires current market evidence (market-scan) — never greenlight from internal knowledge.
category: strategy
---

# Concept Eval

The job is not to expand the idea. The job is to try to kill it while killing it is cheap. A
concept that survives honest attack is worth a prototype; one that dies here just saved months.
Enthusiastic agreement at this gate is the most expensive failure mode an agentic studio has.

This is a two-input decision: the concept, and a current **market brief** (`market-scan`). If
there is no fresh brief, produce one first or return RESEARCH MORE — a verdict on commercial
potential without current market evidence is an opinion wearing a lab coat. When the user wants
the concept argued to a decision interactively, run the questioning through `grill-me`.

## First, state the concept back

One sentence: *"You do X, which creates Y, and that's interesting because Z."* If the concept
can't survive that compression, that is finding one — no pitch, no Steam capsule, no word of
mouth. Then name the three closest shipped competitors from the brief. "It has no competitors"
is almost never true and never good news; it usually means the demand is unproven.

## Try to break it

Attack, don't audit. Put real force behind each question that applies:

- **Why this over the three closest competitors?** "Mine will be more polished" is not an
  answer a player can act on in a store page.
- **The 10-second clip test.** What can a streamer show, with no setup, that makes a viewer
  understand why this game is interesting? If the answer needs a paragraph of context, the
  game has a discovery problem regardless of its quality.
- **Is the hook a mechanic or a theme?** "Vampires but cozy" is a theme; themes get you the
  click. "Your shadow repeats your last ten seconds of movement" is a mechanic; mechanics get
  you the second session. A concept whose only hook is theme competes on art budget.
- **Does multiplayer actually improve it?** Or is it there because multiplayer games are
  popular? Multiplayer roughly triples engineering cost and makes iteration slower exactly
  when iteration matters most. It has to *create* the fun, not accompany it.
- **Can it generate unscripted stories?** Games spread by players retelling things that
  happened to them, not things the designer wrote.
- **What makes someone say "one more round"?** Name the specific loop. Then: what creates
  tension, laughter, skill expression, surprise? A concept strong on none of the four has no
  engine for retention or virality.
- **What stops hour one from being repetitive?** Not content volume — structure.
- **What is expensive to build but contributes little to fun?** Every concept has one; find it
  now. Likewise: which features impress in a design doc but are invisible to players?
- **Where does it get technically dangerous in Godot?** Large-scale physics crowds, rollback
  netcode, huge procedural worlds, MMO-shaped anything. Flag; the technical skills own the
  detail.
- **Does the content burden fit the team?** Count the artists, animators, and level designers
  the concept silently assumes. A 3-person team concept that needs 200 animations is a
  40-person concept in disguise.
- **Can the core mechanic be tested with placeholder assets?** If the concept is only fun
  once the art is good, the mechanic is not the hook — the art is, and art-led is the most
  expensive lane in games.

## The scorecard

Score 1–5 across the dimensions that apply, **with one line of evidence each**. A number
without evidence is decoration. Mark market-derived rows with the brief's date; mark
fun-related rows as *hypothesis* — fun is unverifiable until a prototype exists.

Group them so the shape is readable at a glance:

- **Hook & fun** — core hook, originality, clarity of pitch, fun potential, replayability,
  retention potential
- **Audience & spread** — market demand, competitive saturation, streamer potential,
  short-form clip potential, multiplayer/social value, Steam discoverability
- **Feasibility** — development complexity, art/content burden, networking complexity, Godot
  suitability, small-team fit, prototype speed, budget risk
- **Business** — pricing/monetization fit for the genre's norms

Do not average the groups into one number. A 5-across-feasibility concept with a 1 on hook is
a well-scoped game nobody wants; averaging hides exactly that. The verdict comes from the
shape: a low **hook** score caps everything, a low **feasibility** score means MODIFY or KILL
regardless of how exciting the market looks.

## The verdict

Exactly one of:

| Verdict | Meaning |
|---|---|
| **BUILD** | Evidence is strong *and* the core loop is already proven fun in a playable form. Rare before a prototype exists — treat requesting it pre-prototype as a red flag in itself. |
| **PROTOTYPE** | The default positive outcome. Name the single question the prototype must answer, the smallest build that answers it, and a time box. |
| **MODIFY** | The concept has a live core wrapped in a dead or oversized shell. Say precisely what to cut or change and which score it moves. |
| **RESEARCH MORE** | A named unknown controls the decision. Name it and how to resolve it — this is a to-do, not a hedge. Cap it: if two rounds of research haven't resolved it, the answer is KILL or PROTOTYPE, not a third round. |
| **KILL** | The concept fails on hook or feasibility and modification doesn't save it. Say what evidence would reopen it, and record it in `design-record` so it stays killed. |

Deliver as: verdict, the one-paragraph reason, the scorecard, the two or three strongest
objections with whatever answers survived, and what happens next. If the user overrides a KILL
— it is their studio — state the disagreement once, plainly, and then help them build the best
version of it. Repeating the objection every session is nagging; recording it once in
`design-record` is process.

## What this gate never does

It never designs the full game — a positive verdict hands off to `scope-control` for the MVP
cut, `loop-and-economy` for the loop, `streamability` for the clip engine. It never pads a
doomed concept with compliments, and it never claims a verdict on *fun*. Fun is decided by a
playable build in front of real people (`playtest-review`); this gate only decides whether
that build is worth making.
