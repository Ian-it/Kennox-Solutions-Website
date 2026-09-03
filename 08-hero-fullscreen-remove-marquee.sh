#!/usr/bin/env bash
#
# 08-hero-fullscreen-remove-marquee.sh
#
# What this does to the Home page hero (the first box visitors land on):
#   1. Removes the scrolling marquee ("... WAYS TO BRING YOUR IDEA TO LIFE ...")
#      from inside the hero box entirely.
#   2. Makes the hero box fill the full screen on load — it now stretches to
#      fill the viewport height below the fixed 76px header, instead of being
#      a short card near the top of the page.
#   3. Enlarges the hero's headline, body copy, buttons and art panel so the
#      bigger box doesn't look empty.
#   4. As a direct result, the "Who We Are" section (title + paragraph +
#      stats) is pushed below the fold — it is no longer visible until the
#      user scrolls down.
#
# Usage:
#   Place this script at the root of your repo (the folder that contains
#   "artifacts/kennox-solutions"), or pass the path to that app folder as $1.
#
#     ./08-hero-fullscreen-remove-marquee.sh                # assumes ./artifacts/kennox-solutions
#     ./08-hero-fullscreen-remove-marquee.sh path/to/kennox-solutions
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
  echo "  ./08-hero-fullscreen-remove-marquee.sh path/to/kennox-solutions"
  exit 1
fi

PAGES_FILE="$APP_DIR/src/pages/Pages.tsx"
MARKETING_FILE="$APP_DIR/src/components/Marketing.tsx"

