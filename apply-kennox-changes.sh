#!/usr/bin/env bash
#
# apply-kennox-changes.sh
#
# Applies three targeted edits to the Kennox Solutions site:
#   1. Wraps the hero + <KennoxMarquee /> in a block that fills the full
#      viewport height (viewport minus the 76px fixed header), so the
#      "Who We Are" section starts right at the fold instead of being
#      partly visible on load. Works the same way on mobile (100dvh).
#   2. Fixes the WhatsApp number in SupportTools.tsx to +254 727 321 145.
#   3. Adds a clickable tel: link for the phone number to the footer's
#      "Say hello" column, next to the email.
#
# Usage:
#   Place this script at the root of your repo (the folder that contains
#   "artifacts/kennox-solutions"), or pass the path to that app folder as $1.
#
#     ./apply-kennox-changes.sh                # assumes ./artifacts/kennox-solutions
#     ./apply-kennox-changes.sh path/to/kennox-solutions
#
# Requires: python3 (used for safe, literal find-and-replace edits).
# The script is idempotent — running it twice will not double-apply changes.
# Each modified file gets a one-time ".bak" backup next to it.

set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve target directory
# ---------------------------------------------------------------------------
if [ "${1:-}" != "" ]; then
  APP_DIR="$1"
elif [ -d "./artifacts/kennox-solutions/src" ]; then
  APP_DIR="./artifacts/kennox-solutions"
elif [ -d "./src" ] && [ -f "./src/App.tsx" ]; then
  APP_DIR="."
else
  echo "Could not locate the kennox-solutions app automatically."
  echo "Run this script from the repo root, or pass the path explicitly:"
  echo "  ./apply-kennox-changes.sh path/to/kennox-solutions"
  exit 1
fi

PAGES_FILE="$APP_DIR/src/pages/Pages.tsx"
SUPPORT_FILE="$APP_DIR/src/components/SupportTools.tsx"
SHELL_FILE="$APP_DIR/src/components/Shell.tsx"

for f in "$PAGES_FILE" "$SUPPORT_FILE" "$SHELL_FILE"; do
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
  if [ ! -f "$f.bak" ]; then
    cp "$f" "$f.bak"
  fi
}

