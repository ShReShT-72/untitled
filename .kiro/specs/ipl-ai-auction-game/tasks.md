# Implementation Plan

## Overview

Task numbers match the playbook stage numbers. Work one stage at a time and wait for approval before the next. Each stage ends with a review against its acceptance criteria, using only checks that were actually run.

## Tasks

- [x] 1. Stage 1: Repository and reference audit
  - [x] 1.1 Audit the workspace, toolchain and reference site, and write project-audit.md
    - Result: new project, static GitHub Pages architecture approved
    - _Requirements: 19.1_

- [ ] 2. Stage 2: Requirements and architecture
  - [x] 2.1 Write requirements.md
    - _Requirements: 1 to 21_
  - [x] 2.2 Write design.md
    - _Requirements: 1 to 21_
  - [x] 2.3 Write tasks.md
    - _Requirements: 1 to 21_
  - [x] 2.4 Review the data model and main user flow with the user, record the decisions, and get approval
    - Decisions recorded on 27 November 2026 in requirements.md: ten franchises including LSG, IPL 2027 Mini Auction plus configurable Mega Auction, repository URL, testing approach, pause reliability
    - _Requirements: 2.4, 19.2_
  - [ ] 2.5 Bootstrap the repository, only after the user approves a shown plan
    - Initialize Git, add .gitignore, README skeleton, project steering file adapted to the static architecture, Vite/React/TypeScript/Tailwind scaffold, Vitest and Playwright config, and a CI workflow that builds with the Pages base path
    - Target repository: https://github.com/ShReShT-72/untitled (not reachable by public fetch, so visibility and existence are unknown). Show the exact commands and wait for approval before git init, adding a remote, installing dependencies, creating a repository, changing visibility or pushing
    - _Requirements: 19.1, 19.2, 19.3, 19.4, 19.7_

- [ ] 3. Stage 3: Venue, pitch and conditions intelligence
  - [ ] 3.1 Define schemas for Venue, PitchProfile, ConditionsRecord, Scenario and TournamentConfig with provenance
    - Zod schemas and TypeScript types
    - Unit tests for valid and invalid records
    - _Requirements: 10.1, 10.2, 10.7_
  - [ ] 3.2 Build validation for missing, contradictory, stale and low-confidence data
    - Unknown stays unknown, forecasts need issue and valid times
    - Unit tests for freshness and long-range forecast handling
    - _Requirements: 10.2, 10.3, 10.4, 10.5_
  - [ ] 3.3 Build the JSON/CSV import with preview and error reporting
    - Errors reported by file and field, repeatable imports
    - _Requirements: 10.7, 17.1, 17.2_
  - [ ] 3.4 Add source-verified venue data for the configured season, or mark fields unknown
    - Do not fabricate values. Record each source and date
    - _Requirements: 10.1, 10.5, 10.6_
  - [ ] 3.5 Implement scenario retrieval and coverage reporting
    - Service returns a venue and conditions profile per scenario with coverage
    - Unit tests for scenario retrieval and provenance
    - _Requirements: 10.8, 11.6_
  - [ ] 3.6 Build a mobile-readable conditions panel component
    - Does not crowd out bid controls on small screens
    - _Requirements: 14.7_

