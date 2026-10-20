set shell := ["bash", "-cu"]

setup:
	@echo "→ just setup (stub) — wire toolchains, bun install, gcloud auth"
	@echo "  See docs/development/local-dev.md"

dev:
	@echo "→ just dev (stub) — bring up local Reef + Macro-on-Reef"
	@echo "  Requires infra/gcp wiring (stream 1: reef-foundation)"

check:
	@echo "→ just check (stub) — typecheck + lint + cargo check"
	bun run check --if-present || true

sync-upstream:
	bash scripts/sync-upstream.sh

flows-publish:
	@echo "→ publish flows to dev (stub)"

flows-list:
	ls -1 flows/*/flow.json 2>/dev/null || echo "no flows yet"
