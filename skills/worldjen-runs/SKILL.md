---
name: worldjen-runs
description: Create, list, and inspect WorldJen evaluation runs — the jobs that score one model on one or more dimensions. Use when starting an eval run, checking run status, fetching logs, downloading videos, or canceling/deleting a run. NOT for runner host setup (use `worldjen-runner` for that).
---

# WorldJen — Runs

Create and manage **evaluation runs** — the jobs that score one model on one or more dimensions.

This skill is for **run lifecycle**. For setting up the GPU worker host that executes runs, use the `worldjen-runner` skill.

## Auth

Set `WORLDJEN_API_KEY` (get one at https://www.worldjen.com/settings/api-keys), or pass `--api-key`.

If `worldjen` is not installed yet, run `pip install worldjen` first (or use the `worldjen-install` skill).

## Discover inputs first

Don't invent IDs — list them:

```bash
worldjen dimensions list --json
worldjen models list
worldjen runner list --json
```

## Create a queued run

```bash
worldjen runs create \
  --name "<RUN_NAME>" \
  --dimensions "<DIM1,DIM2>" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>"
```

Optional flags:

- `--reference-model-id <REF_MODEL_ID>` — compare against another model in the same run
- `--run-instructions <JSON_OR_PATH>` — pipeline options for the runner (inline JSON or path to `.json`)

## Inspect

```bash
worldjen runs list --json
worldjen runs get <RUN_ID> --json
worldjen runs logs <RUN_ID>
worldjen runs videos <RUN_ID> --json
worldjen runs csv <RUN_ID>            # scorecard
worldjen runs download-videos <RUN_ID>
```

## SDK alternative

For local Python execution without a runner daemon, use `worldjen.run(pipeline, dimensions=[...], run_name=..., model_id=..., wait_for_evals=True)`. It runs your pipeline on the local machine, uploads videos, and waits for evals. Returned object has `run_id`, `status`, and `eval_results`.

## REST API (no SDK)

The CLI and SDK both wrap `/api/v1/runs`. Use `X-API-Key` header and an `Idempotency-Key` on POSTs so retries don't double-create.

## Confirm before destructive operations

- `worldjen runs cancel <RUN_ID>` — stops a queued or in-flight run; partial results may be lost
- `worldjen runs delete <RUN_ID>` — permanently removes the run record and artifacts

Confirm with the user before either.

## Stop and ask when needed

- Missing `WORLDJEN_API_KEY`
- Missing runner ID, model ID, or run ID — list them first

## See also

- `worldjen-install` — install the SDK and CLI
- `worldjen-runner` — set up the GPU worker host
- `worldjen-leaderboard` — public leaderboard (no auth)
- `worldjen-sandbox` — user-scoped sandbox runs (Playground and Rank)

For examples and troubleshooting, see [references/examples.md](references/examples.md).
