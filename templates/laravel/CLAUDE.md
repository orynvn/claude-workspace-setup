# Stack: Laravel

> Append this to your project's CLAUDE.md under the Stack and Conventions sections.

## Stack

| Layer | Technology |
|---|---|
| Backend | PHP 8.3, Laravel 11 |
| Database | MySQL / PostgreSQL |
| Auth | Laravel Sanctum (API tokens) |
| Testing | Pest PHP |
| Queue | Laravel Horizon (Redis) |

## Conventions

### Files & Naming
- Controllers: `app/Http/Controllers/<Resource>Controller.php` — thin, delegate to Services
- Services: `app/Services/<Resource>Service.php` — business logic here
- Models: `app/Models/<Resource>.php` — relations, scopes, casts only
- Requests: `app/Http/Requests/<Action><Resource>Request.php`
- Resources: `app/Http/Resources/<Resource>Resource.php`
- Jobs: `app/Jobs/<Action><Resource>Job.php`

### Code Rules
- All business logic in Services — never in Controllers or Models
- Always use Form Requests for validation — never `$request->validate()` in controllers
- Use API Resources for all responses — never raw `json()` with model data
- Use Database Transactions for multi-step writes: `DB::transaction(fn() => ...)`
- Queued jobs for any operation > 500ms
- No raw SQL — use Eloquent or Query Builder with bindings

### Testing (Pest PHP)
- Feature tests in `tests/Feature/`, Unit tests in `tests/Unit/`
- Use `RefreshDatabase` trait — real DB, no mocks for DB layer
- Factory for test data: `User::factory()->create()`
- Test naming: `it('does X when Y')`
- Run: `php artisan test --parallel`

### Migrations
- Never modify existing migrations — always create new ones
- Add `->comment()` to non-obvious columns
- Index foreign keys and frequently filtered columns
