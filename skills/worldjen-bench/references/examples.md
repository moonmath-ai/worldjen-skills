# WorldJen Bench — Examples

## Discover inputs

```bash
worldjen dimensions list --json
worldjen models list
worldjen runner list
```

## Create a Bench run

```bash
worldjen bench create \
  --name "example-run" \
  --dimensions "subject_consistency,scene_consistency" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>"
```

## Benchmark with reasoning stored

```bash
worldjen bench create \
  --name "nightly-comparison" \
  --dimensions "subject_consistency,motion_smoothness" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>" \
  --reasoning
```

## With a reference model for comparison

```bash
worldjen bench create \
  --name "comparison" \
  --dimensions "motion_smoothness" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>" \
  --reference-model-id "<REF_MODEL_ID>"
```

## With runner pipeline options

```bash
worldjen bench create \
  --name "tuned-sampler" \
  --dimensions "subject_consistency" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>" \
  --run-instructions ./pipeline-options.json
```

## Inspect

```bash
worldjen bench list --json
worldjen bench list --status running --page 1 --limit 50
worldjen bench get "<RUN_ID>" --json
worldjen bench logs "<RUN_ID>"
worldjen bench videos "<RUN_ID>" --json
worldjen bench csv "<RUN_ID>" -o results.csv
worldjen bench download-videos "<RUN_ID>" -o ./videos
```

## Compare two runs (drift / regression check)

```bash
worldjen bench get run_8a3f --json > /tmp/a.json
worldjen bench get run_91bc --json > /tmp/b.json
# Diff per-dimension scores; flag drops >= 5pp.
```

## SDK (in-process pipeline, no runner daemon)

```python
import worldjen

result = worldjen.bench.run_with_pipeline(
    my_pipeline,
    dimensions=[worldjen.Dimensions.SUBJECT_CONSISTENCY],
    run_name="my-eval",
    model_id="my-org/my-model",
    wait_for_evals=True,
)
print(result.run_id, result.status)
```

## SDK (enqueue on a runner)

```python
import worldjen

run = worldjen.bench.create(
    name="nightly",
    dimensions=["subject_consistency"],
    runner_id="<RUNNER_ID>",
    model_id="my-org/my-model",
)
print(run)
```

## REST API (no SDK)

```bash
export WORLDJEN_API_KEY="wjk_..."
curl -sS -X POST "https://www.worldjen.com/api/v1/bench" \
  -H "X-API-Key: $WORLDJEN_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen)" \
  -d '{
    "name": "demo-run",
    "dimensions": ["subject_consistency"],
    "model_id": "my-org/my-model"
  }'
```

## Troubleshooting

- Missing run ID — `worldjen bench list --json`.
- Auth failure (exit 2) — confirm `WORLDJEN_API_KEY` or pass `--api-key`.
- Idempotency mismatch (HTTP 409 `idempotency_mismatch`) — same `Idempotency-Key` reused with a different body. Generate a new one with `uuidgen`.
