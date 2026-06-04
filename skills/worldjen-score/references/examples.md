# WorldJen Score — Examples

## Get the Score session

```bash
worldjen score get
worldjen score get --json
```

## Score a single clip (wait for results)

```bash
worldjen score upload hero-shot.mp4 --prompt "product on white" --wait
```

## Score against specific dimensions

```bash
worldjen score upload clip.mp4 --dimensions aesthetic_quality,dynamic_degree --json
```

## Score several clips at once

```bash
worldjen score upload clip-01.mp4 clip-02.mp4 clip-03.mp4 --prompt "a cat" --wait
```

## Score an image (t2i)

```bash
worldjen score upload image.png --prompt "neon city, cyberpunk" --dimensions prompt_adherence --wait
```

## SDK

```python
import worldjen

result = worldjen.score.upload("clip.mp4", prompt="a cat", wait=True)
print(result)
```

## Reset (destructive — confirm first)

```bash
worldjen score reset
```

Reset clears all videos from the Score session. The session id is preserved so the dashboard URL stays stable.

## Troubleshooting

- Scores not back yet — re-run `worldjen score get`, or upload with `--wait`. Tune `--poll-interval` / `--timeout` if needed.
- Auth failure (exit 2) — confirm `WORLDJEN_API_KEY` or pass `--api-key`.
- "Which dimension should I use?" — `worldjen dimensions list --json` (filter with `--model-type t2v|i2v|t2i`).
