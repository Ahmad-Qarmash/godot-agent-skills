---
name: market-scan
description: Research the current games market before any commercial recommendation — Steam trends, recent successes and failures, review complaints, Twitch and YouTube activity, upcoming competitors, pricing, and genre saturation. Use when the user asks what is trending, whether a genre is saturated or underserved, who the competitors for an idea are, whether a game like X would sell, or before evaluating any game concept for commercial potential. Never answer these from internal model knowledge.
category: strategy
---

# Market Scan

Model knowledge about the games market is stale on arrival. Training data lags by months to
years; Steam shifts in weeks. A genre that was underserved at training time may have had forty
releases since. **Never recommend or reject a commercial game concept from internal knowledge
when current market information matters** — and for concept decisions it always matters.

If you cannot browse in this session, say so explicitly, label every market claim as
potentially stale with your knowledge cutoff attached, and downgrade any verdict that depends
on it to RESEARCH MORE. A confident answer built on stale data is worse than no answer.

## What to research

Work through what the question needs, not the whole list every time:

- **Steam directly** — the genre's tag pages, Top Sellers, New & Trending, and upcoming
  releases. Release volume per month in the tag is the saturation number.
- **Recent successes** — what shipped in the last 12–18 months and worked. What did they do,
  what did they charge, how small was the team?
- **Recent failures** — the same genre's games that sank. This is the more informative list:
  success stories survive selection bias, failures show the actual base rate. A genre where
  three games won and two hundred died is not an opportunity, it is a lottery.
- **Reviews of comparables** — negative reviews of successful games are a map of underserved
  demand. "I love this but wish it had X" repeated across a genre is a design brief written by
  the market.
- **Player counts** — SteamDB / SteamCharts for concurrents where available. Review count is
  the proxy otherwise: owners ≈ reviews × 30–50 (the multiplier varies by genre and price;
  treat it as an order-of-magnitude tool, not arithmetic).
- **Twitch and YouTube** — is anyone streaming the genre? Are videos about these games getting
  views from non-owners? A genre players buy but nobody watches has no discovery flywheel.
- **Reddit and community spaces** — what are players of the closest comparables complaining
  about and asking for?
- **Upcoming competition** — announced and wishlisted games in the same space. Being second to
  a hyped game's exact pitch is a real risk that pure trend data won't show.
- **Pricing norms** — what the genre actually charges and where the review-score cliff sits.
- **Development scope of comparables** — team size and dev time where discoverable
  (credits, interviews, dev logs). A comparable built by 40 people in 4 years is not a
  comparable for a 3-person team.

## Classify what you found

The single most valuable output is putting the genre in the right bucket. These are different
situations that demand different decisions, and conflating them is how trend-chasing happens:

| Classification | Signal | Implication |
|---|---|---|
| **Popular** | Large stable player base, steady releases | Room exists, but you need a wedge |
| **Growing** | Rising release volume *and* rising success rate | Timing opportunity — window closes |
| **Temporary trend** | Spike driven by one hit or one streamer moment | Will be saturated before you ship |
| **Saturated** | High release volume, falling median revenue | Avoid without an exceptional wedge |
| **Underserved** | Loud demand in reviews/Reddit, few or dated supply | The real opportunity bucket |

Do the same for mechanics: **proven** (shipped in multiple successful games, players understand
it) versus **risky/unvalidated** (sounds great, no shipped evidence it is fun). One risky
mechanic can be the hook; a concept made of three unvalidated mechanics is a research project,
not a product.

The trend-lag trap deserves its own warning: by the time a trend is visible enough to research,
the games that will saturate it are already in development. A visible trend is an argument for
speed or for avoidance, never for a two-year project.

## Output: the market brief

```markdown
# Market brief — <genre / concept space> — <date of research>

## Classification
<one of the five buckets, one paragraph of justification>

## Comparables
| Game | Released | Price | Reviews (count / %) | Team size if known | Verdict |
|---|---|---|---|---|---|

## Recent failures and why
- <game> — <best hypothesis, from reviews/coverage>

## What players are asking for that nobody ships
- <complaint/request> — seen in <where>

## Upcoming competition
- <game> — <status, wishlist signal if visible>

## Pricing norm
<range, and where the quality bar sits>

## Confidence
What was actually observed vs inferred; what couldn't be checked; when this
brief goes stale.
```

Every claim carries its source and date. Distinguish **observed** (a number you read) from
**inferred** (a multiplier you applied) every time — a brief that mixes them silently is
worth less than one that is openly half-empty.

A brief is fresh for weeks, not months. Re-scan before any gate decision if the last scan is
older than about a month, or immediately if a major release landed in the space.

## What this skill does not do

It does not evaluate the user's concept — that is `concept-eval`, which consumes this brief as
evidence. It does not design the wedge. And it does not soften findings: if the honest brief
says "saturated, and the demand you hoped for isn't there", that brief just saved months.
