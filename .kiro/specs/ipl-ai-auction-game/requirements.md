# Requirements Document

## Introduction

The IPL AI Auction Game is a browser game in which one human controls one IPL franchise and competes in a player auction against nine AI-controlled franchises. The AI franchises build squads for a tournament played across several venues and changing pitch and weather conditions.

The game is a static site hosted on GitHub Pages, like https://shresht-72.github.io/SupeRR/. All logic runs in the browser. There is no backend, database, WebSocket server or user account system. Saved auctions live in browser storage and can be exported and imported as files.

https://playauctiongame.com/ is a behavioural reference only. No code, assets or branding are copied. Its visible features could not be observed first-hand (see `project-audit.md`).

Source documents: the "IPL AI Auction Game, Kiro Prompt Playbook (UPDATED)" PDF and `project-audit.md`. Where the playbook assumes a server, this specification replaces it with the static equivalent approved on 27 November 2026.

## Confirmed Decisions (27 November 2026)

1. **Franchises:** ten IPL franchises (CSK, MI, RCB, KKR, DC, RR, SRH, PBKS, GT, LSG). Whichever one the human selects, the other nine are independent AI opponents.
2. **Primary baseline:** IPL 2027, following official IPL/BCCI announcements and regulations. IPL 2027 is a mini-auction, not a mega auction.
3. **Modes:** IPL 2027 Mini Auction (verified, season-specific data and rules) and a configurable Mega Auction mode for future seasons and custom simulations. The playbook's "2026 Mock Auction" mode is replaced by the IPL 2027 Mini Auction.
4. **Pool:** the 1,220-player Auction Register is a registration list, not the final pool. The official final Auction List and player sets are imported when published.
5. **Fields:** registration, auction eligibility and capped/uncapped classification are separate season-specific fields. Auction sets are rearranged automatically from verified classification and the applicable rules.
6. **Money:** whole Indian rupees internally, shown in lakh and crore.
7. **No hard-coded rules:** every rule that can change between seasons is configuration data.
8. **Repository:** https://github.com/ShReShT-72/untitled (not reachable by public fetch on 27 November 2026, so it may be private or not yet created).
9. **Testing:** Playwright and responsive browser testing on Android, iOS/iPadOS (including Safari), Windows and macOS targets. Physical-device testing is claimed only after it is performed. The user will supply physical device models for final manual testing.
10. **Pause reliability:** pause and resume must hold when switching tabs, locking the screen, or changing devices, and background timer throttling must never cause incorrect bids or lost state.
11. **Sample pool and set order:** the project owner supplied a mock auction list (`Mock_list.txt`, converted to `data/mock-auction-list.csv` by `tools/format-mock-list.ps1`). It has 520 players in 47 sets, with set order and base prices taken exactly as supplied. M.S. Dhoni and Ajinkya Rahane were removed at the owner's request. Capped/uncapped debut checks were not applied ("set order and price as it is"). It is sample data, not official, and every row has `isSample = true`. The reference site could not be read, so set order comes from this list and not from the reference site.
12. **Approval gate:** before creating a repository, installing dependencies, changing GitHub visibility or doing anything destructive, the assistant shows the plan and waits for approval.

## Verified Reference Facts (IPL 2027)

Source A is the official BCCI media advisory "1,220 players feature on Auction Register for TATA IPL 2027 Player Auction", dated 25 November 2026, at https://www.iplt20.com/news/article/1-220-players-feature-on-auction-register-for-tata-ipl-2027-player-auction (read 27 November 2026). Source B is the IPL-branded explainer at https://www.ipl.com/cricket/news/ipl-2027-auction-rules-purse-limit-squad-size-amp-player-regulations/ (read 27 November 2026), treated as secondary until checked against official regulations.

