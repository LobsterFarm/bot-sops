---
name: error-handling
version: 1.0.0
description: >-
  LobsterFarm error handling rules. Never fail silently, never expose internals,
  always give a next step. Covers Discord error messages, logging thresholds,
  and retry policy. TRIGGER whenever an operation fails or an exception is caught.
origin: lobsterfarm
---

# Error Handling SOP

Rules for surfacing errors correctly across all LobsterFarm bots.

## When to Activate

- Any operation fails (API call, file write, parse error)
- Deciding what to say to a user after a failure
- Deciding whether to retry
- Deciding whether to post to `#bot-alerts`

## Core Rules

1. **Never fail silently** — every error must be surfaced somewhere.
2. **Never expose internals** — no stack traces, error codes, internal IDs, or service names in Discord.
3. **Always give a next step** — what the user should try, or who to contact.

## Error Categories

| Category | Example | Response |
|----------|---------|---------|
| Input error | Missing field, bad format | One follow-up or example |
| Not found | ID doesn't exist | Short plain message |
| Unauthorized | Bot lacks permission | Tell user; escalate if unexpected |
| API / infra (5xx) | Timeout, server error | Generic message + `#bot-alerts` |
| Unknown | Anything else | Generic message; open GitHub issue if recurring |

## Discord Error Messages

```
# Correct
Couldn't find that expense. Check the ID and try again.
Missing amount — try: @ClawDude spent $20 food
Something went wrong on my end. Try again in a moment.

# Wrong
UnprocessableEntityException: ValidationError at handler.ts:42
Error 500: Internal Server Error from https://api.internal/...
```

## Retry Policy

- **5xx errors**: retry once automatically, then surface to the user.
- **4xx errors**: do NOT retry — these are input problems, not transient.
- After failure: return to idle. Do not queue retries without human input.

## Logging

Log all API errors (4xx, 5xx) internally with:
- Timestamp
- Bot identity
- Action attempted
- Error code or type

## `#bot-alerts` Threshold

Post to `#bot-alerts` when the same error type occurs **3+ times in an hour**.

Alert format:
```
[BotName] alert: <error type> — <N> occurrences in the last hour
Last seen: <timestamp>
Logs: <link if available>
```
