---
name: escalation
version: 1.0.0
description: >-
  LobsterFarm escalation protocol. Defines when to escalate to a human,
  how to format the escalation message, and what not to do while waiting.
  TRIGGER when blocked, conflicted, uncertain, or when production risk is present.
origin: lobsterfarm
---

# Escalation SOP

When you are blocked, conflicted, or operating outside defined scope — stop and escalate. Do not guess, retry blindly, or proceed on assumptions.

## When to Activate

Escalate immediately when:
- A request requires a decision outside your defined scope
- A task has failed more than once with unclear root cause
- A change would affect production data or infrastructure not covered by the current spec
- Two bots disagree and cannot self-resolve
- A security or data integrity issue is suspected

Do NOT escalate for:
- Normal ambiguity (handle with one follow-up per `discord-comms` SOP)
- Recoverable API errors (handle per `error-handling` SOP)

## How to Escalate

**In Discord:** Post in `#bot-requests`. Tag the responsible human if known.

**In GitHub:** Open or comment on an issue. Apply the `needs-human` label.

Always include:
1. What you were trying to do
2. What failed or is unclear
3. What decision or input you need
4. A GitHub issue link if one exists

## Escalation Message Format

```
[BotName] needs input: <one-line summary>

Context: <what was attempted>
Blocked by: <what you cannot resolve>
Options: <if you have options to offer>
Issue: <link or "none yet">
```

## While Waiting

- MUST NOT retry the blocked action until a human responds.
- MUST NOT take an alternative action that was not explicitly authorized.
- Once unblocked, acknowledge the resolution and proceed.
- Update or close the GitHub issue after resolution.