| Fact | Value | Source | Status |
|---|---|---|---|
| Register size | 1,220 players: 939 Indian, 281 overseas from 17 countries | A | Verified |
| Register categories | Capped Indian 14; capped international 170; Associate Nations 42; uncapped Indian who played in earlier IPL seasons 127; uncapped Indian 798; uncapped international 69 | A | Verified |
| Already retained or picked | 184 players | A | Verified |
| Slots available | At most 66, including 25 overseas | A | Verified |
| Final list | The final Auction List and player sets are to be released on Friday 4 December 2026 | A | Verified |
| Franchise opening state | See table below | A | Verified |
| Late additions | Franchises could request missing players until 27 November (reported by cricketnews.com) | Secondary | Unverified, so the register may change |
| Auction date and venue | 16 December 2026, ITC Grand Goa, 11:00 AM IST | B | Unverified |
| Auction purse per team | 130 crore (consistent with spent plus available for every franchise in table A) | A, B | Consistent, to confirm in regulations |
| Total salary limit | 157 crore | B | Unverified |
| Squad size | Minimum 18, maximum 25 | B | Unverified |
| Overseas limits | 8 in a squad, 4 in a playing XI | B | Unverified |
| Right to Match | Not available in the 2027 mini-auction | B | Unverified |
| Overseas payment cap | Player payment limited to 18 crore, excess to the BCCI player welfare fund, purse deducted in full | B | Unverified |
| Retention before a mini-auction | No fixed limit | B | Unverified |
| Impact Player | Enabled | B | Unverified |

Franchise opening state from source A (amounts in rupees crore):

| Franchise | Players | Overseas | Spent | Purse available | Slots | Overseas slots |
|---|---|---|---|---|---|---|
| CSK | 19 | 6 | 101.95 | 28.05 | 6 | 2 |
| DC | 16 | 4 | 90.50 | 39.50 | 9 | 4 |
| GT | 22 | 6 | 121.25 | 8.75 | 3 | 2 |
| KKR | 17 | 5 | 88.35 | 41.65 | 8 | 3 |
| LSG | 18 | 5 | 82.55 | 47.45 | 7 | 3 |
| MI | 16 | 6 | 99.75 | 30.25 | 9 | 2 |
| PBKS | 19 | 6 | 111.40 | 18.60 | 6 | 2 |
| RCB | 20 | 7 | 115.85 | 14.15 | 5 | 1 |
| RR | 19 | 5 | 102.95 | 27.05 | 6 | 3 |
| SRH | 18 | 5 | 89.85 | 40.15 | 7 | 3 |
| Total | 184 | 55 | 1004.40 | 295.60 | 66 | 25 |

Consistency checks on this table (performed while writing this spec): players plus slots equals 25 for every franchise, 8 minus overseas players equals overseas slots for every franchise, spent plus available equals 130 for every franchise, and the totals row matches the column sums. These facts are reference data for importing and testing. The game must load them from data files and must not hard-code them.

The advisory and ipl.com do not list individual players in this text. Whether any named player (for example Ben Stokes) is on the official register has not been verified here. Media reports name him, but registration must come from the official list during import.

## Glossary

- **Auction_Engine**: The UI-independent module that is the only code allowed to change auction state, budgets, bids and ownership.
- **Franchise**: One of the ten IPL teams. One is human-controlled and nine are AI-controlled.
- **Player_Master**: A player's identity and profile data, independent of any season.
- **Season_Registration**: A season-specific record that says whether a player is registered and eligible for one auction.
- **Classification**: A season-specific capped/uncapped determination with rule version, source and effective date.
- **Auction_Set**: A group of players auctioned together, built from verified classification and the configured set order.
- **Auction_Pool**: The validated list of eligible players for one auction.
- **Lot**: One player being auctioned at a given moment.
- **Fair_Value**: A franchise-independent estimate of a player's worth. It is a game heuristic, not a price prediction.
- **Willingness_To_Pay (WTP)**: The most a specific franchise will bid, given its needs, purse and strategy.
- **Conditions_Scenario**: A named set of pitch, weather and venue assumptions (for example spin-friendly, humid/dewy).
- **Provenance**: The source, retrieval or update timestamp, confidence and freshness of a data record.
- **Save**: A persisted auction session in browser storage.
- **Money**: An integer number of rupees. Display formats it in lakh and crore.
- **Unresolved**: A record whose registration, eligibility or classification cannot be verified.
- **Auction_Register**: The official registration list (1,220 names for IPL 2027). It is not the final pool.
- **Final_Auction_List**: The official list of players in the auction and their player sets, published after franchises choose from the register.
- **Opening_State**: A franchise's purse, existing squad and overseas count when an auction begins.
- **Pool_Kind**: A label on an Auction_Pool: register, provisional, final or sample.

## Requirements

### Requirement 1: Auction setup and modes

**User Story:** As a player, I want to configure a new auction, so that I can play the format I choose.

#### Acceptance Criteria

