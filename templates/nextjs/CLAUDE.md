# Stack: Next.js (App Router)

> Append this to your project's CLAUDE.md under the Stack and Conventions sections.

## Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 15, React 19 |
| Language | TypeScript (strict) |
| Styling | Tailwind CSS |
| State | Zustand (client), React Query (server) |
| Testing | Vitest + Testing Library, Playwright (E2E) |
| Auth | NextAuth.js / Supabase Auth |

## Conventions

### File Structure
- Pages: `app/<route>/page.tsx`
- Layouts: `app/<route>/layout.tsx`
- Components: `src/components/<Feature>/<Component>.tsx`
- Hooks: `src/hooks/use-<name>.ts`
- API calls: `src/lib/api.ts` — never `fetch()` directly in components
- Server actions: `src/actions/<feature>.ts`
- Types: `src/types/<domain>.ts`

### Code Rules
- Server Components by default — add `"use client"` only when needed (event handlers, hooks, browser APIs)
- No `any` — use `unknown` + type narrowing
- All data fetching in Server Components or React Query — no `useEffect` for data
- Server Actions for mutations — no separate API routes unless external clients need them
- Tailwind only — no inline styles, no CSS modules, no styled-components

### Testing
- Unit/Integration: Vitest + `@testing-library/react`
- E2E: Playwright in `tests/e2e/`
- Mock external APIs with `msw`, never mock internal modules
- Run: `npx vitest run` / `npx playwright test`
