# API contract (v1)

Base URL is stage-specific (staging vs prod).
Auth: IAM (SigV4).

## POST /spend
Create a new spending record.

Request JSON:
```json
{
  "amountCents": 1299,
  "currency": "USD",
  "category": "food",
  "merchant": "Taco Spot",
  "note": "late night",
  "createdBy": "clawdude"
}
```

Response JSON (201):
```json
{
  "id": "b7b6d3b7-2f2c-4d14-bd45-41d47edc2b6c",
  "createdAt": "2026-03-15T00:40:00.000Z"
}
```

## GET /spend
List records.

Query params (optional):
- `from` ISO timestamp
- `to` ISO timestamp
- `limit` integer
- `category` string

Response JSON (200):
```json
{
  "items": [
    {
      "id": "...",
      "createdAt": "2026-03-15T00:40:00.000Z",
      "amountCents": 1299,
      "currency": "USD",
      "category": "food",
      "merchant": "Taco Spot",
      "note": "late night",
      "createdBy": "clawdude"
    }
  ],
  "nextToken": null
}
```

## Error shape (recommended)
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "amountCents must be a positive integer"
  }
}
```
