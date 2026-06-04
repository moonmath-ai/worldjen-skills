# TODOs

## Distribution

**Priority:** P3 — Cursor `.cursor/rules/*.mdc` ecosystem coverage
- Generate one `.mdc` rule per capability skill, derived from each `SKILL.md`. Lets Cursor users pick up these skills natively.

**Priority:** P3 — Machine-readable skill registry
- Add `skills/index.json` (name, description, auth-required, tags) generated from frontmatter at build time. Useful when worldjen.com wants to render an "agent-capable" page or for LLM-native discovery.

**Priority:** P3 — `llms.txt`-driven discovery
- Reference https://docs.worldjen.com/llms.txt as the canonical source agents fetch first; consider auto-generating skills from the worldjen CLI's `--help` output to eliminate skill drift.

## Validator improvements

**Priority:** P3 — `scripts/check-skills.sh`: support YAML folded scalars
- The hand-rolled parser rejects valid frontmatter forms like `description: >\n  multi-line text`. Future contributors writing long descriptions will hit confusing errors. Either upgrade to a small dependency-free YAML lib or note the limitation in CONTRIBUTING.

## Completed

- **0.3.0** — Removed the deprecated `worldjen` umbrella router (soft-deprecated in 0.2.0). All references migrated to the per-capability skills.
