import SwiftUI

struct WeekView: View {
    @Environment(Store.self) private var store
    @State private var grown = false
    @State private var drawn: CGFloat = 0
    @State private var counted = false

    var body: some View {
        let days = store.last7()
        let done = days.reduce(0) { $0 + $1.done }, total = days.reduce(0) { $0 + $1.total }
        let pcts = days.map { $0.total == 0 ? 0 : Double($0.done) / Double($0.total) }
        let best = pcts.firstIndex(of: pcts.max() ?? 0) ?? 6
        let maxTotal = max(days.map(\.total).max() ?? 1, 1)

        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Label12(text: "Last 7 days")
                (Text("A steady ") + Text("week.").font(Theme.serifItalic(34)).foregroundColor(Theme.mute))
                    .lineSpacing(-5).tracking(-0.3)
                    .font(Theme.serif(34)).foregroundStyle(Theme.ink).padding(.top, 4).padding(.bottom, 10)
                (Text(total == 0 ? "Nothing logged yet. " : "You finished ")
                    + Text(total == 0 ? "" : "\(done) of \(total)").foregroundColor(Theme.next)
                    + Text(total == 0 ? "" : " tasks. \(days[best].id.formatted(.dateTime.weekday(.wide))) was your best day."))
                    .font(Theme.serif(18)).foregroundStyle(Theme.ink)

                VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 9) {
                    ForEach(Array(days.enumerated()), id: \.element.id) { i, d in
                        let h = 110 * CGFloat(max(d.total, 1)) / CGFloat(maxTotal)
                        VStack(spacing: 6) {
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Theme.soft)
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(d.isToday ? Theme.next : Theme.ink)
                                    .frame(height: h * (d.total == 0 ? 0 : CGFloat(d.done) / CGFloat(d.total)))
                            }
                            .frame(height: grown ? h : 0)
                            .animation(.spring(response: 0.9, dampingFraction: 0.62).delay(Double(i) * 0.07), value: grown)
                            VStack(spacing: 3) {
                                Circle().fill(d.isToday ? Theme.next : .clear).frame(width: 4, height: 4)
                                Text(d.label).font(.system(size: 11, weight: d.isToday ? .semibold : .medium))
                                    .foregroundStyle(d.isToday ? Theme.next : Theme.mute)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 140, alignment: .bottom).padding(.top, 18)

                TrendLine(values: pcts, drawn: drawn).frame(height: 56).padding(.top, 8)
                }
                .padding(.top, 14)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible())], spacing: 10) {
                    stat(counted ? "\(total == 0 ? 0 : Int(round(Double(done) / Double(total) * 100)))%" : "0%", "completed")
                    stat(counted ? winDays(days) : "0 days", "with a win")
                    stat(total == 0 ? "None" : days[best].id.formatted(.dateTime.weekday(.abbreviated)), "best day")
                    stat(counted ? "\(total - done)" : "0", "still open")
                }
                .padding(.top, 14)

                Card {
                    VStack(alignment: .leading, spacing: 4) {
                        Label12(text: "Delivered")
                        Text("Every Sunday at 7 pm, as a notification and here.").font(Theme.serif(19)).foregroundStyle(Theme.ink)
                    }
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .onAppear {
            grown = true
            withAnimation(.easeOut(duration: 1.6).delay(0.3)) { drawn = 1 }
            withAnimation(.easeOut(duration: 0.9).delay(0.2)) { counted = true }
        }
    }

    private func winDays(_ days: [DayStat]) -> String {
        let n = days.filter { $0.done > 0 }.count
        return "\(n) day\(n == 1 ? "" : "s")"
    }

    private func stat(_ value: String, _ caption: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value).font(Theme.serif(28)).foregroundStyle(Theme.ink).monospacedDigit()
                .contentTransition(.numericText())
            Text(caption).font(Theme.sans(12)).foregroundStyle(Theme.mute)
        }
        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Theme.line, lineWidth: 1))
    }
}

/// Completion line: fades in from faint to full green, then breathes with a glow, a travelling light and a ringing end dot.
struct TrendLine: View {
    let values: [Double]
    let drawn: CGFloat

    private func point(_ i: Int, _ size: CGSize) -> CGPoint {
        let x = 6 + (size.width - 12) * CGFloat(i) / CGFloat(max(values.count - 1, 1))
        return CGPoint(x: x, y: size.height - 6 - (size.height - 12) * CGFloat(values[i]))
    }

    private func path(_ size: CGSize) -> Path {
        var p = Path()
        for i in values.indices { i == 0 ? p.move(to: point(i, size)) : p.addLine(to: point(i, size)) }
        return p
    }

    var body: some View {
        TimelineView(.animation) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate
            let breathe = (sin(t * 2 * .pi / 5 - .pi / 2) + 1) / 2
            let cycle = t.truncatingRemainder(dividingBy: 5) / 5
            let comet = min(1.16, cycle / 0.65 * 1.16)
            let ring = cycle
            GeometryReader { g in
                let style = StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round)
                let end = point(values.count - 1, g.size)
                ZStack {
                    path(g.size).trim(from: 0, to: drawn)
                        .stroke(LinearGradient(colors: [Theme.next.opacity(0.08), Theme.next], startPoint: .leading, endPoint: .trailing), style: style)
                        .shadow(color: Theme.next.opacity(0.5 * breathe * drawn), radius: 5)
                    path(g.size).trim(from: max(0, comet - 0.16), to: min(1, comet))
                        .stroke(Color.white.opacity(0.6 * drawn), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    Circle().stroke(Theme.next, lineWidth: 1.5).frame(width: 8, height: 8)
                        .scaleEffect(1 + 2.2 * ring).opacity(0.7 * (1 - ring) * drawn).position(end)
                    Circle().fill(Theme.next).frame(width: 8, height: 8).opacity(drawn).position(end)
                }
            }
        }
    }
}
