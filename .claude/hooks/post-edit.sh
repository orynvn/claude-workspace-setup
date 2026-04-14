#!/usr/bin/env bash
# PostToolUse hook — auto-lint/format edited files based on detected stack
set -euo pipefail

FILE=$(echo "$1" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('file_path',''))" 2>/dev/null || echo "")
[ -z "$FILE" ] && exit 0
[ ! -f "$FILE" ] && exit 0

EXT="${FILE##*.}"

case "$EXT" in
  php)
    # Laravel: run Pint if available
    [ -f "vendor/bin/pint" ] && vendor/bin/pint "$FILE" --quiet || true
    ;;
  ts|tsx)
    # TypeScript: type-check (non-blocking)
    [ -f "tsconfig.json" ] && npx tsc --noEmit --skipLibCheck 2>/dev/null || true
    ;;
  py)
    # Python: ruff format + lint if available
    command -v ruff &>/dev/null && ruff check --fix "$FILE" --quiet && ruff format "$FILE" --quiet || true
    ;;
esac

exit 0
