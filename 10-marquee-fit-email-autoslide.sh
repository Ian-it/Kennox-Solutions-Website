#!/usr/bin/env bash
#
# 10-marquee-fit-email-autoslide.sh
#
# Three independent fixes:
#
#   1. Hero marquee no longer gets clipped on mobile. It was absolutely
#      positioned flush to the bottom of a min-h-[100dvh] hero, which is
#      unreliable on phones because the browser's address bar changes the
#      real viewport height as you scroll. Below the "sm" breakpoint the
#      marquee now flows naturally right after the hero content instead
#      (always fully visible, no clipping); at "sm" and above it keeps the
#      original flush-to-bottom, fills-the-screen behaviour, since desktop
#      viewport height is stable.
#
#   2. The contact email changes from info@kennoxsolutions.co.ke to
#      info@kennox.co.ke everywhere it appears: the shared contactInfo
#      config (used by the footer and the Contact page) and the mailto:
#      link used by the Music and Contact form submissions.
#
#   3. ServiceExplorer (the "01 Brand / 02 Marketing & Growth / ..." picker
#      on Home and What We Do) now auto-advances every 5.5s, exactly like
#      TestimonialSlideshow: pauses on hover/focus, respects
#      prefers-reduced-motion, and still lets you click a card to jump to
#      it and pause — clicking is no longer required to see the details.
#
# Usage:
#   ./10-marquee-fit-email-autoslide.sh                # assumes ./artifacts/kennox-solutions
#   ./10-marquee-fit-email-autoslide.sh path/to/kennox-solutions
#
# Requires: python3. Idempotent — safe to re-run. Each modified file gets a
# one-time ".bak3" backup next to it.

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
  echo "  ./10-marquee-fit-email-autoslide.sh path/to/kennox-solutions"
  exit 1
fi

PAGES_FILE="$APP_DIR/src/pages/Pages.tsx"
MARKETING_FILE="$APP_DIR/src/components/Marketing.tsx"
SITE_FILE="$APP_DIR/src/data/site.ts"
SUBMISSIONS_FILE="$APP_DIR/src/services/submissions.ts"

for f in "$PAGES_FILE" "$MARKETING_FILE" "$SITE_FILE" "$SUBMISSIONS_FILE"; do
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
  if [ ! -f "$f.bak3" ]; then
    cp "$f" "$f.bak3"
  fi
}

