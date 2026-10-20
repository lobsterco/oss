# oss — Macro rebuilt on Reef

> Macro ([macro-inc/macro](https://github.com/macro-inc/macro)) is a unified workspace: email, chat, docs, tasks, agents, calls, and CRM — @-linked together with shared AI memory. This repo rebuilds it on [Reef](https://reef.computer) primitives, running on Reef's GCP account.

## Why rebuild on Reef

| Macro concept | Reef primitive | Notes |
|---|---|---|
| Workspace / Organization | **Reef (reef)** | Tenant boundary: auth, membership, billing, data residency. All Macro data lives inside a Reef. |
| Automations, triggers, scheduled actions, agent orchestrations | **Flows** | Durable, Temporal-backed workflows. Every cross-system behavior is a Flow (versioned graph, event bridge, scheduled ticks, payload refs). |
| Realtime sync, presence | Reef realtime + Loro CRDT mirror | Macro's Loro-based docs stay Loro; sync goes through Reef realtime. |
| Auth, connections (Gmail, Calendar, etc.) | Reef auth + Toolshed connectors | Reuse existing Reef connector surface; add Macro-specific connectors (see `packages/connectors`). |
| AI engine, agent harnesses | Reef hosted agents + agent-harness service | Coding agents (Claude/Codex/Cursor) run via existing Reef harness; Macro's agent UX becomes a Reef channel variant. |
| Infra (Pulumi/AWS) | Reef GCP account | Terraform on `infra/gcp/`. No AWS resources. |

Everything else — app UX, data models, permissions, search, notifications, CRM semantics — stays faithful to Macro.

## Repository layout

```
apps/
  web/            # Solid.js web app (ported from macro/apps/web) — runs inside a Reef
  marketing/      # Marketing site (ported)
packages/
  collaboration/  # Loro → Reef realtime bridge
  lexical-core/   # Lexical editor core (ported)
  loro-mirror/    # CRDT sync layer
  machine/        # Shared AI/tool primitives
  email-renderer/ # Email rendering
  sdk/            # Public SDK + MCP surface
  connectors/     # Reef Toolshed connectors for Macro (Gmail, Calendar, CRM, etc.)
crates/           # Rust crates — ported from macro/crates (250 crates)
services/         # Backend services — ported from macro/services
flows/            # Flow definitions (Macro automations as Reef Flows)
infra/
  gcp/            # Terraform for Reef's GCP project (replaces Pulumi/AWS)
docs/
  architecture/   # Reef-mapping ADRs
  development/    # Dev guide (just dev, etc.)
```

## Quick start

```sh
just setup        # toolchains, deps, GCP auth
just dev          # local dev — Reef cluster + Macro-on-Reef
just check        # typecheck + lint gate
```

See `docs/development/local-dev.md` and `CONTRIBUTING.md`.

## Workstreams (fanned-out subagents)

Each stream is an independent build cell. See `docs/planning/workstreams.md` for the full fan-out.

| # | Stream | Scope | Label |
|---|--------|-------|-------|
| 1 | `reef-foundation` | Reef tenant bootstrap, GCP infra, auth/membership mapping | `area:infra` |
| 2 | `channels-chat` | Channels, threads, DMs, @-mentions on Reef realtime | `area:chat` |
| 3 | `docs-crdt` | Markdown docs, Loro CRDT, collab, file-over-app | `area:docs` |
| 4 | `tasks` | Tasks, boards, assignments, dedup | `area:tasks` |
| 5 | `email` | Email ingest, Gmail connector, email service on Flows | `area:email` |
| 6 | `calendar-calls` | Calendar events, scheduling, calls | `area:calendar` |
| 7 | `crm` | CRM entities, pipelines, @-linking | `area:crm` |
| 8 | `agents` | Agent harnesses, coding agents, AI engine as Flows | `area:agents` |
| 9 | `search-notifs` | Search indexing, notifications, activity | `area:search` |
| 10 | `web-shell` | Web app shell, Solid.js inside Reef, shell integration | `area:web` |

Each stream tracks progress in `docs/planning/workstreams.md` and ships via `lobsterco/oss` PRs.

## License

Same as upstream: see [LICENSE.md](LICENSE.md) (Macro's license) + Reef terms for Reef primitives.
