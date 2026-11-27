# Project Audit: IPL AI Auction Game (Stage 1)

Date: 27 November 2026
Scope: read-only audit. No application code, dependencies, or configuration were created or changed.

## 1. Repository findings

The workspace is a new project. It contains no repository to audit.

| Item | Finding |
|---|---|
| Workspace contents | One file: `IPL_AI_Auction_Game_Kiro_Prompt_Playbook_UPDATED.pdf` (18 pages) |
| Git | Not a Git repository. No branch, remote, or history |
| README, package/dependency files, env examples | None |
| Application code, tests, build scripts, deployment config | None |
| Frontend / backend / database / hosting | None exist. All are open decisions |
| Reusable modules | None |

Baseline test, lint, type-check and build results: **not applicable**. There is nothing to run, so no results are claimed.

### Local toolchain (checked with version commands only)

| Tool | Result |
|---|---|
| Node.js | v26.13.1 |
| npm | 11.20.0 |
| Python | 3.14.5 |
| Git | 2.54.0 (Windows) |
| PostgreSQL client (`psql`) | Not found |
| Docker | Not found |

Implications:
- Node 26 and Python 3.14 are very recent. Before Stage 2 locks versions, confirm that the chosen frameworks and libraries (for example Next.js, FastAPI, Pydantic, SQLAlchemy, psycopg) support them. Prefer an LTS Node release if a library does not.
- PostgreSQL and Docker are not needed. The approved architecture is a static, browser-only site (see section 5).

## 2. Requirements summary (from the playbook)

- One human-controlled franchise plus nine independent AI franchises (CSK, MI, RCB, KKR, DC, RR, SRH, PBKS, GT, minus whichever the human picks).
- Modes: Mega Auction and 2026 Mock Auction, with configurable rules.
- Authoritative auction rules engine with money-safe arithmetic. In the static architecture it runs in the browser as a UI-independent module.
- AI decisions that are explainable, seeded and reproducible, and use no paid LLM API for core logic. They draw on valuation, squad gaps, venue, pitch, weather and dew.
- Venue, pitch and weather intelligence that separates historical, forecast and observed data, with provenance and no fabricated values.
- Season-specific player registration, eligibility and capped/uncapped classification (addendum). Nothing is inferred and unverified records are flagged.
- Mobile-first, cross-platform (Android, iOS/Safari, laptops), with reconnect and state recovery.
- Save and resume, including from another device. In the static architecture this is done with save-file export/import, not accounts.
- A 14-stage plan with an approval gate after each stage.

## 3. Reference website audit

Reference: https://playauctiongame.com/

Method and limits:
- The site redirects to `https://www.playauctiongame.com/`. The page returned no readable content to a plain HTTP fetch, which suggests the interface is rendered by JavaScript in the browser.
- No browser session was run, so none of its screens or interactions were observed first-hand.
- The points below come from public search-result descriptions and third-party listings. They are secondhand and unverified.

Publicly described features:
- Real-time IPL auction simulator that can be played with friends.
- No sign-up. A user creates a room, picks a team, and bids.
- A pool of 200+ players (listing text refers to the 2026 season).

Gap to resolve: the reference appears to be a multiplayer, room-based game. Our product is one human against nine AI franchises. Treat the reference as inspiration for the bidding feel (timer, bid controls, team selection). Do not copy its assets, branding or code. A first-hand walkthrough in a real browser is recommended before Stage 10 (UI design). It was not done here.

Other IPL auction simulators exist online. They were not reviewed. Their design and data are not a basis for this project.

## 4. Hosting decision

Decision (approved by user, 27 November 2026): host as a static site on GitHub Pages, the same way as https://shresht-72.github.io/SupeRR/. The game runs entirely in the browser. There is no backend, database, WebSocket server or user accounts.

Why this works: the game is one human against nine AI franchises, so no second player needs protection from a tampered client.

Playbook items that change because of this decision (to be written into the Stage 2 specs):

| Playbook item | Static-site replacement |
|---|---|
| Server validates every bid (rule 5) | A single rules-engine module validates every bid, for the human and the AIs alike. It has no UI or AI dependencies. Nothing else may change budgets or auction state |
| Stage 11 WebSockets, reconnect snapshots, multi-client tests | In-page event bus. Tab backgrounding and refresh recovery are handled by saved state and a deadline-based timer |
| Stage 12 PostgreSQL, migrations, transactions, auth | IndexedDB/localStorage with a versioned save schema, atomic save writes, and save-file export/import for cross-device resume |
| Stage 13 server security review | Review of client-side concerns: input handling, dependency audit, no secrets in the repo, import file validation |
| Stage 14 Vercel/Render/paid hosting | GitHub Actions build, deploy to GitHub Pages, live URL check |
| Data tables in a database | Versioned JSON/CSV files in the repo with source, date and confidence fields, validated at build time and on import |

Limits to state honestly in the product: a player can inspect or edit the client code and saved data, so there is no tamper protection (acceptable for single-player). Cross-device continuity is manual (export/import). Live weather needs a browser-callable provider and CORS support, or pre-fetched files. Browser storage can be cleared, so the UI should prompt users to export saves.

