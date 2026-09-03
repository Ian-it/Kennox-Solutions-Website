#!/usr/bin/env bash
#
# 09-hero-freeform-and-icon-mockup.sh
#
# Follow-up to 08-hero-fullscreen-remove-marquee.sh. Three changes:
#
#   1. Pages.tsx (Home hero) — removes the white rounded card (border,
#      rounded corners, background, shadow) entirely. The hero content now
#      sits directly on the page background, still filling the screen.
#   2. Pages.tsx (Home hero) — brings the marquee back as a full-bleed bar
#      (edge-to-edge, no rounded corners) absolutely positioned flush with
#      the bottom of the hero section, so on load it sits flush with the
#      bottom of the viewport — matching the reference mock-up.
#   3. SupportTools.tsx — special-cases the WhatsApp + chatbot launcher for
#      the home page only: on "/" they stack vertically and float above the
#      marquee bar (matching the mock-up); on every other page they keep
#      their current side-by-side, bottom-right placement, unchanged.
#
# Usage:
#   ./09-hero-freeform-and-icon-mockup.sh                # assumes ./artifacts/kennox-solutions
#   ./09-hero-freeform-and-icon-mockup.sh path/to/kennox-solutions
#
# Requires: python3. Idempotent — safe to re-run. Each modified file gets a
# one-time ".bak2" backup next to it (kept separate from script 08's .bak).

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
  echo "  ./09-hero-freeform-and-icon-mockup.sh path/to/kennox-solutions"
  exit 1
fi

PAGES_FILE="$APP_DIR/src/pages/Pages.tsx"
SUPPORT_FILE="$APP_DIR/src/components/SupportTools.tsx"

for f in "$PAGES_FILE" "$SUPPORT_FILE"; do
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
  if [ ! -f "$f.bak2" ]; then
    cp "$f" "$f.bak2"
  fi
}

