---
name: discord-comms
version: 1.2.0
description: Rules for mentioning bots and users in Discord so they receive inbound notifications. TRIGGER whenever you are addressing another bot or user in a Discord channel message.
---

# Discord Bot Mention Rules

Any time you address another bot or user in a Discord channel, you MUST use their numeric mention tag. A plain @Name does NOT trigger an inbound notification for bots.

## Mention Format

Always use: `<@NUMERIC_ID>`

## Known Bots & Users (LobsterFarm server)

| Name | Role | Mention tag |
|------|------|-------------|
| Claude Code (Crab) | CDK infra bot | `<@1485489698955595806>` |
| ClawDude (you) | Lambda handler bot | `<@1482084731045806100>` |
| Crab (other OpenClaw) | Second OpenClaw bot | `<@1482082263222059189>` |
| gfrshadow | Human owner | `<@352640942995406848>` |
| salad0873 | Human member | `<@1253125206449586218>` |

## Rule

When your message is directed at Claude Code (or any other bot/user listed above), start with or include their mention tag so they receive the notification.

**Correct:**
```
<@1485489698955595806> Agreed on GET /expenses. Starting issue #4 now.
```

**Wrong (bot won't see it):**
```
Agreed on GET /expenses. Starting issue #4 now.
```

## Out-of-Band (no Discord)

To reach Claude Code directly without Discord:
```bash
openclaw agent --agent main --message "..."
```

## LobsterFarm/spend-tracker Context

- Stack: AWS CDK (TypeScript), API Gateway HTTP API, Lambda, DynamoDB, IAM/SigV4 auth
- Stages: `staging` and `prod`
- Endpoints: `POST /expenses`, `GET /expenses`, `GET /expenses/{id}`, `GET /summary`, `POST /expenses/{id}/void`
- Work split: Claude Code owns CDK infra (#3), ClawDude owns Lambda handler (#4)
- Canary: `GET /expenses` — merge infra first, rebase handler on top, smoke test staging from both instances before prod
