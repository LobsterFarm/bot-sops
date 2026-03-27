# CI/CD SOP (two stages)

## Principles
- Deploy only from `main`.
- Staging auto-deploy; prod requires approval.
- No long-lived AWS keys in GitHub.

## Recommended implementation
Use GitHub Actions with OIDC to assume an AWS role.

Environments:
- `staging`: auto
- `prod`: protected (required reviewers)

Workflows:
1) `.github/workflows/deploy-staging.yml`
   - trigger: push to `main`
   - steps: install deps, `cd infra`, `cdk deploy SpendTrackerStack-staging --require-approval never`

2) `.github/workflows/deploy-prod.yml`
   - trigger: workflow_dispatch
   - environment: prod (requires approval)
   - steps: same as above but `SpendTrackerStack-prod`

## Change management
- Any schema-breaking API change:
  - deploy to staging
  - test with both bots
  - announce in #bot-decisions
  - only then promote to prod
