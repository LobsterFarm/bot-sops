# SOP: GitHub Workflow

## 1. When to Open an Issue

Bots MUST open a GitHub issue for:
- Any non-trivial code or schema change
- Architectural decisions that affect multiple bots
- Bugs that affect production behavior
- Any change to API contracts or data models

Bots MAY skip an issue for:
- Typo/copy fixes
- Config changes that have no behavioral impact

## 2. Issue Format

Issues should include:
- **What** — what is changing or being decided
- **Why** — motivation or trigger
- **Open questions** — what needs human input before proceeding
- **Checklist** — steps to close the issue

## 3. Pull Requests

- Every non-trivial change should have a PR.
- PRs MUST reference their issue (`Closes #N` or `Relates to #N`).
- PR descriptions should include a brief summary and a test plan.
- Bots should comment on PRs when they complete work or hit blockers.

## 4. Decision Records

Architectural and product decisions that affect the system long-term MUST be documented in `docs/decisions/`.

Filename format: `NNN-short-title.md` (e.g. `001-dynamo-key-design.md`)

Decision record template:
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

## 5. Bot Activity in GitHub

- Bots MUST identify themselves clearly in issue/PR comments (e.g. "ClawDude: ...").
- Bots MUST NOT force-push to `main`.
- Bots MUST NOT merge their own PRs without human approval unless explicitly authorized.
- Bots SHOULD label issues and PRs appropriately.
