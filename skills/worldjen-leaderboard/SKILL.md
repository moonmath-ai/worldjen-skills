---
name: worldjen-leaderboard
description: Fetch the public WorldJen leaderboard. Use when the user wants model rankings, available evaluation dimensions, or a comparison of top entries. No auth required.
---

## Preamble (run first)

Best-effort update check. Fails silently on network errors or non-marketplace installs. If output starts with `UPGRADE_AVAILABLE` or `JUST_UPGRADED`, surface it once to the user and continue with the skill workflow.

```bash
{
  for _p in \
    "$HOME/.claude/plugins/marketplaces/worldjen/bin/check-update" \
    "$HOME/.codex/.tmp/plugins/plugins/worldjen/bin/check-update"; do
    if [ -x "$_p" ]; then "$_p" 2>/dev/null && break; fi
  done
} 2>/dev/null || true
```

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

## See also

- `worldjen-install` — install the SDK and CLI for richer programmatic access
- `worldjen-bench` — benchmark a whole model (every leaderboard row is a full Bench run)
- `worldjen-score` — score the clip you just generated
- `worldjen-rank` — quick personal preview vs the standard rank set
- `worldjen-runner` — set up a GPU worker host
