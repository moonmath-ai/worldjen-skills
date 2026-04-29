# WorldJen Agent Skills

Agent skills for the [WorldJen](https://www.worldjen.com) AI video and world model evaluation service. Drop them into Claude Code, Codex, or any agent harness so your agent can install the SDK, operate runners, create eval runs, fetch the leaderboard, and use the Playground/Rank sandbox for you.

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
| Create and inspect evaluation runs                     | `worldjen-runs`        | Yes  |
| Fetch the public leaderboard                           | `worldjen-leaderboard` | No   |
| Use the Playground or Rank sandbox                     | `worldjen-sandbox`     | Yes  |
| Upgrade this plugin to the latest release              | `worldjen-update`      | No   |

`worldjen-runs` is for **evaluation jobs**. `worldjen-runner` is for the **GPU worker host**. They are different.

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

Check WorldJen run <RUN_ID> and summarize its status.

Reset my WorldJen Playground sandbox.

Get my WorldJen Rank sandbox as JSON.
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

## Migration from 0.1.x

The single `worldjen` umbrella skill is **deprecated in 0.2.0** and will be removed in **0.3.0**. Existing references to `/worldjen:worldjen` continue to work — they now resolve to a router that points at the per-capability skills.

| Old call                    | New call                                                   |
| --------------------------- | ---------------------------------------------------------- |
| Install with the umbrella   | `worldjen-install`                                         |
| Runner setup with umbrella  | `worldjen-runner`                                          |
| Run status with umbrella    | `worldjen-runs`                                            |
| Leaderboard with umbrella   | `worldjen-leaderboard`                                     |
| Sandbox usage with umbrella | `worldjen-sandbox`                                         |

Update `AGENTS.md` files, blog posts, and pinned scripts to reference the per-capability skill names before 0.3.0.

## Troubleshooting

- `worldjen: command not found` — activate the environment where `worldjen` was installed. Verify with `python -m pip show worldjen`.
- Auth failure — set `WORLDJEN_API_KEY` (or pass `--api-key`). Get a key at <https://www.worldjen.com/settings/api-keys>.
- Runner service commands fail on macOS — runner service management requires Linux + systemd.
- Missing IDs — list them: `worldjen runner list --json`, `worldjen models list`, `worldjen runs list --json`.

## What these skills do not do

This repo stays on the public product surface:

- Public CLI commands (`worldjen ...`) and SDK entrypoints (`worldjen.run(...)`)
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
