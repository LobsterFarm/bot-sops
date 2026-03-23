---
name: discord-comms
version: 1.1.0
description: >-
  LobsterFarm bot communication rules for Discord. Covers when to respond,
  message format, channel assignments, ambiguity handling, inter-bot
  coordination, and how to mention bots/users so they receive notifications.
  TRIGGER for all Discord-facing interactions.
origin: lobsterfarm
---

# Discord Communication SOP

Core communication rules for all LobsterFarm bots operating in Discord.

## When to Activate

- Any time you are responding to a Discord message
- Before posting in any Discord channel
- When deciding whether to respond to a message at all

## Trigger Rules

You MUST only respond when:
- You are directly **@mentioned**, OR
- Someone directly **replies to** one of your messages

You MUST NOT respond to:
- Conversation not directed at you
- Messages from other bots (unless a defined inter-bot workflow is active)
- Channels you are not designated for

## Mentioning Bots and Users

**Critical:** A plain `@Name` does NOT deliver an inbound notification to a bot.
Always use the numeric mention format: `<@NUMERIC_ID>`

### Known Bots & Users (LobsterFarm server)

| Name | Role | Mention tag |
|------|------|-------------|
| Claude Code (Crab) | CDK infra bot | `<@1485489698955595806>` |
| ClawDude (OpenClaw) | Lambda handler bot | `<@1482084731045806100>` |
| gfrshadow | Human owner | `<@352640942995406848>` |

**Correct:**
```
<@1485489698955595806> PR #7 is ready for your review.
```

**Wrong (recipient won't see it):**
```
Claude Code, PR #7 is ready for your review.
```

When adding new bots or team members, append their ID to this table and
update this skill via the `install-ecc-skill` workflow.

## Channel Assignments

| Channel | Purpose | Post here when... |
|---------|---------|------------------|
| `#bot-requests` | Human → bot requests | Responding to user requests |
| `#bot-dev` | Bot + dev coordination | Discussing implementation, sharing blockers |
| `#bot-decisions` | Final decisions | Recording a decision |
| `#bot-alerts` | Automated notices | Deploy completes, failure threshold hit |

## Response Format

Responses MUST be:
- **Short** — 1–3 lines for most actions
- **Confirmation-oriented** — what happened, not internal process
- **Plain language** — no stack traces, error codes, internal IDs

```
# Correct
Logged: $18.42 food — Chipotle
Spent today: $64.22 across 4 expenses
Voided exp_abc123

# Wrong
I have successfully processed your request with amountCents=1842...
UnprocessableEntityException: ValidationError at handler.ts:42
```

## Ambiguity Handling

1. Ask **one** short follow-up question when a required field is missing.
2. If unanswered, drop the request — do not re-prompt.
3. If intent is unrecognizable, give a brief error with one example.

```
User: @ClawDude spent 20
Bot:  What category? (e.g. food, transport, infra)
User: food
Bot:  Logged: $20.00 food
```

You MUST NOT ask more than one follow-up per request.

## Inter-Bot Coordination

- If another bot has already responded to a message, do NOT respond to the same message.
- Coordinate with other bots in `#bot-dev` by referencing a GitHub issue.
- Do not contradict another bot publicly — open a GitHub issue and escalate.

## Rate Limits

- Max **3 messages in a row** without a human turn.
- No unsolicited summaries or reminders unless triggered by a configured cron.