- [ ] 4. Stage 4: Player database and statistics
  - [ ] 4.1 Define schemas for PlayerMaster, SeasonRegistration, Classification, ClassificationReview and PlayerStats
    - _Requirements: 3.1, 3.2, 4.1, 17.3_
  - [ ] 4.2 Build the validated player import with preview, deduplication and repeatable results
    - Tests for duplicates, invalid values and repeat imports
    - _Requirements: 17.1, 17.2_
  - [ ] 4.3 Implement missing-statistic handling and stats aggregation
    - Missing data is never zero
    - _Requirements: 9.4, 17.4_
  - [ ] 4.4 Implement search and filters
    - Role, style, nationality, base price, tags, registration status and classification
    - _Requirements: 17.5_
  - [ ] 4.5 Implement the registration and eligibility pipeline
    - Test: a newly registered player absent from the previous auction is included
    - Test: an unregistered or ineligible player is excluded
    - Test: missing or conflicting data is flagged Unresolved
    - _Requirements: 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9_
  - [ ] 4.6 Implement classification with history, rule versions and review overrides
    - Tests for season changes, refresh, unresolved status and preserved history
    - _Requirements: 4.1, 4.2, 4.5, 4.6, 4.7, 4.8_
  - [ ] 4.7 Implement auction set building and automatic reordering
    - Set order comes from rules configuration
    - Tests for reassignment and reordering
    - _Requirements: 4.3, 4.4_
  - [ ] 4.8 Import the owner's sample pool and label it as sample data
    - Source file data/mock-auction-list.csv (520 players, 47 sets, built from Mock_list.txt by tools/format-mock-list.ps1). Keep set order and prices as supplied
    - Add a test that each set's row count matches set_printed_count (Set 3 is 15 after the Rahane removal) and that no player appears twice
    - Record provenance and licensing. Never present sample data as real
    - _Requirements: 15.5, 17.7, 17.8_
  - [ ] 4.9 Import the official IPL 2027 Auction Register (1,220 players) as registration records
    - Check the totals against the BCCI advisory: 939 Indian, 281 overseas, 17 countries, six official categories
    - Do not mark any player registered without the official list. Check the licence and terms for bundling the data first
    - _Requirements: 3.2, 3.3, 3.5, 4.9, 23.1_
  - [ ] 4.10 Import the final Auction List and player sets when published (scheduled 4 December 2026)
    - Compare with the register, flag differences, rebuild sets. Until published, no official launch
    - _Requirements: 3.10, 3.11, 5.5, 5.6, 23.6_
  - [ ] 4.11 Import franchise opening states (retained and traded squads, purses, overseas counts)
    - Verify totals: 184 players, 55 overseas, 66 slots, 25 overseas slots, and 130 crore spent plus available per franchise
    - _Requirements: 22.1, 22.4, 22.5_
- [ ] 5. Stage 5: Auction rules engine
  - [ ] 5.1 Implement money helpers and display formatting in lakh and crore
    - Property tests for integer arithmetic
    - _Requirements: 7.1, 7.2, 7.4_
  - [ ] 5.2 Define the rules configuration schema, the IPL 2027 Mini Auction preset and the Mega Auction template
    - Values come from official rules for the season. Mark any unverified value
    - _Requirements: 1.1, 1.2, 1.4_
  - [ ] 5.3 Implement the state machine with an injectable clock
    - _Requirements: 6.7, 8.1, 8.7_
  - [ ] 5.4 Implement bid validation with rejection reasons
    - Eligibility, purse, increment, lot status, squad limits, overseas limit, role constraints
    - _Requirements: 6.2, 6.3, 6.9_
  - [ ] 5.5 Implement idempotent and stale-safe command handling
    - One winner per lot, duplicate request IDs, stale versions
    - _Requirements: 6.4, 6.5, 6.6_
  - [ ] 5.6 Implement timer deadlines, extension or reset rules, pause and resume
    - Tests with the test clock for expiry and pause
    - _Requirements: 8.2, 8.3, 8.5, 8.6_
  - [ ] 5.7 Load lots from the validated pool and reject unresolved or ineligible players at launch
    - _Requirements: 5.1, 5.2, 5.4_
  - [ ] 5.8 Add purse-conservation checks at every transition and property tests
    - _Requirements: 7.3_
  - [ ] 5.9 Complete integration tests and document rules and state transitions
    - Valid and invalid bids, purse limits, ownership, squad limits, timer expiry, completion
    - _Requirements: 6.1, 6.8, 20.1_
  - [ ] 5.10 Support per-franchise opening states, and empty-squad starts for the Mega Auction
    - Exclude opening-squad players from lots. Tests for the opening-state integrity property
    - _Requirements: 22.2, 22.3, 22.4, 22.6_
  - [ ] 5.11 Support configurable Right to Match, overseas payment cap with full purse deduction, and rule value verification status
    - Unverified values are listed for review and the mode is not marked verified until confirmed
    - _Requirements: 23.2, 23.3, 23.5_
- [ ] 6. Stage 6: Player valuation and willingness to pay
  - [ ] 6.1 Implement the fair-value service with factor breakdown and confidence
    - _Requirements: 9.1, 9.4, 9.8_
  - [ ] 6.2 Implement role scarcity from the active pool
    - _Requirements: 9.3_
  - [ ] 6.3 Implement willingness to pay and maximum bid per franchise
    - Separate from fair value
    - _Requirements: 9.2, 9.3_
  - [ ] 6.4 Add versioned weights configuration and stored valuation inputs
    - _Requirements: 9.5_
  - [ ] 6.5 Add plain-language explanations
    - _Requirements: 9.6_
  - [ ] 6.6 Add tests for missing data, small samples, scarcity, budget limits and consistency
    - No paid API or LLM
    - _Requirements: 9.4, 9.7, 20.1_

