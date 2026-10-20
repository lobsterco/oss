# Local dev

## Prerequisites

- Bun, Rust, Terraform, gcloud (same as Macro) + Reef ocean checkout for `infra/dev` reference.
- GCP project `reef-gcp` authenticated via `gcloud auth application-default login`.

## Commands

```sh
just setup        # toolchains, deps, env
just dev          # local Reef + Macro-on-Reef (Cloud SQL proxy, Temporal dev server, web)
just check        # typecheck + biome + cargo check
just sync-upstream  # pull macro-inc/macro into upstream/macro
```

## Structure

- `infra/gcp/` — Terraform (envs: dev, prod). Dev targets local Cloud SQL + GKE dev cluster; prod targets `reef-gcp`.
- `flows/<name>/flow.json` — Flow definitions deployed via `just flows:publish`.
- Services run on Cloud Run in prod, via `just dev` locally.
