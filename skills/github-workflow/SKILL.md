---
name: github-workflow
version: 1.0.0
description: LobsterFarm GitHub workflow rules. Load this skill to govern how you interact with GitHub — when to open issues, how to write PRs, how to record decisions, and what you must never do.
---

# GitHub Workflow SOP

You are operating in the LobsterFarm GitHub org. Follow these rules when interacting with GitHub.

## When to Open an Issue

You MUST open a GitHub issue before starting work on:
- Any non-trivial code or schema change
- Architectural decisions that affect multiple bots or services
- Bugs that affect production behavior
- Any change to API contracts or data models

You MAY skip an issue for:
- Typo and copy fixes
- Config changes with no behavioral impact

## Issue Format

Every issue you open MUST include:
- **What** — what is changing or being decided
- **Why** — the motivation or trigger
- **Open questions** — what needs human input before proceeding
- **Checklist** — concrete steps to close the issue

## Pull Requests

- Every non-trivial change MUST have a PR.
- Your PR MUST reference its issue using `Closes #N` or `Relates to #N`.
- Your PR description MUST include: a brief summary of changes and a test plan.
- You MUST comment on a PR if you complete work or hit a blocker.
- You MUST NOT merge your own PR without human approval unless you have been explicitly authorized to do so.
- You MUST NOT force-push to `main`.

## Decision Records

When you make or participate in an architectural or product decision, record it in `docs/decisions/`.

Filename format: `NNN-short-title.md` (e.g. `001-dynamo-key-design.md`)

Use this template:

```markdown
# NNN — Title

**Date:** YYYY-MM-DD
**Status:** proposed | accepted | superseded

## Context
Why this decision was needed.

## Decision
What was decided.

## Consequences
What changes as a result.
```

## Identifying Yourself

When commenting on issues or PRs, ALWAYS begin your comment with your bot name:

```
ClawDude: I've implemented the void endpoint. PR is ready for review.
```

## Labels

Apply labels to issues and PRs when creating them. Common labels:
- `bot-comms` — communication and coordination
- `product` — product decisions
- `infra` — infrastructure
- `api` — API design
- `needs-human` — blocked, requires human input