- [ ] 7. Stage 7: Squad composition and conditions optimization
  - [ ] 7.1 Implement role coverage, depth and bowling-phase coverage reports
    - _Requirements: 11.1_
  - [ ] 7.2 Implement pace and spin balance, handedness and overseas composition reports
    - _Requirements: 11.1_
  - [ ] 7.3 Implement scenario scoring with explicit uncertainty
    - _Requirements: 11.2, 11.6_
  - [ ] 7.4 Implement venue and scenario weighting with a dominance limit
    - _Requirements: 11.5_
  - [ ] 7.5 Implement the adaptability score and weakness list
    - _Requirements: 11.3_
  - [ ] 7.6 Implement marginal player value
    - _Requirements: 11.4_
  - [ ] 7.7 Implement readable per-scenario squad reports
    - Not a match-win predictor
    - _Requirements: 11.3, 11.7_
  - [ ] 7.8 Add tests for squad types, venue distributions, scenario weights, missing data and rule constraints
    - _Requirements: 20.1_

- [ ] 8. Stage 8: Nine independent AI franchise agents
  - [ ] 8.1 Define AgentProfile schema and configurable profiles for all ten franchises
    - The human franchise gets no agent
    - _Requirements: 2.2, 2.3, 12.1, 12.8_
  - [ ] 8.2 Implement agent state: purse view, squad gaps, shortlist and decision history
    - _Requirements: 12.1_
  - [ ] 8.3 Implement the decision pipeline: BID, PASS, WITHDRAW, WAIT
    - _Requirements: 12.2, 12.3_
  - [ ] 8.4 Integrate eligible-pool, classification and category inputs
    - _Requirements: 12.2, 12.5_
  - [ ] 8.5 Submit all bids through the engine and handle rejections
    - _Requirements: 12.4_
  - [ ] 8.6 Add decision reasons and the seeded random stream per agent
    - _Requirements: 12.6, 12.7_
  - [ ] 8.7 Add reaction timing and avoid frustrating delays
    - _Requirements: 12.9_
  - [ ] 8.8 Tune the nine strategies for measurable differences without early full-purse spending
    - _Requirements: 12.8, 12.9_
  - [ ] 8.9 Add tests: agents differ, respect budgets and rules, and react to pitch, weather and squad scenarios
    - _Requirements: 12.8, 20.1_

- [ ] 9. Stage 9: Auction simulation and validation
  - [ ] 9.1 Build the simulation harness with a simulated human strategy and nine agents
    - _Requirements: 13.1_
  - [ ] 9.2 Add configurable pools, rules, venue distributions and scenarios
    - Include scarce wicketkeepers, limited death bowlers, many batters and all-rounder scarcity
    - _Requirements: 13.2_
  - [ ] 9.3 Add newly registered players, players missing from history, classification changes and set reordering cases
    - _Requirements: 13.2_
  - [ ] 9.4 Record every event and validate each completed squad
    - _Requirements: 13.3, 13.4_
  - [ ] 9.5 Add detectors for overspending, ignored gaps, identical behaviour, irrational bidding and incomplete squads
    - _Requirements: 13.5_
  - [ ] 9.6 Produce the report with seeds and configuration and a documented command
    - _Requirements: 13.6_
  - [ ] 9.7 Run at least 100 seeded auctions, fix critical and high defects, and add regression tests
    - Report only the actual counts
    - _Requirements: 13.1, 13.7_

