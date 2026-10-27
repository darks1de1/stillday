import SwiftUI

struct TodayView: View {
    @Environment(Store.self) private var store
    @FocusState private var focused: Bool
    @State private var showVoice = false
    @State private var showPlan = false
    @State private var clearBurst = 0
    @State private var wins = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Label12(text: Date.now.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)))
                    Spacer()
                    Button { showPlan = true } label: {
                        Image(systemName: "calendar").font(.system(size: 14, weight: .medium)).foregroundStyle(Theme.ink)
                            .frame(width: 30, height: 30).background(Theme.soft, in: Circle())
                    }
                    .buttonStyle(PressStyle())
                    .accessibilityLabel("Plan ahead")
                    HStack(spacing: 4) {
                        Text("Streak")
                        Text("\(store.streak)").foregroundStyle(Theme.next)
                            .contentTransition(.numericText())
                        Text(store.streak == 1 ? "day" : "days")
                    }
                    .font(Theme.sans(12, .medium)).monospacedDigit()
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Theme.soft, in: Capsule())
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: store.streak)
                }

                (Text("Today, ") + Text("one\nthing").font(Theme.serifItalic(34)).foregroundColor(Theme.mute) + Text(" at a time."))
                    .lineSpacing(-5).tracking(-0.3)
                    .font(Theme.serif(34)).foregroundStyle(Theme.ink)
                    .padding(.top, 4).padding(.bottom, 16)

                ProgressPulse(value: store.today.isEmpty ? 0 : Double(store.doneCount) / Double(store.today.count))
                    .padding(.bottom, 14)

                if !store.yesterdayOpen.isEmpty {
                    Button { withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { store.moveYesterdayToToday() } } label: {
                        Text("Move \(store.yesterdayOpen.count) from yesterday to today")
                            .font(Theme.sans(13, .medium)).foregroundStyle(Theme.next)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Theme.next.opacity(0.1), in: Capsule())
                    }
                    .buttonStyle(PressStyle()).padding(.bottom, 8)
                }

                if store.today.isEmpty {
                    Text("Nothing planned yet. Add the first thing.")
                        .font(Theme.sans(15)).foregroundStyle(Theme.mute).padding(.vertical, 24)
                }

                VStack(spacing: 0) {
                ForEach(store.today) { t in
                    VStack(spacing: 0) {
                        SwipeRow(
                            leading: SwipeAction(icon: "archivebox", label: "Archive", color: Theme.archive) { remove(t, archive: true) },
                            trailing: SwipeAction(icon: "trash", label: "Trash", color: Theme.trash) { remove(t, archive: false) }
                        ) {
                            TaskRow(task: t, isNext: t.id == store.next?.id) {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { store.toggle(t.id) }
                            }
                        }
                        Divider().overlay(Theme.line)
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                            removal: .offset(y: 12).combined(with: .opacity)))
                }
                }

                AddBar(placeholder: "Add a task", focus: $focused, onVoice: { showVoice = true }) { store.add($0) }
                    .padding(.top, 12)

                Card {
                    VStack(alignment: .leading, spacing: 4) {
                        Label12(text: "Day summary")
                        Text(summary).font(Theme.serif(19)).foregroundStyle(Theme.ink)
                    }
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .overlay { if clearBurst > 0 { Burst(count: 30, radius: 150).id(clearBurst) } }
        .sheet(isPresented: $showVoice) { VoiceSheet(day: store.startOfDay()) }
        .sheet(isPresented: $showPlan) {
            PlanView().background(Theme.bg.ignoresSafeArea()).presentationDragIndicator(.visible)
        }
        .sensoryFeedback(.success, trigger: store.doneCount)
        .onChange(of: store.doneCount) { old, new in if new > old { celebrate() } }
    }

    private var summary: String {
        let t = store.today.count, d = store.doneCount
        if t == 0 { return "A blank day. Add what matters." }
        if d == t { return "All \(t) done. A clear day." }
        return "\(d) of \(t) done. \(t - d) to go."
    }

    private func celebrate() {
        wins += 1
        let msgs = ["Nice. One down.", "Momentum building.", "Quietly excellent.", "That is how it is done."]
        var m = msgs[wins % msgs.count]
        if Int.random(in: 0..<5) == 0 { m = "Rare one: your longest-waiting task, gone." }
        if !store.today.isEmpty && store.today.allSatisfy(\.isDone) {
            clearBurst += 1
            m = "Day cleared. \(store.streak)-day streak."
        }
        Sound.play(m.hasPrefix("Day cleared") ? .cleared : .complete)
        store.showToast(m)
    }

    private func remove(_ t: TaskItem, archive: Bool) {
        Sound.play(archive ? .archive : .trash)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            archive ? store.archive(t.id) : store.trash(t.id)
        }
        store.showToast(archive ? "Moved to Archive" : "Moved to Trash") {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { store.restore(t.id) }
        }
    }
}

