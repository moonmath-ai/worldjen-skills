# WorldJen Agent Skill

This repo gives your coding agent a WorldJen playbook for:

- installing and using the SDK or CLI
- installing and operating a runner
- checking run status
- retrieving public leaderboard data

The same skill can be used in Claude Code, Codex, or simpler agent harnesses.

## Quick start

Pick the install path that matches your agent:

- **Claude Code:** load this repo as a plugin
- **Codex:** install it either as a plugin or as a local skill
- **Other agents:** point the agent at `skills/worldjen/SKILL.md`

If you just want the core skill files, they are here:

- `skills/worldjen/SKILL.md`
- `skills/worldjen/reference.md`

## Claude Code

Add the marketplace:

```bash
claude plugin marketplace add moonmath-ai/worldjen-skills
```

Then install the `worldjen` plugin from that marketplace, or load the repo locally during development:

```bash
claude --plugin-dir /path/to/worldjen
```

Then invoke:

```text
/worldjen:worldjen
```

If you install it through a plugin marketplace, the same namespaced skill should be available there.

Example invocations:

```text
/worldjen:worldjen Install the WorldJen CLI in my active environment and verify it works.

/worldjen:worldjen Register this Linux machine as a runner with token <TOKEN> and show me the status.

/worldjen:worldjen Check run <RUN_ID> and summarize its current status.

/worldjen:worldjen Fetch the public WorldJen leaderboard and list the available dimensions.
```

## Codex

### Option 1: install as a plugin

Add the marketplace:

```bash
codex plugin marketplace add moonmath-ai/worldjen-skills
```

Then install the `worldjen` plugin from that marketplace.

For local testing without the public repo, use `examples/codex-marketplace.json` as a starting point for your own marketplace file, then point the marketplace entry at the directory where this plugin repo lives.

### Option 2: install as a local skill

Copy or symlink the skill folder into your Codex user skills directory:

```bash
mkdir -p ~/.agents/skills
cp -R /path/to/worldjen/skills/worldjen ~/.agents/skills/worldjen
```

Then invoke it explicitly:

```text
$worldjen
```

Or let Codex pick it from the skill description.

If you want Codex to prefer the skill inside a working repo, add the snippet from `examples/codex-AGENTS.md` to that repo's `AGENTS.md`.

Example invocations:

```text
$worldjen Install the WorldJen CLI in my active environment and verify it works.

$worldjen Register this Linux machine as a runner with token <TOKEN> and show me the status.

$worldjen Check run <RUN_ID> and summarize its current status.

$worldjen Fetch the public WorldJen leaderboard and list the available dimensions.
```

## Other agent harnesses

For Gemini CLI, Hermes, PI, or similar tools:

1. Give the agent `skills/worldjen/SKILL.md` as the main instruction file.
2. Provide `skills/worldjen/reference.md` when the agent needs examples or troubleshooting notes.
3. If the harness supports a local skills directory, install the whole `skills/worldjen/` folder there.

For the simplest bootstrap, reuse the text in `examples/generic-instructions.md`.

Example prompts:

```text
Use the WorldJen skill to install the CLI in my active Python environment and verify it works.

Use the WorldJen skill to check run <RUN_ID> and tell me whether it is still pending, running, or finished.

Use the WorldJen skill to fetch the public leaderboard and show the available dimensions.
```

## Common tasks

Examples of what the skill is meant to handle:

- install `worldjen` or `worldjen[runner]`
- create or register a runner on a Linux host
- start, stop, inspect, or tail runner logs
- list dimensions, models, runners, and runs
- check a specific run and inspect logs or videos
- fetch the public leaderboard JSON

## What the skill expects

The skill assumes the agent can gather these values before acting:

- `WORLDJEN_API_KEY` for authenticated CLI usage
- runner name or runner ID when operating a runner
- model ID when creating queued runs
- run ID when checking a specific run
- a Linux host with systemd for local runner service commands

## What the skill does not do

This repo stays on the public product surface:

- public CLI commands
- public SDK entrypoints
- public leaderboard retrieval

It avoids private repository paths, internal modules, and undocumented behavior.
