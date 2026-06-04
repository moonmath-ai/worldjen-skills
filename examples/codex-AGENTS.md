## WorldJen

If a task mentions WorldJen, follow the matching skill:

- Install / verify the SDK / CLI → `worldjen-install`
- Runner host setup or operations (Linux + systemd) → `worldjen-runner`
- Benchmark a whole model (create / inspect / compare Bench runs) → `worldjen-bench`
- Score a single generated clip (raw per-dimension scores) → `worldjen-score`
- Rank clips that share a prompt into a leaderboard → `worldjen-rank`
- Public leaderboard → `worldjen-leaderboard`

`worldjen-bench` covers benchmark jobs (the actual evaluation work). `worldjen-runner` covers the GPU worker host that executes them. They are different.

Three surfaces: `worldjen-score` ("how good is this clip?" — one upload, raw per-dimension scores), `worldjen-rank` ("which of these is best?" — a leaderboard across clips that share a prompt), `worldjen-bench` ("how does the model perform overall?" — many prompts at scale on a worker queue). Requires worldjen SDK 0.6.0+.
