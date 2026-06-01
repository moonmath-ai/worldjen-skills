---
name: worldjen-rank
description: Rank multiple clips that share a prompt into a leaderboard. Upload variants to the user-scoped Rank session and get them sorted; the session locks to the first prompt (server-enforced). Use when sweeping a hyperparameter, comparing model variants on one prompt, or collecting a leaderboard — without a full Bench run. Backed by `worldjen rank get/upload/current/reset`. NOT for single-clip scoring (use `worldjen-score`) or whole-model benchmarks (use `worldjen-bench`).
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

# WorldJen — Rank

"Which of these is the best?" Rank is the comparative surface: upload several clips that share a prompt and get a leaderboard back. One Rank session per user.

For raw per-dimension numbers on a single clip, use `worldjen-score`. For a full benchmark across many prompts and models, use `worldjen-bench`.

## Auth

Set `WORLDJEN_API_KEY` (get one at https://www.worldjen.com/settings/api-keys), or pass `--api-key`.

If `worldjen` is not installed yet, run `pip install worldjen` first (or use the `worldjen-install` skill).

## Prompt lock

A Rank session always evaluates clips against the **same** prompt. The first upload captures and locks the prompt. Every later upload must either omit `--prompt` (the locked value is reused) or pass the exact same string. A different prompt fails fast with exit code 2 and `RANK_PROMPT_MISMATCH`. To rank a new prompt, `reset` first.

## Get the Rank session

```bash
worldjen rank get             # text view
worldjen rank get --json      # machine-readable
worldjen rank current         # the current ranked leaderboard
```

## Upload and rank

Lock the prompt on the first upload, then keep uploading variants without `--prompt`. Add `--wait` to poll until scores land.

```bash
worldjen rank upload variant_a.mp4 --prompt "a cat" --wait
worldjen rank upload variant_b.mp4 --wait    # uses the locked prompt
worldjen rank current
```

## Confirm before destructive operations

- `worldjen rank reset` — clears all videos and releases the prompt lock; the session id stays

This cannot be undone. Confirm with the user before running, especially if they have been iterating recently.

## SDK alternative

```python
import worldjen

worldjen.rank.upload("variant_a.mp4", prompt="a cat sitting on a windowsill")
worldjen.rank.upload("variant_b.mp4")        # uses the locked prompt
```

## Stop and ask when needed

- Missing `WORLDJEN_API_KEY`
- A `RANK_PROMPT_MISMATCH` (exit 2) — the session is locked to a different prompt. Confirm with the user before `reset`, or re-upload with the locked prompt
- The user wants a full leaderboard submission across many prompts — that's `worldjen-bench`, not a Rank session

## See also

- `worldjen-install` — install the SDK and CLI
- `worldjen-score` — raw per-dimension scores for a single clip
- `worldjen-bench` — whole-model benchmark across all dimensions, at scale
- `worldjen-leaderboard` — public leaderboard
- `worldjen-runner` — GPU worker host setup

For examples and troubleshooting, see [references/examples.md](references/examples.md).
