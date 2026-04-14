# Stack: NestJS

> Append this to your project's CLAUDE.md under the Stack and Conventions sections.

## Stack

| Layer | Technology |
|---|---|
| Framework | NestJS 10, Node.js 20 |
| Language | TypeScript (strict) |
| ORM | TypeORM / Prisma |
| Auth | Passport.js + JWT |
| Testing | Jest + Supertest |
| Queue | Bull (Redis) |

## Conventions

### File Structure (per module)
```
src/<module>/
  <module>.module.ts
  <module>.controller.ts
  <module>.service.ts
  dto/create-<module>.dto.ts
  dto/update-<module>.dto.ts
  entities/<module>.entity.ts
  <module>.controller.spec.ts
  <module>.service.spec.ts
```

### Code Rules
- All business logic in Services — Controllers only handle HTTP/serialization
- DTOs for all request/response shapes — use `class-validator` decorators
- Every route requires `@UseGuards(JwtAuthGuard)` unless explicitly `@Public()`
- Use `@Roles()` guard + decorator for admin endpoints
- No `any` in TypeScript
- Transactions for multi-step DB writes: `dataSource.transaction(async manager => ...)`

### Testing
- Unit: Jest with mocked dependencies (`jest.createMockFromModule`)
- E2E: `test/` folder, Supertest against real NestJS app
- Run: `npm run test` / `npm run test:e2e`
