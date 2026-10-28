import SwiftUI
import UserNotifications

/// Receives the buttons and taps on nudges.
final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        Notifier.registerCategories()
        return true
    }

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            didReceive response: UNNotificationResponse) async {
        let action = response.actionIdentifier
        let id = (response.notification.request.content.userInfo["task"] as? String).flatMap(UUID.init)
        await MainActor.run { Notifier.handle(action: action, task: id) }
    }
}

@main
struct StilldayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @State private var store = Store.shared
    @Environment(\.scenePhase) private var phase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .task {
                    Notifier.requestAuth()
                    FocusController.shared.endStale()
                    Behavior.shared.recordOpen()
                    Notifier.reschedule(store)
                    WidgetBridge.publish(store)
                }
                .onChange(of: phase) { _, p in
                    if p == .active {
                        Behavior.shared.recordOpen()
                        Notifier.reschedule(store)
                        WidgetBridge.publish(store)
                    }
                }
        }
    }
}

enum Tab: CaseIterable {
    case today, week, history, search
    var title: String { ["Today", "Week", "History", "Search"][Tab.allCases.firstIndex(of: self)!] }
    var icon: String {
        ["checkmark.circle", "chart.bar", "clock.arrow.circlepath", "magnifyingglass"][Tab.allCases.firstIndex(of: self)!]
    }
}

struct RootView: View {
    @Environment(Store.self) private var store
    @State private var tab = Tab.today
    @Namespace private var ns

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            Group {
                switch tab {
                case .today: TodayView()
                case .week: WeekView()
                case .history: HistoryView()
                case .search: SearchView()
                }
            }
            .id(tab)
            .transition(.opacity.combined(with: .offset(y: 8)))
        }
        .overlay(alignment: .bottom) {
            if let t = store.toast {
                HStack(spacing: 14) {
                    Text(t.text).font(Theme.sans(14, .medium)).foregroundStyle(Theme.bg)
                    if let undo = t.undo {
                        Button("Undo") { undo(); store.toast = nil }
                            .font(Theme.sans(14, .semibold)).foregroundStyle(Theme.next)
                    }
                }
                .padding(.horizontal, 18).padding(.vertical, 12)
                .background(Theme.ink, in: Capsule())
                .padding(.bottom, 90)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.8), value: store.toast)
        .onChange(of: store.openJustThis) { _, id in
            if id != nil { withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { tab = .today } }
        }
        .safeAreaInset(edge: .bottom) { tabBar }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { t in
                Button {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { tab = t }
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: t.icon).font(.system(size: 18, weight: .regular))
                        Text(t.title).font(Theme.sans(10.5, .medium))
                    }
                    .foregroundStyle(tab == t ? Theme.ink : Theme.mute)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background {
                        if tab == t {
                            Capsule().fill(Theme.soft).matchedGeometryEffect(id: "pill", in: ns)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(Theme.surface, in: Capsule())
        .overlay(Capsule().stroke(Theme.line, lineWidth: 1))
        .shadow(color: .black.opacity(0.12), radius: 14, y: 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}
