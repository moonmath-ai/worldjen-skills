# WorldJen Agent Skills

Agent skills for [WorldJen](https://www.worldjen.com) — measurable quality scoring for generated media. Drop them into Claude Code, Codex, or any agent harness so your agent can install the SDK, operate runners, score the clip you just generated, benchmark a whole model, and fetch the public leaderboard for you.

## Quick start

1. **Install the plugin** (Claude Code: two-step CLI; Codex: marketplace + interactive picker, or copy directly):

   ```bash
   # Claude Code (CLI)
   claude plugin marketplace add moonmath-ai/worldjen-skills
   claude plugin install worldjen@worldjen

   # Codex — marketplace path (then pick "worldjen" inside the Codex TUI)
   codex plugin marketplace add moonmath-ai/worldjen-skills

   # Codex — direct skill copy (no TUI required)
   mkdir -p ~/.codex/skills
   cp -R skills/worldjen-* ~/.codex/skills/
   ```

2. Set `WORLDJEN_API_KEY` (get one at <https://www.worldjen.com/settings/api-keys>) for any auth-needed task.
3. Ask your agent: *"Show me the WorldJen leaderboard."* The leaderboard skill is auto-invocable; no syntax to remember.

## What do you want to do?

| Goal                                                   | Skill                  | Auth |
| ------------------------------------------------------ | ---------------------- | ---- |
| Install the SDK and CLI                                | `worldjen-install`     | No   |
| Set up or operate a GPU runner host (Linux + systemd)  | `worldjen-runner`      | Yes  |
| Score a single generated clip                          | `worldjen-score`       | Yes  |
| Rank clips that share a prompt into a leaderboard      | `worldjen-rank`        | Yes  |
| Benchmark a whole model (create / inspect / compare)   | `worldjen-bench`       | Yes  |
| Fetch the public leaderboard                           | `worldjen-leaderboard` | No   |
| Upgrade this plugin to the latest release              | `worldjen-update`      | No   |

**Three surfaces.** `worldjen-score` answers "how good is this clip?" (raw per-dimension scores for one upload). `worldjen-rank` answers "which of these is best?" (a leaderboard across clips that share a prompt). `worldjen-bench` answers "how does the model perform overall?" (a full benchmark across many prompts, on a worker queue).

`worldjen-bench` covers evaluation jobs. `worldjen-runner` covers the GPU worker host that executes them. They are different.

> Requires worldjen SDK **0.6.0+** (Score / Rank / Bench CLI). `pip install -U worldjen` if you're on an older release.

## Invocation syntax

| Platform                | Form                                              |
| ----------------------- | ------------------------------------------------- |
| Claude Code (plugin)    | `/worldjen:worldjen-leaderboard ...`              |
| Claude Code (local)     | `/worldjen-leaderboard ...`                       |
| Codex (plugin or local) | `$worldjen-leaderboard ...`                       |
| Generic agent           | Point at `skills/worldjen-leaderboard/SKILL.md`   |

All skills are auto-invocable. Type natural language and the agent picks the right skill from the description.

## Examples

```text
Show me the WorldJen leaderboard.

Install the WorldJen CLI in my active Python environment.

Register this Linux machine as a runner with token <TOKEN>.

Score these 10 videos and tell me which one to ship and why.

/worldjen-score image.png for prompt_adherence against "neon city, cyberpunk"

/worldjen-bench Lightricks/LTX-2, all t2v dimensions, runner gpu-h100-01

Compare run_8a3f to run_91bc — which dimensions regressed by 5pp or more?

Reset my WorldJen Score session.

Get my WorldJen Rank session as JSON.
```

## Install paths

### Claude Code

```bash
claude plugin marketplace add moonmath-ai/worldjen-skills
claude plugin install worldjen@worldjen
```

For local development without the marketplace install:

```bash
claude --plugin-dir /path/to/worldjen-skills
```

### Codex (marketplace)

```bash
codex plugin marketplace add moonmath-ai/worldjen-skills
```

This registers the marketplace. To install the plugin from it, open the Codex TUI and pick `worldjen` from the available plugins. The Codex CLI does not currently expose a non-interactive `plugin install` step.

For local testing without the public repo, copy `examples/codex-marketplace.json` to your own marketplace directory and point its plugin entry at this repo.

### Codex (direct skill copy)

```bash
mkdir -p ~/.codex/skills
cp -R skills/worldjen-* ~/.codex/skills/   # all skills; or pick individual ones
```

Then restart Codex. Each skill becomes available — `$worldjen-leaderboard ...` (or any other), or let Codex pick from descriptions. Verified path; no marketplace setup required.

### Generic harness

Point the agent at `skills/<skill-name>/SKILL.md`. Each skill is self-contained — no shared includes. See `examples/generic-instructions.md` for the bootstrap snippet.

## Migration to 0.3.0

The deprecated `worldjen` umbrella skill (soft-deprecated in 0.2.0) is **removed in 0.3.0**, along with `worldjen-runs` and `worldjen-sandbox`. Use the per-capability skills directly:

| Old call                            | New call                                                           |
| ----------------------------------- | ------------------------------------------------------------------ |
| `/worldjen:worldjen` (any umbrella) | the matching per-capability skill below                            |
| `worldjen-runs`                     | `worldjen-bench`                                                   |
| `worldjen-sandbox` (custom prompts) | `worldjen-score`                                                  |
| `worldjen-sandbox` (standard set)   | `worldjen-rank`                                                   |

Update `AGENTS.md` files, blog posts, and pinned scripts that reference `/worldjen:worldjen`, `worldjen-runs`, or `worldjen-sandbox`.

## Troubleshooting

- `worldjen: command not found` — activate the environment where `worldjen` was installed. Verify with `python -m pip show worldjen`.
- Auth failure — set `WORLDJEN_API_KEY` (or pass `--api-key`). Get a key at <https://www.worldjen.com/settings/api-keys>.
- Runner service commands fail on macOS — runner service management requires Linux + systemd.
- Missing IDs — list them: `worldjen runner list`, `worldjen models list`, `worldjen bench list --json`.

## What these skills do not do

This repo stays on the public product surface:

- Public CLI commands (`worldjen ...`) and SDK entrypoints (`worldjen.score.*`, `worldjen.rank.*`, `worldjen.bench.*`)
- Public REST API (`/api/v1/*`)
- Public leaderboard (`/api/v1/public/leaderboard`)

It avoids private repository paths, internal modules, and undocumented behavior.

## Development

Validate skills locally:

```bash
./scripts/check-skills.sh
```

Checks: plugin manifests parse, every skill has correct frontmatter and matching `agents/openai.yaml` policy, all relative markdown links resolve, destructive-ops skills include the required confirmation section.

`.github/workflows/check.yml` runs the same validator on every push and pull request, so a broken skill fails CI before it can land.

### Releasing

Releases are cut by pushing a tag that matches the version in the plugin manifests:

```bash
# Bump VERSION in .claude-plugin/plugin.json + .codex-plugin/plugin.json + add CHANGELOG entry first
git tag v0.3.0
git push origin v0.3.0
```

`.github/workflows/release.yml` then validates the skills, confirms the tag matches both manifest versions, extracts the matching `CHANGELOG.md` section, and creates a GitHub Release. The `worldjen-update` skill (and the `bin/check-update` preamble in every other skill) reads from the GitHub Releases API, so a release tag is what triggers update notifications for installed users.
