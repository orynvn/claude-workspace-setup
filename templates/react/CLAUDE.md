# Stack: React (Vite)

> Append this to your project's CLAUDE.md under the Stack and Conventions sections.

## Stack

| Layer | Technology |
|---|---|
| Framework | React 19, Vite |
| Language | TypeScript (strict) |
| State | Zustand (global), React Query (server) |
| Styling | Tailwind CSS |
| Testing | Vitest + Testing Library |

## Conventions

### File Structure
```
src/
  components/<Feature>/<Component>.tsx
  hooks/use-<name>.ts
  stores/<name>-store.ts        # Zustand stores
  lib/api.ts                    # All API calls
  types/<domain>.ts
```

### Code Rules
- No `any` — use proper types or `unknown`
- All API calls in `src/lib/api.ts` — never `fetch()` in components
- `useEffect` only for side effects — not data fetching (use React Query)
- Tailwind only — no inline styles
- Component file = one default export + co-located types

### Testing
- Vitest + `@testing-library/react`
- Mock API calls with `msw` — never mock React hooks
- Run: `npx vitest run`
