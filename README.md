# Kennox Solutions

Kennox Solutions is a frontend-first website helping gospel musicians grow through training, production, branding, community, and industry guidance.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — MySQL connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: MySQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

- `artifacts/kennox-solutions/src/pages/Pages.tsx` — public routes, account screen, and conversational form flows
- `artifacts/kennox-solutions/src/components/` — shared shell, marketing interactions, and scaffold UI
- `artifacts/kennox-solutions/src/data/site.ts` — typed local values, highlights, services, differentiators, testimonials, and navigation
- `artifacts/kennox-solutions/src/services/` — mailto submission and local member-profile service boundaries
- `artifacts/kennox-solutions/prisma/schema.prisma` — Phase 2 database blueprint; not connected in Phase 1
- `artifacts/kennox-solutions/src/index.css` — brand tokens, typography, motion, and responsive utilities

## Architecture decisions

- Phase 1 intentionally uses a static React/Vite client with local typed fixtures and service abstractions, so a later backend can replace service internals without rewriting page components.
- Music and Contact forms use `mailto:` to `info@kennoxsolutions.co.ke` and explain that the visitor must press Send in their mail client.
- The account screen is explicitly a local preview; profile edits persist only on the current device until real authentication and persistence are activated.
- Brand expression uses deep forest green, golden yellow, warm cream, terracotta accent text, and charcoal; bright yellow remains reserved for actions and highlights.

## Product

- Marketing routes for Home, Our Story, What We Do, Share Your Sound, and Let's Talk
- Interactive service explorer across 11 Kennox service categories
- Sample testimonial carousel with accessible controls
- Multi-step Music and Contact forms with inline validation, review screens, personalized confirmation, loading/error states, and mailto handoff
- My Kennox profile preview with editable local fields

## User preferences

- Use conversational, musician-first copy rather than generic corporate labels.

## Gotchas

- The frontend workflow supplies `PORT` and `BASE_PATH`; run the managed workflow for preview, or provide both when invoking a production build manually.
- The Prisma file is documentation for the future backend and must not be connected or provisioned during the frontend-only phase.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
