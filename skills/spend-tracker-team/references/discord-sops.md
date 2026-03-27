# Discord SOPs (humans + @ClawDude + @Crab#6592)

---

## Cluster Setup

### Bots & Discord IDs
| Bot | Discord User ID | Role |
|-----|----------------|------|
| ClaudeCode | `1485489698955595806` | Me — Claude Code CLI bot |
| ClawDude | `1482084731045806100` | OpenClaw agent bot |
| Crab | `1482082263222059189` | Unknown/other bot |

### Humans
| User | Discord User ID |
|------|----------------|
| gfrshadow | `352640942995406848` |
| salad0873 | `1253125206449586218` |

### Server
- **Guild:** OpenClaw Discord Server (`1482083029835972832`)
- **Host:** EC2 instance at `ip-172-31-39-106.us-west-2.compute.internal`
- **User:** `ec2-user`

---

### ClaudeCode (me) — setup
- **Process:** `claude --channels plugin:discord@claude-plugins-official --dangerously-skip-permissions`
- **Launched via:** `tmux` session `discord` + `claude-discord-wrapper.py` (auto-accepts trust dialog)
- **Systemd service:** `claude-discord.service` (user service)
- **Discord config (allowlist):** `~/.claude/channels/discord/access.json`
- **Bot token:** `~/.claude/channels/discord/.env`
- **Restart:** `systemctl --user restart claude-discord.service`

### ClawDude (OpenClaw) — setup
- **Process:** `openclaw-gateway` (Node.js, port 18789)
- **Systemd service:** `openclaw-gateway.service` (user service)
- **Main config (Discord channels, guild allowlist, model, tools):** `~/.openclaw/openclaw.json`
- **Gateway auth token:** inside `~/.openclaw/openclaw.json` under `gateway.auth.token`
- **Discord channel config:** `~/.openclaw/openclaw.json` → `channels.discord.guilds.<guild_id>.channels`
- **Restart:** `systemctl --user restart openclaw-gateway.service`

### Adding a new Discord channel to ClawDude's allowlist
1. Edit `~/.openclaw/openclaw.json`
2. Under `channels.discord.guilds.1482083029835972832.channels`, add:
   ```json
   "<channel_id>": { "requireMention": true }
   ```
3. `systemctl --user restart openclaw-gateway.service`

### Adding a new Discord channel to ClaudeCode's allowlist
1. Edit `~/.claude/channels/discord/access.json`
2. Under `groups`, add:
   ```json
   "<channel_id>": { "requireMention": true, "allowFrom": ["1482084731045806100","352640942995406848","1253125206449586218"] }
   ```
3. Config is hot-reloaded (no restart needed)

---

## Goals
- Keep noise low (bots only act when asked)
- Keep work auditable (GitHub is source of truth)
- Make handoffs deterministic (templates)

## Channels (actual)
- #prd (`1485473432975179966`)
  - Feature requests, product ideas, weekly rollup, PRD tracking
  - Prefix messages: `FEATURE:`, `IDEA:`, `BUG:`, `DECISION:`, `NOTE:`
- #coding (`1482243352878383225`)
  - Coding discussions, implementation handoffs, PR reviews, technical deep-dives
  - Bot-to-bot handoffs for code work should happen here
- #ops (`1485899460318990336`)
  - Service health alerts, deploy failures, liveness ping failures
  - Automated only — no general chat
- DMs (gfrshadow ↔ Claude Code)
  - Direct requests, task delegation, private context

## Mention rules
- Bots respond only when:
  - directly @mentioned
  - OR a user replies to a bot-authored message
- No mention = no action (bots may stay silent)

## Request template (humans)
Copy/paste:
- @ClawDude (or @Crab#6592)
  - **Task:** …
  - **Context:** …
  - **Constraints:** (staging/prod? deadline? budget?)
  - **Output:** (code PR? design doc? checklist?)
  - **Links:** (issue/PR/diagram)

## Handoff template (bot → bot)
- @OtherBot
  - **Context:** …
  - **Ask:** …
  - **Links:** …
  - **Done means:** …
  - **Priority/time:** P0/P1/P2 …

## Decision template
Post in #bot-decisions:
- **Decision:** …
- **Why:** …
- **Impact:** …
- **Links:** …

## Incident template (if prod breaks)
Post in #bot-alerts:
- **What happened:** …
- **User impact:** …
- **Current status:** investigating/mitigated/resolved
- **Next update:** time
- **Link:** GitHub issue
