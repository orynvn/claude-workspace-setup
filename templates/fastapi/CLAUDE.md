# Stack: FastAPI

> Append this to your project's CLAUDE.md under the Stack and Conventions sections.

## Stack

| Layer | Technology |
|---|---|
| Framework | FastAPI, Python 3.12 |
| ORM | SQLAlchemy 2 (async) |
| Validation | Pydantic v2 |
| Auth | python-jose (JWT) |
| Testing | pytest + httpx |

## Conventions

### File Structure
```
app/
  main.py
  routers/<resource>.py     # Route handlers — thin
  schemas/<resource>.py     # Pydantic models (request/response)
  services/<resource>.py    # Business logic
  models/<resource>.py      # SQLAlchemy models
  dependencies.py           # Shared Depends() functions
tests/
  test_<resource>.py
```

### Code Rules
- All routes `async` — all DB operations use `await`
- Pydantic schemas for all request/response — never raw dicts
- Auth via `Depends(get_current_user)` — add to every protected router
- No f-strings in SQL queries — use SQLAlchemy ORM or `:param` bindings
- Format: `ruff format`, lint: `ruff check`

### Testing
- `pytest` + `httpx.AsyncClient` for async route tests
- `pytest-asyncio` for async fixtures
- Use real test DB (`TEST_DATABASE_URL`) — no mocks for DB layer
- Run: `pytest -v`
