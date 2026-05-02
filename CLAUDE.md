# CLAUDE.md

> This file is the persistent brain of the project. Claude Code reads it automatically at every session start.
> Keep it under 150 lines — high signal only.

## Project Overview

**Stack detected from:** `composer.json` / `package.json` / `pyproject.toml`
**Replace this section** with a 2-3 sentence description of the project.

## Stack

| Layer | Technology |
|---|---|
| Backend | *(e.g. Laravel 11 / NestJS / FastAPI)* |
| Frontend | *(e.g. Next.js 14 / React + Vite / Vue 3)* |
| Database | *(e.g. PostgreSQL, Redis)* |
| Auth | *(e.g. Sanctum / JWT / Supabase)* |
| Testing | *(e.g. Pest PHP / Vitest / pytest)* |
| CI | GitHub Actions |

→ Stack-specific conventions: see `templates/<stack>/CLAUDE.md`

## Language

Respond in the same language the user writes in.
Default: **Vietnamese** — switch to English only if the user writes in English.
Code, variable names, comments, and commit messages are always in **English**.

## Conventions

- English for all code, comments, and commit messages
- Commit format: `type(scope): subject` — feat | fix | chore | docs | refactor | test | perf
- No hardcoded secrets — always use environment variables
- No dead code (commented-out blocks) in final commits
- Max function length: ~40 lines — split if longer
- Validate all external inputs at system boundaries

## Workflow Triggers

When a user message matches these patterns, route to the agent shown:

| Type | Vietnamese keywords | English keywords | Start with |
|---|---|---|---|
| New feature | thêm, xây dựng, tạo mới, tạo tính năng | add, build, create, implement | `@analyst` |
| Fix / Bug | sửa, fix, lỗi, không chạy, bug | fix, bug, broken, error, not working | `@analyst` |
| Test | viết test, thêm test | write test, add test, coverage | `@analyst` |
| List tasks | liệt kê task, task còn lại | list tasks, pending tasks, what's left | `@analyst` |
| Run task N | thực hiện task N, chạy task N | run task N, execute task N | `@analyst` |
| Mark done | đã xong task N, xong task N | done task N, mark task N done | `@analyst` |
| Quick edit | đổi tên, dịch, cập nhật config | rename, translate, update config | `@quick` |
| Code review | review, xem lại code | review, check code | `@reviewer` |
| Security | bảo mật, kiểm tra bảo mật | security, audit, owasp | `@security` |

`@analyst` creates plans in `.context/plans/` and tracks task status with `[ ]` → `[~]` → `[x]`.

## Agent Behavior

- For any new work: run `@analyst` first — it creates a plan and tells you the command sequence
- Read `.context/ERRORS.md` before implementing — avoid repeating known mistakes
- Read `.context/DECISIONS.md` before proposing architecture changes
- Prefer editing existing files over creating new ones
- Confirm with user before: DROP, TRUNCATE, bulk DELETE, force-push, `rm -rf`
- Never commit `.env` files or secrets
- When blocked: state the blocker clearly, ask one focused question

## Context Tracking

### Active Work
*(Update this section at the start of each session)*
- *(e.g. Feature: user auth — branch `feat/auth` — PLAN-001 phase 2/3)*

### Active Plans
*(Link to in-progress plans)*
- *(e.g. [PLAN-001](.context/plans/PLAN-001-user-auth.md) — user auth — phase 2)*

### Key Files
*(List files that need extra care)*
- *(e.g. `src/core/pipeline.ts` — core orchestration, read fully before editing)*

### Known Issues
*(Link to `.context/ERRORS.md` entries)*
- *(e.g. BUG-001: Redis queue drops jobs under load — see ERRORS.md)*

## Session Workflow

1. Read `.context/HISTORY.md` and `.context/DECISIONS.md`
2. Check **Active Plans** above — resume if continuing an existing plan
3. Update **Active Work** above with current task
4. Implement using the appropriate subagent (see `.claude/agents/`)
5. After finishing: update `.context/HISTORY.md` with a one-line entry
6. If an architectural decision was made: update `.context/DECISIONS.md`
7. If a bug was fixed: update `.context/ERRORS.md`
8. If a plan was completed: set `status: completed` in the plan file
