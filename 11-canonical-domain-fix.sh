#!/usr/bin/env bash
#
# 11-canonical-domain-fix.sh
#
# Updates the two remaining places the old domain (kennoxsolutions.co.ke)
# was still hardcoded, now that the site is live at kennox.co.ke:
#
#   1. index.html — <link rel="canonical" href="..."> now points at
#      https://kennox.co.ke/
#   2. public/sitemap.xml — every <loc> entry now uses https://kennox.co.ke
#      instead of https://kennoxsolutions.co.ke
#
# (dist/public/index.html and dist/public/sitemap.xml are build output, not
# source — they get regenerated correctly next time you run `pnpm build`,
# so this script doesn't touch them directly.)
#
# Usage:
#   ./11-canonical-domain-fix.sh                # assumes ./artifacts/kennox-solutions
#   ./11-canonical-domain-fix.sh path/to/kennox-solutions
#
# Requires: python3. Idempotent — safe to re-run. Each modified file gets a
# one-time ".bak4" backup next to it.

set -euo pipefail

if [ "${1:-}" != "" ]; then
  APP_DIR="$1"
elif [ -d "./artifacts/kennox-solutions/src" ]; then
  APP_DIR="./artifacts/kennox-solutions"
elif [ -d "./src" ] && [ -f "./src/App.tsx" ]; then
  APP_DIR="."
else
  echo "Could not locate the kennox-solutions app automatically."
  echo "Run this script from the repo root, or pass the path explicitly:"
  echo "  ./11-canonical-domain-fix.sh path/to/kennox-solutions"
  exit 1
fi

INDEX_FILE="$APP_DIR/index.html"
SITEMAP_FILE="$APP_DIR/public/sitemap.xml"

for f in "$INDEX_FILE" "$SITEMAP_FILE"; do
  if [ ! -f "$f" ]; then
    echo "Expected file not found: $f"
    echo "Check that APP_DIR points at the kennox-solutions app root."
    exit 1
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to run this script but was not found."
  exit 1
fi

echo "Using app directory: $APP_DIR"

backup() {
  local f="$1"
  if [ ! -f "$f.bak4" ]; then
    cp "$f" "$f.bak4"
  fi
}

# ---------------------------------------------------------------------------
# 1. index.html — canonical URL.
# ---------------------------------------------------------------------------
echo "1/2 Updating the canonical URL in index.html..."
backup "$INDEX_FILE"
INDEX_FILE="$INDEX_FILE" python3 <<'PYEOF'
import os
path = os.environ["INDEX_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_canonical = '<link rel="canonical" href="https://kennoxsolutions.co.ke/" />'
new_canonical = '<link rel="canonical" href="https://kennox.co.ke/" />'

if new_canonical in content:
    print("    canonical URL already updated — skipping.")
elif old_canonical in content:
    content = content.replace(old_canonical, new_canonical, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    canonical URL is now https://kennox.co.ke/.")
else:
    raise SystemExit("Could not find the expected canonical link in index.html — aborting to avoid a bad edit.")
PYEOF

# ---------------------------------------------------------------------------
# 2. public/sitemap.xml — every <loc> entry.
# ---------------------------------------------------------------------------
echo "2/2 Updating sitemap.xml..."
backup "$SITEMAP_FILE"
SITEMAP_FILE="$SITEMAP_FILE" python3 <<'PYEOF'
import os
path = os.environ["SITEMAP_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_domain = "https://kennoxsolutions.co.ke"
new_domain = "https://kennox.co.ke"

count = content.count(old_domain)
if count == 0:
    if new_domain in content:
        print("    sitemap already updated — skipping.")
    else:
        raise SystemExit("Could not find the old domain in sitemap.xml — aborting to avoid a bad edit.")
else:
    content = content.replace(old_domain, new_domain)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print(f"    updated {count} <loc> entr{'y' if count == 1 else 'ies'} to https://kennox.co.ke.")
PYEOF

echo ""
echo "Done. Next steps:"
echo "  1. Review the diffs (originals saved as .bak4 next to each file)."
echo "  2. Rebuild so dist/public picks up the fix, e.g.:"
echo "       pnpm --filter \"./$APP_DIR\" run build"
echo "  3. Re-run your deploy.sh so the corrected sitemap.xml and index.html"
echo "     ship in the next frontend.zip."
