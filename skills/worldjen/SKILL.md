---
name: worldjen
description: Operate the WorldJen runner and SDK or CLI. Use when installing WorldJen, setting up or operating a runner, checking run status, or retrieving leaderboard data.
disable-model-invocation: true
---

# WorldJen

Use this skill for public WorldJen operational tasks.

## Defaults

- Prefer an active Python environment before running install commands.
- Prefer stable public commands and public SDK entrypoints only.
- Prefer `--json` output when available.
- Do not invent runner IDs, model IDs, or run IDs. Fetch them first.
- Use `WORLDJEN_API_KEY` or `--api-key` for authenticated CLI commands.
- Treat local runner service commands as Linux plus systemd operations.

## Install SDK and CLI

Use the core package when the user needs the SDK or CLI only:

```bash
pip install worldjen
```

Use the runner extra when the user also needs local runner operations:

```bash
pip install "worldjen[runner]"
```

With `uv`, create and activate an environment first:

```bash
uv venv && source .venv/bin/activate
uv pip install "worldjen[runner]"
```

Verify the install with:

```bash
worldjen --version
```

## Install and run the runner

Start by discovering existing runners:

```bash
worldjen runner list --json
worldjen runner list --local --json
```

Use one of these setup paths:

- `worldjen runner create --name <NAME>` when creating a runner resource and configuring the current host in one flow
- `worldjen runner register --token <TOKEN> --name <NAME>` when the user already has a registration token

Operate the local service with:

```bash
worldjen runner start --name <NAME>
worldjen runner stop --name <NAME>
worldjen runner status --name <NAME>
worldjen runner logs --name <NAME> -n 100
```

Reuse the same `--name` value consistently for a given runner instance.

## Check run status

For queued CLI runs, gather IDs before creating or inspecting runs:

```bash
worldjen dimensions list --json
worldjen models list
worldjen runner list --json
```

Create a queued run with explicit IDs:

```bash
worldjen runs create --name "<RUN_NAME>" --dimensions "<DIM1,DIM2>" --runner-id "<RUNNER_ID>" --model-id "<MODEL_ID>"
```

Inspect status with:

```bash
worldjen runs list --json
worldjen runs get <RUN_ID> --json
worldjen runs logs <RUN_ID>
worldjen runs videos <RUN_ID> --json
```

For local Python SDK execution, use the public `worldjen.run(...)` entrypoint and read the returned `run_id` and `status`.

## Retrieve leaderboard data

Fetch the public leaderboard with:

```bash
curl -fsSL "https://www.worldjen.com/api/v1/public/leaderboard"
```

Expect a JSON object with:

- `entries`
- `availableDimensions`

If the user wants a non-production environment, ask for the base URL instead of guessing.

## Stop and ask when needed

- Missing auth, IDs, or runner tokens
- A host does not use Linux with systemd for runner service operations
- The requested workflow depends on private or undocumented behavior

## Additional resource

Read [reference.md](reference.md) for command sequences, examples, and troubleshooting.
