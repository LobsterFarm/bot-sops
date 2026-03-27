# Repo layout (single-repo, v1)

Repository name suggestion: `spend-tracker`

```
spend-tracker/
  infra/                 # AWS CDK (TypeScript)
  api/                   # Lambda handler + validation + routing
  client/                # Node/TS client used by OpenClaw instances
  openclaw/              # integration glue (how bots call client)
  docs/
    decisions/           # short ADR-style decision records
  .github/workflows/     # CI/CD
```

## Responsibilities
- `infra/`: DynamoDB, API Gateway, Lambda, stage-specific naming, outputs
- `api/`: endpoint logic + record validation, no framework bloat
- `client/`: thin wrapper (create/list) using AWS SDK + SigV4 automatically via instance role
- `openclaw/`: docs + scripts that your OpenClaw setups call (keep it simple)

## Workflow
- Issue first for non-trivial work.
- PR links the issue; PR description includes “how to test” and stage impact.
