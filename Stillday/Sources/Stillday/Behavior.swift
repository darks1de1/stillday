import Foundation

/// Remembers when the app was opened, whether each nudge was answered, and how each "Just this" run went.
/// Stays on the phone.
@MainActor
final class Behavior {
    static let shared = Behavior()

    /// One sitting with a ladder: how far you got, and whether the whole task got done.
    struct Run: Codable {
        var date: Date
        var stepsDone: Int
        var steps: Int
        var finished: Bool
    }

    struct State: Codable {
        var opens: [Date] = []
        var outcomes: [Bool] = []          // true: you opened the app within 30 minutes of a nudge
        var pending: [Date] = []           // nudges scheduled but not yet judged
        var runs: [Run] = []
        var ladders: [String: [String]] = [:]   // your own steps, remembered by task title
        var lastAction: Date?              // last time you finished a task or a step
        var snoozedUntil: Date?            // "Later" on the stuck offer

        init() {}
        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            opens = try c.decodeIfPresent([Date].self, forKey: .opens) ?? []
            outcomes = try c.decodeIfPresent([Bool].self, forKey: .outcomes) ?? []
            pending = try c.decodeIfPresent([Date].self, forKey: .pending) ?? []
            runs = try c.decodeIfPresent([Run].self, forKey: .runs) ?? []
            ladders = try c.decodeIfPresent([String: [String]].self, forKey: .ladders) ?? [:]
            lastAction = try c.decodeIfPresent(Date.self, forKey: .lastAction)
            snoozedUntil = try c.decodeIfPresent(Date.self, forKey: .snoozedUntil)
        }
    }

    private(set) var state = State()
    private let url = URL.documentsDirectory.appending(path: "behavior.json")

    private init() {
        if let data = try? Data(contentsOf: url), let s = try? JSONDecoder().decode(State.self, from: data) { state = s }
    }

    /// Call every time the app comes to the foreground. Quick app switches inside five minutes are not counted as new opens.
    func recordOpen(now: Date = .now) {
        if state.opens.last.map({ now.timeIntervalSince($0) >= 300 }) ?? true { state.opens.append(now) }
        let cutoff = now.addingTimeInterval(-14 * 86_400)
        state.opens = Array(state.opens.filter { $0 > cutoff }.suffix(400))

        for fired in state.pending where fired <= now {
            state.outcomes.append(now.timeIntervalSince(fired) <= 30 * 60)
        }
        state.pending.removeAll { $0 <= now }
        state.outcomes = Array(state.outcomes.suffix(20))
        save()
    }

    func setPending(_ dates: [Date]) {
        state.pending = dates
        save()
    }

    var ignoredStreak: Int { state.outcomes.reversed().prefix { !$0 }.count }
    var answeredStreak: Int { state.outcomes.reversed().prefix { $0 }.count }

    func record(_ run: Run) {
        state.runs.append(run)
        state.runs = Array(state.runs.suffix(300))
        save()
    }

    func runs(since: Date) -> [Run] { state.runs.filter { $0.date >= since } }

    func remember(_ title: String, _ steps: [String]) {
        let k = Ladder.key(title)
        guard !k.isEmpty else { return }
        state.ladders[k] = steps
        save()
    }

    func ladder(for title: String) -> [String]? { state.ladders[Ladder.key(title)] }

    /// Finishing a task or a step is doing something; opening the app and looking is not.
    func noteAction(now: Date = .now) {
        state.lastAction = now
        state.snoozedUntil = nil
        save()
    }

    func snooze(hours: Double, now: Date = .now) {
        state.snoozedUntil = now.addingTimeInterval(hours * 3600)
        save()
    }

    var snoozedUntil: Date { state.snoozedUntil ?? .distantPast }

    /// Opens today since you last did anything. The open you are in counts.
    func looksSinceAction(now: Date = .now, cal: Calendar = .current) -> Int {
        let from = max(state.lastAction ?? .distantPast, cal.startOfDay(for: now))
        return state.opens.filter { $0 >= from && $0 <= now }.count
    }

    /// Hours of quiet since your last action (or your first open today), only between 8 am and 10 pm.
    func idleHours(now: Date = .now, cal: Calendar = .current) -> Double {
        let hour = cal.component(.hour, from: now)
        guard (8..<22).contains(hour) else { return 0 }
        let today = cal.startOfDay(for: now)
        let anchor = state.lastAction.map { max($0, today) } ?? state.opens.first { $0 >= today } ?? now
        return max(0, now.timeIntervalSince(anchor) / 3600)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(state) { try? data.write(to: url, options: .atomic) }
    }
}
