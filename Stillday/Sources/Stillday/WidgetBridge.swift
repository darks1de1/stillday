import Foundation
import WidgetKit
import ActivityKit
import StilldayShared

/// Hands today's state to the widgets and refreshes them.
@MainActor
enum WidgetBridge {
    static func publish(_ s: Store) {
        let open = s.today.filter { !$0.isDone }
        Shared.write(WidgetSnapshot(date: .now, next: open.first?.title, nextMinutes: open.first?.minutes,
                                    plannedAt: open.first?.plannedAt, done: s.doneCount, total: s.today.count,
                                    streak: s.streak, upcoming: open.dropFirst().prefix(3).map(\.title),
                                    step: open.first?.currentStep?.title))
        WidgetCenter.shared.reloadAllTimelines()
    }
}

/// The "focus on this task now" Live Activity: Dynamic Island and Lock Screen.
@MainActor @Observable
final class FocusController {
    static let shared = FocusController()

    private(set) var taskID: UUID?
    private(set) var title = ""
    @ObservationIgnored private var activity: Activity<FocusAttributes>?

    var isOn: Bool { taskID != nil }

    /// Returns false when Live Activities are turned off for the app in Settings.
    @discardableResult
    func start(_ t: TaskItem) -> Bool { start(taskID: t.id, title: t.title, minutes: t.minutes ?? 25) }

    @discardableResult
    func start(taskID id: UUID, title text: String, minutes: Int) -> Bool {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return false }
        end()
        let state = FocusAttributes.ContentState(title: text, start: .now, minutes: minutes)
        do {
            activity = try Activity.request(attributes: FocusAttributes(), content: .init(state: state, staleDate: nil))
            taskID = id
            title = text
            return true
        } catch {
            return false
        }
    }

    /// Moves the island to the next step and restarts its ring.
    func update(title text: String, minutes: Int) {
        guard let a = activity else { return }
        title = text
        let state = FocusAttributes.ContentState(title: text, start: .now, minutes: minutes)
        Task { await a.update(.init(state: state, staleDate: nil)) }
    }

    func end() {
        let old = activity
        activity = nil
        taskID = nil
        title = ""
        Task { await old?.end(nil, dismissalPolicy: .immediate) }
    }

    /// Ends the activity once its task is finished, moved or deleted.
    func reconcile(_ s: Store) {
        guard let id = taskID else { return }
        if !s.today.contains(where: { $0.id == id && !$0.isDone }) { end() }
    }

    /// Activities outlive the app, so after a relaunch there may be one we no longer track.
    func endStale() {
        for a in Activity<FocusAttributes>.activities { Task { await a.end(nil, dismissalPolicy: .immediate) } }
    }
}
