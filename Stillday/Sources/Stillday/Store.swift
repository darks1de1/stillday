import Foundation
import Observation

enum TaskState: String, Codable { case active, archived, trashed }

/// One rung of a task's ladder of tiny steps.
struct TaskStep: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var done = false
}

struct TaskItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var day: Date
    var doneAt: Date?
    var order: Int
    var state: TaskState = .active
    var removedAt: Date?
    var plannedAt: Date?
    var minutes: Int?
    var steps: [TaskStep] = []
    var carried = 0
    var isDone: Bool { doneAt != nil }
    var currentStep: TaskStep? { steps.first { !$0.done } }
    /// You did at least the first small step. That counts as showing up.
    var started: Bool { steps.contains(where: \.done) }

    init(title: String, day: Date, order: Int) {
        self.title = title
        self.day = day
        self.order = order
    }

    // Saves from the first build have no state or removedAt.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        day = try c.decode(Date.self, forKey: .day)
        doneAt = try c.decodeIfPresent(Date.self, forKey: .doneAt)
        order = try c.decode(Int.self, forKey: .order)
        state = try c.decodeIfPresent(TaskState.self, forKey: .state) ?? .active
        removedAt = try c.decodeIfPresent(Date.self, forKey: .removedAt)
        plannedAt = try c.decodeIfPresent(Date.self, forKey: .plannedAt)
        minutes = try c.decodeIfPresent(Int.self, forKey: .minutes)
        steps = try c.decodeIfPresent([TaskStep].self, forKey: .steps) ?? []
        carried = try c.decodeIfPresent(Int.self, forKey: .carried) ?? 0
    }
}

struct DayStat: Identifiable {
    let id: Date
    let label: String
    let total: Int
    let done: Int
    let isToday: Bool
}

struct ToastMsg: Equatable {
    let id = UUID()
    let text: String
    var undo: (() -> Void)?
    static func == (a: ToastMsg, b: ToastMsg) -> Bool { a.id == b.id }
}

@MainActor @Observable
final class Store {
    static let shared = Store()

    var tasks: [TaskItem] = []
    var toast: ToastMsg?
    /// Set when you tap a nudge: Today opens "Just this" for that task.
    var openJustThis: UUID?
    @ObservationIgnored private let url = URL.documentsDirectory.appending(path: "tasks.json")
    @ObservationIgnored let cal = Calendar.current
    static let trashDays = 30

    init() {
        if let data = try? Data(contentsOf: url), let saved = try? JSONDecoder().decode([TaskItem].self, from: data) {
            tasks = saved
        }
        let cutoff = Date.now.addingTimeInterval(-Double(Store.trashDays) * 86_400)
        tasks.removeAll { $0.state == .trashed && ($0.removedAt ?? .now) < cutoff }
    }

    func startOfDay(_ d: Date = .now) -> Date { cal.startOfDay(for: d) }
    func day(offset: Int) -> Date { cal.date(byAdding: .day, value: offset, to: startOfDay()) ?? startOfDay() }

    /// Active tasks only: archived and trashed ones live in their own folders.
    func tasks(on d: Date) -> [TaskItem] {
        tasks.filter { $0.day == d && $0.state == .active }.sorted { $0.order < $1.order }
    }
    var today: [TaskItem] { tasks(on: startOfDay()) }
    var next: TaskItem? { today.first { !$0.isDone } }
    var doneCount: Int { today.filter(\.isDone).count }

    func add(_ title: String, on d: Date? = nil) {
        let t = title.trimmingCharacters(in: .whitespaces)
        guard !t.isEmpty else { return }
        let day = d ?? startOfDay()
        tasks.append(TaskItem(title: t, day: day, order: (tasks(on: day).last?.order ?? -1) + 1))
        commit()
    }

    func toggle(_ id: UUID) {
        guard let i = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[i].doneAt = tasks[i].isDone ? nil : .now
        if tasks[i].isDone { Behavior.shared.noteAction() }
        commit()
    }

    private func setState(_ id: UUID, _ s: TaskState) {
        guard let i = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[i].state = s
        tasks[i].removedAt = s == .active ? nil : .now
        commit()
    }
    func archive(_ id: UUID) { setState(id, .archived) }
    func trash(_ id: UUID) { setState(id, .trashed) }
    func restore(_ id: UUID) { setState(id, .active) }

    /// Gives tasks their start time and length, and puts them in time order at the top of today's list.
    func setPlan(_ blocks: [DayPlanner.Block]) {
        var order = 0
        for b in blocks.sorted(by: { $0.start < $1.start }) {
            guard let i = tasks.firstIndex(where: { $0.id == b.id }) else { continue }
            tasks[i].plannedAt = b.start
            tasks[i].minutes = b.minutes
            tasks[i].order = order
            order += 1
        }
        let placed = Set(blocks.map(\.id))
        for t in today where !placed.contains(t.id) {
            if let i = tasks.firstIndex(where: { $0.id == t.id }) { tasks[i].order = order; order += 1 }
        }
        commit()
    }

    /// Replaces the ladder. Steps you already did stay done if their words are unchanged.
    func setSteps(_ id: UUID, _ titles: [String]) {
        guard let i = tasks.firstIndex(where: { $0.id == id }) else { return }
        let old = tasks[i].steps
        tasks[i].steps = titles
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { t in old.first { $0.title == t } ?? TaskStep(title: t) }
        Behavior.shared.remember(tasks[i].title, tasks[i].steps.map(\.title))
        commit()
    }

