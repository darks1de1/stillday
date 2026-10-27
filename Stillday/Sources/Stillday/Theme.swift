import SwiftUI
import UIKit

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(red: CGFloat((hex >> 16) & 255) / 255, green: CGFloat((hex >> 8) & 255) / 255, blue: CGFloat(hex & 255) / 255, alpha: 1)
    }
}

extension Color {
    init(_ light: UInt32, _ dark: UInt32) {
        self.init(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light) })
    }
}

enum Theme {
    static let bg = Color(0xEEF1EC, 0x0D110F)
    static let surface = Color(0xF9FAF7, 0x161C18)
    static let ink = Color(0x151A16, 0xE9EEE9)
    static let mute = Color(0x9BA49D, 0x5F6A62)
    static let next = Color(0x2C9A5F, 0x4DC083)
    static let soft = Color(0x151A16, 0xE9EEE9).opacity(0.06)
    static let line = Color(0x151A16, 0xE9EEE9).opacity(0.09)

    // Newsreader for titles and Hanken Grotesk for everything else, bundled in the app (see xtool.yml and Info.plist).
    // The preview is drawn on a 352 pt wide phone. Titles scale up with the real screen so they keep the same proportions.
    static let titleScale: CGFloat = max(1, min(1.15, UIScreen.main.bounds.width / 352))
    static func serif(_ size: CGFloat) -> Font { .custom("StilldayNewsreader-Regular", size: size * titleScale) }
    static func serifItalic(_ size: CGFloat) -> Font { .custom("StilldayNewsreader-Italic", size: size * titleScale) }
    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .medium: .custom("StilldayHanken-Medium", size: size)
        case .semibold, .bold, .heavy, .black: .custom("StilldayHanken-SemiBold", size: size)
        default: .custom("StilldayHanken-Regular", size: size)
        }
    }
}

struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Theme.line, lineWidth: 1))
    }
}

struct Label12: View {
    let text: String
    var body: some View {
        Text(text.uppercased()).font(.system(size: 12, weight: .medium)).tracking(1).foregroundStyle(Theme.mute)
    }
}