## 5. Gaps, risks and technical debt

| # | Risk | Severity | Mitigation |
|---|---|---|---|
| R1 | No verified player data source. The playbook forbids invented stats, prices and availability | High | Choose sources and check licensing in Stage 2. Build import with provenance (Stage 4). Label any development data as sample |
| R2 | No official registration list or capped/uncapped rules for the target season yet | High | Season-specific registration and classification data. Unverified records go to manual review. Auction cannot start with unresolved records |
| R3 | Venue and weather data sources are unchosen. Licensing, cost, update frequency and browser CORS access are unknown | High | Start with curated, sourced venue history in JSON. Add forecast or observed data later behind an interface, as pre-fetched files if no CORS-friendly API exists |
| R4 | Timer and click races. Browsers throttle timers in background tabs, and users can double-click | Medium | Deadline-based clock (compare timestamps, not tick counts), injectable test clock, idempotent bid handling in the engine |
| R5 | No accounts, so cross-device resume is manual | Medium | Save-file export/import. Do not claim automatic cross-device sync |
| R6 | Real iOS and Android testing needs devices. Desktop emulation is not enough per the addendum | Medium | Plan device access and a Safari test path in Stage 2 |
| R7 | Very new Node and Python versions (Node 26, Python 3.14) may break tooling | Medium | Use an LTS Node in CI and check compatibility before pinning versions. Python is optional (data scripts only) |
| R8 | AI quality is hard to judge. Agents may be identical, overspend or stall | Medium | Seeded simulation harness (Stage 9) run with Vitest or a Node script, with explicit failure detectors |
| R9 | Browser storage limits and clearing can lose saved auctions | Medium | Versioned save schema, export prompts, corrupted-save handling |
| R10 | GitHub Pages limits: static only, project path prefix, and the repository visibility needed for free Pages | Low | Set the Vite base path. Verify current GitHub Pages plan limits before creating the repo |
| R11 | Large computation (squad evaluation, 100-auction simulations) on the main thread can freeze mobile UIs | Low | Keep the engine pure, run heavy work in a Web Worker if profiling shows a need |

Destructive changes to avoid: none exist yet. Keep to the playbook rules: no force-push, no main-branch overwrite, no push or deploy without approval.

## 6. Proposed architecture direction (for Stage 2 to confirm)

No existing stack to keep, so these are proposals:

| Layer | Proposal | Notes |
|---|---|---|
| App | Vite, React, TypeScript, Tailwind, static build output | Mobile-first, touch controls. Vite is simpler than Next.js for a pure static Pages site |
| Core modules | Plain TypeScript packages inside the repo: rules engine, valuation, squad evaluator, AI agents, conditions, player/registration data | No React imports in core modules. Money uses integer minor units or a decimal library, never floats |
| AI randomness | Seeded PRNG | Reproducible decisions and simulations |
| Data | Versioned JSON/CSV with schema validation (for example Zod) | Provenance on every record |
| Persistence | IndexedDB (localStorage fallback), save-file export/import | Versioned schema |
| Tests | Vitest for core logic and simulations, Playwright for responsive and browser flows | Real-device checks are separate |
| CI/CD | GitHub Actions: install, lint, type-check, test, build, deploy to Pages | Pages base path set in config |
| Shape | Modular monolith in one repository | |

Open decisions for Stage 2:
1. Repository name and visibility (this sets the Pages URL and base path).
2. Money representation: integer lakhs/paise versus a decimal library.
3. Data sources and licensing for players, registration, venues and weather.
4. Target season and auction pool.
5. Test device plan for iOS and Android.
6. Dependency and tool versions, after the compatibility check in R7.

## 7. Assumptions

- This is a new project and the folder `Untitled` is its root.
- The target season is the 2026 or later IPL auction. The exact season, pool size and rules will be fixed in Stage 2 from official sources.
- Playbook rules (stage gates, no fabricated data, no unrun tests claimed) apply to all work, adapted for the static architecture where section 4 says so.

## 8. Recommended implementation sequence

Follow the playbook order, one stage per approval:

1. Stage 2: requirements, design and tasks, including the section 4 changes and the addendum (cross-platform, registration, capped/uncapped).
2. Initialize the repository (Git, README, `.gitignore`, steering file, Pages workflow skeleton) with your approval.
3. Stages 3 to 4: conditions and player data, with provenance and registration.
4. Stage 5: rules engine, then Stages 6 to 8: valuation, squad optimization, AI agents.
5. Stage 9: simulation harness, before any UI.
6. Stages 10 to 12: frontend, in-page real-time flow, persistence and save/resume.
7. Stages 13 to 14: QA and security, then GitHub Pages deployment and live URL check.
8. Bonus: squad strategy simulator.

## 9. Status

Stage 1 approved on 27 November 2026. Stage 2 specifications are in `.kiro/specs/ipl-ai-auction-game/` and were approved with the decisions recorded in `requirements.md` (ten franchises, IPL 2027 Mini Auction plus configurable Mega Auction, repository URL, testing approach, pause reliability). Nothing has been installed, committed or pushed.
