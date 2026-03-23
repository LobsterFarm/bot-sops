# SOP: Discord Communication

## 1. Trigger Rules

Bots MUST only respond when:
- Directly **@mentioned**, OR
- Directly **replied to** by a user

Bots MUST NOT respond to:
- General conversation not directed at them
- Other bots (unless a specific inter-bot workflow is defined)
- Messages in channels they are not designated for

## 2. Channel Assignments

| Channel | Purpose | Who posts |
|---------|---------|-----------|
| `#bot-requests` | Humans make requests to bots | Humans + bots (responses) |
| `#bot-dev` | Implementation threads, bot coordination during development | Bots + developers |
| `#bot-decisions` | Finalized architectural and product decisions | Bots + developers |
| `#bot-alerts` | Deploy notices, failures, automated status updates | Bots only |

## 3. Response Style

- Responses MUST be **short and confirmation-oriented**.
- Avoid walls of text. If a summary is long, truncate with a note ("showing top 10").
- Use structured output (tables, lists) only when it genuinely aids clarity.
- Never expose raw stack traces, API errors, or internal IDs in Discord.

### Good examples
```
Logged: $18.42 food — Chipotle
Spent today: $64.22 across 4 expenses
Voided expense exp_abc123
```

### Bad examples
```
I have successfully processed your request and logged the expense with the following details: amount=1842 cents, category=food...
Error: UnprocessableEntityException: ValidationError at handler.ts:42
```

## 4. Ambiguity Handling

When a required field is missing or unclear:
1. Ask **one** short follow-up question.
2. If the follow-up is not answered within the conversation, drop the request (do not re-prompt).
3. If the intent is completely unrecognizable, respond with a brief error and an example.

### Example
```
User: @ClawDude spent 20
Bot:  What category should I use? (e.g. food, transport, infra)

User: food
Bot:  Logged: $20.00 food
```

## 5. Inter-Bot Coordination

- Bots MUST NOT duplicate work. If one bot has already responded to a request, the other should not respond to the same message.
- If bots need to coordinate on a shared task, use `#bot-dev` and reference a GitHub issue.
- Bots should not argue or contradict each other in public channels. Escalate disagreements to a GitHub issue.

## 6. Rate and Spam Limits

- Bots should not send more than **3 messages in a row** without a human turn.
- Bots MUST NOT post unsolicited summaries or reminders unless explicitly configured to do so.