- [ ] 10. Stage 10: Responsive frontend and auction experience
  - [ ] 10.1 Build the design system: dark high-contrast theme, tokens, reusable components
    - Original design, no copied assets
    - _Requirements: 14.1, 15.2_
  - [ ] 10.2 Build the Home screen with New Auction and Resume
    - _Requirements: 16.7_
  - [ ] 10.3 Build the auction setup screen
    - _Requirements: 1.1, 1.3_
  - [ ] 10.4 Build the franchise selection screen
    - _Requirements: 2.1, 2.2_
  - [ ] 10.5 Build the pool review and validation screen
    - Shows unresolved records with season and rule context
    - _Requirements: 5.3, 17.6_
  - [ ] 10.6 Build the auction dashboard with a mobile layout of fixed header, fixed bottom bid bar and tabs
    - _Requirements: 6.9, 14.3, 14.4, 14.5_
  - [ ] 10.7 Build sold, unsold, paused, error and loading states
    - _Requirements: 15.2, 15.4_
  - [ ] 10.8 Build the player details and statistics view
    - _Requirements: 17.3_
  - [ ] 10.9 Build the results and squad summary screen
    - _Requirements: 18.1, 18.2, 18.3, 18.4_
  - [ ] 10.10 Build the saved auctions screen with resume, export, import and delete
    - _Requirements: 16.2, 16.3_
  - [ ] 10.11 Add accessibility: keyboard flow, labels, contrast, focus states, reduced motion
    - _Requirements: 14.8, 15.1, 15.2, 15.3_
  - [ ] 10.12 Add Playwright responsive tests on Chromium, Firefox and WebKit at phone, tablet and laptop viewports, plus component tests
    - Emulation only. Do not describe it as physical-device testing
    - _Requirements: 14.10, 20.1_

- [ ] 11. Stage 11: In-page real-time auction integration
  - [ ] 11.1 Connect the UI to the engine through an event subscription
    - UI never reimplements rules
    - _Requirements: 6.1, 6.8_
  - [ ] 11.2 Run agents on the latest engine state with seeded timing
    - _Requirements: 12.4, 12.7_
  - [ ] 11.3 Handle double-taps, stale UI state and rapid sequential bids
    - _Requirements: 6.4, 6.5, 6.6_
  - [ ] 11.4 Implement pause on hide, lock and freeze, monotonic timing, suspension-gap detection and wake lock where supported
    - _Requirements: 8.4, 8.8, 8.9, 8.10, 8.11, 14.8_
  - [ ] 11.5 Add integration tests for competing bids, AI bids, timer expiry, pause and tab visibility
    - _Requirements: 20.1_
  - [ ] 11.6 Document the event and command formats
    - _Requirements: 20.5_
  - [ ] 11.7 Add tests that simulate throttled timers, long gaps between ticks, hidden tabs, screen lock and page freeze
    - Assert no sale, pass or bid is accepted for a missed interval and the saved state is correct
    - _Requirements: 8.8, 8.9, 8.10, 8.12, 20.1_
- [ ] 12. Stage 12: Persistence, save and resume
  - [ ] 12.1 Implement the IndexedDB store with atomic writes and the session index
    - _Requirements: 16.1, 16.2_
  - [ ] 12.2 Implement versioned save schema and migrations
    - _Requirements: 16.5, 16.8, 16.9_
  - [ ] 12.3 Implement save, pause, resume, abandon and completed flows
    - _Requirements: 16.3, 16.7, 8.5_
  - [ ] 12.4 Implement export and import with validation, pause-on-export, export lineage and copy-or-replace choice on import
    - _Requirements: 16.4, 16.11, 16.12, 16.13_
  - [ ] 12.5 Implement the tab lock
    - _Requirements: 16.6_
  - [ ] 12.6 Implement corrupt-save handling and storage warnings
    - Verify Safari and iOS storage behaviour and document the result
    - _Requirements: 16.8, 16.10_
  - [ ] 12.7 Add tests for save and resume round trip, duplicate requests, two tabs, corrupt saves and multiple saves
    - _Requirements: 16.1, 16.2, 16.6, 20.1_

- [ ] 13. Stage 13: QA, security and performance
  - [ ] 13.1 Run the functional QA checklist from the playbook and record results
    - _Requirements: 20.1, 20.2_
  - [ ] 13.2 Run the data QA checklist: provenance, labelling, stale data, missing stats
    - _Requirements: 10, 17_
  - [ ] 13.3 Run unit, integration, simulation, browser, type, lint and build checks
    - _Requirements: 20.1, 20.2_
  - [ ] 13.4 Run the client-side security review: import validation, text rendering, dependency audit, secrets scan
    - _Requirements: 19.4_
  - [ ] 13.5 Give the user a real-device checklist, and record only results for devices the user reports, with device model and browser version
    - Until then, reports say "emulated only"
    - _Requirements: 14.9_
  - [ ] 13.6 Run performance checks for simulation and squad evaluation on mobile
    - Move work to a Web Worker only if profiling shows a need
    - _Requirements: 14.1_
  - [ ] 13.7 Write the QA report, fix critical and high issues, and list the rest
    - _Requirements: 20.2, 20.5_

