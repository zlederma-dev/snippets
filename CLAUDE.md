# Snippets — Claude Code Guide

## Stack

- Vite + React 18 (functional components + hooks only)
- No external libraries — keep it that way

## Structure

Components are split across specific files. Do not consolidate or reorganize them:

- `App.jsx` — all state, top-level layout
- `components/Header.jsx` — title, Paste, Load buttons
- `components/Sidebar.jsx` — filter nav
- `components/SnippetList.jsx` — renders the filtered list
- `components/SnippetCard.jsx` — individual snippet display + actions

## State

All state lives in `App.jsx` and is passed down via props. Do not introduce context, reducers, or external state.

## Styling

Single `styles.css` file. No CSS modules, no inline styles, no utility frameworks. The color scheme is intentional — dark navy background with purple (`#7c3aed`) and cyan (`#22d3ee`) accents. Don't drift the palette.

## Intentional design decisions

- **No persistence** — snippets are in-memory only. Do not add localStorage or any other persistence.
- **Load button delay** — the 800ms delay between clipboard writes is deliberate. It gives clipboard managers like Flycut time to capture each entry. Do not remove or "optimize" it.
- **Recent filter** — shows the top 5 snippets. Simple slice, nothing fancier needed.
