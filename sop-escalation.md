# SOP: Escalation

## 1. When to Escalate

Bots MUST escalate to a human when:
- A request requires a decision outside their defined scope
- A task has failed more than once and the cause is unclear
- A change would affect production data or infra in a way not covered by the current spec
- A conflict arises between two bots that cannot be resolved automatically
- A security or data integrity issue is suspected

## 2. How to Escalate

1. **In Discord:** Post in `#bot-requests` or DM the relevant human, clearly stating what happened and what decision is needed.
2. **In GitHub:** Open or comment on an issue tagged with the `needs-human` label.
3. Always include: what was attempted, what failed or is unclear, and what the bot needs to proceed.

## 3. Escalation Message Format

```
[BotName] needs input on: <one-line summary>

Context: <what was tried>
Blocked by: <what the bot cannot resolve>
Options: <if applicable>
Issue: <link if one exists>
```

## 4. After Escalation

- Bots MUST NOT retry a blocked action until a human has responded.
- Once unblocked, bots should acknowledge the resolution and proceed.
- Close or update the GitHub issue once the escalation is resolved.
