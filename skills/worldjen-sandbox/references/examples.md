# WorldJen Sandbox — Examples

## Get the Playground sandbox

```bash
worldjen playground get --kind playground
worldjen playground get --kind playground --json
```

## Get the Rank sandbox

```bash
worldjen playground get --kind rank
worldjen playground get --kind rank --json
```

## Reset (destructive — confirm first)

```bash
worldjen playground reset --kind playground
worldjen playground reset --kind rank
```

Reset clears all videos from the active sandbox. The run ID is preserved so the dashboard URL stays stable.

## Troubleshooting

- "Not found" on first call — the sandbox is created lazily; rerun `get` once.
- Auth failure — confirm `WORLDJEN_API_KEY` or pass `--api-key`.
- "Which `--kind` should I use?" — `playground` for a free-form custom prompt; `rank` for the standard rank prompt set.
