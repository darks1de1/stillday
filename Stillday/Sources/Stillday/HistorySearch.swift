import SwiftUI

private func dayTitle(_ d: Date) -> String {
    let cal = Calendar.current
    if cal.isDateInToday(d) { return "Today" }
    if cal.isDateInYesterday(d) { return "Yesterday" }
    return d.formatted(.dateTime.weekday(.wide).day().month(.abbreviated))
}

struct DayGroup: View {
    let day: Date
    let items: [TaskItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label12(text: dayTitle(day))
                Spacer()
                Text("\(items.filter(\.isDone).count)/\(items.count)")
                    .font(Theme.sans(12, .medium)).monospacedDigit().foregroundStyle(Theme.mute)
            }
            ForEach(items) { t in
                HStack(alignment: .top, spacing: 12) {
                    Circle().fill(t.isDone ? Theme.mute : Theme.ink).frame(width: 8, height: 8).padding(.top, 7)
                    Text(t.title).font(Theme.sans(15)).foregroundStyle(t.isDone ? Theme.mute : Theme.ink)
                    Spacer(minLength: 0)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.bottom, 18)
    }
}

struct HistoryView: View {
    enum Part: String, CaseIterable { case days = "Days", archive = "Archive", trash = "Trash" }
    @Environment(Store.self) private var store
    @State private var part = Part.days

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Label12(text: "Every day, kept")
                Text("History").font(Theme.serif(34)).foregroundStyle(Theme.ink).padding(.top, 4).padding(.bottom, 14)

                HStack(spacing: 8) {
                    ForEach(Part.allCases, id: \.self) { p in
                        let n = p == .archive ? store.folder(.archived).count : p == .trash ? store.folder(.trashed).count : 0
                        Button { withAnimation(.easeInOut(duration: 0.25)) { part = p } } label: {
                            Text(n > 0 ? "\(p.rawValue) \(n)" : p.rawValue).font(Theme.sans(13, .medium))
                                .foregroundStyle(part == p ? Theme.bg : Theme.ink)
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(part == p ? Theme.ink : Theme.soft, in: Capsule())
                        }
                        .buttonStyle(PressStyle())
                    }
                }
                .padding(.bottom, 16)

                Group {
                switch part {
                case .days:
                    let groups = store.groups()
                    if groups.isEmpty {
                        Text("Your days will collect here.").font(Theme.sans(15)).foregroundStyle(Theme.mute)
                    }
                    ForEach(groups, id: \.day) { g in DayGroup(day: g.day, items: g.items) }
                case .archive:
                    Folder(state: .archived)
                case .trash:
                    Folder(state: .trashed)
                }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }
}

/// Archive or Trash. Slide right to pull a task back; slide left to send it to Trash or delete it for good.
struct Folder: View {
    let state: TaskState
    @Environment(Store.self) private var store

    var body: some View {
        let items = store.folder(state)
        let isTrash = state == .trashed
        VStack(alignment: .leading, spacing: 0) {
            Text(isTrash ? "Slide right to restore, left to delete for good. Items are removed after \(Store.trashDays) days."
                         : "Done with, not gone. Slide right to bring a task back, left to trash it.")
                .font(Theme.sans(13)).foregroundStyle(Theme.mute).padding(.bottom, 10)
            if items.isEmpty {
                Text(isTrash ? "Trash is empty." : "Nothing archived yet.")
                    .font(Theme.sans(15)).foregroundStyle(Theme.mute).padding(.vertical, 12)
            }
            ForEach(items) { t in
                VStack(spacing: 0) {
                    SwipeRow(
                        leading: SwipeAction(icon: "arrow.uturn.backward", label: "Restore", color: Theme.restore) {
                            Sound.play(.restore)
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { store.restore(t.id) }
                            store.showToast("Restored to " + t.day.formatted(.dateTime.day().month(.abbreviated)))
                        },
                        trailing: SwipeAction(icon: "trash", label: isTrash ? "Delete" : "Trash", color: Theme.trash) {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                isTrash ? store.purge(t.id) : store.trash(t.id)
                            }
                        }
                    ) {
                        HStack(alignment: .top, spacing: 12) {
                            Circle().fill(t.isDone ? Theme.mute : Theme.ink).frame(width: 8, height: 8).padding(.top, 7)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(t.title).font(Theme.sans(16)).foregroundStyle(t.isDone ? Theme.mute : Theme.ink)
                                Text("from " + t.day.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)))
                                    .font(Theme.sans(12)).foregroundStyle(Theme.mute)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 11)
                    }
                    Divider().overlay(Theme.line)
                }
                .transition(.asymmetric(insertion: .opacity, removal: .offset(y: 12).combined(with: .opacity)))
            }
            if isTrash && !items.isEmpty {
                Button("Empty Trash") { withAnimation { store.emptyTrash() } }
                    .font(Theme.sans(14, .medium)).foregroundStyle(Theme.trash).padding(.top, 14)
            }
        }
    }
}

struct SearchView: View {
    enum Filter: String, CaseIterable { case all = "All", open = "Open", done = "Done" }
    @Environment(Store.self) private var store
    @State private var query = ""
    @State private var filter = Filter.all

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Label12(text: "Find anything")
                Text("Search").font(Theme.serif(34)).foregroundStyle(Theme.ink).padding(.top, 4).padding(.bottom, 16)

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass").foregroundStyle(Theme.mute)
                    TextField("Search all tasks", text: $query)
                }
                .padding(14)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Theme.line, lineWidth: 1))

                HStack(spacing: 8) {
                    ForEach(Filter.allCases, id: \.self) { f in
                        Button { withAnimation(.easeInOut(duration: 0.25)) { filter = f } } label: {
                            Text(f.rawValue).font(Theme.sans(13, .medium))
                                .foregroundStyle(filter == f ? Theme.bg : Theme.ink)
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(filter == f ? Theme.ink : Theme.soft, in: Capsule())
                        }
                        .buttonStyle(PressStyle())
                    }
                }
                .padding(.vertical, 12)

                let groups = store.groups(matching: query, done: filter == .all ? nil : filter == .done)
                VStack(alignment: .leading, spacing: 0) {
                    if groups.isEmpty {
                        Text("Nothing matches. Try fewer words.").font(Theme.sans(15)).foregroundStyle(Theme.mute)
                            .padding(.vertical, 10)
                    }
                    ForEach(groups, id: \.day) { g in DayGroup(day: g.day, items: g.items) }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }
}
