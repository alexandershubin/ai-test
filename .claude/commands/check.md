Run all quality checks across the project and report results.

## Frontend checks

```bash
cd /Users/alexandershubin/Desktop/IT_обучение/pet_project/ai_test/frontend
npx tsc --noEmit
npx eslint src/
```

## Backend checks

```bash
cd /Users/alexandershubin/Desktop/IT_обучение/pet_project/ai_test/backend
npx tsc --noEmit
npx eslint src/
npx jest --passWithNoTests
```

Run each command and report:
- ✅ PASS — if no errors/warnings
- ❌ FAIL — list every error with file:line

At the end, give a summary:
```
Frontend: TypeScript ✅ | ESLint ✅
Backend:  TypeScript ✅ | ESLint ✅ | Tests ✅
```

If any check fails, list the exact fixes needed before proceeding.
