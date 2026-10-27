import Foundation

/// Decides when to nudge, from what the app can honestly observe: when you open it and whether a nudge was followed by an open.
/// iOS does not tell an app how often you unlock the phone or what other apps you use, so those are not inputs.
enum Planner {
    struct Input {
        var now: Date
        var opens: [Date]        // foreground opens, oldest first
        var ignoredStreak: Int   // latest nudges in a row that were not followed by an open
        var answeredStreak: Int  // latest nudges in a row that were
        var remaining: Int       // unfinished tasks today
        var cal: Calendar
    }

    static let defaultGap: TimeInterval = 90 * 60

    /// How long you usually stay away from the app on a day you use it: median of same-day gaps between opens.
    static func typicalGap(_ opens: [Date], cal: Calendar) -> TimeInterval {
        var gaps: [TimeInterval] = []
        for (a, b) in zip(opens, opens.dropFirst()) where cal.isDate(a, inSameDayAs: b) {
            let g = b.timeIntervalSince(a)
            if g >= 5 * 60 && g <= 4 * 3600 { gaps.append(g) }
        }
        guard gaps.count >= 3 else { return defaultGap }
        gaps.sort()
        return min(max(gaps[gaps.count / 2], 30 * 60), 150 * 60)
    }

    /// The hour your day usually ends: median hour of each day's last open, kept between 19 and 22.
    static func endHour(_ opens: [Date], cal: Calendar) -> Int {
        let lastPerDay = Dictionary(grouping: opens) { cal.startOfDay(for: $0) }.values.compactMap { $0.max() }
        guard lastPerDay.count >= 3 else { return 21 }
        let hours = lastPerDay.map { cal.component(.hour, from: $0) }.sorted()
        return min(max(hours[hours.count / 2] + 1, 19), 22)
    }

    /// Nudge times for the rest of today. Open the app often and the first nudge keeps moving back; stay away
    /// longer than usual and it arrives on schedule. Ignored nudges tighten the spacing, answered ones relax it.
    static func times(_ i: Input) -> [Date] {
        guard i.remaining > 0,
              let end = i.cal.date(bySettingHour: endHour(i.opens, cal: i.cal), minute: 0, second: 0, of: i.now),
              let earliest = i.cal.date(bySettingHour: 8, minute: 0, second: 0, of: i.now) else { return [] }

        var gap = typicalGap(i.opens, cal: i.cal)
        if i.ignoredStreak >= 2 { gap *= 0.75 } else if i.answeredStreak >= 3 { gap *= 1.3 }
        gap = min(max(gap, 30 * 60), 3 * 3600)

        let budget = min(6, i.remaining + 2)
        var out: [Date] = []
        var t = max(i.now.addingTimeInterval(gap), earliest)
        while t < end && out.count < budget {
            out.append(t)
            t = t.addingTimeInterval(gap)
        }
        return out
    }

    /// Short, specific and a little different each time. Wording gets more direct the more nudges are ignored.
    static func copy(ignored: Int, title: String, left: Int, streak: Int, index: Int) -> String {
        let t = title.count > 40 ? String(title.prefix(40)) + "…" : title
        switch ignored {
        case ..<2:
            return ["Next: \(t). Five minutes?", "\(left) left. \(t) is up.", "Small step: \(t)."][index % 3]
        case 2..<4:
            return ["Still waiting: \(t).", "\(t). You said it matters.", "Back to \(t)?"][index % 3]
        default:
            return streak > 0 ? "\(t) has been waiting. Day \(streak) is on the line." : "\(t) has been waiting. One tap to start."
        }
    }
}
