import SwiftUI

extension Theme {
    static let trash = Color(0xD2574A, 0xE5776A)
    static let archive = Color(0x5B7FB0, 0x7FA2D1)
    static let restore = Color(0x2C9A5F, 0x4DC083)
}

struct SwipeAction {
    let icon: String
    let label: String
    let color: Color
    let run: () -> Void
}

/// Row you can slide: right reveals `leading`, left reveals `trailing`. The colour fades in with the drag,
/// the icon pops and a haptic fires once the swipe is far enough to commit.
struct SwipeRow<Content: View>: View {
    var leading: SwipeAction?
    var trailing: SwipeAction?
    @ViewBuilder var content: Content

    @State private var dx: CGFloat = 0
    @State private var engaged = false
    @State private var crossed = false
    private let commit: CGFloat = 96

    private var progress: CGFloat { min(1, abs(dx) / commit) }
    private var action: SwipeAction? { dx > 0 ? leading : trailing }

    var body: some View {
        ZStack {
            background
            content
                .background(dx == 0 ? Color.clear : Theme.bg)
                .offset(x: dx)
                .simultaneousGesture(drag)
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: crossed)
    }

    @ViewBuilder private var background: some View {
        if dx != 0, let a = action {
            ZStack(alignment: dx > 0 ? .leading : .trailing) {
                a.color.opacity(0.12 + 0.88 * progress)
                VStack(spacing: 3) {
                    Image(systemName: a.icon).font(.system(size: 18, weight: .medium))
                    Text(a.label).font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 26)
                .scaleEffect(crossed ? 1.12 : 0.85 + 0.15 * progress)
                .opacity(progress)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: crossed)
            }
        }
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { v in
                if !engaged {
                    guard abs(v.translation.width) > abs(v.translation.height) * 1.4 else { return }
                    engaged = true
                }
                let w = v.translation.width
                if (w > 0 && leading == nil) || (w < 0 && trailing == nil) { dx = 0; return }
                dx = w
                let c = abs(w) >= commit
                if c != crossed { crossed = c }
            }
            .onEnded { _ in
                guard engaged else { return }
                engaged = false
                crossed = false
                let a = action
                if abs(dx) >= commit, let a {
                    withAnimation(.easeIn(duration: 0.2)) { dx = dx > 0 ? 500 : -500 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                        a.run()
                        dx = 0
                    }
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { dx = 0 }
                }
            }
    }
}