# ---------------------------------------------------------------------------
# 1. Pages.tsx — stop clipping the marquee on mobile.
# ---------------------------------------------------------------------------
echo "1/4 Fixing the mobile marquee fit in Pages.tsx..."
backup "$PAGES_FILE"
PAGES_FILE="$PAGES_FILE" python3 <<'PYEOF'
import os
path = os.environ["PAGES_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_wrap = '        <div className="page-wrap flex min-h-[calc(100dvh-76px)] flex-col justify-center pb-20 pt-6 sm:pb-24 sm:pt-8">'
new_wrap = '        <div className="page-wrap flex flex-col justify-center pb-10 pt-6 sm:min-h-[calc(100dvh-76px)] sm:pb-24 sm:pt-8">'

old_marquee = '        <KennoxMarquee className="absolute inset-x-0 bottom-0" />'
new_marquee = '        <KennoxMarquee className="static mt-6 sm:absolute sm:inset-x-0 sm:bottom-0 sm:mt-0" />'

changed = False
if new_wrap in content:
    print("    hero wrapper already fixed — skipping.")
elif old_wrap in content:
    content = content.replace(old_wrap, new_wrap, 1)
    changed = True
else:
    raise SystemExit("Could not find the expected hero wrapper div in Pages.tsx — aborting to avoid a bad edit.")

if new_marquee in content:
    print("    marquee positioning already fixed — skipping.")
elif old_marquee in content:
    content = content.replace(old_marquee, new_marquee, 1)
    changed = True
else:
    raise SystemExit("Could not find the expected KennoxMarquee usage in Pages.tsx — aborting to avoid a bad edit.")

if changed:
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    marquee now flows in on mobile (no clipping) and stays flush-bottom on larger screens.")
PYEOF

# ---------------------------------------------------------------------------
# 2. site.ts — the single source of truth for the contact email.
# ---------------------------------------------------------------------------
echo "2/4 Updating the contact email in site.ts..."
backup "$SITE_FILE"
SITE_FILE="$SITE_FILE" python3 <<'PYEOF'
import os
path = os.environ["SITE_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_email = "  email: 'info@kennoxsolutions.co.ke',"
new_email = "  email: 'info@kennox.co.ke',"

if new_email in content:
    print("    email already updated — skipping.")
elif old_email in content:
    content = content.replace(old_email, new_email, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    contactInfo.email is now info@kennox.co.ke (used by the footer and Contact page).")
else:
    raise SystemExit("Could not find the expected email line in site.ts — aborting to avoid a bad edit.")
PYEOF

# ---------------------------------------------------------------------------
# 3. submissions.ts — the hardcoded mailto: target for form submissions.
# ---------------------------------------------------------------------------
echo "3/4 Updating the mailto: target in submissions.ts..."
backup "$SUBMISSIONS_FILE"
SUBMISSIONS_FILE="$SUBMISSIONS_FILE" python3 <<'PYEOF'
import os
path = os.environ["SUBMISSIONS_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_mailto = "mailto:info@kennoxsolutions.co.ke?subject="
new_mailto = "mailto:info@kennox.co.ke?subject="

if new_mailto in content:
    print("    mailto target already updated — skipping.")
elif old_mailto in content:
    content = content.replace(old_mailto, new_mailto, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    Music/Contact form submissions now mail to info@kennox.co.ke.")
else:
    raise SystemExit("Could not find the expected mailto: target in submissions.ts — aborting to avoid a bad edit.")
PYEOF

# ---------------------------------------------------------------------------
# 4. Marketing.tsx — auto-advance ServiceExplorer like TestimonialSlideshow.
# ---------------------------------------------------------------------------
echo "4/4 Making ServiceExplorer auto-advance in Marketing.tsx..."
backup "$MARKETING_FILE"
MARKETING_FILE="$MARKETING_FILE" python3 <<'PYEOF'
import os
path = os.environ["MARKETING_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

old_explorer_open = """export function ServiceExplorer({ limit }: { limit?: number }) {
  const shown = limit ? services.slice(0, limit) : services;
  const [activeId, setActiveId] = useState(shown[0].id);
  const active = shown.find((service) => service.id === activeId) ?? shown[0];

  return <div className="grid items-start gap-10 lg:grid-cols-[1.35fr_1fr] lg:gap-14"><div className="grid gap-x-8 sm:grid-cols-2">{shown.map((service) => <ServiceCard key={service.id} service={service} active={service.id === active.id} onSelect={() => setActiveId(service.id)} />)}</div><div key={active.id} className="reveal relative overflow-hidden rounded-[1.75rem] bg-[hsl(var(--background))] p-8 text-[hsl(var(--foreground))] shadow-[var(--shadow-md)] sm:p-10">"""

new_explorer_open = """export function ServiceExplorer({ limit }: { limit?: number }) {
  const shown = limit ? services.slice(0, limit) : services;
  const [activeId, setActiveId] = useState(shown[0].id);
  const [paused, setPaused] = useState(false);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const active = shown.find((service) => service.id === activeId) ?? shown[0];

  useEffect(() => {
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (prefersReducedMotion || paused) return;
    timerRef.current = setInterval(() => {
      setActiveId((current) => {
        const currentIndex = shown.findIndex((service) => service.id === current);
        return shown[(currentIndex + 1) % shown.length].id;
      });
    }, 5500);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [paused, shown]);

  return <div className="grid items-start gap-10 lg:grid-cols-[1.35fr_1fr] lg:gap-14" onMouseEnter={() => setPaused(true)} onMouseLeave={() => setPaused(false)} onFocus={() => setPaused(true)} onBlur={() => setPaused(false)}><div className="grid gap-x-8 sm:grid-cols-2">{shown.map((service) => <ServiceCard key={service.id} service={service} active={service.id === active.id} onSelect={() => setActiveId(service.id)} />)}</div><div key={active.id} className="reveal relative overflow-hidden rounded-[1.75rem] bg-[hsl(var(--background))] p-8 text-[hsl(var(--foreground))] shadow-[var(--shadow-md)] sm:p-10">"""

if new_explorer_open in content:
    print("    ServiceExplorer already auto-advances — skipping.")
elif old_explorer_open in content:
    content = content.replace(old_explorer_open, new_explorer_open, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    ServiceExplorer now auto-advances every 5.5s (pauses on hover/focus, click still works).")
else:
    raise SystemExit("Could not find the expected ServiceExplorer block in Marketing.tsx — aborting to avoid a bad edit.")
PYEOF

echo ""
echo "Done. Next steps:"
echo "  1. Review the diffs (originals saved as .bak3 next to each file)."
echo "  2. Run your usual build/verify step, e.g.:"
echo "       pnpm --filter \"./$APP_DIR\" run typecheck"
echo "       pnpm --filter \"./$APP_DIR\" run build"
echo "  3. Preview locally: pnpm --filter \"./$APP_DIR\" run dev"
echo ""
echo "Heads up: the site's <link rel=\"canonical\"> tag and sitemap.xml still"
echo "reference the old domain kennoxsolutions.co.ke (not the email — the"
echo "domain used in SEO/meta tags). Since the live site is now kennox.co.ke,"
echo "you may want those updated too — just ask and I'll prepare that separately."
