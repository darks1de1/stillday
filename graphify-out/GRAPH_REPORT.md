# Graph Report - ios-todo-app  (2026-10-27)

## Corpus Check
- 87 files · ~155,015 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 11 file(s) not represented in the graph (top: .ttf 5, (none) 2, .plist 2)

## Summary
- 1684 nodes · 3840 edges · 98 communities (92 shown, 6 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 211 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4b17151b`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Store
- Filter
- TaskRow
- SwipeRow
- VoiceSheet
- State
- AddBar
- xtool.yml
- CLAUDE.md
- PackageDescription
- WidgetSnapshot
- actOnAgentTarget
- syncPageChatFocus
- Sound
- cleanup
- modern-screenshot.umd.js
- setLiveState
- documentRefForElement
- initPageChat
- WidgetBridge.swift
- initGlobalBar
- mountSvelteComponentVariant
- restoreSessionWithoutWrapper
- live-browser.js
- Responsive Design
- new-work.md
- handleManualEditActivity
- onboard.md
- showShaderOverlay
- createLiveBrowserDomHelpers
- showToast
- resumeSession
- Impeccable Asset Producer
- SKILL.md
- The Toolkit
- captureElementToBlob
- findVariantsWrapper
- createLiveBrowserSessionState
- Widgets.swift
- onAnnotDown
- animate.md
- live.md
- Handle `generate`
- Generate Report
- New visual work
- optimize.md
- Scan mode (approach C: auto-extract, then confirm descriptive language)
- View
- critique.md
- Simplify the Design
- Hardening Dimensions
- clarify.md
- Nielsen's 10 Heuristics
- document.md
- polish.md
- quieter.md
- el
- Generate Combined Critique Report
- Init flow
- syncEditBadgeHitProxies
- DayPlanner
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
- StilldayWidgetView
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
- Impeccable Documenter
- Widgets.swift
- SwiftUI
- FocusLiveActivity
- .sans
- closeTunePopover
- connectSSE
- Shared.swift

## God Nodes (most connected - your core abstractions)
1. `TaskItem` - 46 edges
2. `Store` - 42 edges
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
- `.isLast` --references--> `TaskItem`  [INFERRED]
  Stillday/Sources/Stillday/JustThis.swift → Stillday/Sources/Stillday/Store.swift
- `.open` --references--> `Store`  [INFERRED]
  Stillday/Sources/Stillday/PlanDay.swift → Stillday/Sources/Stillday/Store.swift
- `init()` --indirect_call--> `stopFocusOutIntoChrome()`  [INFERRED]
  .claude/skills/impeccable/scripts/live-browser.js → .claude/skills/impeccable/scripts/live-browser-dom.js
- `teardown()` --indirect_call--> `stopFocusOutIntoChrome()`  [INFERRED]
  .claude/skills/impeccable/scripts/live-browser.js → .claude/skills/impeccable/scripts/live-browser-dom.js

## Import Cycles
- None detected.

## Communities (98 total, 6 thin omitted)

### Community 0 - "Store"
Cohesion: 0.11
Nodes (17): .body, Store, .doneCount, .next, .streak, .today, .yesterdayOpen, TaskItem (+9 more)

### Community 1 - "Filter"
Cohesion: 0.08
Nodes (20): Filter, all, done, open, Part, archive, days, trash (+12 more)

### Community 2 - "TaskRow"
Cohesion: 0.10
Nodes (15): Bullet, .body, .tint, Burst, .body, Check, ProgressPulse, .body (+7 more)

### Community 3 - "SwipeRow"
Cohesion: 0.17
Nodes (9): PlanView, .body, SwipeAction, SwipeRow, .action, .background, .body, .drag (+1 more)

### Community 4 - "VoiceSheet"
Cohesion: 0.16
Nodes (10): AVFoundation, Observation, Speech, Draft, Orb, .body, VoiceCapture, VoiceParser (+2 more)

### Community 5 - "State"
Cohesion: 0.08
Nodes (12): Behavior, .answeredStreak, .ignoredStreak, Run, State, Ladder, AIPlanner, Answer (+4 more)

### Community 6 - "AddBar"
Cohesion: 0.25
Nodes (5): AddBar, .body, .empty, EditSheet, .empty

### Community 7 - "xtool.yml"
Cohesion: 0.20
Nodes (9): bundleID, extensions, infoPath, product, iconPath, infoPath, product, resources (+1 more)

### Community 11 - "actOnAgentTarget"
Cohesion: 0.29
Nodes (17): actOnAgentTarget(), agentTargetBusyReason(), agentTargetOverlayGone(), agentTargetTaken(), claimAgentTarget(), claimAndActOnAgentTarget(), declineAgentTargetBusy(), declineAgentTargetUnresolvable() (+9 more)

### Community 12 - "syncPageChatFocus"
Cohesion: 0.32
Nodes (13): attachSteerFocusDebug(), attachSteerFocusGuard(), focusConfigureInput(), focusSteerChat(), notePagePointerDown(), pageHasHostTextSelection(), scheduleSteerFocusRecover(), shouldFocusSteerChat() (+5 more)

### Community 13 - "Sound"
Cohesion: 0.15
Nodes (11): AudioToolbox, Sound, add, archive, cleared, complete, .id, micOff (+3 more)

### Community 14 - "cleanup"
Cohesion: 0.15
Nodes (19): cleanup(), clearHandled(), clearMountErrorCard(), clearScrollY(), clearSession(), discardedWrappers(), discardStateStyleId(), mountErrorCardBottomOffset() (+11 more)

### Community 15 - "modern-screenshot.umd.js"
Cohesion: 0.09
Nodes (55): ae(), be(), bt(), Ce(), s(), Ct(), de(), dt() (+47 more)

### Community 16 - "setLiveState"
Cohesion: 0.13
Nodes (47): applyEditing(), beginNewLiveConfiguration(), buildInsertPlaceholderSnapshotFromDom(), buildLocatorForLeaf(), buildPickedAnchorSnapshot(), cancelEditing(), cancelEditingToPicking(), cancelInsertConfigure() (+39 more)

### Community 17 - "documentRefForElement"
Cohesion: 0.09
Nodes (29): addManualContextText(), canRestoreManualEditElement(), collectManualContextPieces(), walk(), contextElementForManualEdit(), copyEditContainerContext(), copyEditLeafContext(), cssIdent() (+21 more)

### Community 18 - "initPageChat"
Cohesion: 0.11
Nodes (39): agentHasWorkInFlight(), armPageChatForTyping(), buildSteerProcessingDots(), buildSteerQueueHint(), clearSteerAwaitTimer(), collapsePageChat(), expandPageChat(), finishVoiceSession() (+31 more)

### Community 19 - "WidgetBridge.swift"
Cohesion: 0.47
Nodes (4): ActivityKit, WidgetBridge, StilldayShared, WidgetKit

### Community 20 - "initGlobalBar"
Cohesion: 0.08
Nodes (44): agentStatusText(), barPaletteForTheme(), brandMarkSvg(), buildDesignHeader(), buildParamsPanel(), clearSteerFocusRecoverTimer(), cursorForInsertAxis(), designPanelCss() (+36 more)

### Community 21 - "mountSvelteComponentVariant"
Cohesion: 0.07
Nodes (42): acceptedDomAlreadyClean(), applyOriginalAttrsToSvelteAnchor(), buildSvelteExpressionTextMap(), buildSveltePropValuesFromLiveElement(), buildSveltePropValuesV2(), clearHandledWrapperReloadStamp(), cloneWithoutElements(), collectTextNodes() (+34 more)

### Community 22 - "restoreSessionWithoutWrapper"
Cohesion: 0.24
Nodes (12): applySavedSessionMeta(), clampVariantIndex(), findActiveSessionSummary(), findAdoptableServerSession(), isSessionHandled(), isTerminalSessionSummary(), normalizePagePath(), pageMatchesCurrent() (+4 more)

### Community 23 - "live-browser.js"
Cohesion: 0.04
Nodes (82): applyGlobalBarLabelState(), applyLiveBarPreference(), applyParamDefaults(), applyParamValue(), applyPlaceholderSizingStyles(), applySavedParamValues(), bufferToBase64(), buildCollapsible() (+74 more)

### Community 24 - "Responsive Design"
Cohesion: 0.08
Nodes (25): Assess Adaptation Challenge, Breakpoints: Content-Driven, Content Adaptation, Desktop Adaptation (Mobile → Desktop), Detect Input Method, Not Just Screen Size, Email Adaptation (Web → Email), Implement Adaptations, Layout Adaptation Patterns (+17 more)

### Community 25 - "new-work.md"
Cohesion: 0.11
Nodes (14): Recommended Actions, Craft (deprecated alias), Apply, Live-mode signature params, Set the spatial thesis, Two isolated assessments, Verify, Visitor mode (+6 more)

### Community 26 - "handleManualEditActivity"
Cohesion: 0.18
Nodes (26): clearStoredManualApplyState(), fetchPendingCount(), handleManualEditActivity(), hidePendingApplyDock(), manualApplyLoadingText(), manualApplyStateKey(), manualEditEventForCurrentPage(), numberOrNull() (+18 more)

### Community 27 - "onboard.md"
Cohesion: 0.09
Nodes (22): Assess Onboarding Needs, Context Over Ceremony, Contextual Help, Design Onboarding Experiences, Documentation & Help, Empty State Design, Feature Discovery & Adoption, Guided Tours & Walkthroughs (+14 more)

### Community 28 - "showShaderOverlay"
Cohesion: 0.50
Nodes (3): compileShader(), showShaderBitmapFallback(), showShaderOverlay()

### Community 29 - "createLiveBrowserDomHelpers"
Cohesion: 0.10
Nodes (24): collectEditableTextRows(), visit(), createLiveBrowserDomHelpers(), activeElementDeep(), cloneWithoutChrome(), copyTextViaSelection(), cssId(), liveUiRoot() (+16 more)

### Community 30 - "showToast"
Cohesion: 0.18
Nodes (13): abandonForeignSession(), abandonSupersededGo(), discardOrphanedSession(), dismissToast(), maybePrefetchPage(), maybeShowFirstSaveToast(), maybeWarnConditionalAncestor(), probeJsxWrapperForOrphan() (+5 more)

### Community 31 - "resumeSession"
Cohesion: 0.11
Nodes (41): abortSvelteComponentInjection(), checkpointPayload(), completeParameterGenerationIfReady(), completeParameterPublication(), completeSourceInjection(), enterRecoveryWaitingForAnchor(), finalizeInsertSession(), findInsertAnchorInDom() (+33 more)

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
Cohesion: 0.16
Nodes (17): averageRgb01(), captureChromeNodes(), captureElementFromRenderedAncestor(), captureElementToBlob(), cssColorToRgb01(), dominantRgb01(), findBackdropAncestor(), findShaderProxyCaptureRoot() (+9 more)

### Community 36 - "findVariantsWrapper"
Cohesion: 0.18
Nodes (16): applyPlaceholderDimensions(), commitAcceptedVariantToDom(), ensureInsertPlaceholder(), findVariantsWrapper(), hideHighlightTagTooltip(), isInsertGeneratingSession(), isVariantShown(), positionAnnotOverlay() (+8 more)

### Community 37 - "createLiveBrowserSessionState"
Cohesion: 0.19
Nodes (17): createLiveBrowserSessionState(), clearHandled(), clearScrollY(), clearSession(), isHandled(), loadSession(), markHandled(), nextCheckpointRevision() (+9 more)

### Community 38 - "Widgets.swift"
Cohesion: 0.23
Nodes (3): Entry, Provider, .body

### Community 39 - "onAnnotDown"
Cohesion: 0.20
Nodes (17): beginEditPin(), buildAnnotationsForCapture(), buildPinElement(), cancelEditingPin(), clampPlaceholderSize(), finalizeEditingPin(), initAnnotOverlay(), localCoords() (+9 more)

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

### Community 47 - "Scan mode (approach C: auto-extract, then confirm descriptive language)"
Cohesion: 0.15
Nodes (13): Component translation rules, Narrative mapping, Scan mode (approach C: auto-extract, then confirm descriptive language), Schema, Step 1: Find the design assets, Step 2: Auto-extract what can be auto-extracted, Step 2b: Stage the frontmatter, Step 3: Ask the user for qualitative language (+5 more)

### Community 49 - "View"
Cohesion: 0.15
Nodes (14): DayGroup, .body, dayTitle(), Folder, HistoryView, .body, SearchView, .body (+6 more)

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

### Community 59 - "el"
Cohesion: 0.08
Nodes (47): actionLabel(), applyConfigureBarChrome(), bindConfigureCountPillTooltip(), bindConfigureInlineControlHover(), bindConfigureModifierPillHover(), buildConfigureActionControl(), buildConfigureCountControl(), buildConfigureRow() (+39 more)

### Community 60 - "Generate Combined Critique Report"
Cohesion: 0.20
Nodes (10): Design Health Score, Design Specificity Verdict, Generate Combined Critique Report, Minor Observations, Overall Impression, Persona Red Flags, Priority Issues, Questions to Consider (+2 more)

### Community 61 - "Init flow"
Cohesion: 0.20
Nodes (10): Completion gate, Init flow, Step 1: Load current state, Step 2: Explore the project, Step 3: Interview for product truth, Step 4: Write PRODUCT.md, Step 5: Record workflow defaults, Step 6: Wrap up or resume (+2 more)

### Community 63 - "syncEditBadgeHitProxies"
Cohesion: 0.27
Nodes (10): bindEditBadgeProxy(), editBadgeProxyTargets(), initEditBadge(), initEditBadgeHitProxies(), positionEditBadge(), proxyMouseEvent(), setImportantStyle(), styleEditBadgeProxy() (+2 more)

### Community 64 - "DayPlanner"
Cohesion: 0.13
Nodes (7): Foundation, Block, DayPlanner, Item, Input, Planner, UserNotifications

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

### Community 82 - "StilldayWidgetView"
Cohesion: 0.12
Nodes (14): WidgetSnapshot, .isToday, .progress, StilldayWidgetView, .body, .circular, .counts, .fresh (+6 more)

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

### Community 91 - "TrendLine"
Cohesion: 0.19
Nodes (5): DayStat, TrendLine, .body, WeekView, .body

### Community 92 - "typeset.md"
Cohesion: 0.25
Nodes (7): Apply, Line breaks, Live-mode signature params, Set the system, Two isolated assessments, Verify, Visitor mode

### Community 94 - "Impeccable Documenter"
Cohesion: 0.40
Nodes (4): Impeccable Documenter, Input Contract, Output Contract, Workflow

### Community 95 - "Widgets.swift"
Cohesion: 0.38
Nodes (3): StilldayBundle, .body, StilldayWidget

### Community 96 - "SwiftUI"
Cohesion: 0.11
Nodes (9): FoundationModels, Security, Card, .body, Color, UIColor, Palette, SwiftUI (+1 more)

### Community 98 - ".sans"
Cohesion: 0.11
Nodes (18): .body, JustThisSheet, .body, .buttons, .isLast, .task, Row, StepsEditor (+10 more)

### Community 99 - "closeTunePopover"
Cohesion: 0.32
Nodes (8): closedClipPath(), closeTunePopover(), hideParamsPanel(), popoverDirection(), positionParamsPanel(), setClipPath(), showParamsPanel(), toggleTunePopover()

### Community 100 - "connectSSE"
Cohesion: 0.12
Nodes (27): buildCyclingRow(), connectSSE(), cycleVariant(), cyclingCounterText(), cyclingShownVariant(), ensureCyclingRenderable(), findAnyVariantsWrapper(), handleAccept() (+19 more)

## Knowledge Gaps
- **59 isolated node(s):** `PackageDescription`, `Security`, `.isToday`, `.progress`, `.base` (+54 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 575 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Reference Material` connect `Heuristics Scoring Guide` to `Persona-Based Design Testing`, `critique.md`, `Cognitive Load Assessment`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Are the 17 inferred relationships involving `TaskItem` (e.g. with `.body` and `.isLast`) actually correct?**
  _`TaskItem` has 17 INFERRED edges - model-reasoned connections that need verification._
- **What connects `PackageDescription`, `Security`, `.isToday` to the rest of the system?**
  _59 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Store` be split into smaller, more focused modules?**
  _Cohesion score 0.10779220779220779 - nodes in this community are weakly interconnected._
- **Why does `StilldayWidgetView` connect `StilldayWidgetView` to `View`, `Widgets.swift`, `Widgets.swift`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Are the 5 inferred relationships involving `Store` (e.g. with `.task` and `.open`) actually correct?**
  _`Store` has 5 INFERRED edges - model-reasoned connections that need verification._
- **Should `Filter` be split into smaller, more focused modules?**
  _Cohesion score 0.07936507936507936 - nodes in this community are weakly interconnected._