- [ ] 14. Stage 14: GitHub workflow and Pages deployment
  - [ ] 14.1 Inspect Git state and create a dedicated release branch
    - No force-push and no main overwrite
    - _Requirements: 19.5_
  - [ ] 14.2 Review all changed files and confirm no secrets or debug artifacts
    - _Requirements: 19.4_
  - [ ] 14.3 Finish the README
    - Setup, tests, data import, deployment
    - _Requirements: 19.7_
  - [ ] 14.4 Finish the GitHub Actions workflow and Pages settings
    - _Requirements: 19.2, 19.3_
  - [ ] 14.5 Ask the user before pushing, then push and deploy
    - _Requirements: 19.5_
  - [ ] 14.6 Verify the live URL in a browser: home, new auction, franchise selection, bid, AI bid, pause and resume, reload save, export and import
    - Report the URL only after verification
    - _Requirements: 19.6, 14.9_

- [ ] 15. Bonus: Tournament Conditions and Squad Strategy Simulator
  - [ ] 15.1 Build the module that reuses existing valuation, rules and conditions services
    - _Requirements: 21.7_
  - [ ] 15.2 Show per-venue and per-scenario suitability for a completed squad
    - _Requirements: 21.1_
  - [ ] 15.3 Recommend a legal XI, batting order, bowling phases and Impact Player option
    - _Requirements: 21.2_
  - [ ] 15.4 Explain player gains and losses per scenario, with data confidence warnings
    - _Requirements: 21.3, 21.4_
  - [ ] 15.5 Add squad comparison and saved scenario reports
    - _Requirements: 21.5_
  - [ ] 15.6 Add tests for lineup legality, overseas limits, role coverage, scenario changes and missing data
    - Scores are suitability, not win probability
    - _Requirements: 21.6, 20.1_

## Task Dependency Graph

The stages run strictly in order, and tasks inside a stage run in order, so each wave holds one task. Tasks 4.10 and 4.11 depend on official publications and may need to wait.

