#!/usr/bin/env bash
set -euo pipefail

# 03-verify-and-build.sh
# Kennox Solutions rebrand — installs dependencies and verifies the
# kennox-solutions app typechecks and builds after scripts 01 and 02 have run.
# Run this from the ROOT of your project-source checkout, same as scripts 01/02.

APP_DIR="artifacts/kennox-solutions"

if [ ! -d "$APP_DIR" ]; then
  echo "Could not find $APP_DIR — make sure you're running this from the project root." >&2
  exit 1
fi

if ! command -v pnpm >/dev/null 2>&1; then
  echo "pnpm is required. Install it first, e.g.: npm install -g pnpm" >&2
  exit 1
fi

echo "==> Installing dependencies (pnpm install)..."
pnpm install

echo "==> Typechecking $APP_DIR..."
pnpm --filter "./$APP_DIR" run typecheck

echo "==> Building $APP_DIR..."
pnpm --filter "./$APP_DIR" run build

echo ""
echo "==> All good. To preview locally, run:"
echo "    pnpm --filter \"./$APP_DIR\" run dev"
