# WorldJen Rank — Examples

## Get the Rank session

```bash
worldjen rank get
worldjen rank get --json
worldjen rank current        # current ranked leaderboard
```

## Sweep one prompt across many variants

Lock on the first upload, then omit `--prompt` on the rest:

```bash
worldjen rank upload variant_a.mp4 --prompt "a cat sitting on a windowsill" --wait
worldjen rank upload variant_b.mp4 --wait
worldjen rank upload variant_c.mp4 --wait
worldjen rank current
```

## Switch to a new prompt

Reset first; the next upload starts a fresh lock.

```bash
worldjen rank reset
worldjen rank upload variant_a.mp4 --prompt "a dog running through grass" --wait
```

## SDK

```python
import worldjen

worldjen.rank.upload("variant_a.mp4", prompt="a cat sitting on a windowsill")
for path in ("variant_b.mp4", "variant_c.mp4"):
    worldjen.rank.upload(path)            # uses the locked prompt

# Recover from a mismatch
try:
    worldjen.rank.upload("variant.mp4", prompt="a dog")
except worldjen.RankPromptMismatchError as exc:
    print(exc.detail)
    worldjen.rank.reset()
    worldjen.rank.upload("variant.mp4", prompt="a dog")
```

## Reset (destructive — confirm first)

```bash
worldjen rank reset
```

Reset clears all videos and releases the prompt lock. The session id is preserved.

## Troubleshooting

- `RANK_PROMPT_MISMATCH` (exit 2) — you passed a prompt that differs from the locked one. Either omit `--prompt`, pass the locked string, or `worldjen rank reset` to start over.
- Scores not back yet — re-run `worldjen rank current`, or upload with `--wait`.
- Auth failure (exit 2) — confirm `WORLDJEN_API_KEY` or pass `--api-key`.
