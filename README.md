# claude-workspace-setup

A project template for Claude Code CLI — opinionated, token-efficient, and built for multi-agent workflows.

## What's included

```
claude-workspace-setup/
├── CLAUDE.md                        # Brain file — customized per project
├── .claude/
│   ├── settings.json                # Hooks + MCP servers (error-learning, github)
│   ├── hooks/
│   │   ├── pre-bash.sh              # Block destructive commands before execution
│   │   ├── post-edit.sh             # Auto-lint after file edits (PHP/TS/JS/Py/Go/Ruby)
│   │   └── session-stop.sh          # Remind to update context at session end
│   ├── agents/
│   │   ├── analyst.md               # Detects intent → creates plan → outputs roadmap
│   │   ├── planner.md               # Detailed task breakdown for a single requirement
│   │   ├── implementer.md           # Writes code from task breakdown
│   │   ├── reviewer.md              # Code review — reports, does not fix
│   │   ├── debugger.md              # Bug fix + CI/CD failures (RCA workflow)
│   │   ├── security.md              # OWASP Top 10 audit
│   │   └── quick.md                 # Simple tasks, no pipeline (uses haiku)
│   └── commands/                    # Slash command shortcuts
│       ├── plan.md                  # /plan <requirement>
│       ├── todo.md                  # /todo <PLAN-NNN>
│       ├── do.md                    # /do <N> <PLAN-NNN>
│       └── ship.md                  # /ship — pre-merge review + security check
├── .context/
│   ├── HISTORY.md                   # Session log — updated by Claude at end
│   ├── DECISIONS.md                 # Architectural decisions (ADR index)
│   ├── ERRORS.md                    # Known bugs / anti-patterns
│   ├── plans/                       # Feature/fix/test plans with phases and tasks
│   └── decisions/                   # ADR detail files
└── templates/
    ├── laravel/CLAUDE.md
    ├── nextjs/CLAUDE.md
    ├── nestjs/CLAUDE.md
    ├── django/CLAUDE.md
    ├── fastapi/CLAUDE.md
    └── react/CLAUDE.md
```

## Quick start

**Option A — Copy into your project:**

```bash
# Clone the template
git clone https://github.com/orynvn/claude-workspace-setup.git

# Copy files into your project
cp claude-workspace-setup/CLAUDE.md your-project/
cp -r claude-workspace-setup/.claude your-project/
cp -r claude-workspace-setup/.context your-project/

# Add the matching stack conventions to CLAUDE.md
cat claude-workspace-setup/templates/laravel/CLAUDE.md >> your-project/CLAUDE.md
# (replace 'laravel' with your stack: nextjs | nestjs | django | fastapi | react)

# Open Claude Code in your project
cd your-project && claude
```

**Option B — Use as reference while building from scratch:**

Copy only what you need: `CLAUDE.md` + `templates/<stack>/CLAUDE.md` → merge → customize.

### Install Error Learning MCP (optional but recommended)

