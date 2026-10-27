import Foundation
import UserNotifications

/// Task state only changes inside the app, so we re-plan the nudges on every change and every foreground.
/// iOS keeps at most 64 pending local notifications; this uses at most 12 plus one weekly.
@MainActor
enum Notifier {
    static func requestAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func reschedule(_ s: Store) {
        let c = UNUserNotificationCenter.current()
        let ids = (0...2).flatMap { d in ["m", "n", "e", "s"].map { "nudge-\(d)-\($0)" } }
        c.removePendingNotificationRequests(withIdentifiers: ids)

        let total = s.today.count, done = s.doneCount, left = total - done, streak = s.streak

        func add(_ slot: String, day: Int, _ h: Int, _ m: Int, _ body: String) {
            guard let base = s.cal.date(byAdding: .day, value: day, to: s.startOfDay()),
                  let when = s.cal.date(bySettingHour: h, minute: m, second: 0, of: base),
                  when > .now else { return }
            let content = UNMutableNotificationContent()
            content.title = "Stillday"
            content.body = body
            content.sound = .default
            let comps = s.cal.dateComponents([.year, .month, .day, .hour, .minute], from: when)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            c.add(UNNotificationRequest(identifier: "nudge-\(day)-\(slot)", content: content, trigger: trigger))
        }

        if total > 0 && done == 0 {
            add("m", day: 0, 8, 30, "\(total) today. One is quick.")
            add("n", day: 0, 13, 0, "Still blank. Start small?")
        }
        if left > 0 {
            add("e", day: 0, 18, 0, "\(left) left. " + (streak > 0 ? "Day \(streak) is on the line." : "Almost there."))
        }
        if done == 0 && streak > 0 {
            add("s", day: 0, 21, 0, "One tap saves day \(streak).")
        }
        func morning(_ d: Int) -> String {
            let n = s.tasks(on: s.day(offset: d)).count
            return n > 0 ? "\(n) planned today. Start with one." : "New day. One quick win?"
        }
        add("m", day: 1, 8, 30, morning(1))
        if streak > 0 { add("s", day: 1, 21, 0, "Your \(streak)-day streak needs one tap.") }
        add("m", day: 2, 8, 30, morning(2))

        let content = UNMutableNotificationContent()
        content.title = "Stillday"
        content.body = "Your week is in. Take a look."
        content.sound = .default
        let weekly = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 19, minute: 0, weekday: 1), repeats: true)
        c.add(UNNotificationRequest(identifier: "weekly", content: content, trigger: weekly))
    }
}