for f in "$PAGES_FILE" "$MARKETING_FILE"; do
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
# 1. Pages.tsx — drop the marquee import, make the hero box full-screen and
#    enlarge its content.
# ---------------------------------------------------------------------------
echo "1/2 Updating hero section in Pages.tsx..."
backup "$PAGES_FILE"
PAGES_FILE="$PAGES_FILE" python3 <<'PYEOF'
import os
path = os.environ["PAGES_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

# --- 1a. Remove the now-unused KennoxMarquee import -------------------------
old_import = """import {
  ArtPanel,
  KennoxMarquee,
  SectionIntro,
  ServiceExplorer,
  TestimonialSlideshow,
  accentFor,
} from "@/components/Marketing";"""

new_import = """import {
  ArtPanel,
  SectionIntro,
  ServiceExplorer,
  TestimonialSlideshow,
  accentFor,
} from "@/components/Marketing";"""

if old_import in content:
    content = content.replace(old_import, new_import, 1)
    print("    removed unused KennoxMarquee import.")
elif new_import in content:
    print("    import already clean — skipping.")
else:
    raise SystemExit("Could not find the expected import block in Pages.tsx — aborting to avoid a bad edit.")

# --- 1b. Replace the hero box: drop the marquee, go full-screen, enlarge ---
old_hero = """      <section className="page-wrap pb-4 pt-4 sm:pt-5">
        <div className="overflow-hidden rounded-[1.75rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))] shadow-[var(--shadow-md)]">
          <div className="grid gap-6 p-5 sm:gap-8 sm:p-7 lg:grid-cols-[1.02fr_.98fr] lg:items-center lg:gap-12">
            <div className="reveal">
              <p className="eyebrow flex items-center gap-3 text-[hsl(var(--accent))]">
                <span className="h-px w-8 bg-[hsl(var(--secondary))]" />
                For businesses with something worth building
              </p>
              <h1 className="serif mt-3 max-w-lg text-3xl leading-[1.05] tracking-[-.03em] sm:text-4xl md:text-5xl lg:text-[2.85rem]">
                Building <em className="text-[hsl(var(--accent))]">Brands</em>.
                <br />
                Powering <em className="text-[hsl(var(--accent))]">Ideas</em>.
                <br />
                Creating the <em className="text-[hsl(var(--accent))]">Future</em>.
              </h1>
              <p className="mt-4 max-w-md text-sm leading-relaxed text-[hsl(var(--muted-foreground))] sm:text-base">
                You've got the vision. We bring the strategy, the craft and the
                technology to help it travel — from a rough idea to something
                people actually use, trust and remember.
              </p>
              <div className="mt-5 flex flex-wrap gap-3">
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
          </div>
          <KennoxMarquee className="rounded-b-[1.75rem]" />
        </div>
      </section>"""

new_hero = """      <section className="page-wrap pb-4 pt-4 sm:pt-5">
        <div className="flex min-h-[calc(100dvh-76px-3rem)] flex-col justify-center overflow-hidden rounded-[1.75rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))] shadow-[var(--shadow-md)]">
          <div className="grid gap-10 p-8 sm:gap-14 sm:p-12 lg:grid-cols-[1.02fr_.98fr] lg:items-center lg:gap-20 lg:p-20">
            <div className="reveal">
              <p className="eyebrow flex items-center gap-3 text-[hsl(var(--accent))]">
                <span className="h-px w-8 bg-[hsl(var(--secondary))]" />
                For businesses with something worth building
              </p>
              <h1 className="serif mt-5 max-w-xl text-4xl leading-[1.03] tracking-[-.04em] sm:text-5xl md:text-6xl lg:text-[4.25rem]">
                Building <em className="text-[hsl(var(--accent))]">Brands</em>.
                <br />
                Powering <em className="text-[hsl(var(--accent))]">Ideas</em>.
                <br />
                Creating the <em className="text-[hsl(var(--accent))]">Future</em>.
              </h1>
              <p className="mt-6 max-w-lg text-base leading-relaxed text-[hsl(var(--muted-foreground))] sm:text-lg">
                You've got the vision. We bring the strategy, the craft and the
                technology to help it travel — from a rough idea to something
                people actually use, trust and remember.
              </p>
              <div className="mt-8 flex flex-wrap gap-4">
                <CTA href="/contact">Start a Project</CTA>
                <Link
                  href="/services"
                  className="inline-flex items-center gap-2 rounded-full border border-[hsl(var(--border))] px-7 py-4 text-[.75rem] font-bold uppercase tracking-[.12em] hover:border-[hsl(var(--primary))]"
                  data-testid="link-hero-fit"
                >
                  See What We Do <ArrowDown size={16} />
                </Link>
              </div>
            </div>
            <div className="reveal reveal-delay-2">
              <ArtPanel />
            </div>
          </div>
        </div>
      </section>"""

if old_hero in content:
    content = content.replace(old_hero, new_hero, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    hero box is now full-screen and marquee-free.")
elif new_hero in content:
    print("    hero already updated — skipping.")
else:
    raise SystemExit("Could not find the expected hero block in Pages.tsx — aborting to avoid a bad edit.")
PYEOF

# ---------------------------------------------------------------------------
# 2. Marketing.tsx — enlarge the default ArtPanel (used only by the Home
#    hero; the About page uses the separate `compact` variant, untouched).
# ---------------------------------------------------------------------------
echo "2/2 Enlarging the hero's art panel in Marketing.tsx..."
backup "$MARKETING_FILE"
MARKETING_FILE="$MARKETING_FILE" python3 <<'PYEOF'
import os
path = os.environ["MARKETING_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_size = "${compact ? 'h-[220px]' : 'h-[240px] sm:h-auto sm:min-h-[260px]'}"
new_size = "${compact ? 'h-[220px]' : 'h-[320px] sm:h-auto sm:min-h-[420px] lg:min-h-[480px]'}"

old_caption = '<p className="serif mt-1.5 max-w-[15rem] text-lg italic leading-tight sm:text-xl">Turning ideas into meaningful solutions.</p>'
new_caption = '<p className="serif mt-1.5 max-w-[17rem] text-xl italic leading-tight sm:text-2xl">Turning ideas into meaningful solutions.</p>'

changed = False
if old_size in content:
    content = content.replace(old_size, new_size, 1)
    changed = True
elif new_size not in content:
    raise SystemExit("Could not find the expected ArtPanel size classes in Marketing.tsx — aborting to avoid a bad edit.")

if old_caption in content:
    content = content.replace(old_caption, new_caption, 1)
    changed = True
elif new_caption not in content:
    raise SystemExit("Could not find the expected ArtPanel caption in Marketing.tsx — aborting to avoid a bad edit.")

if changed:
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    art panel enlarged.")
else:
    print("    art panel already enlarged — skipping.")
PYEOF

echo ""
echo "Done. Next steps:"
echo "  1. Review the diffs (originals saved as .bak next to each file)."
echo "  2. Run your usual build/verify step, e.g.:"
echo "       pnpm --filter \"./$APP_DIR\" run typecheck"
echo "       pnpm --filter \"./$APP_DIR\" run build"
echo "  3. Preview locally: pnpm --filter \"./$APP_DIR\" run dev"