The `debugger` agent integrates with [orynvn/mcp-error-learning](https://github.com/orynvn/mcp-error-learning) — a local SQLite knowledge base that remembers past bugs and surfaces solutions automatically.

```bash
# Clone MCP server into your project root
cd your-project
git clone https://github.com/orynvn/mcp-error-learning.git

# Install
python3 -m pip install -e mcp-error-learning/

# Claude Code auto-discovers it via .claude/settings.json — no extra config needed
```

> The knowledge base is stored at `mcp-error-learning/data/errors.db` (local only, not committed).
> Remove `mcp-error-learning/` from `.claude/settings.json` if you choose not to install it — the debugger falls back to `.context/ERRORS.md`.

### Setup GitHub MCP (optional — for CI/CD debugging)

The `debugger` agent uses the GitHub MCP to read workflow runs and issue details when debugging CI failures.

```bash
# Requires a GitHub Personal Access Token with repo + workflow scopes
# Add to your shell profile:
export GITHUB_TOKEN=ghp_your_token_here
```

> The token is read from `$GITHUB_TOKEN` at runtime — never hardcoded.  
> Remove the `github` block from `.claude/settings.json` if you don't use GitHub.  
> For CI log details, `gh run view <id> --log-failed` (GitHub CLI) is more complete than the MCP.

## Design principles

| Principle | Implementation |
|---|---|
| **Persistent context** | `CLAUDE.md` auto-discovered by Claude Code every session |
| **Token efficiency** | `CLAUDE.md` < 150 lines; `quick` agent uses `haiku` model |
| **Enforce without asking** | Hooks auto-lint, block destructive ops, auto-remind context update |
| **Specialized agents** | Each subagent does one thing with minimal tools |
| **No repeated mistakes** | `.context/ERRORS.md` + MCP error-learning read before every implementation |
| **Planned execution** | `@analyst` creates structured plans; user runs tasks one by one |

## Workflow

The `@analyst` agent is the entry point for all non-trivial work. It detects intent from keywords (Vietnamese and English), then creates a structured plan and outputs a numbered command sequence.

**Trigger words:**

| Work type | Vietnamese | English |
|---|---|---|
| New feature | thêm, xây dựng, tạo mới | add, build, create, implement |
| Fix / Bug | sửa, fix, lỗi, không chạy | fix, bug, broken, error |
| Write tests | viết test, thêm test | write test, add test, coverage |
| Continue plan | tiếp tục, chạy task N | continue, resume, run task N |

**Example session:**
```
You:    "thêm tính năng đăng nhập bằng Google OAuth"
Claude: [runs @analyst] → creates .context/plans/PLAN-001-google-oauth.md
        → outputs:
          [1] Use the @implementer agent to: Create GoogleOAuthService...
          [2] Use the @implementer agent to: Add /auth/google route...
          [3] Use the @reviewer agent to: Review src/auth/...

You:    "chạy task 1"
Claude: [runs @implementer with task 1 details from the plan]
```

## Agents

| Agent | When to use | Model |
|---|---|---|
| `analyst` | **Start here** — any new feature, fix, or test request | sonnet-4-6 |
| `planner` | Detailed task breakdown (called by analyst or directly) | sonnet |
| `implementer` | Writing code from a task breakdown | sonnet |
| `reviewer` | Code review before merging | sonnet |
| `debugger` | Bug fix following RCA workflow | sonnet |
| `security` | Security audit (OWASP Top 10) | sonnet |
| `quick` | Docs, translations, config, single-file edits | **haiku** |

**Task status commands (say these in Claude Code):**
```
list tasks PLAN-001             # show all pending tasks in order
run task 2 PLAN-001             # extract and start task 2
done task 2 PLAN-001            # mark task 2 complete, show next
```

Checkbox legend in plan files: `- [ ]` pending · `- [~]` in-progress · `- [x]` done

**To invoke an agent directly:**
```
Use the @analyst agent to: add Google OAuth login
Use the @quick agent to translate README.md to Vietnamese
```

## Hooks

| Hook | Trigger | Action |
|---|---|---|
| `pre-bash.sh` | Before any Bash command | Blocks DROP/TRUNCATE/rm -rf/force-push |
| `post-edit.sh` | After Edit/Write/MultiEdit | Auto-lint (PHP/TS/JS/Py/Go/Ruby) |
| `session-stop.sh` | Session ends | Blocks close if `.context/HISTORY.md` not updated today |

## Context tracking

After each session, Claude updates `.context/HISTORY.md`:
```
[YYYY-MM-DD] feat: add user auth — src/auth/auth.service.ts
```

| File / Folder | Purpose |
|---|---|
| `HISTORY.md` | Reverse-chronological log of all changes |
| `DECISIONS.md` | ADR index — architectural decisions with rationale |
| `ERRORS.md` | Known bugs and anti-patterns — read before implementing |
| `plans/PLAN-NNN-*.md` | Structured feature/fix/test plans with phases and tasks |

### Plan file format

Plans in `.context/plans/` follow a consistent structure:

```markdown
---
id: PLAN-001
title: Add Google OAuth
type: feature          # feature | fix | test
status: in-progress   # planning | in-progress | completed
created: 2026-05-02
branch: feat/google-oauth
---

## Phase 1: Backend
### Task 1.1: Create GoogleOAuthService
- File: `app/Services/GoogleOAuthService.php`
- Command: `Use the @implementer agent to: Create GoogleOAuthService...`

## Execution Roadmap

- [x] **[1]** Use the @implementer agent to: Create GoogleOAuthService — Task 1.1
- [~] **[2]** Use the @implementer agent to: Add /auth/google route — Task 1.2
- [ ] **[3]** Use the @reviewer agent to: Review auth changes
- [ ] **[4]** Update .context/HISTORY.md
```

Status updates automatically:
- When implementer finishes a task → marks `[x]` in plan file
- When analyst runs task → marks `[~]` (in-progress)
- When all `[x]` → plan `status: completed`

## vs copilot-workspace-setup

| | copilot-workspace-setup | claude-workspace-setup |
|---|---|---|
| Runtime | VS Code Copilot | Claude Code CLI |
| Agent format | `.github/agents/*.agent.md` | `.claude/agents/*.md` |
| Hooks | JSON + shell scripts | shell scripts via `settings.json` |
| Context | Per-session (chat) | Persistent via `CLAUDE.md` |
| Token savings | — | `quick` uses haiku; compact CLAUDE.md |
