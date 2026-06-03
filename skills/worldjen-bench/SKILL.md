---
name: worldjen-bench
description: Benchmark or evaluate an entire AI model. Create, list, inspect, and compare WorldJen Bench runs — large-scale evaluation across many prompts and dimensions, executed on a GPU worker queue. Invoke ONLY when the target is a whole model — a model id, a checkpoint, a Hugging Face repo, "the model", "my model", comparing two models, tracking drift across model versions, or gating CI on a model's benchmark. To score an individual clip, video, or image, use `worldjen-score` instead, NOT this skill. Backed by `worldjen bench create / list / get / cancel / delete / logs / csv / videos / download-videos`. NOT for runner host setup (use `worldjen-runner`) or ranking clips that share a prompt (use `worldjen-rank`).
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

# WorldJen — Bench

"How does the model perform overall?" Bench runs a full benchmark at scale: many prompts, your chosen dimensions, optionally multiple models compared, executed on a GPU worker queue.

This skill is for **Bench run lifecycle**. For setting up the GPU worker host that executes runs, use the `worldjen-runner` skill. For single-clip scoring, use `worldjen-score`; for prompt-locked ranking, use `worldjen-rank`.

## Auth

Set `WORLDJEN_API_KEY` (get one at https://www.worldjen.com/settings/api-keys), or pass `--api-key`.

If `worldjen` is not installed yet, run `pip install worldjen` first (or use the `worldjen-install` skill).

## Discover inputs first

Don't invent IDs — list them:

```bash
worldjen dimensions list --json
worldjen models list
worldjen runner list
```

## Create a Bench run

```bash
worldjen bench create \
  --name "<RUN_NAME>" \
  --dimensions "<DIM1,DIM2>" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>"
```

Optional flags:

- `--reference-model-id <REF_MODEL_ID>` — compare against another model in the same run
- `--reasoning` — store the per-dimension reasoning and generated summaries (off by default)
- `--run-instructions <JSON_OR_PATH>` — runner pipeline options (inline JSON or path to a `.json`)

## Inspect

```bash
worldjen bench list --json
worldjen bench list --status running          # filter; also --page / --limit
worldjen bench get <RUN_ID> --json
worldjen bench logs <RUN_ID>
worldjen bench videos <RUN_ID> --json
worldjen bench csv <RUN_ID> -o results.csv    # scorecard
worldjen bench download-videos <RUN_ID> -o ./videos
```

## Compare runs

Fetch both runs as JSON and diff the per-dimension scores. Useful for catching regressions across model checkpoints (v3 → v4 → v5):

```bash
worldjen bench get <RUN_ID_A> --json
worldjen bench get <RUN_ID_B> --json
```

Flag any dimension where the score dropped by your threshold (5pp is a common gate for CI).

## SDK alternative

- `worldjen.bench.create(...)` — enqueue a run on a runner you provisioned; the call returns immediately and the worker handles generation, upload, and scoring.
- `worldjen.bench.run_with_pipeline(...)` — in-process variant for scripts that already have the model loaded in Python; the SDK drives generation, upload, and (optionally) waits for evaluator scores. There is no CLI equivalent — Python callables don't survive shell arguments.

## REST API (no SDK)

The CLI and SDK both wrap `/api/v1/bench`. Use the `X-API-Key` header and an `Idempotency-Key` on POSTs so retries don't double-create.

## Confirm before destructive operations

- `worldjen bench cancel <RUN_ID>` — stops a queued or in-flight run; partial results may be lost
- `worldjen bench delete <RUN_ID>` — permanently removes the run record and artifacts

Confirm with the user before either.

## Stop and ask when needed

- Missing `WORLDJEN_API_KEY`
- Missing runner ID, model ID, or run ID — list them first
- The user only wants to score a single clip — that's `worldjen-score`, not a full Bench run

## See also

- `worldjen-install` — install the SDK and CLI
- `worldjen-runner` — set up the GPU worker host
- `worldjen-score` — raw per-dimension scores for a single clip
- `worldjen-rank` — comparative ranking of clips that share a prompt
- `worldjen-leaderboard` — public leaderboard (no auth)

For examples and troubleshooting, see [references/examples.md](references/examples.md).
