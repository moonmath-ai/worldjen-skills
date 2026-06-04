WorldJen agent skills are split by capability. Pick the matching `skills/<name>/SKILL.md` for the task at hand:

- Install the SDK / CLI → `skills/worldjen-install/SKILL.md`
- Runner host setup / operation (Linux + systemd) → `skills/worldjen-runner/SKILL.md`
- Benchmark a whole model (create / inspect / compare Bench runs) → `skills/worldjen-bench/SKILL.md`
- Score a single generated clip (raw per-dimension scores) → `skills/worldjen-score/SKILL.md`
- Rank clips that share a prompt into a leaderboard → `skills/worldjen-rank/SKILL.md`
- Public leaderboard → `skills/worldjen-leaderboard/SKILL.md`

Each skill is self-contained. Use `references/examples.md` (where present) for examples and troubleshooting. Stay on the public product surface, prefer machine-readable output (`--json`), and do not invent runner / model / run IDs — list them first.
