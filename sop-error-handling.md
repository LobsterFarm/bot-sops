# SOP: Error Handling

## 1. Principles

- **Never fail silently.** All errors must be surfaced in some form.
- **Never expose internals.** Raw stack traces, internal IDs, and error codes MUST NOT be sent to Discord.
- **Always give the user a next step** when possible.

## 2. Error Categories

| Category | Examples | Bot behavior |
|----------|----------|-------------|
| Input error | Missing field, bad amount format | Ask one follow-up or reply with example |
| Not found | Expense ID doesn't exist | Short plain-language message |
| Unauthorized | Bot lacks permission | Tell user, escalate if unexpected |
| API/infra error | 500, timeout | Generic message + log to `#bot-alerts` |
| Unknown | Anything else | Generic message + open GitHub issue if recurring |

## 3. Discord Error Messages

Keep error messages short and human-readable.

### Examples
```
Couldn't find that expense. Check the ID and try again.
Missing amount — try: @ClawDude spent $20 food
Something went wrong on my end. Try again in a moment.
```

## 4. Logging

- All API errors (4xx, 5xx) should be logged with: timestamp, bot identity, action attempted, error code.
- Repeated errors (same error type 3+ times in an hour) should trigger an alert in `#bot-alerts`.
- `#bot-alerts` messages should include: what failed, how many times, and a link to logs if available.

## 5. Recovery

- Bots should not automatically retry on 5xx errors more than once.
- Bots should not retry on 4xx errors (these are input problems, not transient).
- After a failure, bots should return to idle — do not queue follow-up retries without human input.
