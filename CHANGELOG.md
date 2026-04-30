# Changelog

All notable changes to the WorldJen agent skill package should be documented in this file.

The format is based on Keep a Changelog and this package uses Semantic Versioning.

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
