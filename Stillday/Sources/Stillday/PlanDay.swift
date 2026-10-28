import SwiftUI
import UIKit
#if canImport(FoundationModels)
import FoundationModels
#endif

enum AIPlanner {
    /// `text` is nil when Apple's on-device model could not answer; `note` then says why, in words you can act on.
    struct Answer {
        var text: String?
        var note = ""
    }

    static func ask(_ prompt: String) async -> Answer {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            switch SystemLanguageModel.default.availability {
            case .available:
                do {
                    let session = LanguageModelSession(instructions: "You plan a person's day. Follow the requested output format exactly.")
                    let response = try await session.respond(to: prompt)
                    return Answer(text: response.content)
                } catch {
                    return Answer(note: "Apple Intelligence returned an error: \(error.localizedDescription)")
                }
            case .unavailable(let reason):
                switch reason {
                case .deviceNotEligible:
                    return Answer(note: "This iPhone does not support Apple Intelligence.")
                case .appleIntelligenceNotEnabled:
                    return Answer(note: "Apple Intelligence is off. Turn it on in Settings, Apple Intelligence & Siri.")
                case .modelNotReady:
                    return Answer(note: "Apple Intelligence is still downloading its model. Try again later, on Wi-Fi and charging.")
                @unknown default:
                    return Answer(note: "Apple Intelligence is not available on this phone right now.")
                }
            @unknown default:
                return Answer(note: "Apple Intelligence is not available on this phone right now.")
            }
        }
        return Answer(note: "Apple Intelligence needs iOS 26 or later. This phone is on iOS \(UIDevice.current.systemVersion).")
        #else
        return Answer(note: "This build does not include Apple Intelligence.")
        #endif
    }
}

/// Pick a time window, get today's open tasks laid out in time, and apply the plan.
struct PlanDaySheet: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var start: Date
    @State private var end: Date
    @State private var blocks: [DayPlanner.Block] = []
    @State private var source = ""
    @State private var busy = false

    init() {
        let cal = Calendar.current
        let now = Date.now
        let quarter = (cal.component(.minute, from: now) / 15 + 1) * 15
        let from = cal.date(bySettingHour: cal.component(.hour, from: now), minute: 0, second: 0, of: now)?
            .addingTimeInterval(Double(quarter) * 60) ?? now
        let evening = cal.date(bySettingHour: 21, minute: 0, second: 0, of: now) ?? from.addingTimeInterval(7200)
        _start = State(initialValue: from)
        _end = State(initialValue: evening > from.addingTimeInterval(1800) ? evening : from.addingTimeInterval(7200))
    }

    private var open: [TaskItem] { store.today.filter { !$0.isDone } }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label12(text: "Plan my day").padding(.top, 26)

            if open.isEmpty {
                Text("Nothing left to plan today.").font(Theme.serif(22)).foregroundStyle(Theme.ink)
            } else {
                HStack(spacing: 12) {
                    picker("From", $start)
                    picker("Until", $end)
                }

                Button { Task { await generate() } } label: {
                    HStack(spacing: 8) {
                        if busy { ProgressView().tint(.white) }
                        Text(busy ? "Planning" : blocks.isEmpty ? "Plan \(open.count) task\(open.count == 1 ? "" : "s")" : "Plan again")
                            .font(Theme.sans(16, .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Theme.next, in: Capsule())
                }
                .buttonStyle(PressStyle())
                .disabled(busy || end <= start)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(blocks, id: \.id) { b in
                            HStack(alignment: .top, spacing: 12) {
                                Text(b.start.formatted(date: .omitted, time: .shortened))
                                    .font(Theme.sans(13, .medium)).foregroundStyle(Theme.next).monospacedDigit()
                                    .frame(width: 72, alignment: .leading)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(title(b.id)).font(Theme.sans(16, .medium)).foregroundStyle(Theme.ink)
                                    Text("\(b.minutes) min").font(Theme.sans(12)).foregroundStyle(Theme.mute)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 10)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            Divider().overlay(Theme.line)
                        }
                    }
                }
                .scrollIndicators(.hidden)

                if !source.isEmpty {
                    Text(source).font(Theme.sans(12)).foregroundStyle(Theme.mute)
                }
                if !blocks.isEmpty {
                    Button(action: apply) {
                        Text("Use this plan").font(Theme.sans(16, .semibold)).foregroundStyle(Theme.bg)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Theme.ink, in: Capsule())
                    }
                    .buttonStyle(PressStyle())
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 22).padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg.ignoresSafeArea())
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func picker(_ label: String, _ date: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label12(text: label)
            DatePicker("", selection: date, displayedComponents: .hourAndMinute).labelsHidden()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func title(_ id: UUID) -> String { store.tasks.first { $0.id == id }?.title ?? "" }

    private func generate() async {
        let items = open.map { DayPlanner.Item(id: $0.id, title: $0.title) }
        guard !items.isEmpty, end > start else { return }
        busy = true
        defer { busy = false }
        let cal = store.cal
        let result: [DayPlanner.Block]
        let answer = await AIPlanner.ask(DayPlanner.prompt(items, start: start, end: end, cal: cal))
        if let text = answer.text, let parsed = DayPlanner.parse(text, items: items, start: start, end: end, cal: cal) {
            result = parsed
            source = "Planned with Apple Intelligence, on this phone."
        } else {
            result = DayPlanner.even(items, start: start, end: end)
            source = answer.text == nil
                ? "Spaced evenly. " + answer.note
                : "Spaced evenly. Apple Intelligence answered, but its plan did not fit your window."
        }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { blocks = result }
    }

    private func apply() {
        store.setPlan(blocks)
        Sound.play(.add)
        store.showToast("Planned \(blocks.count) task\(blocks.count == 1 ? "" : "s")")
        dismiss()
    }
}
