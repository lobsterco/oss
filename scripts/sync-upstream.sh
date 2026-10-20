#!/usr/bin/env bash
set -euo pipefail
UPSTREAM_REMOTE="upstream"
UPSTREAM_URL="https://github.com/macro-inc/macro.git"
git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1 || git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
git fetch "$UPSTREAM_REMOTE" --depth 1
git branch -f upstream/macro "$UPSTREAM_REMOTE/main"
echo "updated upstream/macro"
