---
name: worldjen
description: DEPRECATED umbrella router for WorldJen. Routes to the per-capability skills (worldjen-install, worldjen-runner, worldjen-runs, worldjen-leaderboard, worldjen-sandbox). Will be removed in 0.3.0. Explicit invocation only.
disable-model-invocation: true
---

# WorldJen (deprecated umbrella router)

> **Deprecated in 0.2.0 — will be removed in 0.3.0.** Use the per-capability skills below.

| Need                                                | Skill                  |
| --------------------------------------------------- | ---------------------- |
| Install the SDK and CLI                             | `worldjen-install`     |
| Set up or operate a runner host (Linux + systemd)   | `worldjen-runner`      |
| Create and inspect evaluation runs                  | `worldjen-runs`        |
| Fetch the public leaderboard (no auth)              | `worldjen-leaderboard` |
| Use the Playground or Rank user-scoped sandbox      | `worldjen-sandbox`     |

If you arrived here from a tutorial, blog post, or pinned `AGENTS.md` reference, follow the matching skill above. The capability skills live at the same plugin namespace — replace `worldjen` with the per-capability name in your invocation.

## Migration examples

| Old                                          | New                                                                  |
| -------------------------------------------- | -------------------------------------------------------------------- |
| `/worldjen:worldjen` install the CLI         | `/worldjen:worldjen-install`                                         |
| `/worldjen:worldjen` register a runner       | `/worldjen:worldjen-runner`                                          |
| `/worldjen:worldjen` check run status        | `/worldjen:worldjen-runs`                                            |
| `/worldjen:worldjen` fetch the leaderboard   | `/worldjen:worldjen-leaderboard`                                     |
| `/worldjen:worldjen` reset my Playground     | `/worldjen:worldjen-sandbox`                                         |

(Codex users: replace `/worldjen:` with `$`. Generic harnesses: point at `skills/<skill-name>/SKILL.md`.)
