import SwiftUI
import UIKit

/// Text field with a green round Add button. Keeps focus after adding so the next task can be typed straight away.
struct AddBar: View {
    let placeholder: String
    var focus: FocusState<Bool>.Binding
    var onVoice: (() -> Void)? = nil
    let onAdd: (String) -> Void
    @State private var draft = ""

    private var empty: Bool { draft.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        HStack(spacing: 10) {
            TextField(placeholder, text: $draft)
                .focused(focus)
                .submitLabel(.done)
                .onSubmit(add)
            if let onVoice {
                Button(action: onVoice) {
                    Image(systemName: "mic.fill").font(.system(size: 15, weight: .medium)).foregroundStyle(Theme.ink)
                        .frame(width: 36, height: 36).background(Theme.soft, in: Circle())
                }
                .buttonStyle(PressStyle())
                .accessibilityLabel("Add tasks by voice")
            }
            Button(action: add) {
                Image(systemName: "plus").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Theme.next.opacity(empty ? 0.35 : 1), in: Circle())
                    .scaleEffect(empty ? 0.94 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: empty)
            }
            .buttonStyle(PressStyle())
            .disabled(empty)
            .sensoryFeedback(.impact(weight: .light), trigger: draft.isEmpty)
        }
        .padding(.leading, 14).padding(.trailing, 8).padding(.vertical, 8)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(focus.wrappedValue ? Theme.next : Theme.line, lineWidth: focus.wrappedValue ? 1.5 : 1))
        .animation(.easeOut(duration: 0.2), value: focus.wrappedValue)
    }

    private func add() {
        let t = draft.trimmingCharacters(in: .whitespaces)
        guard !t.isEmpty else { return }
        Sound.play(.add)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { onAdd(t) }
        draft = ""
        focus.wrappedValue = true
    }
}

/// Small sheet for changing a task's title.
struct EditSheet: View {
    let save: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var text: String
    @FocusState private var focused: Bool

    init(initial: String, save: @escaping (String) -> Void) {
        _text = State(initialValue: initial)
        self.save = save
    }

    private var empty: Bool { text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label12(text: "Edit task").padding(.top, 26)
            TextField("Task", text: $text, axis: .vertical)
                .font(Theme.sans(18, .medium))
                .focused($focused)
                .lineLimit(1...4)
                .padding(14)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Theme.next, lineWidth: 1.5))
            Button {
                save(text)
                Sound.play(.add)
                dismiss()
            } label: {
                Text("Save").font(Theme.sans(16, .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Theme.next.opacity(empty ? 0.35 : 1), in: Capsule())
            }
            .buttonStyle(PressStyle())
            .disabled(empty)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg.ignoresSafeArea())
        .presentationDetents([.height(270)])
        .presentationDragIndicator(.visible)
        .onAppear { focused = true }
    }
}
