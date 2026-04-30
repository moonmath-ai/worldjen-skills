---
name: worldjen-sandbox
description: Operate the user-scoped WorldJen sandbox runs — Playground (custom-prompt) and Rank (rank-dimension). One sandbox of each per user. Use when the user wants ad-hoc evaluation without queueing a full run, or wants to reset their sandbox. Backed by `worldjen playground get/reset --kind playground|rank`.
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

# WorldJen — Sandbox (Playground & Rank)

The dashboard exposes two user-scoped sandbox runs: **Playground** (free-form custom prompt) and **Rank** (rank-dimension prompts). Both are operated by the same CLI subcommand, switched via `--kind`.

| `--kind`     | Use when                                                                          |
| ------------ | --------------------------------------------------------------------------------- |
| `playground` | Iterating on prompts, models, or generation settings ad-hoc                       |
| `rank`       | Quick personal preview of how a model would place against the standard rank set   |

If the user is unsure: custom prompt = `playground`, standard rank set = `rank`.

## Auth

Set `WORLDJEN_API_KEY` (get one at https://www.worldjen.com/settings/api-keys), or pass `--api-key`.

If `worldjen` is not installed yet, run `pip install worldjen` first (or use the `worldjen-install` skill).

## Get the active sandbox run

The first call lazily creates the sandbox if it doesn't exist. The run ID is preserved across calls so the dashboard URL stays stable.

```bash
worldjen playground get --kind playground          # Playground sandbox
worldjen playground get --kind rank                # Rank sandbox
worldjen playground get --kind playground --json   # machine-readable
```

## Confirm before destructive operations

- `worldjen playground reset --kind playground` — clears all videos from the Playground sandbox; the run ID stays
- `worldjen playground reset --kind rank` — same for the Rank sandbox

These cannot be undone. Confirm with the user before running, especially if they have been iterating recently.

## Stop and ask when needed

- Missing `WORLDJEN_API_KEY`
- The user wants to "delete" the sandbox — there's no delete, only `reset` (which keeps the run id)
- The user is unsure which `--kind` they want

## See also

- `worldjen-install` — install the SDK and CLI
- `worldjen-runs` — full queued evaluation runs (multiple per user, not user-scoped)
- `worldjen-leaderboard` — public leaderboard
- `worldjen-runner` — GPU worker host setup

For examples and troubleshooting, see [references/examples.md](references/examples.md).