1. WHEN the user chooses New Auction THEN the system SHALL offer the IPL 2027 Mini Auction mode and the configurable Mega Auction mode.
2. WHEN a mode is selected THEN the system SHALL load its rules from a configuration file and SHALL NOT hard-code starting purse, base prices, bid increments, squad minimum or maximum, overseas limit, role constraints, retention rules or timer rules.
3. WHEN the user selects the player pool, season and conditions profile THEN the system SHALL record them in the new auction's configuration.
4. IF a rules configuration fails schema validation THEN the system SHALL refuse to start the auction and SHALL show which fields are invalid.
5. WHEN the auction starts THEN the system SHALL store the exact rules configuration and data versions used so the auction can be restored and audited.
6. WHEN the IPL 2027 Mini Auction is selected THEN the system SHALL load the IPL 2027 season rules, Opening_States and pool data, each with source and verification date.
7. WHEN the Mega Auction mode is selected THEN the system SHALL use a configurable rules template, and SHALL start every franchise with an empty squad unless the configuration supplies Opening_States.

### Requirement 2: Franchise selection and AI opponents

**User Story:** As a player, I want to choose one franchise and face nine AI rivals, so that the auction feels like a full ten-team event.

#### Acceptance Criteria

1. WHEN the user reaches franchise selection THEN the system SHALL list all ten IPL franchises (CSK, MI, RCB, KKR, DC, RR, SRH, PBKS, GT and LSG) from configuration data.
2. WHEN the user selects a franchise THEN the system SHALL assign every other franchise to an AI agent and SHALL NOT assign an AI agent to the human franchise.
3. WHEN the auction starts THEN each AI franchise SHALL have its own profile, strategy parameters, purse, needs and decision state.
4. IF the configured franchise list does not contain exactly ten franchises THEN the system SHALL refuse to start and SHALL report the mismatch.

### Requirement 3: Player master data and season registration

**User Story:** As an organiser, I want registration and eligibility tracked per season, so that no player is wrongly included or excluded.

#### Acceptance Criteria

1. THE system SHALL store Player_Master records separately from Season_Registration records.
2. WHEN a Season_Registration is stored THEN it SHALL include registration status, registration date where available, auction season, official source, source URL or reference, verification timestamp and eligibility decision.
3. WHEN building an Auction_Pool THEN the system SHALL include a player only if a verified Season_Registration for that season marks the player eligible.
4. THE system SHALL NOT infer registration, availability or eligibility from past auction history, news, reputation or the existence of a Player_Master record.
5. WHEN a player was absent from a previous auction but has a verified eligible registration for the selected season THEN the system SHALL include that player.
6. WHEN a player has no registration record, or a record that is ineligible THEN the system SHALL exclude that player.
7. IF registration data is missing or conflicting THEN the system SHALL mark the record Unresolved and flag it for manual review without silently including or excluding the player.
8. THE system SHALL support new entrants, returning players, players who skipped earlier auctions, withdrawn players, and registration or eligibility changes before the auction.
9. THE system SHALL keep historical auction participation as informational data only.
10. THE system SHALL distinguish the Auction_Register from the Final_Auction_List, and SHALL record for each pool its Pool_Kind, source and publication date.
11. WHEN the Final_Auction_List differs from the Auction_Register THEN the system SHALL show the differences and SHALL use the final list as the pool.

### Requirement 4: Capped/uncapped classification and auction sets

**User Story:** As an organiser, I want capped/uncapped status and set order to follow the season's rules, so that sets match the real format.

#### Acceptance Criteria

1. THE system SHALL store Classification per player per season, with rule version, effective date, source, verification timestamp and an audit explanation, and SHALL NOT store capped/uncapped status on the Player_Master record.
2. WHEN verified player history or official rules change THEN the system SHALL recompute the affected Classification and SHALL preserve earlier seasons' records.
3. WHEN a Classification changes or the Auction_Pool is refreshed THEN the system SHALL rebuild Auction_Sets and re-sort players automatically.
4. THE system SHALL read set grouping and order from the auction rules configuration and SHALL NOT assume one fixed order.
5. THE system SHALL keep eligibility and Classification as separate fields.
6. THE system SHALL NOT infer capped/uncapped status from popularity, IPL appearances alone, nationality or stale data.
7. IF a Classification cannot be verified THEN the system SHALL mark it Unresolved and SHALL NOT assign a definitive category.
8. THE system SHALL provide a manual review and override flow that records who or what changed a value, when, and why.
9. THE system SHALL support the official register categories (capped Indian, capped international, Associate Nations, uncapped Indian who played in earlier IPL seasons, uncapped Indian, uncapped international) as configurable category values, and SHALL store each player's official category with its source.
10. WHEN the official category differs from a rule-based classification computed by the system THEN the system SHALL flag the difference for review, and SHALL treat the official published category as the verified value until a review changes it.

