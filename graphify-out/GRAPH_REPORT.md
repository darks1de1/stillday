# Graph Report - ios-todo-app  (2026-10-27)

## Corpus Check
- 81 files · ~151,081 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 10 file(s) not represented in the graph (top: .ttf 5, (none) 2, .exe 1)

## Summary
- 1547 nodes · 3505 edges · 97 communities (92 shown, 5 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 174 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5d26f329`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Store
- Tab
- TaskRow
- SwipeRow
- VoiceSheet
- Behavior
- AddBar
- xtool.yml
- CLAUDE.md
- PackageDescription
- View
- View
- .body
- Sound
- live-browser.js
- modern-screenshot.umd.js
- setLiveState
- documentRefForElement
- el
- mountSvelteComponentVariant
- initGlobalBar
- resolveLiveInjectionAnchor
- connectSSE
- renderDesignVisual
- Responsive Design
- new-work.md
- handleManualEditActivity
- onboard.md
- startVariantObserver
- createLiveBrowserDomHelpers
- cleanup
- refreshParamsPanel
- Impeccable Asset Producer
- SKILL.md
- The Toolkit
- captureElementToBlob
- showToast
- createLiveBrowserSessionState
- actOnAgentTarget
- onAnnotDown
- animate.md
- live.md
- Handle `generate`
- Generate Report
- New visual work
- optimize.md
- buildCyclingRow
- Scan mode (approach C: auto-extract, then confirm descriptive language)
- injectSvelteComponentsFromManifest
- PlanDaySheet
- critique.md
- Simplify the Design
- Hardening Dimensions
- clarify.md
- Nielsen's 10 Heuristics
- document.md
- polish.md
- quieter.md
- scheduleAcceptCleanup
- steerFocusLog
- Generate Combined Critique Report
- Init flow
- syncEditBadgeHitProxies
- connectSSE
- Common Cognitive Load Violations
- iOS platform
- Operate mode depth (and Read notes)
- Shape
- adapt.native.md
- Android platform
- colorize.md
- Persona-Based Design Testing
- doctor.md
- Extract Flow
- README.md
- Impeccable Finish Reviewer
- Impeccable Manual Edit Applier
- Generate Report
- Cognitive Load Assessment
- Impeccable Finish Reviewer
- Impeccable Manual Edit Applier
- injectVariantsFromSource
- live-browser-ignores.js
- Diagnostic Scan
- /impeccable hooks
- Visualize: Direction Comps & Asset Production
- Impeccable Documenter
- Region map
- Heuristics Scoring Guide
- Operate
- TrendLine
- typeset.md
- buildColorModels
- Impeccable Documenter
- enableInlineEdit
- hasTextRows

## God Nodes (most connected - your core abstractions)
1. `Store` - 36 edges
2. `TaskItem` - 35 edges
3. `connectSSE()` - 34 edges
4. `setLiveState()` - 33 edges
5. `resumeSession()` - 33 edges
6. `showToast()` - 31 edges
7. `initGlobalBar()` - 30 edges
8. `el()` - 29 edges
9. `buildInsertConfigureRow()` - 28 edges
10. `handleKeyDown()` - 27 edges

## Surprising Connections (you probably didn't know these)
- `.body` --calls--> `days`  [INFERRED]
  Stillday/Sources/Stillday/WeekView.swift → Stillday/Sources/Stillday/HistorySearch.swift
- `.open` --references--> `Store`  [INFERRED]
  Stillday/Sources/Stillday/PlanDay.swift → Stillday/Sources/Stillday/Store.swift
- `enableInlineEdit()` --indirect_call--> `own()`  [INFERRED]
  .claude/skills/impeccable/scripts/live-browser.js → .claude/skills/impeccable/scripts/live-browser-dom.js
- `.body` --calls--> `AddBar`  [INFERRED]
  Stillday/Sources/Stillday/PlanView.swift → Stillday/Sources/Stillday/Components.swift
- `.body` --calls--> `AddBar`  [INFERRED]
  Stillday/Sources/Stillday/TodayView.swift → Stillday/Sources/Stillday/Components.swift

## Import Cycles
- None detected.

## Communities (97 total, 5 thin omitted)

### Community 0 - "Store"
Cohesion: 0.14
Nodes (13): DayStat, Store, .doneCount, .next, .streak, .today, .yesterdayOpen, TaskItem (+5 more)

### Community 1 - "Tab"
Cohesion: 0.11
Nodes (16): dayTitle(), Filter, all, done, open, Part, archive, days (+8 more)

### Community 2 - "TaskRow"
Cohesion: 0.09
Nodes (15): Color, UIColor, Bullet, .body, .tint, Burst, .body, Check (+7 more)

### Community 3 - "SwipeRow"
Cohesion: 0.20
Nodes (7): SwipeAction, SwipeRow, .action, .background, .body, .drag, .progress

### Community 4 - "VoiceSheet"
Cohesion: 0.15
Nodes (9): AVFoundation, Observation, Speech, Draft, Orb, .body, VoiceCapture, VoiceParser (+1 more)

### Community 5 - "Behavior"
Cohesion: 0.08
Nodes (14): Foundation, Behavior, .answeredStreak, .ignoredStreak, State, Block, DayPlanner, Item (+6 more)

### Community 6 - "AddBar"
Cohesion: 0.27
Nodes (5): AddBar, .empty, EditSheet, .empty, UIKit

### Community 7 - "xtool.yml"
Cohesion: 0.33
Nodes (5): bundleID, iconPath, infoPath, resources, version

### Community 10 - "View"
Cohesion: 0.13
Nodes (13): Folder, HistoryView, SearchView, MonthGrid, .body, .cal, .cells, .weekdays (+5 more)

### Community 11 - "View"
Cohesion: 0.16
Nodes (16): .body, .body, DayGroup, .body, .body, .body, .body, Card (+8 more)

### Community 12 - ".body"
Cohesion: 0.17
Nodes (6): .body, PlanView, .body, ToastMsg, TodayView, .summary

### Community 13 - "Sound"
Cohesion: 0.15
Nodes (11): AudioToolbox, Sound, add, archive, cleared, complete, .id, micOff (+3 more)

### Community 14 - "live-browser.js"
Cohesion: 0.05
Nodes (61): applyGlobalBarLabelState(), applyParamDefaults(), applyParamValue(), applyPlaceholderSizingStyles(), applySavedParamValues(), bufferToBase64(), buildLocatorForLeaf(), collectFontCssText() (+53 more)

### Community 15 - "modern-screenshot.umd.js"
Cohesion: 0.09
Nodes (55): ae(), be(), bt(), Ce(), s(), Ct(), de(), dt() (+47 more)

### Community 16 - "setLiveState"
Cohesion: 0.24
Nodes (28): beginNewLiveConfiguration(), cancelEditing(), cancelEditingToPicking(), cancelInsertConfigure(), clearAnnotations(), clearInsertPicking(), closeTunePopover(), disableInlineEdit() (+20 more)

### Community 17 - "documentRefForElement"
Cohesion: 0.08
Nodes (31): addManualContextText(), canRestoreManualEditElement(), collectManualContextPieces(), walk(), contextElementForManualEdit(), copyEditContainerContext(), copyEditLeafContext(), cssIdent() (+23 more)

### Community 18 - "el"
Cohesion: 0.05
Nodes (84): actionLabel(), agentHasWorkInFlight(), armPageChatForTyping(), bindConfigureCountPillTooltip(), bindConfigureInlineControlHover(), bindConfigureModifierPillHover(), buildConfigureActionControl(), buildConfigureCountControl() (+76 more)

### Community 19 - "mountSvelteComponentVariant"
Cohesion: 0.24
Nodes (13): applyOriginalAttrsToSvelteAnchor(), commitAcceptedSvelteComponentToDom(), componentModuleCandidates(), describeMountFailure(), detectDevServerBase(), getMountedSvelteComponentAnchor(), importFirstReachable(), isSvelteInsertManifest() (+5 more)

### Community 20 - "initGlobalBar"
Cohesion: 0.13
Nodes (28): agentStatusText(), barPaletteForTheme(), brandMarkSvg(), detectPageTheme(), stopFocusOutIntoChrome(), ensureAgentPollTooltip(), fetchAgentPollingStatus(), fetchPendingCount() (+20 more)

### Community 21 - "resolveLiveInjectionAnchor"
Cohesion: 0.16
Nodes (19): buildSvelteExpressionTextMap(), buildSveltePropValuesFromLiveElement(), buildSveltePropValuesV2(), cloneWithoutElements(), collectTextNodes(), collectVisibleTexts(), cssEscapeIdent(), elementMatchesOriginalMarkup() (+11 more)

### Community 22 - "connectSSE"
Cohesion: 0.15
Nodes (22): applySavedSessionMeta(), clampVariantIndex(), clearHandled(), findActiveSessionSummary(), findAdoptableServerSession(), findAnyVariantsWrapper(), isFrameworkComponentPreviewMode(), isSessionHandled() (+14 more)

### Community 23 - "renderDesignVisual"
Cohesion: 0.08
Nodes (38): buildCollapsible(), buildDesignHeader(), buildListHtml(), buildRadiiModels(), copyToClipboard(), cssSafe(), designEmptyMessage(), designPanelCss() (+30 more)

### Community 24 - "Responsive Design"
Cohesion: 0.08
Nodes (25): Assess Adaptation Challenge, Breakpoints: Content-Driven, Content Adaptation, Desktop Adaptation (Mobile → Desktop), Detect Input Method, Not Just Screen Size, Email Adaptation (Web → Email), Implement Adaptations, Layout Adaptation Patterns (+17 more)

### Community 25 - "new-work.md"
Cohesion: 0.11
Nodes (14): Recommended Actions, Craft (deprecated alias), Apply, Live-mode signature params, Set the spatial thesis, Two isolated assessments, Verify, Visitor mode (+6 more)

### Community 26 - "handleManualEditActivity"
Cohesion: 0.19
Nodes (25): clearStoredManualApplyState(), handleManualEditActivity(), hidePendingApplyDock(), manualApplyLoadingText(), manualApplyStateKey(), numberOrNull(), onPendingKeepFixingClick(), onPendingPillClick() (+17 more)

### Community 27 - "onboard.md"
Cohesion: 0.09
Nodes (22): Assess Onboarding Needs, Context Over Ceremony, Contextual Help, Design Onboarding Experiences, Documentation & Help, Empty State Design, Feature Discovery & Adoption, Guided Tours & Walkthroughs (+14 more)

### Community 28 - "startVariantObserver"
Cohesion: 0.24
Nodes (16): commitAcceptedVariantToDom(), ensureInsertPlaceholder(), finalizeInsertSession(), findVariantsWrapper(), isInsertGeneratingSession(), pickVariantContent(), positionShaderOverlay(), removeInsertPlaceholderDom() (+8 more)

### Community 29 - "createLiveBrowserDomHelpers"
Cohesion: 0.14
Nodes (18): createLiveBrowserDomHelpers(), activeElementDeep(), cloneWithoutChrome(), copyTextViaSelection(), cssId(), liveUiRoot(), makeFrozenAnchor(), own() (+10 more)

### Community 30 - "cleanup"
Cohesion: 0.16
Nodes (23): buildInsertPlaceholderSnapshotFromDom(), buildPickedAnchorSnapshot(), captureAndEmit(), cleanup(), cleanupAcceptedSession(), clearMountErrorCard(), clearScrollY(), clearSession() (+15 more)

### Community 31 - "refreshParamsPanel"
Cohesion: 0.20
Nodes (15): buildParamsPanel(), closedClipPath(), formatRangeValue(), getVisibleVariantEl(), hideParamsPanel(), mountedParameterCount(), noteParamEdited(), openTunePopover() (+7 more)

### Community 32 - "Impeccable Asset Producer"
Cohesion: 0.10
Nodes (18): Core Rule, Decision Comps, Impeccable Asset Producer, Input Contract, Output Contract, Review handoff, The job, Act on the receipt (+10 more)

### Community 33 - "SKILL.md"
Cohesion: 0.10
Nodes (15): Before you finish, Scope is sovereign, The amplification, The skeleton test, Why it reads flat, Craft floor, Refuse, Verify (+7 more)

### Community 34 - "The Toolkit"
Cohesion: 0.10
Nodes (20): Animate complex properties, Assess What "Extraordinary" Means Here, For data-heavy interfaces, For functional UI, For performance-critical UI, For visual/marketing surfaces, Implement with Discipline, Interact with the device (+12 more)

### Community 35 - "captureElementToBlob"
Cohesion: 0.12
Nodes (20): averageRgb01(), captureChromeNodes(), captureElementFromRenderedAncestor(), captureElementToBlob(), compileShader(), cssColorToRgb01(), dominantRgb01(), findBackdropAncestor() (+12 more)

### Community 36 - "showToast"
Cohesion: 0.19
Nodes (17): abandonForeignSession(), abandonSupersededGo(), applyEditing(), discardOrphanedSession(), extractContext(), handleAccept(), handleDiscard(), markSessionHandled() (+9 more)

### Community 37 - "createLiveBrowserSessionState"
Cohesion: 0.19
Nodes (17): createLiveBrowserSessionState(), clearHandled(), clearScrollY(), clearSession(), isHandled(), loadSession(), markHandled(), nextCheckpointRevision() (+9 more)

### Community 38 - "actOnAgentTarget"
Cohesion: 0.31
Nodes (16): actOnAgentTarget(), agentTargetBusyReason(), agentTargetOverlayGone(), agentTargetTaken(), claimAgentTarget(), claimAndActOnAgentTarget(), declineAgentTargetBusy(), declineAgentTargetUnresolvable() (+8 more)

### Community 39 - "onAnnotDown"
Cohesion: 0.12
Nodes (24): applyPlaceholderDimensions(), beginEditPin(), buildAnnotationsForCapture(), buildPinElement(), buildPlaceholderResizeHandles(), cancelEditingPin(), clampPlaceholderSize(), cursorForPlaceholderEdge() (+16 more)

### Community 40 - "animate.md"
Cohesion: 0.12
Nodes (14): Accessibility and control, Choose material by meaning, Find the job, Implement to the runtime, Set the motion thesis, Timing and easing, Verify, Visitor mode (+6 more)

### Community 41 - "live.md"
Cohesion: 0.07
Nodes (26): Step 1: Parse the request, Step 2: Reuse the page, then start, Step 3: Generate, Step 4: Accept and close, Cleanup, Exit, First-time setup, Handle `accept` (+18 more)

### Community 42 - "Handle `generate`"
Cohesion: 0.12
Nodes (16): 1. Read the screenshot (if present), 2. Wrap the element, 3. Load the action's reference, 4. Plan three variants: identity first, then mode, then axes, 5. Apply the freeform prompt (if present), 6. Deliver variants, 7. Parameters (composition-sized, 0-4 per variant), 8. Signal done (+8 more)

### Community 43 - "Generate Report"
Cohesion: 0.13
Nodes (14): 1. Accessibility (A11y), 2. Performance, 3. Theming, 4. Responsive Design, 5. Implementation Integrity (CRITICAL), Audit Health Score, Detailed Findings by Severity, Diagnostic Scan (+6 more)

### Community 44 - "New visual work"
Cohesion: 0.14
Nodes (14): 1. Decide what is already true, 2. Ask what will change the work, 3. Choose the right amount of invention, 4. Commit the world, 5. Record the decision, 6. Build with full commitment, 7. Inspect and finish, Both paths (+6 more)

### Community 45 - "optimize.md"
Cohesion: 0.14
Nodes (13): Animation Performance, Assess Performance Issues, Core Web Vitals Optimization, Cumulative Layout Shift (CLS < 0.1), Interaction to Next Paint (INP < 200ms), Largest Contentful Paint (LCP < 2.5s), Loading Performance, Network Optimization (+5 more)

### Community 46 - "buildCyclingRow"
Cohesion: 0.47
Nodes (6): buildCyclingRow(), cycleVariant(), cyclingCounterText(), cyclingShownVariant(), navBtn(), syncCyclingControls()

### Community 47 - "Scan mode (approach C: auto-extract, then confirm descriptive language)"
Cohesion: 0.15
Nodes (13): Component translation rules, Narrative mapping, Scan mode (approach C: auto-extract, then confirm descriptive language), Schema, Step 1: Find the design assets, Step 2: Auto-extract what can be auto-extracted, Step 2b: Stage the frontmatter, Step 3: Ask the user for qualitative language (+5 more)

### Community 48 - "injectSvelteComponentsFromManifest"
Cohesion: 0.22
Nodes (16): abortSvelteComponentInjection(), completeParameterGenerationIfReady(), completeParameterPublication(), completeSourceInjection(), findInsertAnchorInDom(), findLiveElementForSvelteManifest(), hideShaderOverlay(), injectSvelteComponentsFromManifest() (+8 more)

### Community 49 - "PlanDaySheet"
Cohesion: 0.21
Nodes (4): FoundationModels, AIPlanner, PlanDaySheet, .open

### Community 50 - "critique.md"
Cohesion: 0.17
Nodes (11): Action Summary, Ask the User, Assessment A: Design Review, Assessment B: Detector + Browser Evidence, Assessment Orchestration, Deliver the Report, Hard Invariants, Persist the Snapshot (+3 more)

### Community 51 - "Simplify the Design"
Cohesion: 0.17
Nodes (11): Assess Current State, Code Simplification, Content Simplification, Document Removed Complexity, Information Architecture, Interaction Simplification, Layout Simplification, Plan Simplification (+3 more)

### Community 52 - "Hardening Dimensions"
Cohesion: 0.17
Nodes (11): Accessibility Resilience, Assess Hardening Needs, Edge Cases & Boundary Conditions, Error Handling, Hardening Dimensions, Input Validation & Sanitization, Internationalization (i18n), Performance Resilience (+3 more)

### Community 53 - "clarify.md"
Cohesion: 0.18
Nodes (10): Actions and navigation, Audit the language, Errors and permissions, Forms, Help and instructional text, Loading, empty, and success states, Rewrite by function, Set the message hierarchy (+2 more)

### Community 54 - "Nielsen's 10 Heuristics"
Cohesion: 0.18
Nodes (11): 10. Help and Documentation, 1. Visibility of System Status, 2. Match Between System and Real World, 3. User Control and Freedom, 4. Consistency and Standards, 5. Error Prevention, 6. Recognition Rather Than Recall, 7. Flexibility and Efficiency of Use (+3 more)

### Community 55 - "document.md"
Cohesion: 0.18
Nodes (10): Pitfalls, Seed mode, Step 1: Route through new-work's workshop, Step 2: Write seed DESIGN.md, Step 3: Confirm, Style guidelines, The frontmatter: token schema, The markdown body: eight sections (canonical order) (+2 more)

### Community 56 - "polish.md"
Cohesion: 0.18
Nodes (10): 1. Establish the system, 2. Gather the evidence, 3. Triage, 4. Polish the whole path, 5. Verify and finish, Color, imagery, and icons, Content and code, Flow and hierarchy (+2 more)

### Community 57 - "quieter.md"
Cohesion: 0.18
Nodes (10): Assess Current State, Color Refinement, Composition Refinement, Motion Reduction, Plan Refinement, Refine the Design, Simplification, Verify Quality (+2 more)

### Community 58 - "scheduleAcceptCleanup"
Cohesion: 0.31
Nodes (11): acceptedDomAlreadyClean(), clearHandledWrapperReloadStamp(), deferredRecoverySuperseded(), ensureAcceptedDomClean(), findAcceptedRuntimeWrappers(), handledWrapperReloadKey(), reloadAfterMissingAcceptedDom(), restoreAcceptedDomFromSnapshot() (+3 more)

### Community 59 - "steerFocusLog"
Cohesion: 0.20
Nodes (16): attachSteerFocusDebug(), attachSteerFocusGuard(), clearSteerFocusRecoverTimer(), focusConfigureInput(), focusSteerChat(), isInlineEditActive(), isPageEditableActive(), isPageEditableElement() (+8 more)

### Community 60 - "Generate Combined Critique Report"
Cohesion: 0.20
Nodes (10): Design Health Score, Design Specificity Verdict, Generate Combined Critique Report, Minor Observations, Overall Impression, Persona Red Flags, Priority Issues, Questions to Consider (+2 more)

### Community 61 - "Init flow"
Cohesion: 0.20
Nodes (10): Completion gate, Init flow, Step 1: Load current state, Step 2: Explore the project, Step 3: Interview for product truth, Step 4: Write PRODUCT.md, Step 5: Record workflow defaults, Step 6: Wrap up or resume (+2 more)

### Community 63 - "syncEditBadgeHitProxies"
Cohesion: 0.27
Nodes (10): bindEditBadgeProxy(), editBadgeProxyTargets(), initEditBadge(), initEditBadgeHitProxies(), positionEditBadge(), proxyMouseEvent(), setImportantStyle(), styleEditBadgeProxy() (+2 more)

### Community 64 - "connectSSE"
Cohesion: 0.19
Nodes (13): applyConfigureBarChrome(), applyLiveBarPreference(), buildSavingRow(), connectSSE(), dismissToast(), ensureCyclingRenderable(), ensureSpinKeyframes(), maybeCompleteAcceptedSession() (+5 more)

### Community 65 - "Common Cognitive Load Violations"
Cohesion: 0.22
Nodes (9): 1. The Wall of Options, 2. The Memory Bridge, 3. The Hidden Navigation, 4. The Jargon Barrier, 5. The Visual Noise Floor, 6. The Inconsistent Pattern, 7. The Multi-Task Demand, 8. The Context Switch (+1 more)

### Community 66 - "iOS platform"
Cohesion: 0.22
Nodes (9): Color & materials, Components & controls, iOS platform, Layout & structure, Motion, The iOS slop test, Touch targets, Typography (+1 more)

### Community 67 - "Operate mode depth (and Read notes)"
Cohesion: 0.22
Nodes (9): Color, Components, Layout, Motion, Operate mode depth (and Read notes), Product constraints, Product permissions, The product slop test (+1 more)

### Community 68 - "Shape"
Cohesion: 0.22
Nodes (8): Cadence, Confirm and stop, Phase 1: Discovery interview, Phase 2: Resolve the design direction, Phase 3: Write the brief, Round 1: purpose, people, and outcome, Round 2: material, behavior, and boundaries, Shape

### Community 69 - "adapt.native.md"
Cohesion: 0.25
Nodes (7): Adaptation Strategies, Assess Adaptation Challenge, Implement & Verify, Orientation & foldables, Phone → Tablet (iPad / large screens), Platform → platform (iOS ↔ Android), Web → native (porting a website or web app)

### Community 70 - "Android platform"
Cohesion: 0.25
Nodes (8): Android platform, Color & theming, Components & motion, Layout & structure, The Android slop test, Touch targets, Typography, Verifying the build

### Community 71 - "colorize.md"
Cohesion: 0.25
Nodes (7): Apply at system scale, Audit before choosing, Choose a strategy, Contrast and perception, Live-mode signature params, Verify, Visitor mode

### Community 72 - "Persona-Based Design Testing"
Cohesion: 0.25
Nodes (8): 1. Impatient Power User: "Alex", 2. Confused First-Timer: "Jordan", 3. Accessibility-Dependent User: "Sam", 4. Deliberate Stress Tester: "Riley", 5. Distracted Mobile User: "Casey", Persona-Based Design Testing, Project-Specific Personas, Selecting Personas

### Community 73 - "doctor.md"
Cohesion: 0.25
Nodes (7): Monorepo notes, Opting out of the boot check, Step 1: Run the pass, Step 2: Act by severity, Step 3: Deprecated fields are binding, Step 4: Do not overclaim on truth drift, What this owns, and what it does not

### Community 74 - "Extract Flow"
Cohesion: 0.25
Nodes (7): Extract Flow, Step 1: Discover the Design System, Step 2: Identify Patterns, Step 3: Plan Extraction, Step 4: Extract & Enrich, Step 5: Migrate, Step 6: Document

### Community 75 - "README.md"
Cohesion: 0.25
Nodes (7): Build and install, Built with, Design, Project layout, Status, Things to know, What it does

### Community 76 - "Impeccable Finish Reviewer"
Cohesion: 0.29
Nodes (6): Checks, in order, Disposition, Impeccable Finish Reviewer, Input Contract, Output Contract, Verdict Pass

### Community 77 - "Impeccable Manual Edit Applier"
Cohesion: 0.29
Nodes (6): Checks, Entry Atomicity, Impeccable Manual Edit Applier, Input Contract, Output Contract, Workflow

### Community 78 - "Generate Report"
Cohesion: 0.29
Nodes (7): Audit Health Score, Detailed Findings by Severity, Executive Summary, Generate Report, Patterns & Systemic Issues, Platform Conformance Verdict, Positive Findings

### Community 79 - "Cognitive Load Assessment"
Cohesion: 0.29
Nodes (7): Cognitive Load Assessment, Cognitive Load Checklist, Extraneous Load: Bad Design, Germane Load: Learning Effort, Intrinsic Load: The Task Itself, The Working Memory Rule, Three Types of Cognitive Load

### Community 80 - "Impeccable Finish Reviewer"
Cohesion: 0.29
Nodes (6): Checks, in order, Disposition, Impeccable Finish Reviewer, Input Contract, Output Contract, Verdict Pass

### Community 81 - "Impeccable Manual Edit Applier"
Cohesion: 0.29
Nodes (6): Checks, Entry Atomicity, Impeccable Manual Edit Applier, Input Contract, Output Contract, Workflow

### Community 82 - "injectVariantsFromSource"
Cohesion: 0.27
Nodes (10): checkpointPayload(), enterRecoveryWaitingForAnchor(), injectVariantsFromSource(), isJsxSourceFile(), isSvelteComponentManifestPath(), normalizeSessionPath(), queueCheckpoint(), rememberSessionFileMeta() (+2 more)

### Community 83 - "live-browser-ignores.js"
Cohesion: 0.52
Nodes (6): globToRegex(), matchesScope(), normalizeIgnoreRule(), normalizeIgnoreValue(), pageCandidates(), resolveDetectIgnores()

### Community 84 - "Diagnostic Scan"
Cohesion: 0.33
Nodes (6): 1. Accessibility (VoiceOver / TalkBack), 2. Performance, 3. Appearance & Theming, 4. Platform Conformance (CRITICAL), 5. Adaptivity, Diagnostic Scan

### Community 85 - "/impeccable hooks"
Cohesion: 0.33
Nodes (6): Constraints, Failure modes, Flow, /impeccable hooks, Routing, Triage findings

### Community 86 - "Visualize: Direction Comps & Asset Production"
Cohesion: 0.33
Nodes (5): After approval: the comp becomes a spec, Generate three compositional options, One approval point, Plates and provenance, Visualize: Direction Comps & Asset Production

### Community 87 - "Impeccable Documenter"
Cohesion: 0.40
Nodes (4): Impeccable Documenter, Input Contract, Output Contract, Workflow

### Community 88 - "Region map"
Cohesion: 0.40
Nodes (4): Containment, Painted material, Region map, What varies independently

### Community 89 - "Heuristics Scoring Guide"
Cohesion: 0.50
Nodes (4): Heuristics Scoring Guide, Issue Severity (P0–P3), Reference Material, Score Summary

### Community 90 - "Operate"
Cohesion: 0.50
Nodes (3): Comps, Directions, Operate

### Community 92 - "typeset.md"
Cohesion: 0.25
Nodes (7): Apply, Line breaks, Live-mode signature params, Set the system, Two isolated assessments, Verify, Visitor mode

### Community 93 - "buildColorModels"
Cohesion: 0.33
Nodes (6): buildColorModels(), buildTypographyModels(), findProseDescription(), humanizeKey(), normalizeCssColor(), splitFontFamily()

### Community 94 - "Impeccable Documenter"
Cohesion: 0.40
Nodes (4): Impeccable Documenter, Input Contract, Output Contract, Workflow

### Community 95 - "enableInlineEdit"
Cohesion: 0.40
Nodes (5): collectEditableTextRows(), visit(), enableInlineEdit(), onInlineInput(), wrapMixedContentTextNodes()

## Knowledge Gaps
- **46 isolated node(s):** `PackageDescription`, `.empty`, `.empty`, `archive`, `trash` (+41 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 537 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Reference Material` connect `Heuristics Scoring Guide` to `Persona-Based Design Testing`, `critique.md`, `Cognitive Load Assessment`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `Store` (e.g. with `.open` and `.title()`) actually correct?**
  _`Store` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `PackageDescription`, `.empty`, `.empty` to the rest of the system?**
  _46 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Store` be split into smaller, more focused modules?**
  _Cohesion score 0.1417004048582996 - nodes in this community are weakly interconnected._
- **Why does `New visual work` connect `New visual work` to `new-work.md`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **Are the 13 inferred relationships involving `TaskItem` (e.g. with `.body` and `.generate()`) actually correct?**
  _`TaskItem` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Should `Tab` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._