import SwiftUI

/// "Just this": one tiny step at a time. Every step is a win on its own, and stopping early still counts.
struct JustThisSheet: View {
    let taskID: UUID
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var burst = 0
    @State private var busy = true
    @State private var doneHere = 0
    @State private var finished = false

    private var task: TaskItem? { store.tasks.first { $0.id == taskID } }
    private var isLast: Bool { (task?.steps.filter { !$0.done }.count ?? 0) == 1 }

    var body: some View {
        VStack(spacing: 0) {
            Label12(text: "Just this").padding(.top, 26)
            if let t = task {
                dots(t).padding(.top, 14)
                Spacer(minLength: 20)
                Group {
                    if busy {
                        VStack(spacing: 14) {
                            ProgressView().tint(Theme.next)
                            Text("Finding the smallest first step").font(Theme.sans(14)).foregroundStyle(Theme.mute)
                        }
                    } else if let step = t.currentStep {
                        VStack(spacing: 14) {
                            Text(step.title)
                                .font(Theme.serif(36)).foregroundStyle(Theme.ink).multilineTextAlignment(.center)
                            Text("That is all you have to do right now.").font(Theme.sans(14)).foregroundStyle(Theme.mute)
                        }
                        .padding(.horizontal, 28)
                        .id(step.id)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                removal: .move(edge: .leading).combined(with: .opacity)))
                    } else if finished {
                        Text("Done.").font(Theme.serif(40)).foregroundStyle(Theme.next)
                    }
                }
                Spacer(minLength: 20)
                buttons
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg.ignoresSafeArea())
        .overlay { if burst > 0 { Burst(count: 18, radius: 120).id(burst) } }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .task { await prepare() }
        .onDisappear(perform: finish)
    }

    private func dots(_ t: TaskItem) -> some View {
        HStack(spacing: 8) {
            ForEach(t.steps) { s in
                let current = s.id == t.currentStep?.id
                ZStack {
                    Circle().fill(s.done ? Theme.mute : current ? Theme.next : .clear)
                    Circle().stroke(s.done ? Theme.mute : current ? Theme.next : Theme.ink.opacity(0.5), lineWidth: 1.3)
                    if current { PulseRing() }
                }
                .frame(width: current ? 12 : 9, height: current ? 12 : 9)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: t.steps)
    }

    private var buttons: some View {
        VStack(spacing: 16) {
            Button(action: doneStep) {
                Text(isLast ? "Done. Finish it" : "Done")
                    .font(Theme.sans(18, .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 58)
                    .background(Theme.next.opacity(busy || task?.currentStep == nil ? 0.35 : 1), in: Capsule())
            }
            .buttonStyle(PressStyle())
            .disabled(busy || task?.currentStep == nil)

            HStack(spacing: 24) {
                Button("Too big? Make it smaller") { Task { await smaller() } }
                Button(doneHere > 0 ? "Stop here, that counts" : "Not now") { dismiss() }
            }
            .font(Theme.sans(13, .medium)).foregroundStyle(Theme.mute)
            .disabled(busy)
        }
        .padding(.horizontal, 24).padding(.bottom, 24)
    }

    /// Uses your own ladder for this task if you made one, then Apple Intelligence, then a plain ladder.
    private func prepare() async {
        guard let t = task else { dismiss(); return }
        if t.steps.isEmpty {
            var steps = Behavior.shared.ladder(for: t.title)
            if steps == nil {
                let answer = await AIPlanner.ask(Ladder.prompt(t.title))
                steps = answer.text.flatMap(Ladder.parse)
            }
            store.setSteps(taskID, steps ?? Ladder.fallback(t.title))
        }
        withAnimation { busy = false }
        if let step = task?.currentStep { FocusController.shared.start(taskID: taskID, title: step.title, minutes: 2) }
    }

    private func doneStep() {
        guard task?.currentStep != nil else { return }
        Sound.play(.complete)
        burst += 1
        doneHere += 1
        let last = withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { store.completeStep(taskID) }
        if last {
            finished = true
            if task?.isDone == false { store.toggle(taskID) }
            Sound.play(.cleared)
            store.showToast("Done. It started with one small step.")
            Task {
                try? await Task.sleep(nanoseconds: 900_000_000)
                dismiss()
            }
        } else if let next = task?.currentStep {
            FocusController.shared.update(title: next.title, minutes: 2)
        }
    }

    private func smaller() async {
        guard let step = task?.currentStep else { return }
        busy = true
        let answer = await AIPlanner.ask(Ladder.smallerPrompt(step.title))
        let text = answer.text.flatMap(Ladder.parseOne) ?? "Take one slow breath and look at where this happens"
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { store.insertStepBeforeCurrent(taskID, text) }
        busy = false
        if let s = task?.currentStep { FocusController.shared.update(title: s.title, minutes: 2) }
    }

    private func finish() {
        if doneHere > 0 {
            Behavior.shared.record(.init(date: .now, stepsDone: doneHere, steps: task?.steps.count ?? 0, finished: finished))
            if !finished { store.showToast("That counts. You showed up.") }
        }
        if FocusController.shared.taskID == taskID { FocusController.shared.end() }
    }
}

/// Edit a task's ladder by hand, or let the app suggest one.
struct StepsEditor: View {
    private struct Row: Identifiable { let id = UUID(); var text: String }

    let taskID: UUID
    let title: String
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var rows: [Row]
    @State private var busy = false

    init(task: TaskItem) {
        taskID = task.id
        title = task.title
        _rows = State(initialValue: task.steps.map { Row(text: $0.title) })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Label12(text: "Tiny steps").padding(.top, 26)
                Text(title).font(Theme.serif(24)).foregroundStyle(Theme.ink)
                Text("Make each step so small it is hard to refuse. The last one is the real task. Stopping early still counts.")
                    .font(Theme.sans(13)).foregroundStyle(Theme.mute)

                VStack(spacing: 0) {
                    ForEach($rows) { $row in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\((rows.firstIndex { $0.id == row.id } ?? 0) + 1)")
                                .font(Theme.sans(13, .medium)).foregroundStyle(Theme.next).monospacedDigit().padding(.top, 3)
                            TextField("Step", text: $row.text, axis: .vertical).font(Theme.sans(16, .medium))
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { rows.removeAll { $0.id == row.id } }
                            } label: {
                                Image(systemName: "xmark").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.mute)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding(.vertical, 10)
                        Divider().overlay(Theme.line)
                    }
                }

                HStack(spacing: 10) {
                    Button { withAnimation { rows.append(Row(text: "")) } } label: { pill("plus", "Add a step") }
                    Button { Task { await suggest() } } label: {
                        HStack(spacing: 6) {
                            if busy { ProgressView().tint(Theme.next) } else { Image(systemName: "sparkles").font(.system(size: 12, weight: .semibold)) }
                            Text("Suggest steps").font(Theme.sans(13, .semibold))
                        }
                        .foregroundStyle(Theme.next).padding(.horizontal, 14).padding(.vertical, 9)
                        .background(Theme.next.opacity(0.12), in: Capsule())
                    }
                    .disabled(busy)
                }
                .buttonStyle(PressStyle())

                Button {
                    store.setSteps(taskID, rows.map(\.text))
                    Sound.play(.add)
                    dismiss()
                } label: {
                    Text("Save").font(Theme.sans(16, .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52).background(Theme.next, in: Capsule())
                }
                .buttonStyle(PressStyle())
                .padding(.top, 6)
            }
            .padding(.horizontal, 22).padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background(Theme.bg.ignoresSafeArea())
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func pill(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 12, weight: .semibold))
            Text(text).font(Theme.sans(13, .semibold))
        }
        .foregroundStyle(Theme.ink).padding(.horizontal, 14).padding(.vertical, 9)
        .background(Theme.soft, in: Capsule())
    }

    private func suggest() async {
        busy = true
        defer { busy = false }
        var steps = Behavior.shared.ladder(for: title)
        if steps == nil {
            let answer = await AIPlanner.ask(Ladder.prompt(title))
            steps = answer.text.flatMap(Ladder.parse)
        }
        let result = steps ?? Ladder.fallback(title)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { rows = result.map { Row(text: $0) } }
    }
}