```json
{
  "waves": [
    {"id": 0, "tasks": ["2.5"]},
    {"id": 1, "tasks": ["3.1"]},
    {"id": 2, "tasks": ["3.2"]},
    {"id": 3, "tasks": ["3.3"]},
    {"id": 4, "tasks": ["3.4"]},
    {"id": 5, "tasks": ["3.5"]},
    {"id": 6, "tasks": ["3.6"]},
    {"id": 7, "tasks": ["4.1"]},
    {"id": 8, "tasks": ["4.2"]},
    {"id": 9, "tasks": ["4.3"]},
    {"id": 10, "tasks": ["4.4"]},
    {"id": 11, "tasks": ["4.5"]},
    {"id": 12, "tasks": ["4.6"]},
    {"id": 13, "tasks": ["4.7"]},
    {"id": 14, "tasks": ["4.8"]},
    {"id": 15, "tasks": ["4.9"]},
    {"id": 16, "tasks": ["4.10"]},
    {"id": 17, "tasks": ["4.11"]},
    {"id": 18, "tasks": ["5.1"]},
    {"id": 19, "tasks": ["5.2"]},
    {"id": 20, "tasks": ["5.3"]},
    {"id": 21, "tasks": ["5.4"]},
    {"id": 22, "tasks": ["5.5"]},
    {"id": 23, "tasks": ["5.6"]},
    {"id": 24, "tasks": ["5.7"]},
    {"id": 25, "tasks": ["5.8"]},
    {"id": 26, "tasks": ["5.9"]},
    {"id": 27, "tasks": ["5.10"]},
    {"id": 28, "tasks": ["5.11"]},
    {"id": 29, "tasks": ["6.1"]},
    {"id": 30, "tasks": ["6.2"]},
    {"id": 31, "tasks": ["6.3"]},
    {"id": 32, "tasks": ["6.4"]},
    {"id": 33, "tasks": ["6.5"]},
    {"id": 34, "tasks": ["6.6"]},
    {"id": 35, "tasks": ["7.1"]},
    {"id": 36, "tasks": ["7.2"]},
    {"id": 37, "tasks": ["7.3"]},
    {"id": 38, "tasks": ["7.4"]},
    {"id": 39, "tasks": ["7.5"]},
    {"id": 40, "tasks": ["7.6"]},
    {"id": 41, "tasks": ["7.7"]},
    {"id": 42, "tasks": ["7.8"]},
    {"id": 43, "tasks": ["8.1"]},
    {"id": 44, "tasks": ["8.2"]},
    {"id": 45, "tasks": ["8.3"]},
    {"id": 46, "tasks": ["8.4"]},
    {"id": 47, "tasks": ["8.5"]},
    {"id": 48, "tasks": ["8.6"]},
    {"id": 49, "tasks": ["8.7"]},
    {"id": 50, "tasks": ["8.8"]},
    {"id": 51, "tasks": ["8.9"]},
    {"id": 52, "tasks": ["9.1"]},
    {"id": 53, "tasks": ["9.2"]},
    {"id": 54, "tasks": ["9.3"]},
    {"id": 55, "tasks": ["9.4"]},
    {"id": 56, "tasks": ["9.5"]},
    {"id": 57, "tasks": ["9.6"]},
    {"id": 58, "tasks": ["9.7"]},
    {"id": 59, "tasks": ["10.1"]},
    {"id": 60, "tasks": ["10.2"]},
    {"id": 61, "tasks": ["10.3"]},
    {"id": 62, "tasks": ["10.4"]},
    {"id": 63, "tasks": ["10.5"]},
    {"id": 64, "tasks": ["10.6"]},
    {"id": 65, "tasks": ["10.7"]},
    {"id": 66, "tasks": ["10.8"]},
    {"id": 67, "tasks": ["10.9"]},
    {"id": 68, "tasks": ["10.10"]},
    {"id": 69, "tasks": ["10.11"]},
    {"id": 70, "tasks": ["10.12"]},
    {"id": 71, "tasks": ["11.1"]},
    {"id": 72, "tasks": ["11.2"]},
    {"id": 73, "tasks": ["11.3"]},
    {"id": 74, "tasks": ["11.4"]},
    {"id": 75, "tasks": ["11.5"]},
    {"id": 76, "tasks": ["11.6"]},
    {"id": 77, "tasks": ["11.7"]},
    {"id": 78, "tasks": ["12.1"]},
    {"id": 79, "tasks": ["12.2"]},
    {"id": 80, "tasks": ["12.3"]},
    {"id": 81, "tasks": ["12.4"]},
    {"id": 82, "tasks": ["12.5"]},
    {"id": 83, "tasks": ["12.6"]},
    {"id": 84, "tasks": ["12.7"]},
    {"id": 85, "tasks": ["13.1"]},
    {"id": 86, "tasks": ["13.2"]},
    {"id": 87, "tasks": ["13.3"]},
    {"id": 88, "tasks": ["13.4"]},
    {"id": 89, "tasks": ["13.5"]},
    {"id": 90, "tasks": ["13.6"]},
    {"id": 91, "tasks": ["13.7"]},
    {"id": 92, "tasks": ["14.1"]},
    {"id": 93, "tasks": ["14.2"]},
    {"id": 94, "tasks": ["14.3"]},
    {"id": 95, "tasks": ["14.4"]},
    {"id": 96, "tasks": ["14.5"]},
    {"id": 97, "tasks": ["14.6"]},
    {"id": 98, "tasks": ["15.1"]},
    {"id": 99, "tasks": ["15.2"]},
    {"id": 100, "tasks": ["15.3"]},
    {"id": 101, "tasks": ["15.4"]},
    {"id": 102, "tasks": ["15.5"]},
    {"id": 103, "tasks": ["15.6"]}
  ]
}
```

## Notes

- Stage gate: after each stage, run the stage completion review and wait for explicit approval before the next stage.
- Before creating a repository, installing dependencies, changing GitHub visibility or any destructive step, show the plan and wait for approval (tasks 2.5 and 14.5 in particular).
- Tasks 3.4, 4.8, 4.9, 4.10 and 4.11 must not invent data. Where verified data is unavailable, fields stay unknown or unresolved.
- Rule values marked unverified in requirements.md must be confirmed against official regulations before the IPL 2027 mode is marked verified.
- No physical-device result is recorded until the user reports it.