# ---------------------------------------------------------------------------
# 1. Pages.tsx — drop the card, bring back the marquee flush to the bottom.
# ---------------------------------------------------------------------------
echo "1/2 Freeing the hero from its card + restoring a full-bleed marquee..."
backup "$PAGES_FILE"
PAGES_FILE="$PAGES_FILE" python3 <<'PYEOF'
import os
path = os.environ["PAGES_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

# --- 1a. Re-add the KennoxMarquee import (removed in script 08) ------------
old_import = """import {
  ArtPanel,
  SectionIntro,
  ServiceExplorer,
  TestimonialSlideshow,
  accentFor,
} from "@/components/Marketing";"""

new_import = """import {
  ArtPanel,
  KennoxMarquee,
  SectionIntro,
  ServiceExplorer,
  TestimonialSlideshow,
  accentFor,
} from "@/components/Marketing";"""

if old_import in content:
    content = content.replace(old_import, new_import, 1)
    print("    re-added KennoxMarquee import.")
elif new_import in content:
    print("    import already in place — skipping.")
else:
    raise SystemExit("Could not find the expected import block in Pages.tsx — aborting to avoid a bad edit.")

# --- 1b. Replace the boxed hero with a freeform, full-bleed-marquee hero ---
old_hero = """      <section className="page-wrap pb-4 pt-4 sm:pt-5">
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

new_hero = """      <section className="relative">
        <div className="page-wrap flex min-h-[calc(100dvh-76px)] flex-col justify-center pb-20 pt-6 sm:pb-24 sm:pt-8">
          <div className="grid gap-10 sm:gap-14 lg:grid-cols-[1.02fr_.98fr] lg:items-center lg:gap-20">
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
        <KennoxMarquee className="absolute inset-x-0 bottom-0" />
      </section>"""

if old_hero in content:
    content = content.replace(old_hero, new_hero, 1)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
    print("    hero is now card-free, with the marquee flush to the bottom.")
elif new_hero in content:
    print("    hero already updated — skipping.")
else:
    raise SystemExit("Could not find the expected hero block in Pages.tsx — aborting to avoid a bad edit.")
PYEOF

# ---------------------------------------------------------------------------
# 2. SupportTools.tsx — special-case the launcher position/layout on Home.
# ---------------------------------------------------------------------------
echo "2/2 Special-casing the WhatsApp + chat launcher for the home page..."
backup "$SUPPORT_FILE"
SUPPORT_FILE="$SUPPORT_FILE" python3 <<'PYEOF'
import os
path = os.environ["SUPPORT_FILE"]
with open(path, "r", encoding="utf-8") as fh:
    content = fh.read()

# --- 2a. Import useLocation from wouter -------------------------------------
old_imports = """import { Bot, MessageCircle, Send, X } from "lucide-react";
import { type FormEvent, useEffect, useRef, useState } from "react";"""

new_imports = """import { Bot, MessageCircle, Send, X } from "lucide-react";
import { type FormEvent, useEffect, useRef, useState } from "react";
import { useLocation } from "wouter";"""

if new_imports in content:
    print("    import already in place — skipping.")
elif old_imports in content:
    content = content.replace(old_imports, new_imports, 1)
    print("    added useLocation import.")
else:
    raise SystemExit("Could not find the expected imports in SupportTools.tsx — aborting to avoid a bad edit.")

# --- 2b. Read the current route and branch position/layout on it -----------
old_state = """  const [open, setOpen] = useState(false);
  const [draft, setDraft] = useState("");
  const [messages, setMessages] = useState<ChatMessage[]>([welcomeMessage]);
  const inputRef = useRef<HTMLInputElement>(null);"""

new_state = """  const [open, setOpen] = useState(false);
  const [draft, setDraft] = useState("");
  const [messages, setMessages] = useState<ChatMessage[]>([welcomeMessage]);
  const inputRef = useRef<HTMLInputElement>(null);
  const [location] = useLocation();
  // Special case for the home hero: float the launcher above the full-bleed
  // marquee bar and stack the two buttons, matching the reference mock-up.
  // Every other page keeps the standard bottom-right, side-by-side layout.
  const isHome = location === "/";"""

if new_state in content:
    print("    home-route check already in place — skipping.")
elif old_state in content:
    content = content.replace(old_state, new_state, 1)
    print("    added the home-route check.")
else:
    raise SystemExit("Could not find the expected state block in SupportTools.tsx — aborting to avoid a bad edit.")

# --- 2c. Branch the wrapper position on isHome -----------------------------
# Unique as-is: this is the only "fixed bottom-5 right-4 ..." string in the file.
old_wrapper = '    <div className="fixed bottom-5 right-4 z-50 flex flex-col items-end gap-3 sm:right-6">'
new_wrapper = '    <div className={`fixed right-4 z-50 flex flex-col items-end gap-3 sm:right-6 ${isHome ? "bottom-24 sm:bottom-28" : "bottom-5"}`}>'

changed = False
if new_wrapper in content:
    print("    launcher position already special-cased — skipping.")
elif old_wrapper in content:
    content = content.replace(old_wrapper, new_wrapper, 1)
    changed = True
    print("    launcher now floats above the marquee on the home page.")
else:
    raise SystemExit("Could not find the expected wrapper div in SupportTools.tsx — aborting to avoid a bad edit.")

# --- 2d. Branch the button-row layout (stack on Home) -----------------------
# The chat header also uses className="flex items-center gap-3" (same text),
# so match the whole WhatsApp+chat button block below (unique via its content)
# rather than the bare div, to avoid touching the wrong element.
old_buttons_block = """      <div className="flex items-center gap-3">
        <a href={whatsappHref()} target="_blank" rel="noreferrer" aria-label="Chat with Kennox on WhatsApp" title="Chat on WhatsApp" className="grid h-12 w-12 place-items-center rounded-full bg-[#25D366] text-[#073B1A] shadow-[var(--shadow-md)] ring-2 ring-[hsl(var(--background))] transition-transform hover:-translate-y-0.5" data-testid="button-global-whatsapp">
          <MessageCircle size={22} fill="currentColor" />
        </a>
        <button type="button" onClick={() => setOpen((current) => !current)} aria-label={open ? "Close Kennox chat" : "Open Kennox chat"} title="Chat with Kennox" className="grid h-14 w-14 place-items-center rounded-full bg-[hsl(var(--secondary))] text-[hsl(var(--primary))] shadow-[var(--shadow-md)] ring-2 ring-[hsl(var(--background))] transition-transform hover:-translate-y-0.5" data-testid="button-global-chat">
          {open ? <X size={21} /> : <Bot size={21} />}
        </button>
      </div>"""

new_buttons_block = """      <div className={isHome ? "flex flex-col items-center gap-3" : "flex items-center gap-3"}>
        <a href={whatsappHref()} target="_blank" rel="noreferrer" aria-label="Chat with Kennox on WhatsApp" title="Chat on WhatsApp" className="grid h-12 w-12 place-items-center rounded-full bg-[#25D366] text-[#073B1A] shadow-[var(--shadow-md)] ring-2 ring-[hsl(var(--background))] transition-transform hover:-translate-y-0.5" data-testid="button-global-whatsapp">
          <MessageCircle size={22} fill="currentColor" />
        </a>
        <button type="button" onClick={() => setOpen((current) => !current)} aria-label={open ? "Close Kennox chat" : "Open Kennox chat"} title="Chat with Kennox" className="grid h-14 w-14 place-items-center rounded-full bg-[hsl(var(--secondary))] text-[hsl(var(--primary))] shadow-[var(--shadow-md)] ring-2 ring-[hsl(var(--background))] transition-transform hover:-translate-y-0.5" data-testid="button-global-chat">
          {open ? <X size={21} /> : <Bot size={21} />}
        </button>
      </div>"""

if new_buttons_block in content:
    print("    button-row layout already special-cased — skipping.")
elif old_buttons_block in content:
    content = content.replace(old_buttons_block, new_buttons_block, 1)
    changed = True
    print("    button row now stacks vertically on the home page.")
else:
    raise SystemExit("Could not find the expected button-row block in SupportTools.tsx — aborting to avoid a bad edit.")

if changed:
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)
PYEOF

echo ""
echo "Done. Next steps:"
echo "  1. Review the diffs (originals saved as .bak2 next to each file)."
echo "  2. Run your usual build/verify step, e.g.:"
echo "       pnpm --filter \"./$APP_DIR\" run typecheck"
echo "       pnpm --filter \"./$APP_DIR\" run build"
echo "  3. Preview locally: pnpm --filter \"./$APP_DIR\" run dev"
