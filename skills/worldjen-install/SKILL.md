---
name: worldjen-install
description: Install the WorldJen SDK and CLI in the active Python environment. Use when setting up `worldjen` for the first time, switching between core and runner installs, or verifying the install. NOT for runner host setup (see `worldjen-runner`) or run lifecycle (see `worldjen-runs`).
---

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

## Stop and ask when needed

- Host doesn't have an active Python environment and the user hasn't said where to install.
- The user wants the runner extra on macOS — `worldjen[runner]` runs on Linux + systemd; the SDK/CLI alone work fine on macOS for run creation and inspection.

## See also

- `worldjen-runner` — set up and operate a runner host (Linux + systemd)
- `worldjen-runs` — create and inspect evaluation runs
- `worldjen-leaderboard` — fetch the public leaderboard (no auth)
- `worldjen-sandbox` — Playground and Rank user-scoped sandbox runs

For examples and troubleshooting, see [references/examples.md](references/examples.md).
