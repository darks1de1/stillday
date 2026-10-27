import Foundation

/// Remembers when the app was opened and whether each nudge was answered. Stays on the phone.
@MainActor
final class Behavior {
    static let shared = Behavior()

    struct State: Codable {
        var opens: [Date] = []
        var outcomes: [Bool] = []   // true: you opened the app within 30 minutes of a nudge
        var pending: [Date] = []    // nudges scheduled but not yet judged
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

    private func save() {
        if let data = try? JSONEncoder().encode(state) { try? data.write(to: url, options: .atomic) }
    }
}
