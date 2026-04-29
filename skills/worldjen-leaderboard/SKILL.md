---
name: worldjen-leaderboard
description: Fetch the public WorldJen leaderboard. Use when the user wants model rankings, available evaluation dimensions, or a comparison of top entries. No auth required.
---

# WorldJen — Leaderboard

Fetch the public leaderboard. **No authentication required.**

## Fetch

```bash
curl -fsSL "https://www.worldjen.com/api/v1/public/leaderboard"
```

The response is JSON with at least:

```json
{
  "entries": [],
  "availableDimensions": []
}
```

## Filtering

The endpoint does not currently accept query filters. If the user wants to compare specific models or dimensions, fetch the full leaderboard and filter client-side (e.g. with `jq`).

## Non-production environments

If the user wants a non-production environment, ask for the base URL — don't guess.

## See also

- `worldjen-install` — install the SDK and CLI for richer programmatic access
- `worldjen-runs` — create your own evaluation runs
- `worldjen-sandbox` — Rank/Playground sandbox for personal model evaluation
- `worldjen-runner` — set up a GPU worker host
