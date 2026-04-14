# Stack: Django

> Append this to your project's CLAUDE.md under the Stack and Conventions sections.

## Stack

| Layer | Technology |
|---|---|
| Framework | Django 5, Python 3.12 |
| API | Django REST Framework |
| Auth | SimpleJWT |
| Testing | pytest-django |
| Task Queue | Celery + Redis |

## Conventions

### File Structure (per app)
```
<app>/
  models.py       # DB models only — no business logic
  serializers.py  # DRF serializers — validation + representation
  views.py        # ViewSets — thin, delegate to services
  services.py     # Business logic
  urls.py
  tests/
    test_views.py
    test_services.py
```

### Code Rules
- Business logic in `services.py` — never in views or models
- `serializers.py` for validation — never `request.data` directly in views
- Use `select_related` / `prefetch_related` to prevent N+1
- All endpoints require auth unless `permission_classes = [AllowAny]` with comment explaining why
- Format: `ruff format`, lint: `ruff check`
- Type hints on all function signatures

### Testing (pytest-django)
- Use `@pytest.mark.django_db` for DB tests
- Factory Boy for test data
- Run: `pytest` / `pytest -v tests/test_views.py`
