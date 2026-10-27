import Foundation
import UserNotifications

/// Task state only changes inside the app, so nudges are re-planned on every change and every foreground.
/// iOS keeps at most 64 pending local notifications; this uses at most 6 nudges, a few fixed ones and one weekly.
@MainActor
enum Notifier {
    static func requestAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func reschedule(_ s: Store) {
        let c = UNUserNotificationCenter.current()
        let legacy = (0...2).flatMap { d in ["m", "n", "e", "s"].map { "nudge-\(d)-\($0)" } }
        let adaptive = (0..<8).map { "nudge-t-\($0)" }
        c.removePendingNotificationRequests(withIdentifiers: legacy + adaptive)

        func add(_ id: String, at when: Date, _ body: String) {
            guard when > .now else { return }
            let content = UNMutableNotificationContent()
            content.title = "Stillday"
            content.body = body
            content.sound = .default
            let comps = s.cal.dateComponents([.year, .month, .day, .hour, .minute], from: when)
            c.add(UNNotificationRequest(identifier: id, content: content,
                                        trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)))
        }
        func at(_ day: Int, _ h: Int, _ m: Int = 0) -> Date {
            let base = s.day(offset: day)
            return s.cal.date(bySettingHour: h, minute: m, second: 0, of: base) ?? base
        }

        let left = s.today.filter { !$0.isDone }
        let streak = s.streak
        let b = Behavior.shared

        let times = Planner.times(.init(now: .now, opens: b.state.opens, ignoredStreak: b.ignoredStreak,
                                        answeredStreak: b.answeredStreak, remaining: left.count, cal: s.cal))
        for (i, t) in times.enumerated() {
            let body = Planner.copy(ignored: b.ignoredStreak, title: left.first?.title ?? "your list",
                                    left: left.count, streak: streak, index: i)
            add("nudge-t-\(i)", at: t, body)
        }
        b.setPending(times)

        c.removePendingNotificationRequests(withIdentifiers: s.tasks.map { "plan-\($0.id.uuidString)" })
        for t in left {
            if let p = t.plannedAt { add("plan-\(t.id.uuidString)", at: p, "Time for \(t.title)" + (t.minutes.map { ". \($0) min." } ?? ".")) }
        }

        if s.doneCount == 0 && streak > 0 && !left.isEmpty {
            add("nudge-0-s", at: at(0, 21), "One tap saves day \(streak).")
        }
        func morning(_ d: Int) -> String {
            let n = s.tasks(on: s.day(offset: d)).count
            return n > 0 ? "\(n) planned today. Start with one." : "New day. One quick win?"
        }
        add("nudge-1-m", at: at(1, 8, 30), morning(1))
        if streak > 0 { add("nudge-1-s", at: at(1, 21), "Your \(streak)-day streak needs one tap.") }
        add("nudge-2-m", at: at(2, 8, 30), morning(2))

        let content = UNMutableNotificationContent()
        content.title = "Stillday"
        content.body = "Your week is in. Take a look."
        content.sound = .default
        let weekly = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 19, minute: 0, weekday: 1), repeats: true)
        c.add(UNNotificationRequest(identifier: "weekly", content: content, trigger: weekly))
    }
}
