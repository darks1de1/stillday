import Foundation
import SwiftUI
import UIKit
import ActivityKit
import Security

/// What the app tells the widgets. Written by the app, read by the widget extension.
public struct WidgetSnapshot: Codable, Equatable {
    public var date: Date
    public var next: String?
    public var nextMinutes: Int?
    public var plannedAt: Date?
    public var done: Int
    public var total: Int
    public var streak: Int
    public var upcoming: [String]

    public init(date: Date = .now, next: String? = nil, nextMinutes: Int? = nil, plannedAt: Date? = nil,
                done: Int = 0, total: Int = 0, streak: Int = 0, upcoming: [String] = []) {
        self.date = date; self.next = next; self.nextMinutes = nextMinutes; self.plannedAt = plannedAt
        self.done = done; self.total = total; self.streak = streak; self.upcoming = upcoming
    }

    public static let sample = WidgetSnapshot(next: "Draft the Friday client brief", nextMinutes: 45, done: 2, total: 6, streak: 12,
                                              upcoming: ["Book dentist for next month", "Reply to Mira about the shoot"])

    /// A snapshot from an earlier day says nothing about today.
    public var isToday: Bool { Calendar.current.isDateInToday(date) }
    public var progress: Double { total == 0 ? 0 : Double(done) / Double(total) }
}

/// The app and the widget extension are signed with the same keychain access group, so a small snapshot kept in the
/// keychain is the one thing both can see. (xtool does not enable App Groups on free Apple IDs.)
public enum Shared {
    private static var base: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: "stillday.snapshot",
         kSecAttrAccount as String: "snapshot"]
    }

    public static func write(_ s: WidgetSnapshot) {
        guard let data = try? JSONEncoder().encode(s) else { return }
        SecItemDelete(base as CFDictionary)
        var add = base
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(add as CFDictionary, nil)
    }

    public static func read() -> WidgetSnapshot {
        var query = base
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var out: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &out) == errSecSuccess, let data = out as? Data,
              let s = try? JSONDecoder().decode(WidgetSnapshot.self, from: data) else { return WidgetSnapshot(date: .distantPast) }
        return s
    }
}

/// The task you decided to work on now, shown in the Dynamic Island and on the Lock Screen.
public struct FocusAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var title: String
        public var start: Date
        public var minutes: Int

        public init(title: String, start: Date, minutes: Int) {
            self.title = title; self.start = start; self.minutes = minutes
        }

        public var range: ClosedRange<Date> { start...start.addingTimeInterval(Double(max(minutes, 1)) * 60) }
    }

    public init() {}
}

/// The same colours as the app, so widgets look like part of it.
public enum Palette {
    private static func color(_ light: UInt32, _ dark: UInt32) -> Color {
        func ui(_ hex: UInt32) -> UIColor {
            UIColor(red: CGFloat((hex >> 16) & 255) / 255, green: CGFloat((hex >> 8) & 255) / 255, blue: CGFloat(hex & 255) / 255, alpha: 1)
        }
        return Color(UIColor { $0.userInterfaceStyle == .dark ? ui(dark) : ui(light) })
    }

    public static let bg = color(0xEEF1EC, 0x0D110F)
    public static let ink = color(0x151A16, 0xE9EEE9)
    public static let mute = color(0x9BA49D, 0x5F6A62)
    public static let next = color(0x2C9A5F, 0x4DC083)
    public static let soft = color(0x151A16, 0xE9EEE9).opacity(0.08)
}
