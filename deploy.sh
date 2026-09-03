#!/bin/bash
set -e

# ─────────────────────────────────────────────
# Kennox Solutions — Build & Package for HostAfrica
# ─────────────────────────────────────────────
#
# NOTE: Kennox Solutions is a frontend-only Phase 1 build (see README.md,
# "Architecture decisions" / "Gotchas"). `artifacts/api-server` exists as
# scaffolding for a future Phase 2 backend but is not part of the active
# pnpm workspace and must not be built or deployed yet. This script
# therefore only builds and packages the static frontend — unlike the ITP
# Solutions deploy script it's based on, there is no backend.zip step.

ROOT=~/codes/Kennox-Solutions-Website
FRONTEND_SRC="$ROOT/artifacts/kennox-solutions/dist/public"
FRONTEND_ZIP="$ROOT/frontend.zip"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Kennox Solutions — Deployment Build ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. Build Frontend ─────────────────────────
echo "🎨 [1/2] Building frontend..."
cd "$ROOT/artifacts/kennox-solutions"
PORT=3000 BASE_PATH=/ pnpm build
echo "    ✓ Frontend built"

# ── 2. Package Frontend ───────────────────────
echo ""
echo "🗜️  [2/2] Packaging frontend..."
rm -f "$FRONTEND_ZIP"
cd "$FRONTEND_SRC"
zip -r "$FRONTEND_ZIP" . 2>/dev/null
echo "    ✓ frontend.zip ready"

# ── Summary ───────────────────────────────────
echo ""
echo "╔══════════════════════════════════════╗"
echo "║              Summary                 ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "📁 File size:"
ls -lh "$FRONTEND_ZIP"

echo ""
echo "📋 Frontend zip contents (top level):"
unzip -l "$FRONTEND_ZIP" | head -20

echo "╔══════════════════════════════════════╗"
echo "║     All Done, Ready to Upload!       ║"
echo "╚══════════════════════════════════════╝"
