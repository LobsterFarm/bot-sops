# Spend Tracker system architecture (v1)

## AWS components (per stage)
- DynamoDB table: `spend-records-{stage}`
  - PITR enabled
- Lambda: `spend-api-handler-{stage}`
  - owns all routes (keep it tiny)
- API Gateway HTTP API: `spend-api-{stage}`
  - routes to Lambda
  - IAM auth (SigV4)
- CloudWatch Logs for Lambda

## Stages
- `staging`: safe to test behavior and schema changes
- `prod`: real shared records

Rule: never test breaking changes in prod.

## Identity + auth
- Requests are authorized via IAM.
- Each OpenClaw EC2 instance runs with an instance role.
- Instance role permissions:
  - `execute-api:Invoke` for the specific API/stage
  - (Option A) Only API invocation (preferred)
  - (Option B) Direct Dynamo access (avoid unless you need it)

## DynamoDB data model (suggested)
Primary keys:
- `pk` (string): `GROUP#default` (keeps door open for multi-group)
- `sk` (string): `TS#<createdAt>#ID#<uuid>`

Attributes:
- `id` (uuid)
- `createdAt` (ISO)
- `amountCents` (number)
- `currency` (string)
- `category` (string)
- `merchant` (string, optional)
- `note` (string, optional)
- `createdBy` (string)

Query pattern:
- list by time range using begins_with/range on `sk`.

## Naming conventions
- All resources include `{stage}` suffix.
- CDK stack name includes stage, e.g. `SpendTrackerStack-staging`.

## Observability
- Lambda logs must include request id + stage.
- Add minimal metrics later if needed (invocations/errors/latency).
