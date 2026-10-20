# Workstreams — fanned-out build

Each row is an independent subagent cell. Owners create branches `oss/<stream>` and PR against `main`.

| # | Stream | Branch | Scope | Key crates/services | Depends on |
|---|--------|--------|-------|---------------------|------------|
| 1 | reef-foundation | `oss/reef-foundation` | Reef tenant bootstrap, GCP Terraform (Cloud Run, Cloud SQL, GCS, Temporal), auth → Reef auth, org→reef migration script | `infra/gcp`, `scripts/migrate-org-to-reef`, `packages/connectors/auth` | — |
| 2 | channels-chat | `oss/channels-chat` | Channels, threads, DMs, @-mentions, typing, realtime on Reef realtime, notifications fanout as Flow | `crates/channels`, `crates/chat`, `crates/channel_*`, `crates/collab_surface` | 1 |
| 3 | docs-crdt | `oss/docs-crdt` | Markdown/Canvas docs, Loro CRDT, file-over-app, collab cursors, doc ingest Flow | `packages/loro-mirror`, `packages/collaboration`, `services/document_*`, `crates/cognition` | 1 |
| 4 | tasks | `oss/tasks` | Tasks, boards, assignments, dedup, scheduled actions → `task-scheduler` Flow | `crates/task*`, `services/scheduled_action`, `flows/task-scheduler` | 1 |
| 5 | email | `oss/email` | Gmail connector (Toolshed), email ingest Flow, email_service, rendering, suppression | `services/email_service`, `crates/gmail_client`, `packages/email-renderer`, `flows/email-ingest` | 1 |
| 6 | calendar-calls | `oss/calendar-calls` | Calendar sync Flow, scheduling, calls (SFU), calendar_events | `services/calendar_service`, `services/call_*`, `crates/calendar_*`, `flows/calendar-sync` | 1 |
| 7 | crm | `oss/crm` | CRM entities, pipelines, contacts, @-linking via entity registry | `crates/crm`, `crates/contacts`, `crates/graphql_crm` | 1, 2 |
| 8 | agents | `oss/agents` | Agent harnesses (Claude/Codex/Cursor), agent_trigger → Flow, AI engine, code-mode-sdk, machine | `crates/agent*`, `crates/ai_*`, `services/coding-agent-worker`, `packages/machine`, `packages/code-mode-sdk`, `flows/agent-trigger` | 1, 2 |
| 9 | search-notifs | `oss/search-notifs` | Search indexing Flow, activity feed, notification service, notification retention | `services/search_*`, `services/notification_service`, `crates/activity`, `flows/search-index` | 1–8 |
| 10 | web-shell | `oss/web-shell` | Solid.js web app inside Reef shell, Vite build, design system, marketing site | `apps/web`, `apps/marketing` | 1–9 incremental |

## Execution

- Each subagent: `gh issue create` in `lobsterco/oss` with label `area:<x>`, branch, checklist from this doc, and link to `docs/architecture/reef-mapping.md`.
- Infra/GCP project is `reef-gcp` (operator-provided). No AWS credentials.
- Quality gate: `just check` (typecheck + lint) + `just dev` boots without error.
- Upstream sync: `just sync-upstream` pulls `macro-inc/macro` main into `upstream/macro` branch (see `scripts/sync-upstream.sh`).

## Status

| Stream | Issue | Branch | Status |
|--------|-------|--------|--------|
| 1 | #1 | `oss/reef-foundation` | scaffolded — awaiting owner |
| 2 | #2 | `oss/channels-chat` | scaffolded |
| 3 | #3 | `oss/docs-crdt` | scaffolded |
| 4 | #4 | `oss/tasks` | scaffolded |
| 5 | #5 | `oss/email` | scaffolded |
| 6 | #6 | `oss/calendar-calls` | scaffolded |
| 7 | #7 | `oss/crm` | scaffolded |
| 8 | #8 | `oss/agents` | scaffolded |
| 9 | #9 | `oss/search-notifs` | scaffolded |
| 10 | #10 | `oss/web-shell` | scaffolded |
