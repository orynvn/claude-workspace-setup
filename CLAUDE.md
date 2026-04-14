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

## Conventions

- English for all code, comments, and commit messages
- Commit format: `type(scope): subject` — feat | fix | chore | docs | refactor | test | perf
- No hardcoded secrets — always use environment variables
- No dead code (commented-out blocks) in final commits
- Max function length: ~40 lines — split if longer
- Validate all external inputs at system boundaries

## Agent Behavior

- Read `.context/ERRORS.md` before implementing — avoid repeating known mistakes
- Read `.context/DECISIONS.md` before proposing architecture changes
- Prefer editing existing files over creating new ones
- Ask before running database-destructive operations (DROP, TRUNCATE, bulk DELETE)
- Never commit `.env` files or secrets
- When blocked: state the blocker clearly, ask one focused question

## Context Tracking

### Active Work
*(Update this section at the start of each session)*
- *(e.g. Feature: user auth — branch `feat/auth` — in progress)*

### Key Files
*(List files that need extra care)*
- *(e.g. `src/core/pipeline.ts` — core orchestration, read fully before editing)*

### Known Issues
*(Link to `.context/ERRORS.md` entries)*
- *(e.g. BUG-001: Redis queue drops jobs under load — see ERRORS.md)*

## Session Workflow

1. Read `.context/HISTORY.md` and `.context/DECISIONS.md`
2. Update **Active Work** above with current task
3. Implement using the appropriate subagent (see `.claude/agents/`)
4. After finishing: update `.context/HISTORY.md` with a one-line entry
5. If an architectural decision was made: update `.context/DECISIONS.md`
6. If a bug was fixed: update `.context/ERRORS.md`
