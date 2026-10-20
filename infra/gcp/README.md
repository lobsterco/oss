# infra/gcp

Terraform for Reef's GCP project (`reef-gcp`) — replaces Macro's Pulumi/AWS stacks.

- `envs/dev` — local/Cloud SQL + GKE dev.
- `envs/prod` — prod GCP (Cloud Run, Cloud SQL, GCS, Temporal on GKE, Secret Manager).

Stream 1 (reef-foundation) owns this.
