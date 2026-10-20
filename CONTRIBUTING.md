# Contributing

See `docs/development/local-dev.md`. Workstream ownership in `docs/planning/workstreams.md`.

- Branch from `main`: `oss/<stream>` or `oss/<stream>-<topic>`.
- PR title: `[oss] <stream>: <what>` — link the stream issue.
- `just check` must pass; add tests for Flow definitions and service ports.

Upstream Macro sync: `just sync-upstream` (never force-push upstream history).
