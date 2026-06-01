# Changelog

All notable changes to the WorldJen agent skill package should be documented in this file.

The format is based on Keep a Changelog and this package uses Semantic Versioning.

## [0.3.0] - 2026-06-01

### Added

- `worldjen-score` — "how good is this clip?" Single-clip per-dimension scoring against the user-scoped Score session. Backed by `worldjen score get/reset/upload` (and `worldjen.score.upload(...)`).
- `worldjen-rank` — "which of these is best?" Comparative ranking of clips that share a prompt, with a server-enforced prompt lock. Backed by `worldjen rank get/upload/current/reset` (and `worldjen.rank.*`).
- `worldjen-bench` — "how does the model perform overall?" Comprehensive benchmark across many prompts and dimensions on a worker queue. Backed by `worldjen bench create / list / get / cancel / delete / logs / csv / videos / download-videos` (and `worldjen.bench.create` / `run_with_pipeline`), with an explicit two-run-comparison workflow for drift / regression checks.
- `worldjen-install` — Upgrade section that handles the runner case: stop the systemd service, `pip install -U`, `runner uninstall` + `runner install` to refresh the unit, then start. Plain `pip install -U` does not pick up on a running daemon.

### Changed

- README, examples, and plugin manifests rewritten around the **two modes** (score / bench) product story from worldjen.com.
- `examples/codex-AGENTS.md` and `examples/generic-instructions.md` updated to route to the new score / rank / bench skills.

### Removed

- **BREAKING:** `worldjen-runs` removed — superseded by `worldjen-bench`, tracking the `worldjen runs *` → `worldjen bench *` CLI/SDK rename in worldjen SDK 0.6.0.
- **BREAKING:** `worldjen-sandbox` removed — split into `worldjen-score` and `worldjen-rank`, tracking the removal of `worldjen playground` in favor of the `worldjen score` / `worldjen rank` surfaces in worldjen SDK 0.6.0.
- **BREAKING:** the deprecated `worldjen` umbrella router (soft-deprecated in 0.2.0) removed. Use the per-capability skills directly.

> **Requires worldjen SDK 0.6.0+.** These skills use the Score / Rank / Bench CLI and SDK surface. The pre-0.6.0 `worldjen playground`, `worldjen runs`, and `worldjen.run()` entrypoints are gone.

Update `AGENTS.md` files, blog posts, and pinned scripts that reference `worldjen-runs`, `worldjen-sandbox`, or `/worldjen:worldjen`.

## [0.2.0] - 2026-04-29

### Added

- `worldjen-install` — focused install playbook (SDK / CLI, runner extra, `uv` flow)
- `worldjen-runner` — runner host setup and operation (Linux + systemd)
- `worldjen-runs` — evaluation run lifecycle (create, list, get, logs, videos, csv, download-videos)
- `worldjen-leaderboard` — public leaderboard fetch (no auth)
- `worldjen-sandbox` — Playground and Rank user-scoped sandbox runs (`worldjen playground get/reset --kind playground|rank`)
- `worldjen-update` — auto-invocable skill that detects install method and runs the right upgrade command (`claude plugin update`, `codex plugin marketplace upgrade`, or `git pull && cp -R`)
- `bin/check-update` — best-effort update-check script. 1h GitHub API cache, 7-day snooze, per-session deduplication, fails silently on network errors. Outputs gstack-style `UPGRADE_AVAILABLE` / `JUST_UPGRADED` protocol.
- Per-skill preamble that runs `bin/check-update` (no-op when bin/ isn't present, e.g. direct cp installs).
- `scripts/check-skills.sh` — frontmatter, manifest, and policy-parity validator
- `.github/workflows/check.yml` — runs the validator on every push and pull request
- `.github/workflows/release.yml` — on `v*.*.*` tag push, validates skills, verifies tag matches plugin manifest version, extracts CHANGELOG section, and creates a GitHub Release
- README routing table and cross-platform invocation syntax matrix

### Changed

- All skills are auto-invocable. Safety for destructive operations lives in the SKILL.md content (a "Confirm before destructive operations" section), not the invocation flag.
- README rewritten around a "What do you want to do?" routing table.
- `examples/codex-AGENTS.md` and `examples/generic-instructions.md` updated for the per-skill structure.

### Deprecated

- **BREAKING (soft):** the umbrella `worldjen` skill is deprecated. It now routes to the per-capability skills above. **It will be removed in 0.3.0.** Update `AGENTS.md` files, scripts, and pinned references to use the per-capability skill names.

| Old                  | New                                                                                                       |
| -------------------- | --------------------------------------------------------------------------------------------------------- |
| `/worldjen:worldjen` | One of `worldjen-install`, `worldjen-runner`, `worldjen-runs`, `worldjen-leaderboard`, `worldjen-sandbox` |

## [0.1.0] - 2026-04-21

### Added

- Initial public `worldjen` skill for SDK or CLI setup, runner operations, run checks, and leaderboard retrieval
- Plugin manifests for Codex and Claude Code
- Installation and usage documentation for Codex, Claude Code, and generic agent harnesses
