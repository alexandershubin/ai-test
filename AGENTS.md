# AI Resume Analyzer — Agent Guide

Full-stack AI app. Users upload a CV + paste a job description → Groq LLM returns structured analysis (score, missing skills, issues, suggestions).

## Sub-agent guides

For detailed rules, always read the relevant sub-guide first:
- **Frontend**: `@frontend/AGENTS.md`
- **Backend**: `@backend/AGENTS.md`

## Architecture

```
browser
  └─► Next.js 16.2 (port 3001)       ← frontend/
        └─► NestJS 11 API (port 3000) ← backend/
              ├─► PostgreSQL (port 5432, db: ai_resume)
              └─► Groq API (llama-3.3-70b-versatile)
```

## Project Layout

```
ai_test/
├── CLAUDE.md              # entry point (this file via @AGENTS.md)
├── AGENTS.md              # ← you are here
├── frontend/
│   ├── CLAUDE.md          # @AGENTS.md
│   ├── AGENTS.md          # detailed frontend rules
│   └── src/
│       ├── app/           # Next.js App Router pages
│       ├── components/    # React components (ui/ = shadcn)
│       └── lib/           # api.ts, auth.ts, utils.ts
├── backend/
│   ├── CLAUDE.md          # @AGENTS.md
│   ├── AGENTS.md          # detailed backend rules
│   └── src/
│       ├── auth/          # JWT auth module
│       ├── analysis/      # CV analysis (Groq + pdf-parse)
│       ├── users/         # User module
│       ├── prisma/        # PrismaService
│       └── generated/     # ⚠️ auto-generated Prisma client — NEVER EDIT
└── .claude/
    ├── settings.json      # permissions + hooks
    ├── hooks/pre-bash.sh  # pre-commit quality gate
    └── commands/
        ├── review.md      # /review — code review
        └── check.md       # /check — run all checks
```

## Tech Stack Summary

| Layer | Technology |
|-------|-----------|
| Frontend framework | Next.js 16.2.1 (App Router) |
| Frontend language | TypeScript 5 (strict) |
| Styling | Tailwind CSS 4 (`@theme` in globals.css) |
| UI components | shadcn/ui + @base-ui/react |
| Icons | lucide-react |
| Toasts | sonner |
| Backend framework | NestJS 11 |
| Backend language | TypeScript 5 |
| ORM | Prisma 7.6 |
| Database | PostgreSQL (local, port 5432) |
| Auth | JWT + Passport |
| AI model | Groq `llama-3.3-70b-versatile` |
| PDF parsing | pdf-parse v2 (`PDFParse` class) |

## Development Commands

```bash
# Frontend (run from frontend/)
npm run dev           # → http://localhost:3001
npm run build         # production build
npm run lint          # ESLint
npx tsc --noEmit      # type check

# Backend (run from backend/)
npm run start:dev     # → http://localhost:3000 (watch mode)
npm run build         # compile
npm run lint          # ESLint --fix
npm test              # Jest
npx tsc --noEmit      # type check

# Database (from backend/)
npx prisma migrate dev --name <name>   # create + run migration
npx prisma generate                    # regenerate client
npx prisma studio                      # GUI → http://localhost:5555
```

## Environment Variables

**backend/.env** (never commit secrets):
```
DATABASE_URL="postgresql://alexandershubin@localhost:5432/ai_resume"
JWT_SECRET="..."
GROQ_API_KEY="gsk_..."
```

**frontend/.env.local** (if needed):
```
NEXT_PUBLIC_API_URL=http://localhost:3000/api
```

## Safety Rules

### Allowed autonomously
- Read and search any file
- Run lint, tsc, jest on specific files
- `git status`, `git diff`, `git log`
- Start dev servers

### Requires explicit confirmation
- `npm install` / `npm uninstall`
- `git commit`, `git push`, branch operations
- Deleting any file
- Modifying `package.json`, `tsconfig.json`, `prisma/schema.prisma`
- Any database migration (`prisma migrate dev`)
- Modifying `.env` files

### Never allowed
- Edit `backend/src/generated/` — auto-generated
- Edit `prisma/migrations/` — never edit manually
- `git push --force`
- `git reset --hard`
- `rm -rf` on project directories

## Quality Gate (before every commit)

```bash
# Must pass with zero errors:
cd frontend && npx tsc --noEmit && npx eslint src/
cd backend  && npx tsc --noEmit && npx eslint src/ && npx jest --passWithNoTests
```

Use `/check` command to run all checks at once.
Use `/review` command for a full code review of current changes.
