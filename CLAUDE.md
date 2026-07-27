# Snippets — Claude Code Guide

## Repo structure

```
frontend/    — Vite + React 18 SPA
backend/     — API server (WIP)
terraform/   — AWS infrastructure
.github/     — CI/CD workflows
scripts/     — deploy helpers (ec2-bootstrap.sh, commit-msg hook)
```

## Frontend (`frontend/`)

### Stack

- Vite + React 18 (functional components + hooks only)
- No external libraries — keep it that way

### Structure

Components are split across specific files. Do not consolidate or reorganize them:

- `frontend/App.jsx` — all state, top-level layout
- `frontend/components/Header.jsx` — title, Paste, Load buttons
- `frontend/components/Sidebar.jsx` — filter nav
- `frontend/components/SnippetList.jsx` — renders the filtered list
- `frontend/components/SnippetCard.jsx` — individual snippet display + actions

### State

All state lives in `App.jsx` and is passed down via props. Do not introduce context, reducers, or external state.

### Styling

Single `styles.css` file. No CSS modules, no inline styles, no utility frameworks. The color scheme is intentional — dark navy background with purple (`#7c3aed`) and cyan (`#22d3ee`) accents. Don't drift the palette.

### Intentional design decisions

- **No persistence** — snippets are in-memory only. Do not add localStorage or any other persistence.
- **Load button delay** — the 800ms delay between clipboard writes is deliberate. It gives clipboard managers like Flycut time to capture each entry. Do not remove or "optimize" it.
- **Recent filter** — shows the top 5 snippets. Simple slice, nothing fancier needed.

## Infrastructure

- Deployed to AWS EC2 via Docker (nginx serving the frontend build)
- Docker images pushed to ECR on merge to main
- CI runs Cypress E2E tests against the Docker container
- Self-hosted GitHub Actions runner on EC2
