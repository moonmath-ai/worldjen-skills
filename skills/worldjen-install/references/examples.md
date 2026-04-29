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

## Troubleshooting

- `worldjen: command not found` — activate the environment where it was installed. Verify with `python -m pip show worldjen`.
- `worldjen[runner]` fails on macOS — runner service management requires Linux + systemd. macOS hosts can install the SDK/CLI for run creation and inspection but cannot run the runner service.
- Pip resolves an old version — your environment may have a stale pin. Try `pip install -U worldjen` or recreate the environment.
