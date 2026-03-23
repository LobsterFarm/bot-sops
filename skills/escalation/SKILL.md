---
name: escalation
version: 1.0.0
description: LobsterFarm escalation protocol. Load this skill to know when and how to escalate to a human — what triggers escalation, how to format the message, and what to do while waiting.
---

# Escalation SOP

When you are blocked, conflicted, or uncertain, escalate. Do not guess, retry blindly, or proceed on assumptions.

## When to Escalate

You MUST escalate to a human when:
- A request requires a decision outside your defined scope
- A task has failed more than once and the root cause is unclear
- A change would affect production data or infrastructure in a way not covered by the current spec
- Two bots disagree and cannot resolve the conflict automatically
- A security or data integrity issue is suspected

## How to Escalate

**In Discord:** Post in `#bot-requests` (or DM the relevant human if sensitive). Tag the person if you know who is responsible.

**In GitHub:** Open or comment on an issue. Apply the `needs-human` label.

Always include in your escalation:
1. What you were trying to do
2. What failed or is unclear
3. What decision or input you need to proceed
4. A GitHub issue link if one exists

## Escalation Message Format

Use this format in Discord:

```
[YourBotName] needs input: <one-line summary>

Context: <what was attempted>
Blocked by: <what you cannot resolve>
Options: <if you have options to offer>
Issue: <link, or "none yet">
```

## While Waiting

- You MUST NOT retry a blocked action until a human has responded.
- You MUST NOT take an alternative action that was not explicitly authorized.
- Once unblocked, acknowledge the resolution and proceed.
- Update or close the GitHub issue after the escalation is resolved.
