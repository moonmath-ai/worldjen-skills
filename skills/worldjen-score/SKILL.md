---
name: worldjen-score
description: Score a single generated clip. Upload one (or a few) videos or images to the user-scoped Score session and get raw per-dimension quality scores back, with optional custom prompt and dimension selection. Use when the user wants quick sanity feedback on a clip they just generated, to A/B two clips, or to inspect evaluator scores without a full benchmark. Backed by `worldjen score get/reset/upload`. NOT for comparative ranking across clips (use `worldjen-rank`) or whole-model benchmarks (use `worldjen-bench`).
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

# WorldJen — Score

"How good is this clip?" Score is the single-clip surface: upload a video (or image) and get raw per-dimension scores back. Each user has exactly one Score session; uploads accumulate in it until you reset.

There is no leaderboard or comparison here — just the dimension scores for the clips you uploaded. For comparative ranking of clips that share a prompt, use `worldjen-rank`. For a full benchmark across many prompts at scale, use `worldjen-bench`.

## Auth

Set `WORLDJEN_API_KEY` (get one at https://www.worldjen.com/settings/api-keys), or pass `--api-key`.

If `worldjen` is not installed yet, run `pip install worldjen` first (or use the `worldjen-install` skill).

## Get the Score session

```bash
worldjen score get          # text view
worldjen score get --json   # machine-readable
```

## Upload and score

Upload one or more clips. Add `--wait` to poll until scores land (or `--timeout` elapses; default poll interval 3s, tune with `--poll-interval`).

```bash
worldjen score upload clip.mp4 --prompt "a cat sitting on a windowsill" --wait
```

Pick specific dimensions (otherwise the default set is scored). List them first with `worldjen dimensions list --json`:

```bash
worldjen score upload clip.mp4 --dimensions aesthetic_quality,dynamic_degree --json
```

Images (t2i) work the same way:

```bash
worldjen score upload image.png --prompt "neon city, cyberpunk" --dimensions prompt_adherence --wait
```

## Confirm before destructive operations

- `worldjen score reset` — clears all videos from the Score session; the session id stays

This cannot be undone. Confirm with the user before running, especially if they have been iterating recently.

## SDK alternative

```python
import worldjen

result = worldjen.score.upload("clip.mp4", prompt="a cat", wait=True)
```

## Stop and ask when needed

- Missing `WORLDJEN_API_KEY`
- The user wants to "delete" the session — there's no delete, only `reset` (which keeps the session id)
- The user is unsure which dimensions to score against — list them with `worldjen dimensions list --json`

## See also

- `worldjen-install` — install the SDK and CLI
- `worldjen-rank` — comparative ranking of clips that share a prompt
- `worldjen-bench` — whole-model benchmark across all dimensions, at scale
- `worldjen-leaderboard` — public leaderboard
- `worldjen-runner` — GPU worker host setup

For examples and troubleshooting, see [references/examples.md](references/examples.md).
