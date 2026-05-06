# WorldJen Install — Examples

## Core install

```bash
pip install worldjen
worldjen --version
```

## Runner install (Linux + systemd host only)

```bash
pip install "worldjen[runner]"
worldjen --version
```

## With uv

```bash
uv venv
source .venv/bin/activate
uv pip install "worldjen[runner]"
worldjen --version
```

## Upgrade core SDK/CLI

```bash
pip install -U worldjen
worldjen --version
```

## Upgrade a runner host (Linux + systemd)

```bash
# Find local runners
worldjen runner list --local --json

# For each runner: stop, upgrade, refresh the systemd unit, start
worldjen runner stop --name gpu-0
pip install -U "worldjen[runner]"
worldjen runner uninstall --name gpu-0
worldjen runner install --name gpu-0
worldjen runner start --name gpu-0

# Verify
worldjen --version
worldjen runner status --name gpu-0
```

With `uv`, activate the venv first and substitute `uv pip install -U "worldjen[runner]"` in step 2.

## Troubleshooting

- `worldjen: command not found` — activate the environment where it was installed. Verify with `python -m pip show worldjen`.
- `worldjen[runner]` fails on macOS — runner service management requires Linux + systemd. macOS hosts can install the SDK/CLI for run creation and inspection but cannot run the runner service.
- Pip resolves an old version — your environment may have a stale pin. Try `pip install -U worldjen` or recreate the environment.
- `worldjen --version` shows the new release but the runner is still running the old one — the systemd service caches the old code; stop, `runner uninstall` + `runner install`, then `runner start` (see the upgrade flow above).
