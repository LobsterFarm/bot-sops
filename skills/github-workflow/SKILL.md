---
name: github-workflow
version: 1.0.0
description: >-
  LobsterFarm GitHub interaction rules. Governs when to open issues, how to
  write PRs, how to record decisions as ADRs, and hard limits on destructive
  git operations. TRIGGER when interacting with any LobsterFarm GitHub repo.
origin: lobsterfarm
---

# GitHub Workflow SOP

Rules for all LobsterFarm bot interactions with GitHub.

## When to Activate

- Opening or updating a GitHub issue
- Creating or reviewing a pull request
- Recording an architectural or product decision
- Commenting on any LobsterFarm repo

## When to Open an Issue

MUST open an issue before:
- Any non-trivial code or schema change
- Architectural decisions affecting multiple bots or services
- Bugs impacting production behavior
- Changes to API contracts or data models

MAY skip for:
- Typo and copy fixes
- Config changes with no behavioral impact

## Issue Format

Every issue MUST include:

```markdown
## What
[What is changing or being decided]

## Why
[Motivation or trigger]

## Open Questions
- [ ] [What needs human input]

## Checklist
- [ ] [Concrete steps to close this issue]
```

## Pull Requests

- Every non-trivial change MUST have a PR.
- PR MUST reference its issue: `Closes #N` or `Relates to #N`.
- PR description MUST include: summary of changes + test plan.
- MUST comment on a PR when you complete work or hit a blocker.
- MUST NOT merge your own PR without explicit human approval.
- MUST NOT force-push to `main`.

## Decision Records (ADRs)

Record architectural and product decisions in `docs/decisions/`.

Filename: `NNN-short-title.md` (e.g. `001-dynamo-key-design.md`)

```markdown
# NNN — Title

**Date:** YYYY-MM-DD
**Status:** proposed | accepted | superseded

## Context
Why this decision was needed.

## Decision
What was decided.

## Alternatives Considered
### Option A
- Pros / Cons / Why not chosen

## Consequences
What changes as a result.
```

## Identifying Yourself

Always begin GitHub comments with your bot name:

```
ClawDude: Implementation complete. PR ready for review.
```

## Labels

Apply these labels when creating issues/PRs:

| Label | Use when |
|-------|---------|
| `bot-comms` | Communication and coordination |
| `product` | Product decisions |
| `infra` | Infrastructure |
| `api` | API design |
| `needs-human` | Blocked, requires human input |
