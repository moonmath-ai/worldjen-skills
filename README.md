# WorldJen Agent Skills

Per-capability agent skills for the [WorldJen](https://www.worldjen.com) video-evaluation product. Drop them into Claude Code, Codex, or any agent harness so your agent can install the SDK, operate runners, create eval runs, fetch the leaderboard, and use the Playground/Rank sandbox for you.

## Quick start

1. **Add the marketplace, then install the plugin** (two steps in both Claude Code and Codex):

   ```bash
   # Claude Code
   claude plugin marketplace add moonmath-ai/worldjen-skills
   claude plugin install worldjen@worldjen

   # Codex
   codex plugin marketplace add moonmath-ai/worldjen-skills
   codex plugin install worldjen
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

### Codex (plugin)

```bash
codex plugin marketplace add moonmath-ai/worldjen-skills
codex plugin install worldjen
```

For local testing without the public repo, copy `examples/codex-marketplace.json` and point its plugin entry at this repo.

### Codex (local skill)

```bash
mkdir -p ~/.agents/skills
cp -R skills/worldjen-* ~/.agents/skills/   # all skills; or pick individual ones
```

Then `$worldjen-leaderboard ...` (or any other skill name), or let Codex pick from descriptions.

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

Validate skills locally before opening a PR:

```bash
./scripts/check-skills.sh
```

Checks: plugin manifests parse, every skill has correct frontmatter and matching `agents/openai.yaml` policy, all relative markdown links resolve, destructive-ops skills include the required confirmation section.
