---
name: worldjen-runner
description: Set up and operate the WorldJen runner host — the GPU worker daemon that pulls evaluation jobs and executes them. Use when registering, starting, stopping, or inspecting a Linux+systemd machine that runs WorldJen jobs. NOT for evaluation run lifecycle (use `worldjen-bench` for that).
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

# WorldJen — Runner

Manage the runner host: the GPU worker daemon that pulls evaluation jobs from WorldJen and executes them.

This skill is for **machine setup**. For creating or inspecting evaluation runs (the jobs themselves), use the `worldjen-bench` skill.

## Auth

Set `WORLDJEN_API_KEY` (get one at https://www.worldjen.com/settings/api-keys), or pass `--api-key` to authenticated commands. Local service commands (`install`, `start`, `stop`, `status`, `logs`) do not need auth.

## Prereq: Linux + systemd

The runner service requires Linux with systemd. If the host doesn't use systemd, stop and ask before improvising.

If `worldjen` is not installed yet, run `pip install "worldjen[runner]"` first (or use the `worldjen-install` skill).

## Discovery

```bash
worldjen runner list --json            # backend (your account)
worldjen runner list --local --json    # this machine
```

## Create or register a runner

Use one of:

- `worldjen runner create --name <NAME>` — create a new runner resource and configure this host in one flow
- `worldjen runner register --token <TOKEN> --name <NAME>` — register this host using a token from the dashboard

`<NAME>` is the local instance identifier. Reuse the same `--name` on every subsequent command. Names must match `[a-zA-Z0-9][a-zA-Z0-9_-]{0,63}`. Omit `--name` to use `default`.

## Operate the local service

```bash
worldjen runner install --name <NAME>   # install systemd unit (auto-start on boot)
worldjen runner start --name <NAME>
worldjen runner status --name <NAME>
worldjen runner logs --name <NAME> -n 100
worldjen runner logs --name <NAME> -f   # stream
```

## Confirm before destructive operations

These commands change persistent host state or stop running work. Confirm with the user before running:

- `worldjen runner install --name <NAME>` — installs a systemd unit and enables auto-start on boot. Persists service registration on the host.
- `worldjen runner stop --name <NAME>` — stops accepting new work; in-flight jobs may fail
- `worldjen runner uninstall --name <NAME>` — removes the systemd unit
- `worldjen runner delete --name <NAME>` — deletes the runner from the account AND uninstalls the local service. Once deleted, in-flight runs on this runner will fail.

## Stop and ask when needed

- Missing `WORLDJEN_API_KEY` or registration token
- Host doesn't use Linux + systemd
- The user is unsure which `--name` to use — list with `worldjen runner list --local`

## See also

- `worldjen-install` — install `worldjen[runner]` and verify the CLI
- `worldjen-bench` — create and inspect evaluation runs (the actual benchmark jobs)
- `worldjen-score` — score the clip you just generated
- `worldjen-rank` — quick personal preview vs the standard rank set
- `worldjen-leaderboard` — public leaderboard

For examples and troubleshooting, see [references/examples.md](references/examples.md).
