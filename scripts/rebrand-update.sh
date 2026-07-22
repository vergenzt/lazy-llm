#!/usr/bin/env bash
set -euo pipefail  # https://sipb.mit.edu/doc/safe-shell/

if ! git remote get-url upstream 2>/dev/null; then
  git remote add upstream https://github.com/DietrichGebert/ponytail.git
fi

git fetch --no-tags upstream main

OLD_LOCAL=$(git rev-parse HEAD)
UPSTREAM=$(git rev-parse upstream/main)

# The upstream head we last vendored is recorded as the second parent
# of our current merge commit (empty string on the very first run).
LAST_UPSTREAM=$(git rev-parse --verify --quiet HEAD^2 || true)

if [ "$UPSTREAM" = "$LAST_UPSTREAM" ]; then
  echo "No new upstream commits (upstream@${UPSTREAM}). Nothing to do."
  exit 0
fi
echo "New upstream head ${UPSTREAM} (last was ${LAST_UPSTREAM:-none}); rebranding."

# Take the upstream tree verbatim -- no merge algorithm runs.
git checkout --detach --force "$UPSTREAM"

# Pull in rebrand.sh from the original (local) head so we run *our*
# rebrand logic against the fresh upstream tree.
git checkout "$OLD_LOCAL" -- scripts/rebrand.sh
bash scripts/rebrand.sh

# Restore our own infra files verbatim, overriding whatever the rebrand
# pass (or upstream) left for them.
git checkout "$OLD_LOCAL" -- scripts/rebrand.sh scripts/rebrand-update.sh .github/workflows/update.yml

git add -A
TREE=$(git write-tree)

# Merge commit with two parents and no merged-in changes of its own:
#   first parent  = old local head (main continuity)
#   second parent = upstream latest head
MERGE=$(git commit-tree "$TREE" \
  -p "$OLD_LOCAL" \
  -p "$UPSTREAM" \
  -m "Merge upstream ponytail (${UPSTREAM:0:12}) and rebrand")

# Fast-forward main to the new merge commit. Uses the default
# GITHUB_TOKEN: as long as the rebranded workflow files match what is
# already on main (i.e. upstream hasn't touched its workflows), the push
# carries no net .github/workflows/ change and is allowed. If upstream
# *does* edit a workflow file, this push fails on purpose -- rerun after
# updating the affected file (and the rebrand mapping) by hand.
git push origin "${MERGE}:refs/heads/main"
