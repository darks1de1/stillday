# Graph Report - ios-todo-app  (2026-10-27)

## Corpus Check
- 16 files · ~6,658 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 9 file(s) not represented in the graph (top: .ttf 5, .ipa 2, (none) 1)

## Summary
- 243 nodes · 527 edges · 14 communities (11 shown, 3 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 77 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Store
- Tab
- TaskRow
- SwipeRow
- VoiceSheet
- Tab
- AddBar
- xtool.yml
- CLAUDE.md
- PackageDescription
- .serif
- View
- .body
- Sound

## God Nodes (most connected - your core abstractions)
1. `Store` - 32 edges
2. `TaskItem` - 30 edges
3. `.body` - 21 edges
4. `.body` - 15 edges
5. `SwipeRow` - 13 edges
6. `Theme` - 13 edges
7. `MonthGrid` - 12 edges
8. `Sound` - 12 edges
9. `AddBar` - 11 edges
10. `.body` - 11 edges

## Surprising Connections (you probably didn't know these)
- `.body` --calls--> `days`  [INFERRED]
  Stillday/Sources/Stillday/WeekView.swift → Stillday/Sources/Stillday/HistorySearch.swift
- `.body` --calls--> `AddBar`  [INFERRED]
  Stillday/Sources/Stillday/PlanView.swift → Stillday/Sources/Stillday/Components.swift
- `.body` --calls--> `AddBar`  [INFERRED]
  Stillday/Sources/Stillday/TodayView.swift → Stillday/Sources/Stillday/Components.swift
- `.body` --references--> `TaskItem`  [INFERRED]
  Stillday/Sources/Stillday/HistorySearch.swift → Stillday/Sources/Stillday/Store.swift
- `.body` --calls--> `PressStyle`  [INFERRED]
  Stillday/Sources/Stillday/HistorySearch.swift → Stillday/Sources/Stillday/Theme.swift

## Import Cycles
- None detected.

## Communities (14 total, 3 thin omitted)

### Community 0 - "Store"
Cohesion: 0.15
Nodes (14): .body, DayStat, Store, .doneCount, .next, .streak, .today, .yesterdayOpen (+6 more)

### Community 1 - "Tab"
Cohesion: 0.10
Nodes (17): dayTitle(), Filter, all, done, open, Part, archive, days (+9 more)

### Community 2 - "TaskRow"
Cohesion: 0.10
Nodes (15): Color, UIColor, Bullet, .body, .tint, Burst, .body, Check (+7 more)

### Community 3 - "SwipeRow"
Cohesion: 0.20
Nodes (7): SwipeAction, SwipeRow, .action, .background, .body, .drag, .progress

### Community 4 - "VoiceSheet"
Cohesion: 0.16
Nodes (10): AVFoundation, Observation, Speech, Draft, Orb, .body, VoiceCapture, VoiceParser (+2 more)

### Community 5 - "Tab"
Cohesion: 0.18
Nodes (7): Foundation, Notifier, RootView, .tabBar, StilldayApp, .body, UserNotifications

### Community 6 - "AddBar"
Cohesion: 0.09
Nodes (11): AddBar, .body, .empty, MonthGrid, .body, .cal, .cells, .weekdays (+3 more)

### Community 7 - "xtool.yml"
Cohesion: 0.33
Nodes (5): bundleID, iconPath, infoPath, resources, version

### Community 11 - "View"
Cohesion: 0.16
Nodes (15): DayGroup, .body, Folder, HistoryView, .body, SearchView, .body, .body (+7 more)

### Community 12 - ".body"
Cohesion: 0.17
Nodes (6): .body, PlanView, ToastMsg, TodayView, .body, .summary

### Community 13 - "Sound"
Cohesion: 0.15
Nodes (11): AudioToolbox, Sound, add, archive, cleared, complete, .id, micOff (+3 more)

## Knowledge Gaps
- **45 isolated node(s):** `PackageDescription`, `.empty`, `archive`, `trash`, `all` (+40 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 86 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `TaskItem` connect `Store` to `TaskRow`, `View`, `.body`?**
  _High betweenness centrality (0.115) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Store` (e.g. with `StilldayApp` and `.celebrate()`) actually correct?**
  _`Store` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `PackageDescription`, `.empty`, `archive` to the rest of the system?**
  _45 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Store` be split into smaller, more focused modules?**
  _Cohesion score 0.14564564564564564 - nodes in this community are weakly interconnected._
- **Why does `.body` connect `.body` to `Store`, `TaskRow`, `SwipeRow`, `VoiceSheet`, `AddBar`, `View`?**
  _High betweenness centrality (0.113) - this node is a cross-community bridge._
- **Are the 9 inferred relationships involving `TaskItem` (e.g. with `.body` and `.doneCount`) actually correct?**
  _`TaskItem` has 9 INFERRED edges - model-reasoned connections that need verification._
- **Should `Tab` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._