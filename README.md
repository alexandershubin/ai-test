# AI Resume Analyzer

Full-stack web app that analyzes how well your resume matches a job description, reviews your CV, and generates an AI-improved version ready to download as PDF.

## Features

- **Resume Analysis** — upload a PDF or paste text, provide a job description (text or URL), get a match score with missing skills, issues, and suggestions
- **CV Review** — general AI feedback on your resume without a specific job: strengths, weaknesses, recommendations
- **Improve Resume** — one click to generate a rewritten, tailored CV based on the analysis or review results, with PDF download
- **Job URL Scraping** — paste a link to hh.ru, Indeed, Glassdoor and the app fetches the description automatically
- **Auth** — JWT via httpOnly cookies, no tokens in localStorage

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 16 (App Router), TypeScript, Tailwind CSS v4, shadcn/ui |
| Backend | NestJS 11, TypeScript, Prisma 7, PostgreSQL |
| AI | Groq API — `llama-3.3-70b-versatile` |
| Auth | JWT + Passport, httpOnly cookies |
| PDF parsing | pdf-parse v2 |

## Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL running locally (port 5432)
- [Groq API key](https://console.groq.com)

### 1. Clone and install

```bash
git clone <repo-url>
cd ai_test

cd backend && npm install
cd ../frontend && npm install
```

### 2. Configure environment

**backend/.env**
```env
DATABASE_URL="postgresql://<user>@localhost:5432/ai_resume"
JWT_SECRET="your-secret-key"
GROQ_API_KEY="gsk_..."
```

**frontend/.env.local** (optional)
```env
NEXT_PUBLIC_API_URL=http://localhost:3000/api
```

### 3. Set up the database

```bash
cd backend
npx prisma migrate dev
```

### 4. Run

```bash
# Terminal 1 — backend (port 3000)
cd backend && npm run start:dev

# Terminal 2 — frontend (port 3001)
cd frontend && npm run dev
```

Open [http://localhost:3001](http://localhost:3001)

## Project Structure

```
ai_test/
├── backend/
│   └── src/
│       ├── auth/          # JWT auth (register, login, logout)
│       ├── analysis/      # CV vs job analysis
│       ├── cv-review/     # General CV review
│       └── prisma/        # Database service
└── frontend/
    └── src/
        ├── app/
        │   ├── (auth)/    # Login, Register pages
        │   └── (main)/    # Dashboard, Analysis, CV Review pages
        ├── components/    # UI components
        ├── hooks/         # React Query hooks
        └── lib/           # API client, utilities
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/auth/register` | Register |
| POST | `/api/auth/login` | Login |
| POST | `/api/auth/logout` | Logout |
| GET | `/api/auth/me` | Current user |
| POST | `/api/analysis` | Create analysis |
| GET | `/api/analysis` | List analyses |
| GET | `/api/analysis/:id` | Get analysis |
| POST | `/api/analysis/:id/improve-cv` | Generate improved CV |
| DELETE | `/api/analysis/:id` | Delete analysis |
| POST | `/api/cv-review` | Create CV review |
| GET | `/api/cv-review` | List reviews |
| GET | `/api/cv-review/:id` | Get review |
| POST | `/api/cv-review/:id/improve-cv` | Generate improved CV |
| DELETE | `/api/cv-review/:id` | Delete review |
