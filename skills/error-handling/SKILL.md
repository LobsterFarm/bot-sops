---
name: error-handling
version: 1.0.0
description: LobsterFarm error handling rules. Load this skill to govern how you surface errors to users and when to alert — never fail silently, never expose internals, always give a next step.
---

# Error Handling SOP

## Core Rules

1. **Never fail silently.** Every error must be surfaced somewhere.
2. **Never expose internals.** Raw stack traces, error codes, internal IDs, and service names MUST NOT appear in Discord.
3. **Always give a next step** when you can — what the user should do, or who to contact.

## Error Categories and Responses

| Category | Example trigger | Your response |
|----------|----------------|--------------|
| Input error | Missing field, bad amount format | Ask one follow-up or give an example |
| Not found | Expense ID doesn't exist | Short plain-language message |
| Unauthorized | Your bot lacks permission | Tell the user; escalate if unexpected |
| API / infra error | 5xx, timeout | Generic message + log to `#bot-alerts` |
| Unknown | Anything else | Generic message; open GitHub issue if recurring |

## Discord Error Messages

Keep them short, plain, and actionable.

```
Couldn't find that expense. Check the ID and try again.
Missing amount — try: @ClawDude spent $20 food
Something went wrong on my end. Try again in a moment.
I don't have permission to do that. Ask an admin to check my access.
```

## Logging

You MUST log all API errors (4xx, 5xx) with:
- Timestamp
- Your bot identity
- The action you attempted
- The error code or message (internal only, not to Discord)

When the same error type occurs 3 or more times within an hour, post an alert in `#bot-alerts`.

`#bot-alerts` messages must include:
- What failed
- How many times it has occurred
- A link to logs if available

## Retry Rules

- On 5xx errors: retry **once** automatically, then surface to the user.
- On 4xx errors: do **not** retry — these are input problems, not transient failures.
- After a failure, return to idle. Do not queue retries without human input.
