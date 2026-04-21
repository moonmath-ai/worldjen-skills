# WorldJen Reference

Use this file when the main skill needs concrete examples or quick troubleshooting.

## Install examples

Core SDK and CLI:

```bash
pip install worldjen
worldjen --version
```

Runner-capable install:

```bash
pip install "worldjen[runner]"
worldjen --version
```

With `uv`:

```bash
uv venv
source .venv/bin/activate
uv pip install "worldjen[runner]"
worldjen --version
```

## Runner examples

List backend and local runners:

```bash
worldjen runner list --json
worldjen runner list --local --json
```

Create a new runner and configure the current host:

```bash
worldjen runner create --name default
```

Register a host from an existing token:

```bash
worldjen runner register --token "<TOKEN>" --name default
```

Operate the local service:

```bash
worldjen runner status --name default
worldjen runner logs --name default -n 100
worldjen runner stop --name default
worldjen runner start --name default
```

## Run status examples

Discover inputs first:

```bash
worldjen dimensions list --json
worldjen models list
worldjen runner list --json
```

Create a queued run:

```bash
worldjen runs create \
  --name "example-run" \
  --dimensions "subject_consistency,scene_consistency" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>"
```

Inspect it:

```bash
worldjen runs list --json
worldjen runs get "<RUN_ID>" --json
worldjen runs logs "<RUN_ID>"
worldjen runs videos "<RUN_ID>" --json
```

## Leaderboard example

Fetch the public leaderboard:

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

## Troubleshooting

`worldjen: command not found`

- Activate the environment where `worldjen` was installed.
- Verify the install with `python -m pip show worldjen` if needed.

`runner status` or `runner logs` fails on this host

- Runner service management expects Linux with systemd.
- If the host does not use systemd, stop and ask before improvising.

Missing runner ID, model ID, or run ID

- List them first with `worldjen runner list --json`, `worldjen models list`, or `worldjen runs list --json`.

Authentication failure

- Confirm `WORLDJEN_API_KEY` is set, or pass `--api-key` explicitly for authenticated CLI commands.
