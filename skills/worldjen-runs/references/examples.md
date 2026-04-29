# WorldJen Runs — Examples

## Discover inputs

```bash
worldjen dimensions list --json
worldjen models list
worldjen runner list --json
```

## Create a queued run

```bash
worldjen runs create \
  --name "example-run" \
  --dimensions "subject_consistency,scene_consistency" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>"
```

## With a reference model for comparison

```bash
worldjen runs create \
  --name "comparison" \
  --dimensions "motion_smoothness" \
  --runner-id "<RUNNER_ID>" \
  --model-id "<MODEL_ID>" \
  --reference-model-id "<REF_MODEL_ID>"
```

## Inspect

```bash
worldjen runs list --json
worldjen runs get "<RUN_ID>" --json
worldjen runs logs "<RUN_ID>"
worldjen runs videos "<RUN_ID>" --json
worldjen runs csv "<RUN_ID>"
worldjen runs download-videos "<RUN_ID>"
```

## SDK (no runner daemon)

```python
import worldjen

result = worldjen.run(
    my_pipeline,
    dimensions=[worldjen.Dimensions.SUBJECT_CONSISTENCY],
    run_name="my-eval",
    model_id="my-org/my-model",
    wait_for_evals=True,
)
print(result.run_id, result.status, result.eval_results)
```

## REST API (no SDK)

```bash
export WORLDJEN_API_KEY="wjk_..."
curl -sS -X POST "https://www.worldjen.com/api/v1/runs" \
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

- Missing run ID — `worldjen runs list --json`.
- Auth failure — confirm `WORLDJEN_API_KEY` or pass `--api-key`.
- Idempotency mismatch (HTTP 409 `idempotency_mismatch`) — same `Idempotency-Key` was reused with a different body. Generate a new one with `uuidgen`.
