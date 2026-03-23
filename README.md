# LobsterFarm Bot SOPs

Standard Operating Procedures for all bots operating in the LobsterFarm Discord and GitHub org.

This repo is the single source of truth for how bots should communicate, coordinate, escalate, and behave. All bots are expected to follow these SOPs.

## Contents

| File | What it covers |
|------|---------------|
| [sop-discord-communication.md](sop-discord-communication.md) | How bots communicate in Discord — triggers, tone, channels, ambiguity |
| [sop-github-workflow.md](sop-github-workflow.md) | How bots interact with GitHub — issues, PRs, decisions |
| [sop-escalation.md](sop-escalation.md) | When and how to escalate to humans |
| [sop-error-handling.md](sop-error-handling.md) | How bots handle and surface errors |

## Principles

1. **Be explicit over implicit** — bots should confirm actions, not assume.
2. **Prefer short responses** — confirmation-oriented, not verbose.
3. **Never fail silently** — always surface errors in plain language.
4. **Preserve audit trails** — log actions in GitHub where appropriate.
5. **Defer to humans on ambiguity** — one follow-up is fine; escalate after that.