struct TaskRow: View {
    let task: TaskItem
    let isNext: Bool
    let action: () -> Void
    @Environment(Store.self) private var store
    @State private var burst = 0
    @State private var editing = false

    private var tint: Color { task.isDone ? Theme.mute : isNext ? Theme.next : Theme.ink }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                Bullet(done: task.isDone, next: isNext)
                    .overlay { if burst > 0 { Burst(count: 10, radius: 48).id(burst) } }
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(Theme.sans(17, .medium)).foregroundStyle(tint)
                        .multilineTextAlignment(.leading)
                        .overlay(alignment: .leading) {
                            Rectangle().fill(tint).frame(height: 1.5)
                                .scaleEffect(x: task.isDone ? 1 : 0, anchor: .leading)
                                .animation(.easeOut(duration: 0.4), value: task.isDone)
                        }
                    if let d = task.doneAt {
                        Text("done " + d.formatted(date: .omitted, time: .shortened))
                            .font(Theme.sans(12)).foregroundStyle(Theme.mute)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressStyle())
        .contextMenu {
            Button { editing = true } label: { Label("Edit", systemImage: "pencil") }
        }
        .sheet(isPresented: $editing) {
            EditSheet(initial: task.title) { store.rename(task.id, to: $0) }
        }
        .onChange(of: task.isDone) { _, done in if done { burst += 1 } }
    }
}

struct Bullet: View {
    let done: Bool
    let next: Bool

    private var tint: Color { done ? Theme.mute : next ? Theme.next : Theme.ink }

    var body: some View {
        ZStack {
            Circle().stroke(tint, lineWidth: 1.5)
            Circle().fill(done || next ? tint : .clear)
            if next && !done { PulseRing() }
            Check().trim(from: 0, to: done ? 1 : 0)
                .stroke(Theme.surface, style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
                .frame(width: 11, height: 9)
                .animation(.easeOut(duration: 0.35).delay(0.05), value: done)
        }
        .frame(width: 22, height: 22)
        .padding(.top, 1)
        .animation(.easeInOut(duration: 0.3), value: done)
        .animation(.easeInOut(duration: 0.3), value: next)
    }
}

struct PulseRing: View {
    @State private var on = false
    var body: some View {
        Circle().stroke(Theme.next, lineWidth: 1.5)
            .scaleEffect(on ? 1.7 : 1).opacity(on ? 0 : 0.55)
            .animation(.easeOut(duration: 2.6).repeatForever(autoreverses: false), value: on)
            .onAppear { on = true }
    }
}

struct Check: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.midY))
        p.addLine(to: CGPoint(x: r.width * 0.38, y: r.maxY))
        p.addLine(to: CGPoint(x: r.maxX, y: r.minY))
        return p
    }
}

/// A ripple plus particles. Re-created with `.id(n)` for each trigger, so it always starts from rest.
struct Burst: View {
    let count: Int
    let radius: CGFloat
    @State private var t: CGFloat = 0

    var body: some View {
        ZStack {
            Circle().stroke(Theme.next, lineWidth: 2).frame(width: 22, height: 22)
                .scaleEffect(1 + t * 3.5).opacity(1 - t)
            ForEach(0..<count, id: \.self) { k in
                let a = Double(k) / Double(count) * 2 * .pi + Double(k % 3) * 0.2
                let d = radius * (0.6 + 0.4 * CGFloat((k * 37) % 10) / 10)
                Circle().fill(k % 3 == 0 ? Theme.ink : Theme.next).frame(width: 6, height: 6)
                    .offset(x: CGFloat(cos(a)) * d * t, y: CGFloat(sin(a)) * d * t)
                    .scaleEffect(1 - 0.8 * t).opacity(1 - t)
            }
        }
        .allowsHitTesting(false)
        .onAppear { withAnimation(.easeOut(duration: 0.8)) { t = 1 } }
    }
}

/// Slim progress bar. Its leading edge pulses like the next-task bullet: a dot with a ring that expands and fades.
struct ProgressPulse: View {
    let value: Double

    var body: some View {
        GeometryReader { g in
            let w = max(5, g.size.width * value)
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.soft)
                Capsule()
                    .fill(LinearGradient(colors: [Theme.next.opacity(0.55), Theme.next], startPoint: .leading, endPoint: .trailing))
                    .frame(width: w)
                ZStack {
                    Circle().fill(Theme.next)
                    PulseRing()
                }
                .frame(width: 9, height: 9)
                .offset(x: w - 4.5)
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.85), value: value)
        }
        .frame(height: 5)
    }
}
