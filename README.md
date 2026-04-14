# claude-workspace-setup

A project template for Claude Code CLI — opinionated, token-efficient, and built for multi-agent workflows.

## What's included

```
claude-workspace-setup/
├── CLAUDE.md                        # Brain file — customized per project
├── .claude/
│   ├── settings.json                # Hook configurations
│   ├── hooks/
│   │   ├── post-edit.sh             # Auto-lint after file edits
│   │   └── session-stop.sh          # Remind to update context at session end
│   └── agents/
│       ├── planner.md               # Analyzes requirements → task breakdown
│       ├── implementer.md           # Writes code from task breakdown
│       ├── reviewer.md              # Code review — reports, does not fix
│       ├── debugger.md              # Bug fix following RCA workflow
│       ├── security.md              # OWASP Top 10 audit
│       └── quick.md                 # Simple tasks, no pipeline (uses haiku)
├── .context/
│   ├── HISTORY.md                   # Session log — updated by Claude at end
│   ├── DECISIONS.md                 # Architectural decisions (ADR index)
│   ├── ERRORS.md                    # Known bugs / anti-patterns
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

## Design principles

| Principle | Implementation |
|---|---|
| **Persistent context** | `CLAUDE.md` auto-discovered by Claude Code every session |
| **Token efficiency** | `CLAUDE.md` < 150 lines; `quick` agent uses `haiku` model |
| **Enforce without asking** | Hooks auto-lint, auto-remind context update |
| **Specialized agents** | Each subagent does one thing with minimal tools |
| **No repeated mistakes** | `.context/ERRORS.md` read before every implementation |

## Agents

| Agent | When to use | Model |
|---|---|---|
| `planner` | Complex task needing breakdown | sonnet |
| `implementer` | Writing code from a task list | sonnet |
| `reviewer` | Code review before merging | sonnet |
| `debugger` | Bug fix or CI failure | sonnet |
| `security` | Security audit (OWASP) | sonnet |
| `quick` | Docs, translations, config, single-file edits | **haiku** |

**To invoke an agent in Claude Code:**
```
Use the @planner agent to analyze this requirement: ...
Use the @quick agent to translate README.md to Vietnamese
```

## Hooks

| Hook | Trigger | Action |
|---|---|---|
| `post-edit.sh` | After Edit/Write/MultiEdit | Auto-lint the changed file (Pint/ruff/tsc) |
| `session-stop.sh` | Session ends | Blocks close if `.context/HISTORY.md` not updated today |

## Context tracking

After each session, Claude updates `.context/HISTORY.md`:
```
[YYYY-MM-DD] feat: add user auth — src/auth/auth.service.ts
```

| File | Purpose |
|---|---|
| `HISTORY.md` | Reverse-chronological log of all changes |
| `DECISIONS.md` | ADR index — architectural decisions with rationale |
| `ERRORS.md` | Known bugs and anti-patterns — read before implementing |

## vs copilot-workspace-setup

| | copilot-workspace-setup | claude-workspace-setup |
|---|---|---|
| Runtime | VS Code Copilot | Claude Code CLI |
| Agent format | `.github/agents/*.agent.md` | `.claude/agents/*.md` |
| Hooks | JSON + shell scripts | shell scripts via `settings.json` |
| Context | Per-session (chat) | Persistent via `CLAUDE.md` |
| Token savings | — | `quick` uses haiku; compact CLAUDE.md |
