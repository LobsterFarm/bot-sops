---
name: discord-comms
version: 1.4.0
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

## Sending to Any Channel (Proactive Posts)

The `reply` tool is NOT limited to the originating channel. You can post into any channel by passing its ID as `chat_id`:

```
reply(chat_id="<TARGET_CHANNEL_ID>", text="...")
```

No `reply_to` is needed for a fresh post. This is how to proactively notify a channel (e.g. post a summary into #spending without waiting for a user message).

### Known Channel IDs (LobsterFarm)

| Channel | ID |
|---------|-----|
| #general | `1482083030737616909` |
| #open-forum | `1482243066755813476` |
| #coding | `1482243352878383225` |
| #prd | `1485473432975179966` |
| #parking | `1485473470241574964` |
| #spending | `1485817721424707614` |
| #ops | `1485899460318990336` |
| #notes | `1486214143265607690` |
| #stock-trading | `1486584391256772688` |

## Out-of-Band (no Discord)

To reach Claude Code directly without Discord:
```bash
openclaw agent --agent main --message "..."
```

## Cluster Setup (EC2 — ip-172-31-39-106.us-west-2)

Both bots run on the same EC2 instance as `ec2-user`.

### ClaudeCode (`<@1485489698955595806>`)
- **Service:** `claude-discord.service` (systemd user)
- **Discord allowlist config:** `~/.claude/channels/discord/access.json`
  - Structure: `groups.<channel_id>.{ requireMention, allowFrom[] }`
  - Config is hot-reloaded — no restart needed after edits
- **Restart:** `systemctl --user restart claude-discord.service`

### ClawDude / openclaw (`<@1482084731045806100>`)
- **Service:** `openclaw-gateway.service` (systemd user, port 18789)
- **Main config:** `~/.openclaw/openclaw.json`
  - Discord channel allowlist: `channels.discord.guilds.<guild_id>.channels.<channel_id>.{ requireMention }`
  - Allowed users per guild: `channels.discord.guilds.<guild_id>.users[]`
- **Restart:** `systemctl --user restart openclaw-gateway.service`
- **Skills:** synced hourly from `LobsterFarm/bot-sops` → `~/.openclaw/workspace/skills/`
  - Force sync: `systemctl --user start sync-skills`

### Adding a new channel to both bots' allowlists
**ClaudeCode** (`~/.claude/channels/discord/access.json`):
```json
"<channel_id>": { "requireMention": true, "allowFrom": ["1482084731045806100","352640942995406848","1253125206449586218"] }
```
**ClawDude** (`~/.openclaw/openclaw.json` → `channels.discord.guilds.1482083029835972832.channels`):
```json
"<channel_id>": { "requireMention": true }
```
Then restart ClawDude: `systemctl --user restart openclaw-gateway.service`

---

## LobsterFarm/spend-tracker Context

- Stack: AWS CDK (TypeScript), API Gateway HTTP API, Lambda, DynamoDB, IAM/SigV4 auth
- Stages: `staging` and `prod`
- Endpoints: `POST /expenses`, `GET /expenses`, `GET /expenses/{id}`, `GET /summary`, `POST /expenses/{id}/void`
- Work split: Claude Code owns CDK infra (#3), ClawDude owns Lambda handler (#4)
- Canary: `GET /expenses` — merge infra first, rebase handler on top, smoke test staging from both instances before prod