# ---------------------------------------------------------------------------
# 1. Wrap hero + marquee in a full-viewport-height block
# ---------------------------------------------------------------------------
echo "1/3 Hero + marquee full-viewport wrapper in Pages.tsx..."
backup "$PAGES_FILE"
PAGES_FILE="$PAGES_FILE" python3 <<'PYEOF'
import os
path = os.environ["PAGES_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_hero = '''      <section className="page-wrap grid gap-8 pb-6 pt-8 sm:pt-10 lg:grid-cols-[1.02fr_.98fr] lg:items-center lg:gap-14 lg:pb-6 lg:pt-10">
        <div className="reveal">
          <p className="eyebrow flex items-center gap-3 text-[hsl(var(--accent))]">
            <span className="h-px w-8 bg-[hsl(var(--secondary))]" />
            For businesses with something worth building
          </p>
          <h1 className="serif mt-4 max-w-xl text-4xl leading-[1.03] tracking-[-.04em] sm:text-5xl md:text-6xl lg:text-[3.65rem]">
            Building <em className="text-[hsl(var(--accent))]">Brands</em>.
            <br />
            Powering <em className="text-[hsl(var(--accent))]">Ideas</em>.
            <br />
            Creating the <em className="text-[hsl(var(--accent))]">Future</em>.
          </h1>
          <p className="mt-5 max-w-md text-base leading-relaxed text-[hsl(var(--muted-foreground))]">
            You've got the vision. We bring the strategy, the craft and the
            technology to help it travel — from a rough idea to something
            people actually use, trust and remember.
          </p>
          <div className="mt-6 flex flex-wrap gap-3">
            <CTA href="/contact">Start a Project</CTA>
            <Link
              href="/services"
              className="inline-flex items-center gap-2 rounded-full border border-[hsl(var(--border))] px-6 py-3.5 text-[.7rem] font-bold uppercase tracking-[.12em] hover:border-[hsl(var(--primary))]"
              data-testid="link-hero-fit"
            >
              See What We Do <ArrowDown size={15} />
            </Link>
          </div>
        </div>
        <div className="reveal reveal-delay-2">
          <ArtPanel />
        </div>
      </section>
      <KennoxMarquee />
      <section className="page-wrap grid gap-12 py-20 sm:py-28 lg:grid-cols-[.7fr_1.3fr]">'''

new_hero = '''      <div className="flex min-h-[calc(100dvh-76px)] flex-col justify-between">
        <section className="page-wrap grid flex-1 gap-8 pb-6 pt-8 sm:pt-10 lg:grid-cols-[1.02fr_.98fr] lg:items-center lg:gap-14 lg:pb-6 lg:pt-10">
          <div className="reveal">
            <p className="eyebrow flex items-center gap-3 text-[hsl(var(--accent))]">
              <span className="h-px w-8 bg-[hsl(var(--secondary))]" />
              For businesses with something worth building
            </p>
            <h1 className="serif mt-4 max-w-xl text-4xl leading-[1.03] tracking-[-.04em] sm:text-5xl md:text-6xl lg:text-[3.65rem]">
              Building <em className="text-[hsl(var(--accent))]">Brands</em>.
              <br />
              Powering <em className="text-[hsl(var(--accent))]">Ideas</em>.
              <br />
              Creating the <em className="text-[hsl(var(--accent))]">Future</em>.
            </h1>
            <p className="mt-5 max-w-md text-base leading-relaxed text-[hsl(var(--muted-foreground))]">
              You've got the vision. We bring the strategy, the craft and the
              technology to help it travel — from a rough idea to something
              people actually use, trust and remember.
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              <CTA href="/contact">Start a Project</CTA>
              <Link
                href="/services"
                className="inline-flex items-center gap-2 rounded-full border border-[hsl(var(--border))] px-6 py-3.5 text-[.7rem] font-bold uppercase tracking-[.12em] hover:border-[hsl(var(--primary))]"
                data-testid="link-hero-fit"
              >
                See What We Do <ArrowDown size={15} />
              </Link>
            </div>
          </div>
          <div className="reveal reveal-delay-2">
            <ArtPanel />
          </div>
        </section>
        <KennoxMarquee />
      </div>
      <section className="page-wrap grid gap-12 py-20 sm:py-28 lg:grid-cols-[.7fr_1.3fr]">'''

if old_hero in content:
    content = content.replace(old_hero, new_hero, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    done.")
elif new_hero in content:
    print("    already applied — skipping.")
else:
    print("    could not find the expected hero block — no change made.")
    print("    Please wrap the hero + <KennoxMarquee /> manually in:", path)
PYEOF

# ---------------------------------------------------------------------------
# 2. Fix the WhatsApp number
# ---------------------------------------------------------------------------
echo "2/3 WhatsApp number in SupportTools.tsx..."
backup "$SUPPORT_FILE"
SUPPORT_FILE="$SUPPORT_FILE" python3 <<'PYEOF'
import os
path = os.environ["SUPPORT_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old = 'WHATSAPP_NUMBER = "254700000000"'
new = 'WHATSAPP_NUMBER = "254727321145"'

if old in content:
    content = content.replace(old, new, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    done.")
elif new in content:
    print("    already correct — skipping.")
else:
    print("    could not find the expected placeholder — no change made.")
    print("    Please check WHATSAPP_NUMBER manually in:", path)
PYEOF

# ---------------------------------------------------------------------------
# 3. Add phone number to footer "Say hello" column
# ---------------------------------------------------------------------------
echo "3/3 Footer phone link in Shell.tsx..."
backup "$SHELL_FILE"
SHELL_FILE="$SHELL_FILE" python3 <<'PYEOF'
import os
path = os.environ["SHELL_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

if 'link-footer-phone' in content:
    print("    already present — skipping.")
else:
    import_old = "import { footerServiceLinks, footerVentureLinks, navItems, socialLinks } from '@/data/site';"
    import_new = "import { contactInfo, footerServiceLinks, footerVentureLinks, navItems, socialLinks } from '@/data/site';"

    footer_old = (
        '        <a href="mailto:info@kennoxsolutions.co.ke" '
        'className="mt-5 block text-sm text-[hsl(var(--primary-foreground)/.72)] '
        'hover:text-[hsl(var(--secondary))]" data-testid="link-footer-email">'
        'info@kennoxsolutions.co.ke</a>'
    )
    footer_new = (
        '        <a href={`mailto:${contactInfo.email}`} '
        'className="mt-5 block text-sm text-[hsl(var(--primary-foreground)/.72)] '
        'hover:text-[hsl(var(--secondary))]" data-testid="link-footer-email">'
        '{contactInfo.email}</a>\n'
        "        <a href={`tel:${contactInfo.phone.replace(/\\s+/g, '')}`} "
        'className="mt-2 block text-sm text-[hsl(var(--primary-foreground)/.72)] '
        'hover:text-[hsl(var(--secondary))]" data-testid="link-footer-phone">'
        '{contactInfo.phone}</a>'
    )

    if footer_old in content:
        if import_old in content:
            content = content.replace(import_old, import_new, 1)
        content = content.replace(footer_old, footer_new, 1)
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(content)
        print("    done.")
    else:
        print("    could not find the expected footer email line — no change made.")
        print("    Please add the phone link manually in:", path)
PYEOF

echo ""
echo "All steps complete. Any modified file has a one-time backup at <file>.bak"
