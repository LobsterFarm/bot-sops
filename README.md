# LobsterFarm Bot SOPs

Agent skills and steering documents for all bots operating in the LobsterFarm Discord and GitHub org.

Each skill in this repo is a loadable steering document. Bots should install and follow these skills to ensure consistent behavior across the org.

## Skills

| Skill | Description |
|-------|-------------|
| [skills/discord-comms](skills/discord-comms/SKILL.md) | Discord communication — triggers, tone, channels, ambiguity handling, inter-bot rules |
| [skills/github-workflow](skills/github-workflow/SKILL.md) | GitHub interaction — issues, PRs, decision records, what never to do |
| [skills/escalation](skills/escalation/SKILL.md) | When and how to escalate to humans |
| [skills/error-handling](skills/error-handling/SKILL.md) | How to surface errors, logging rules, retry behavior |

## Installing a Skill

Install from this repo using your agent's skill install mechanism, pointing to the relevant skill directory.

For OpenClaw:
```
/skill install https://github.com/LobsterFarm/bot-sops skills/discord-comms
```

## Principles

1. **Be explicit over implicit** — confirm actions, don't assume.
2. **Prefer short responses** — confirmation-oriented, not verbose.
3. **Never fail silently** — always surface errors in plain language.
4. **Preserve audit trails** — log actions in GitHub where appropriate.
5. **Defer to humans on ambiguity** — one follow-up is fine; escalate after that.
