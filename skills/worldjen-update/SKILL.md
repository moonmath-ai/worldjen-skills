---
name: worldjen-update
description: Upgrade the worldjen-skills plugin to the latest release. Use when an `UPGRADE_AVAILABLE` banner appears in another skill's preamble, or when the user asks to update / upgrade the worldjen skills.
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

# WorldJen — Update

Upgrade the installed worldjen-skills plugin to the latest GitHub release.

## When to run

- An `UPGRADE_AVAILABLE <local> <latest>` banner appeared in another skill's preamble
- The user said "upgrade worldjen", "update the worldjen skills", or similar

## What this skill does

1. Detects how the user installed the plugin (Claude Code marketplace, Codex marketplace, or direct skill copy).
2. Runs the matching upgrade command, or prints it if it cannot run safely on its own.
3. Records a `JUST_UPGRADED <prior> <new>` marker so the next skill invocation surfaces what changed.
4. Honors a `snooze` flag if the user prefers to defer.

## Detect install method

Run these in order, stop at the first match:

```bash
# Claude Code plugin (marketplace install)
claude plugin list 2>/dev/null | grep -q "worldjen@worldjen" && echo "INSTALL=claude-plugin"

# Codex plugin (marketplace install)
[ -d "$HOME/.codex/.tmp/plugins/plugins/worldjen" ] && echo "INSTALL=codex-plugin"

# Direct skill copy (Codex)
[ -d "$HOME/.codex/skills/worldjen-install" ] || [ -d "$HOME/.codex/skills/worldjen-bench" ] \
  && echo "INSTALL=codex-direct"

# Legacy direct skill copy
[ -d "$HOME/.agents/skills/worldjen-install" ] || [ -d "$HOME/.agents/skills/worldjen-bench" ] \
  && echo "INSTALL=agents-direct"
```

## Upgrade

| Install method | Command |
| --- | --- |
| `claude-plugin` | `claude plugin update worldjen@worldjen` |
| `codex-plugin` | `codex plugin marketplace upgrade worldjen` (then re-pick in TUI if needed) |
| `codex-direct` | `git -C <repo> pull && cp -R <repo>/skills/worldjen-* ~/.codex/skills/` |
| `agents-direct` | Same pattern, target `~/.agents/skills/` |

Confirm with the user before running an upgrade command — it modifies their local plugin install.

## Record the upgrade

After a successful upgrade, write a one-shot notification so the user sees what changed on their next skill invocation:

```bash
mkdir -p "$HOME/.cache/worldjen-skills"
PRIOR_VERSION="<old>"   # the version that was installed before
NEW_VERSION="<new>"     # the version they upgraded to
echo "JUST_UPGRADED $PRIOR_VERSION $NEW_VERSION" > "$HOME/.cache/worldjen-skills/just-upgraded"
# Clear any stale snooze
rm -f "$HOME/.cache/worldjen-skills/snooze"
```

The `bin/check-update` script reads this marker, prints it once, and removes it.

## Snooze

If the user wants to defer the upgrade for a week:

```bash
mkdir -p "$HOME/.cache/worldjen-skills"
touch "$HOME/.cache/worldjen-skills/snooze"
```

Snooze lasts 7 days from the touch timestamp. After that, the upgrade banner returns.

## Stop and ask when needed

- The user has uncommitted changes in a `codex-direct` install path (`git status` shows dirty)
- Multiple install methods are present (e.g., both Claude plugin and Codex plugin) — confirm which one to upgrade
- The plugin is installed via `--plugin-dir` (development mode) — upgrades happen via `git pull` in the source repo, not via the plugin manager

## See also

- `worldjen-install` — set up the SDK and CLI (separate from updating the skills package)
- `worldjen-runner` — runner host operations
- `worldjen-bench` — benchmark a whole model
- `worldjen-score` — score the clip you just generated
- `worldjen-rank` — quick personal preview vs the standard rank set
- `worldjen-leaderboard` — public leaderboard
