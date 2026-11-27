# Project standards: IPL AI Auction Game

Adapted from the Kiro playbook steering prompt for a static, browser-only build on GitHub Pages.

## Scope
- Static site only. No backend, database, WebSocket server or accounts.
- One human franchise against nine AI franchises (CSK, MI, RCB, KKR, DC, RR, SRH, PBKS, GT, LSG).

## Rules
1. Inspect the repo, Git status and tests before changing anything.
2. The auction engine is the only code that changes budgets, bids, timers, lot status and ownership. UI and AI code send commands to it.
3. Money is whole rupees (integers). Never use floating-point for money. Display in lakh and crore.
4. Never invent player statistics, registration, eligibility, classification, base prices or venue or weather data. Unknown stays unknown.
5. Mark sample data isSample: true and label it in the UI. Official data needs a source, date and verification status.
6. Core logic has no React or DOM imports.
7. Rules that can change between seasons are configuration data, not code.
8. AI decisions are seeded and reproducible, and explain their reasons. No paid LLM API for core logic.
9. Run and report real tests, lint, type-check and build results. Never claim a check passed unless it ran.
10. Do not commit the playbook PDF, secrets, .env files or 
ode_modules.
11. Do not force-push, modify branches, change remote configuration, change repository visibility or publish without explicit approval.
12. Ask before destructive operations, installs, or anything outside the approved plan.
13. Physical-device results are recorded only for devices the owner actually tests.
