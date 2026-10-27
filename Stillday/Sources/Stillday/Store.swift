import Foundation
import Observation

enum TaskState: String, Codable { case active, archived, trashed }

struct TaskItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var day: Date
    var doneAt: Date?
    var order: Int
    var state: TaskState = .active
    var removedAt: Date?
    var isDone: Bool { doneAt != nil }

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
    var tasks: [TaskItem] = []
    var toast: ToastMsg?
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
            order += 1
        }
        commit()
    }

    /// Archived tasks still count as wins and in the weekly numbers; trashed ones do not.
    private func counted(on d: Date) -> [TaskItem] { tasks.filter { $0.day == d && $0.state != .trashed } }

    func hasWin(_ d: Date) -> Bool { counted(on: d).contains(where: \.isDone) }

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
    }
}