    /// Marks the current step done. Returns true when that was the last one.
    @discardableResult
    func completeStep(_ id: UUID) -> Bool {
        guard let i = tasks.firstIndex(where: { $0.id == id }),
              let s = tasks[i].steps.firstIndex(where: { !$0.done }) else { return false }
        tasks[i].steps[s].done = true
        Behavior.shared.noteAction()
        commit()
        return !tasks[i].steps.contains { !$0.done }
    }

    /// Puts a smaller step in front of the current one.
    func insertStepBeforeCurrent(_ id: UUID, _ title: String) {
        guard let i = tasks.firstIndex(where: { $0.id == id }),
              let s = tasks[i].steps.firstIndex(where: { !$0.done }) else { return }
        tasks[i].steps.insert(TaskStep(title: title), at: s)
        commit()
    }

    func rename(_ id: UUID, to title: String) {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, let i = tasks.firstIndex(where: { $0.id == id }), tasks[i].title != t else { return }
        tasks[i].title = t
        commit()
    }

    func purge(_ id: UUID) {
        tasks.removeAll { $0.id == id }
        commit()
    }

    func emptyTrash() {
        tasks.removeAll { $0.state == .trashed }
        commit()
    }

    func folder(_ s: TaskState) -> [TaskItem] {
        tasks.filter { $0.state == s }.sorted { ($0.removedAt ?? .distantPast) > ($1.removedAt ?? .distantPast) }
    }

    var yesterdayOpen: [TaskItem] { tasks(on: day(offset: -1)).filter { !$0.isDone } }

    func moveYesterdayToToday() {
        let ids = Set(yesterdayOpen.map(\.id))
        var order = (today.last?.order ?? -1) + 1
        for i in tasks.indices where ids.contains(tasks[i].id) {
            tasks[i].day = startOfDay()
            tasks[i].order = order
            tasks[i].carried += 1
            order += 1
        }
        commit()
    }

    struct HelpOffer {
        let task: TaskItem
        let reason: String
    }

    /// What the app can see about whether you are avoiding this task right now.
    func signals(for t: TaskItem, now: Date = .now) -> Stuck.Signals {
        let b = Behavior.shared
        let overdue = t.plannedAt.map { max(0, Int(now.timeIntervalSince($0) / 60)) } ?? 0
        let quiet = now.timeIntervalSince(b.state.lastAction ?? .distantPast) > 45 * 60
        return Stuck.Signals(looks: b.looksSinceAction(now: now, cal: cal), ignored: b.ignoredStreak,
                             overdueMinutes: t.started ? 0 : overdue, carried: t.carried,
                             idleHours: b.idleHours(now: now, cal: cal), stalled: t.started && quiet)
    }

    /// Offer help only when the signs say you are stuck, and not while you have said "later".
    var helpNow: HelpOffer? {
        guard let t = next, Behavior.shared.snoozedUntil < .now else { return nil }
        let s = signals(for: t)
        return Stuck.needsHelp(s) ? HelpOffer(task: t, reason: Stuck.reason(s) ?? "") : nil
    }

    /// Archived tasks still count as wins and in the weekly numbers; trashed ones do not.
    private func counted(on d: Date) -> [TaskItem] { tasks.filter { $0.day == d && $0.state != .trashed } }

    /// A finished task, or a ladder you started, makes the day count.
    func hasWin(_ d: Date) -> Bool { counted(on: d).contains { $0.isDone || $0.started } }

    /// Consecutive days with at least one finished task, counting back from today (or yesterday if today has none yet).
    var streak: Int {
        var d = startOfDay()
        if !hasWin(d) { d = day(offset: -1) }
        var n = 0
        while hasWin(d) {
            n += 1
            d = cal.date(byAdding: .day, value: -1, to: d) ?? d
            if n > 3650 { break }
        }
        return n
    }

    func last7() -> [DayStat] {
        (-6...0).map { off in
            let d = day(offset: off)
            let items = counted(on: d)
            return DayStat(id: d, label: d.formatted(.dateTime.weekday(.narrow)), total: items.count,
                           done: items.filter(\.isDone).count, isToday: off == 0)
        }
    }

    func groups(matching q: String = "", done: Bool? = nil) -> [(day: Date, items: [TaskItem])] {
        let hits = tasks.filter { t in
            t.state == .active && (q.isEmpty || t.title.localizedCaseInsensitiveContains(q)) && (done == nil || t.isDone == done)
        }
        return Dictionary(grouping: hits, by: \.day)
            .sorted { $0.key > $1.key }
            .map { (day: $0.key, items: $0.value.sorted { $0.order < $1.order }) }
    }

    func showToast(_ text: String, undo: (() -> Void)? = nil) {
        let m = ToastMsg(text: text, undo: undo)
        toast = m
        Task {
            try? await Task.sleep(nanoseconds: undo == nil ? 2_200_000_000 : 3_500_000_000)
            if toast == m { toast = nil }
        }
    }

    private func commit() {
        if let data = try? JSONEncoder().encode(tasks) { try? data.write(to: url, options: .atomic) }
        Notifier.reschedule(self)
        WidgetBridge.publish(self)
        FocusController.shared.reconcile(self)
    }
}
