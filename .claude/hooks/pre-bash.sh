#!/bin/bash
# Claude Code pre-bash hook
# Intercepts git commit to run quality checks first

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null)

# Only intercept git commit commands
if ! echo "$COMMAND" | grep -qE "^git commit"; then
  exit 0
fi

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$PROJECT_ROOT" ]; then
  exit 0
fi

echo "=== Pre-commit checks ==="
FAILED=0

# --- Frontend checks ---
if [ -d "$PROJECT_ROOT/frontend" ]; then
  echo ""
  echo "[frontend] TypeScript..."
  cd "$PROJECT_ROOT/frontend" && npx tsc --noEmit
  [ $? -ne 0 ] && FAILED=1

  echo "[frontend] ESLint..."
  cd "$PROJECT_ROOT/frontend" && npx eslint src/
  [ $? -ne 0 ] && FAILED=1
fi

# --- Backend checks ---
if [ -d "$PROJECT_ROOT/backend" ]; then
  echo ""
  echo "[backend] TypeScript..."
  cd "$PROJECT_ROOT/backend" && npx tsc --noEmit
  [ $? -ne 0 ] && FAILED=1

  echo "[backend] ESLint..."
  cd "$PROJECT_ROOT/backend" && npx eslint src/
  [ $? -ne 0 ] && FAILED=1

  echo "[backend] Jest..."
  cd "$PROJECT_ROOT/backend" && npx jest --passWithNoTests
  [ $? -ne 0 ] && FAILED=1
fi

if [ $FAILED -ne 0 ]; then
  echo ""
  echo "❌ Pre-commit checks failed. Fix all errors before committing."
  exit 2
fi

echo ""
echo "✅ All checks passed."
exit 0
