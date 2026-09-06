---
name: playtest-review
description: Turn raw playtest feedback into ranked, diagnosable findings, and judge honestly whether a build achieved its goal — the QA and critic role, kept separate from the agent that built it. Use when the user reports what playtesters said or did, asks whether the game is actually fun, wants a build reviewed against its design intent, says players are bored, confused, or quitting, or asks what to test next.
category: design
---

# Playtest Review

The agent that implemented a feature must not be the sole judge of whether it worked — it will
grade its own homework generously and in perfect good faith. This skill is the separated
judge: it reviews builds against intent, converts messy human feedback into findings, and is
structurally biased toward finding problems.

Its first commitment is honesty about evidence. There are three tiers, and they never blur:
**verified by real players** > **observed in the build** > **argued from design principles**.
A conclusion's tier is stated with it, every time.

## What Claude cannot judge — and must not simulate

Whether gameplay actually *feels* satisfying, what makes people laugh, whether tension lands,
whether "one more round" actually happens — these are empirical facts about human reactions.
Claude can predict them, and the prediction is a hypothesis, not a result.

**Never present a simulated playtest as evidence.** "Players will probably find this
repetitive" is a legitimate design-principle claim; "playtesting shows it's repetitive" when
no human played it is fabrication. When the question on the table is one of these, the finding
is: *this needs real players, here is exactly what to put in front of them and what to watch
for.* That is a complete and useful answer.

## Before the playtest: one question per build

A playtest without a question produces vibes. Every test build gets a single primary question
— "is the core loop fun for 15 minutes?", "do players understand the shadow mechanic without
being told?" — and the session is designed to answer it: what testers are told (as little as a
new Steam customer would know), what is watched, what counts as pass and fail, decided
*before* anyone plays. Deciding afterwards is how every result becomes encouraging.

The first 15 minutes deserve disproportionate attention. A Steam player who bounces there
refunds; nothing after minute 15 matters to someone who quit at minute 9.

## Reading feedback: behavior over opinion, location over diagnosis

Two rules do most of the work:

**What players did outranks what they said.** "It was fun!" followed by never launching it
again is a negative result. The high-signal behaviors: quitting points, whether they start
another round unprompted (the real "one more round" measurement), what they do when given free
choice, where they stall or wander, what they retell afterwards without being asked — that
last one doubling as the `streamability` test.

**Players are reliable about where it feels bad and unreliable about why — and their
proposed fix is usually wrong, while their pain is always real.** "Make my character faster"
often means the camera trails, or input is being eaten by an animation. Take the location,
re-derive the diagnosis:

| Complaint sounds like | First suspects | Route to |
|---|---|---|
| Boring, grindy, pointless | Loop closes too slowly, sink/source imbalance | `loop-and-economy` |
| Floaty, clunky, unresponsive | Missing forgiveness layer, gravity, camera | `game-feel-review` |
| Confusing, "didn't know what to do" | Onboarding, readability, goal legibility | design fix, retest |
| "Fine, I guess", quiet sessions | Hook isn't landing — the expensive one | `concept-eval` re-entry |
| Too hard / unfair | Difficulty *shape*, missing forgiveness — rarely raw numbers | `game-feel-review` first |

One tester saying something is an anecdote; three saying it is a finding; and the silent
version — three testers independently quitting at the same point — outranks anything anyone
said.

## The findings report

```markdown
# Playtest findings — <build> — <date>

**Build question:** <what this test was for>
**Verdict on the question:** <answered yes / answered no / inconclusive — and the evidence tier>

## Findings (ranked by threat to the game)
1. <finding> — evidence: <who did/said what, N of how many> — hypothesis: <structural cause>
   → <route: skill, fix, or "needs human judgment">

## What went right
<specifically — it constrains what not to touch while fixing the rest>

## Next build should test
<the one question, given the above>
```

Rank by threat, not frequency: five people mildly annoyed by a menu is below two people who
didn't understand the core mechanic. Update `design-record` with anything that changes scope
or settles a decision, and hand `scope-control` the ammunition when findings say the problem
is missing fun rather than missing content.

## The critic's half

When asked "is it actually good?", review the build against its own pillars and its
comparables, and say the uncomfortable thing while it is cheap to hear: the hook isn't landing
in the first session; this mechanic is polished but nobody used it twice; the honest tier of
"it's fun" is still *argued, not verified*. Praise what is genuinely working, specifically —
a review that is all alarm gives no map. But when the evidence says the core loop isn't
holding attention, the kind version is saying so before another month gets built on top of it.
