# Macro → Reef mapping

## Principles

1. **Reefs are the tenant.** Every Macro workspace maps to one Reef. Reef owns identity, membership, roles, billing, and the Postgres row-level boundary. No second auth system.
2. **Flows are the automation plane.** Anything that was a cron, webhook handler, scheduled_action, agent trigger, or cross-service orchestration becomes a Flow definition (versioned graph, run, node, event bridge, schedule). No ad-hoc queues.
3. **Keep the app layer.** Macro's product semantics (CRDT docs, channel model, task rules, CRM shapes) stay intact. Only the platform substrate changes (AWS/Pulumi → GCP/Terraform, bespoke queues → Flows/Temporal, custom auth → Reef auth).
4. **Credentials by handle.** Flows never embed tokens; they carry connection/credential handles resolved via Toolshed at activity time.

## Detailed mapping

### Workspaces & tenancy
- `crates/organization*` + `crates/workspace*` → Reef membership + reef settings. Migration creates one Reef per Macro org; org settings become reef metadata.
- Entitlements/billing: `crates/ai_billing` → Reef billing hooks.

### Realtime & sync
- `packages/loro-mirror`, `packages/collaboration` → Reef realtime transport (keep Loro CRDT payloads, swap transport to Reef realtime-protocol).
- Presence/cursors ride the same channel.

### Channels / chat / @-mentions
- `crates/channels`, `crates/chat`, `crates/channel_*` → Reef-native chat tables scoped to reef_id. @-link resolution via shared entity registry backed by Reef entity resolver.
- Notifications: `services/notification_service` → Reef notification conventions + Flows for fanout.

### Docs
- `services/document_*`, `crates/cognition` → Docs service unchanged logically; storage on GCS; ingest via Flow (upload → extract → index).
- Search: `services/search_*` → same; embeddings on GCP.

### Tasks
- `crates/task*`, `services/scheduled_action` → Tasks domain + Flows for due dates, dedup, scheduling.

### Email
- `services/email_service`, `crates/gmail_client`, `crates/email_*` → Email ingest as Flows (poll/webhook → normalize → store → notify). Gmail via Toolshed Gmail connector.

### Calendar & calls
- `services/calendar_service`, `services/call_*`, `crates/calendar_*` → Calendar/Call services on Reef; scheduling as Flows.

### CRM
- `crates/crm`, `crates/graphql_crm`, `crates/contacts` → CRM domain tables scoped to reef; @-linking via entity registry.

### Agents & AI
- `crates/agent*`, `crates/ai_*`, `services/coding-agent-worker`, `services/agent_*` → Reef hosted-agent harness + agent-harness service. Each Macro agent type becomes a harness session; triggers become Flow nodes (agent_trigger → Flow wait + resume).
- `packages/machine`, `packages/code-mode-sdk` stay.

### Infra
- `infra/` (Pulumi/AWS, stacks/*) → `infra/gcp/` (Terraform, Cloud Run, Cloud SQL, GCS, Temporal on GKE). `infra/README.md` replaced.

## Flow catalog (initial)

| Flow | Trigger | Purpose |
|------|---------|---------|
| `email-ingest` | Gmail webhook / poll schedule | Fetch → normalize → store → fanout |
| `doc-ingest` | GCS upload event | Extract → cognition → index |
| `task-scheduler` | Schedule + task mutation | Due/overdue, dedup, SLA |
| `agent-trigger` | Event bridge (mention, schedule, webhook) | Start/resume agent session via harness |
| `calendar-sync` | Schedule + webhook | Poll/sync external calendars |
| `search-index` | DB change stream | Upsert embeddings/search docs |
| `scheduled-actions` | Schedule tick | Former `scheduled_action` service |

Each Flow definition lives in `flows/<name>/` with `flow.json`, `activities/`, and `tests/`.

## What stays AWS/Pulumi-specific and is removed

- `stacks/*` Pulumi projects — replaced by `infra/gcp/`.
- Direct AWS SDK calls in services — replaced by GCS/Cloud SQL clients.
- Custom queue infra — replaced by Flows + Temporal.

## Migration

1. Create Reef per Macro org (script in `scripts/migrate-org-to-reef.ts`).
2. Backfill Flow versions from legacy scheduled/automation rows.
3. Dual-write during cutover for email/calendar webhooks.
4. Cut DNS + webhooks to GCP once Flow runs are green.