### Requirement 5: Pool validation before launch

**User Story:** As a player, I want the pool checked before the auction starts, so that the auction is trustworthy.

#### Acceptance Criteria

1. WHEN the user starts an auction THEN the system SHALL validate the Auction_Pool against the configured published list and the applicable rules.
2. IF any player is Unresolved or ineligible THEN the system SHALL block launch until a review resolves the record or the user excludes it explicitly.
3. WHEN validation completes THEN the system SHALL show the counts of valid, excluded and Unresolved records, each with its season and rule context.
4. IF the pool is too small to satisfy the rules for every franchise THEN the system SHALL report the shortfall and block launch.
5. WHEN the IPL 2027 Mini Auction is launched as official THEN the system SHALL require the published Final_Auction_List and player sets, and SHALL NOT use the Auction_Register as the final pool.
6. IF the Final_Auction_List is not yet published THEN the system SHALL NOT launch the IPL 2027 Mini Auction as official, and SHALL show the expected publication date from the source data.
7. WHEN the user chooses the sample pool (the owner's mock list) THEN the system SHALL allow launch, SHALL label every screen and the results "SAMPLE DATA, not official", and SHALL NOT mark the auction as official or verified.
8. THE system SHALL take set names, set order, player names, roles, overseas flags and base prices of the sample pool from its data file, and SHALL NOT hard-code them.

### Requirement 6: Bidding and the rules engine

**User Story:** As a player, I want every bid checked by one authority, so that human and AI bids follow the same rules.

#### Acceptance Criteria

1. THE Auction_Engine SHALL be the only module that changes budgets, bids, lot status, timers and squad ownership.
2. WHEN any bid is submitted by the human or an AI agent THEN the Auction_Engine SHALL validate franchise eligibility, remaining purse, increment, lot status, squad limits, overseas limit and auction state.
3. IF a bid is invalid THEN the system SHALL reject it with a specific reason and SHALL NOT change state.
4. WHEN a bid command repeats a previously processed request ID THEN the Auction_Engine SHALL return the original result and SHALL NOT apply it twice.
5. WHEN a bid is based on an outdated bid version THEN the Auction_Engine SHALL reject it as stale.
6. WHEN several bids arrive for the same lot THEN the Auction_Engine SHALL process them one at a time in arrival order and SHALL accept at most one winning bid per lot.
7. THE Auction_Engine SHALL implement the states player introduction, bidding, sold, unsold and next lot, plus paused, withdrawn and completed.
8. THE Auction_Engine SHALL NOT depend on UI components or AI strategy code.
9. THE system SHALL show the human the next valid bid and SHALL disable bidding when the human cannot legally bid.

### Requirement 7: Money safety

**User Story:** As a player, I want exact budgets, so that purses never drift.

#### Acceptance Criteria

1. THE system SHALL represent all Money as integer rupees and SHALL NOT use floating-point arithmetic for budgets or bids.
2. THE system SHALL reject any configured amount that is not a whole number of rupees.
3. THE system SHALL guarantee that the sum of remaining purses plus spend equals the total starting purses at every state transition.
4. WHEN displaying Money THEN the system SHALL format it in lakh and crore without changing the stored value.

### Requirement 8: Timer, pause and resume

**User Story:** As a player, I want to pause and resume, so that I can step away without losing the auction.

#### Acceptance Criteria

1. THE Auction_Engine SHALL track timers by deadline timestamp from an injectable clock, not by counting ticks.
2. WHEN the user pauses THEN the system SHALL freeze the remaining time and SHALL reject bids until resume.
3. WHEN the user resumes THEN the system SHALL continue from the stored remaining time.
4. WHEN a browser tab is backgrounded or the screen locks THEN the system SHALL pause the auction automatically, and WHEN the user returns THEN the system SHALL keep it paused with the remaining time intact until the user resumes.
5. WHEN a saved auction is reopened THEN the system SHALL restore it in the paused state with the remaining time intact.
6. WHEN a timer is configured to extend or reset on a bid THEN the system SHALL apply the configured rule.
7. THE system SHALL provide a controllable test clock so timer behaviour can be tested deterministically.
8. THE system SHALL measure running time with a monotonic clock and SHALL NOT use system clock or time zone changes to decide lot outcomes.
9. WHEN the gap between timer evaluations exceeds a configured threshold, which indicates suspension or throttling THEN the system SHALL pause the auction, and SHALL NOT sell a lot, pass a lot or accept a bid for the missed interval.
10. WHEN the page is hidden, frozen or about to unload THEN the system SHALL save the paused state immediately.
11. WHERE the browser supports a screen wake lock THEN the system SHALL request it while bidding is live, and SHALL behave correctly when it is unavailable or released.
12. THE AI scheduling SHALL use the engine clock and SHALL cancel pending AI actions when the auction pauses.

### Requirement 9: Player valuation and willingness to pay

**User Story:** As a player, I want AI prices to be explainable, so that I can understand why rivals bid or stop.

#### Acceptance Criteria

1. THE valuation service SHALL produce a Fair_Value with a breakdown of contributing factors and a confidence level.
2. THE valuation service SHALL calculate each franchise's WTP and maximum bid separately from Fair_Value.
3. WHEN calculating WTP THEN the system SHALL consider remaining purse, squad gaps, available alternatives, role scarcity, auction stage and the franchise's strategy.
4. WHEN player data is missing or the sample is small THEN the system SHALL lower confidence and SHALL NOT treat missing data as zero performance.
5. THE system SHALL store the inputs and the weights version used for each valuation.
6. THE system SHALL explain each valuation in plain language.
7. THE system SHALL NOT require a paid API or LLM for valuation or bidding.
8. THE system SHALL NOT present Fair_Value as a prediction of a real auction price.

### Requirement 10: Venue, pitch and conditions data

**User Story:** As a player, I want conditions to influence the AI, so that rivals plan squads for the tournament.

#### Acceptance Criteria

1. THE system SHALL model venues, pitch profiles and conditions with Provenance on every record.
2. THE system SHALL label every conditions record as historical climate, forecast or observed matchday data, and forecasts SHALL include issue time, valid time, source and freshness.
3. THE system SHALL NOT treat a long-range forecast as a reliable matchday forecast.
4. WHEN data is stale, missing, contradictory or low-confidence THEN the system SHALL mark fields unknown and degrade gracefully.
5. THE system SHALL NOT fabricate venue statistics or weather values.
6. THE tournament venue list SHALL be configurable and SHALL NOT assume every venue is used in every season.
7. THE system SHALL validate venue and conditions files on import and SHALL report errors by file and field.
8. THE system SHALL provide service functions that return a venue and conditions profile for a chosen scenario.

### Requirement 11: Squad composition and adaptability

**User Story:** As a player, I want squads judged across the whole tournament, so that balance beats stacking stars.

#### Acceptance Criteria

1. THE squad evaluation service SHALL assess role coverage, batting depth, bowling phase coverage, pace and spin balance, left/right combinations, fielding, backup cover and overseas composition.
2. THE service SHALL evaluate a squad across the configured venue distribution and the Conditions_Scenarios the data supports.
3. THE service SHALL produce an adaptability score, a list of weaknesses and a readable explanation for each scenario.
4. THE service SHALL compute the marginal value of adding a given player to a squad.
5. THE service SHALL NOT let one venue or scenario dominate unless the tournament configuration says so.
6. WHEN data does not support a scenario assessment THEN the service SHALL report the uncertainty and SHALL NOT score that attribute.
7. THE service SHALL NOT be presented as a match-win predictor.

### Requirement 12: AI franchise agents

**User Story:** As a player, I want nine rivals who behave differently, so that each auction plays out differently.

#### Acceptance Criteria

1. THE system SHALL create one independent agent per AI franchise with its own strategy, risk tolerance, aggressiveness, shortlist, squad gaps and decision history.
2. WHEN deciding THEN each agent SHALL consider Fair_Value and confidence, its squad gaps, remaining purse and expected spend on unfilled roles, alternatives, role scarcity, auction stage, venue distribution, pitch and weather scenarios, adaptability, the player's verified classification and category, and the auction rules.
3. THE agents SHALL support the decisions BID, PASS, WITHDRAW and WAIT.
4. THE agents SHALL submit every bid through the Auction_Engine and SHALL NOT change budgets or state directly.
5. THE agents SHALL bid only on players in the active Auction_Pool.
6. WHEN a decision is meaningful THEN the agent SHALL store a concise human-readable reason.
7. THE system SHALL make agent decisions reproducible from a seed.
8. THE nine strategies SHALL be configurable and SHALL produce measurably different behaviour.
9. THE agents SHALL NOT spend the full purse early without a rule-based reason and SHALL NOT delay in ways that frustrate the player.

### Requirement 13: Simulation and validation

**User Story:** As a developer, I want repeatable full-auction simulations, so that I can find rule violations and bad AI behaviour.

#### Acceptance Criteria

1. THE simulation harness SHALL run complete auctions with one simulated human strategy and nine agents, across many seeds.
2. THE harness SHALL cover the conditions scenarios and player-pool variations named in the playbook, newly registered players, players missing from previous auctions, season-to-season classification changes and automatic set reordering.
3. THE harness SHALL record every bid, pass, withdrawal, sale, budget change, squad addition and AI explanation.
4. THE harness SHALL validate each completed squad against all configured rules.
5. THE harness SHALL detect overspending, ignored critical gaps, identical agent behaviour, repeated irrational bidding and incomplete squads.
6. THE harness SHALL write a report with failure counts, rule violations, budget distribution, sale outcomes, squad coverage and strategy differences, and SHALL record the seeds and configuration that reproduce each failure.
7. THE team SHALL NOT claim a number of successful runs unless the report shows it.

### Requirement 14: Responsive, cross-platform experience

**User Story:** As a player, I want to play on my phone or laptop, so that I can bid anywhere.

#### Acceptance Criteria

1. THE interface SHALL be mobile-first and adapt to phones, tablets, laptops and desktops.
2. THE system SHALL support current Android browsers, iOS and iPadOS browsers including Safari, and Windows and macOS desktop browsers.
3. THE auction controls SHALL be touch-friendly, with adequate tap targets and no hover-only interactions.
4. WHEN shown on a phone THEN the dashboard SHALL prioritise the current player, bid amount, countdown, next bid action, the user's purse, squad summary and essential AI activity, and SHALL use tabs, collapsible panels or stacking for the rest.
5. THE interface SHALL NOT produce horizontal overflow, clipped controls, overlapping panels or accidental page zoom during bidding.
6. THE interface SHALL work in portrait and, where practical, landscape.
7. THE conditions panel SHALL stay readable on phones and SHALL NOT crowd out bid controls.
8. WHEN the network drops, the tab is backgrounded or the screen locks THEN the system SHALL recover to the correct state on return.
9. THE team SHALL verify these flows on the physical Android and iOS devices whose models the user supplies, and SHALL record a result only for a device that was actually tested: create auction, select franchise, bid, observe AI bids, pause and resume, switch tabs, lock the screen, reopen a save and view results. Until then every report SHALL say "emulated only".
10. THE team SHALL run Playwright tests on Chromium, Firefox and WebKit at phone, tablet and laptop viewports, SHALL state that this is emulation and not physical-device testing, and SHALL document device and browser limitations.

### Requirement 15: Accessibility

**User Story:** As a player with accessibility needs, I want the game to be usable with keyboard and assistive tech.

#### Acceptance Criteria

1. THE interface SHALL be fully operable by keyboard on laptops, with visible focus states.
2. THE interface SHALL provide screen-reader labels, sufficient colour contrast and announcements for sold, unsold, paused and error states.
3. WHEN the user prefers reduced motion THEN the interface SHALL reduce or remove animation.
4. THE interface SHALL show loading, empty and error states.
5. THE interface SHALL label any demo or sample data clearly and SHALL NOT present it as real.

### Requirement 16: Persistence, multiple saves and transfer

**User Story:** As a player, I want to keep several auctions and resume them, so that I never lose progress by accident.

#### Acceptance Criteria

1. WHEN auction state changes THEN the system SHALL save it to browser storage atomically so a partial write cannot corrupt a save.
2. THE system SHALL support multiple saved auctions, and starting a new auction SHALL NOT overwrite an existing save.
3. THE Resume screen SHALL list saves with franchise, mode, season, progress and last-played time, and SHALL let the user resume, export or delete a save with a confirmation before deletion.
4. WHEN the user exports a save THEN the system SHALL produce a versioned file, and WHEN the user imports one THEN the system SHALL validate it before accepting it.
5. THE save SHALL contain the rules configuration, data snapshot versions, franchise profiles, current lot, bid history, budgets, squads, sold and unsold players, timer state, conditions profile, AI decision history and the seed.
6. WHEN a save is opened in a second tab while already open in another THEN the system SHALL show a notice and SHALL NOT allow edits in the second tab.
7. WHEN the user reopens the site THEN the system SHALL offer the saved auctions in the same browser, restored as paused.
8. IF a save is corrupted or from an unsupported version THEN the system SHALL report it, keep the file for export and SHALL NOT silently reset it.
9. THE system SHALL migrate saves across schema versions or report that migration is not possible.
10. THE system SHALL warn that browser storage can be cleared (private windows, cleared data, and storage eviction on some browsers) and SHALL prompt the user to export saves.
11. THE system SHALL NOT claim automatic cross-device sync, and SHALL document export/import as the way to move a save.
12. WHEN the user exports a save THEN the system SHALL pause the session, write the paused state to the file and include an export identifier.
13. WHEN the user imports a file that shares an export lineage with an existing save THEN the system SHALL ask whether to import it as a new copy or replace the existing save, and SHALL warn that two copies diverge once either is played.

### Requirement 17: Data import, provenance and review

**User Story:** As an organiser, I want player and venue data imported safely, so that every value has a known source.

#### Acceptance Criteria

1. THE system SHALL import player, registration, classification, venue and conditions data from validated JSON or CSV files, with a preview and clear validation errors.
2. THE system SHALL deduplicate records and SHALL make repeated imports produce the same result.
3. THE system SHALL preserve source, season, sample size, retrieval date and confidence on every statistic.
4. THE system SHALL store missing statistics as unknown and SHALL NOT convert them to zero.
5. THE system SHALL provide search and filters for role, style, nationality, base price, specialist tags, registration status and classification.
6. THE system SHALL provide a review view that shows each record's season, rule context and any Unresolved flag.
7. THE system SHALL NOT present sample or development data as verified real-world data.
8. THE system SHALL NOT invent player statistics, base prices or availability.

### Requirement 18: Results and summary

**User Story:** As a player, I want a full summary at the end, so that I can review how I did.

#### Acceptance Criteria

1. WHEN the auction completes THEN the system SHALL show every franchise's squad, spend, remaining purse, sold and unsold players and role composition.
2. THE system SHALL show the human squad's adaptability report and weaknesses.
3. THE system SHALL let the user view AI decision reasons for any lot.
4. THE system SHALL let the user export the results.

### Requirement 19: Static hosting and delivery

**User Story:** As the owner, I want a free, verifiable GitHub Pages deployment, so that anyone can open the game by URL.

#### Acceptance Criteria

1. THE system SHALL build to static files that run without a server.
2. THE build SHALL set the base path for the GitHub Pages project URL.
3. THE deployment SHALL run through a GitHub Actions workflow that installs, lints, type-checks, tests and builds before publishing.
4. THE project SHALL commit no API keys, tokens or passwords, and SHALL treat anything shipped to the browser as public.
5. THE project SHALL NOT force-push, overwrite the main branch, or publish without the owner's approval.
6. THE team SHALL NOT report a deployment URL until it is live and verified in a browser.
7. THE README SHALL document setup, test commands, data import and deployment.

### Requirement 20: Quality, errors and diagnostics

**User Story:** As a developer, I want honest test results and clear errors, so that I can trust each stage.

#### Acceptance Criteria

1. THE project SHALL include unit tests for rules, valuation, squad constraints and AI decisions, and integration and end-to-end tests for critical flows.
2. THE team SHALL report only the checks it actually ran and their real results.
3. WHEN an unexpected error occurs THEN the system SHALL show a clear message, keep the saved auction intact and offer a way to recover.
4. THE system SHALL provide a local diagnostics view and downloadable log for debugging, and SHALL NOT send telemetry to external services.
5. THE project SHALL document assumptions, limitations and unfinished work.

### Requirement 21: Tournament conditions and squad strategy simulator (post-deployment)

**User Story:** As a player, I want to test my finished squad across venues and conditions, so that I can see its strengths and gaps.

#### Acceptance Criteria

1. WHEN the user selects a completed squad THEN the system SHALL show per-venue and per-scenario suitability, role coverage and overseas constraints.
2. THE system SHALL recommend a legal likely XI, batting order and bowling phase allocation, and an Impact Player option where the rule is enabled.
3. THE system SHALL explain which players gain or lose suitability under each scenario.
4. THE system SHALL show data confidence and warn when data is insufficient.
5. THE system SHALL allow comparing two squads and saving scenario reports.
6. THE system SHALL present all outputs as squad suitability scores and SHALL NOT present them as match-win probabilities.
7. THE module SHALL reuse existing valuation, rules and conditions services without duplicating them.

### Requirement 22: Franchise opening state

**User Story:** As a player, I want each franchise to start from its real retained squad and remaining purse, so that the mini-auction matches the official situation.

#### Acceptance Criteria

1. THE system SHALL support a per-franchise Opening_State with remaining purse in whole rupees, existing squad players with acquisition price where known, overseas count and available slots.
2. WHEN a mode supplies Opening_States THEN the system SHALL start each franchise from its own state and SHALL NOT apply one purse to all franchises.
3. WHEN a mode supplies no Opening_States THEN the system SHALL start every franchise with an empty squad and the configured starting purse.
4. THE system SHALL validate each Opening_State against the rules: squad size not above the maximum, overseas count not above the limit, purse not negative, and available slots equal to the maximum squad size minus the current squad size.
5. THE system SHALL record the source, date and verification time of each Opening_State, and SHALL flag any mismatch with published totals for review.
6. THE system SHALL exclude players in Opening_State squads from the auction pool, and SHALL count them in role composition and squad evaluation.
7. THE AI agents SHALL use their franchise's Opening_State when computing squad gaps, needs and willingness to pay.

### Requirement 23: IPL 2027 baseline data and rule configuration

**User Story:** As a player, I want the mini-auction to follow the real IPL 2027 rules and data, so that results are realistic and auditable.

#### Acceptance Criteria

1. THE system SHALL provide an IPL 2027 Mini Auction configuration built from official IPL/BCCI publications, with source and verification date on each value.
2. THE system SHALL keep every rule value (purse, squad limits, overseas limits, slot counts, increments, payment caps, Right to Match availability, Impact Player, set order, any accelerated rounds) in configuration data, and SHALL NOT hard-code any of them.
3. WHEN a value comes only from a secondary source THEN the system SHALL mark it unverified, list it in the review view, and require confirmation against an official regulation before the mode is marked verified.
4. WHEN official figures change THEN the system SHALL allow the data files to be replaced, and SHALL keep the earlier versions that saved auctions refer to.
5. WHEN an overseas payment cap is configured THEN the system SHALL deduct the full winning bid from the franchise purse, and SHALL apply the cap only to the separately recorded player payment.
6. WHEN the official Final_Auction_List and player sets are published THEN the system SHALL import them, compare them with the Auction_Register and flag differences.

## Out of Scope

- Multiplayer rooms, accounts, sign-in and server-side sync.
- Real-money features, payments and betting.
- Match simulation or match-win prediction.
- Copying the reference site's code, assets or branding.
- Any paid API or LLM for core decisions.
- Native mobile apps.
- Live weather feeds that need a private key stored in the browser.

## Unresolved Decisions

1. **Pool before 4 December.** The sample pool (the owner's mock list) can be played now, labelled as sample (Requirement 5.7). Whether to also allow a "provisional" pool built from the official Auction_Register (minus retained players) is still open. Not assumed.
1a. **Meaning of the sample set labels.** The labels (Marquee Set 1, Set 1 to 4, BA, AL, WK, FA, SP, and the U-prefixed UBA, UAL, UWK, UFA, USP, each numbered in order) are kept as supplied. They look like batters, all-rounders, wicketkeepers, fast bowlers, spinners, and uncapped versions of each, but this has not been confirmed and the system does not depend on it.
2. **Secondary-source rules.** The rule values marked Unverified above (salary limit, squad limits, overseas limits, Right to Match, overseas payment cap, Impact Player) need confirmation against the official IPL regulations before the mode is marked verified.
3. **Accelerated rounds and bid increments.** Whether and how unsold players return in accelerated rounds, and the official bid increment bands, are not yet sourced. They stay in configuration.
4. **Official player data.** Names, categories, base prices and retained squads must be imported from official lists. The licence and terms for bundling this data in a public repository need checking.
5. **Repository visibility and Pages.** The repository https://github.com/ShReShT-72/untitled exists and is private (confirmed by the owner). GitHub documents that GitHub Pages is available for public repositories on GitHub Free, and for private repositories only on paid plans (Pro, Team, Enterprise). To publish at https://shresht-72.github.io/untitled/ (base path /untitled/), the owner must either make the repository public or use a paid plan. Whether a Pages site from a private repository is itself publicly reachable depends on the plan and has not been verified. Changing visibility needs the owner's explicit approval, and making the repository public would publish everything committed to it.
6. **Physical test devices.** The user will provide device models for final manual testing.