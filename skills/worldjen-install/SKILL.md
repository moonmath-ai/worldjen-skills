---
name: worldjen-install
description: Install or upgrade the WorldJen SDK and CLI in the active Python environment. Use when setting up `worldjen` for the first time, switching between core and runner installs, verifying the install, or upgrading to the latest `worldjen` / `worldjen[runner]` release (auto-restarts the runner systemd service so it picks up the new version). NOT for runner host registration (see `worldjen-runner`), benchmark run lifecycle (see `worldjen-bench`), or upgrading the worldjen-skills plugin itself (see `worldjen-update`).
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

# WorldJen — Install

Install the `worldjen` Python package so the SDK and CLI are available.

## Defaults

- Prefer an active Python environment before running install commands.
- Verify with `worldjen --version` after installing.

## Install

Core SDK and CLI:

```bash
pip install worldjen
```

Runner extra (only when this host will run the GPU worker daemon — Linux + systemd required):

```bash
pip install "worldjen[runner]"
```

With `uv`, create and activate an environment first:

```bash
uv venv && source .venv/bin/activate
uv pip install "worldjen[runner]"
```

## Verify

```bash
worldjen --version
```

If `worldjen: command not found`, activate the environment where you installed it. Verify with `python -m pip show worldjen`.

## Upgrade

Upgrade `worldjen` in the active environment to the latest release. If a runner service is installed on this host, the upgrade reinstalls the systemd unit and restarts it so the new version is actually picked up — a plain `pip install -U` is not enough because the running daemon keeps the old code resident.

1. Detect runner instances on this host (skip steps 2 and 4 on hosts without a runner or without systemd):

    ```bash
    worldjen runner list --local --json
    ```

2. Stop each runner before upgrading so in-flight jobs don't crash mid-upgrade. Check `worldjen runner status --name <NAME>` first and confirm with the user if a job is currently executing — `stop` will fail any in-flight work.

    ```bash
    worldjen runner stop --name <NAME>
    ```

3. Upgrade the package in the same environment that owns the existing install:

    ```bash
    pip install -U worldjen              # core SDK/CLI
    pip install -U "worldjen[runner]"    # runner host
    # or, with uv (activate the venv first):
    uv pip install -U "worldjen[runner]"
    ```

4. Reinstall and restart each runner so the systemd unit is regenerated against the upgraded binary (a new release may change entry points or unit contents):

    ```bash
    worldjen runner uninstall --name <NAME>
    worldjen runner install --name <NAME>
    worldjen runner start --name <NAME>
    ```

   `runner uninstall` removes only the systemd unit — it does NOT delete the runner from your account, so registration and `--name` are preserved.

5. Verify the new version is live:

    ```bash
    worldjen --version
    worldjen runner status --name <NAME>
    ```

## Stop and ask when needed

- Host doesn't have an active Python environment and the user hasn't said where to install.
- The user wants the runner extra on macOS — `worldjen[runner]` runs on Linux + systemd; the SDK/CLI alone work fine on macOS for run creation and inspection.
- Upgrading a host with a runner that has a job currently in flight — confirm before stopping the service.
- Multiple runner instances on the same host — confirm whether to upgrade and reinstall all of them or just a subset.

## See also

- `worldjen-runner` — set up and operate a runner host (Linux + systemd)
- `worldjen-bench` — benchmark a whole model (create and inspect evaluation runs)
- `worldjen-score` — score the clip you just generated
- `worldjen-rank` — quick personal preview vs the standard rank set
- `worldjen-leaderboard` — fetch the public leaderboard (no auth)

For examples and troubleshooting, see [references/examples.md](references/examples.md).
