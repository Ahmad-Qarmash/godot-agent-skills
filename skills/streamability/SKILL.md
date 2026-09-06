---
name: streamability
description: Design and review mechanics for streamer appeal, short-form clip potential, and player-generated stories — the systems that make a game spread. Use when the user asks about streamer or TikTok/YouTube appeal, virality, "will people share this", marketability of a mechanic, designing multiplayer social dynamics, or how to create memorable emergent moments; or when reviewing whether multiplayer actually earns its cost.
category: design
---

# Streamability

Games spread when players retell things that happened to them. Streamability is not marketing
applied after the fact — it is a property of mechanics: some systems generate stories and some
merely generate outcomes. This skill designs and reviews for the former.

The test that anchors everything: **the 10-second clip test**. A stranger watches ten seconds
with no context. Do they understand what happened, why it was remarkable, and what game to
wishlist? A game can be excellent and fail this test — it will just have to buy every player
it gets.

## Where clips come from

Design for these deliberately; they rarely emerge from polish alone:

- **Emergent chaos** — systems interacting beyond the designer's script. Physics, fire
  spreading, AI misbehaving plausibly. The clip is "the game let this happen".
- **Near-misses and comebacks** — clips need arcs. A 1-HP survival is a story; a clean win is
  a result. Mechanics that keep losing players dangerous create comebacks structurally.
- **Betrayal and negotiation** — the strongest social clips are player-versus-player trust
  mechanics: alliances, bluffs, one traitor. These need mechanical support (trading, shared
  goals, hidden roles), not just proximity.
- **Skill ceilings** — visibly superhuman play is its own clip genre, but only when the skill
  is legible to a viewer who lacks it.
- **Systemic comedy** — laughter from physics, timing, and consequence generalizes; written
  jokes get one clip ever, systems generate them forever.
- **Dramatic irony** — the audience seeing what the player can't (the monster behind them,
  the wrong lever). Spectator-aware design is nearly free and streamers live on it.

The shared root is **unscripted stories**. Scripted set-pieces produce identical clips from
every player; systems produce a different clip each run, and different-every-time is what
feeds an algorithm.

## The streamer's actual needs

A streamer is a performer using the game as material. Serve the performance:

- **Readable at a glance** — a viewer joining mid-stream must parse the situation in seconds.
  Clean silhouettes, legible stakes, visible health/danger.
- **Short loops, frequent peaks** — a round every 5–15 minutes gives natural highlight
  boundaries; a 40-hour slow burn gives an editor nothing.
- **Room to talk** — downtime beats between intensity are where commentary lives. Wall-to-wall
  intensity reads worse on stream than in hand.
- **Failure that is funny or dramatic, not tedious** — death should produce a reaction shot,
  then a fast restart. Long corpse-runs kill VOD pacing.
- Chat interaction hooks are a genuine amplifier and almost never MVP — backlog them
  (`scope-control`).

## The multiplayer question

Answer it honestly, because multiplayer is the most expensive word in the design doc: does
multiplayer *create* the stories, or is it there because multiplayer games are popular?

Betrayal, negotiation, shared panic, and emergent comedy are strongest with friends — if the
concept's clips are those, multiplayer earns its ~3× engineering cost and slower iteration.
If the clips are mastery, atmosphere, or discovery, single-player plus a leaderboard or
async ghosts may buy 80% of the social spread at 10% of the cost. Route the cost side to
`scope-control`; a real topology fork (P2P vs authoritative) goes to `grill-me`.

## Theme virality vs mechanic virality

A striking theme ("it's X but Y") gets the first wave of clicks and dies in a month, because
theme is copyable and exhausts. A clip-generating *mechanic* compounds, because every player
manufactures new material. Ask which one the concept is leaning on. Theme-led is a launch-spike
plan; mechanic-led is a long-tail plan. Both can work — but only one keeps producing after
week two, and the store page can't tell you which you have. The clips can.

## Red flags

- The best moments require 50 hours of play to reach — clips must come from the first session
  too, or discovery never starts.
- The fun doesn't read on camera — internal, cerebral satisfaction (great for players, invisible
  to viewers) with no visible correlate.
- The clip spoils the game — one-shot narrative surprises monetize exactly once.
- "Streamers will love it" with no named mechanism — which of the sources above, specifically?
- Forced meme-ability — physics jank and wacky ragdolls as a coat of paint on a game that
  isn't otherwise generating moments. Players smell the difference in a week.

## Verify against reality

This skill's claims are hypotheses until checked two ways. Against the market: do clips of the
closest comparables actually circulate — what do their viral moments contain, what gets
ignored? (`market-scan` owns the protocol.) Against players: do playtesters retell stories
afterwards unprompted? "Tell me what happened in your run" producing a shrug is a failed
streamability test no matter how good the design argument was (`playtest-review`).
