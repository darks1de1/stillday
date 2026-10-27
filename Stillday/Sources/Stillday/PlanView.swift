import SwiftUI

/// Month grid with task dots. Used by the Plan tab and the iPad side panel.
struct MonthGrid: View {
    @Environment(Store.self) private var store
    @Binding var month: Date
    @Binding var selected: Date
    var compact = false
    @State private var forward = true
    @Namespace private var ns

    private var cal: Calendar { store.cal }
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    private var cells: [Date?] {
        guard let start = cal.date(from: cal.dateComponents([.year, .month], from: month)),
              let range = cal.range(of: .day, in: .month, for: start) else { return [] }
        let lead = (cal.component(.weekday, from: start) - cal.firstWeekday + 7) % 7
        return Array(repeating: nil, count: lead) + range.compactMap { cal.date(byAdding: .day, value: $0 - 1, to: start) }
    }

    private var weekdays: [String] {
        let s = cal.veryShortStandaloneWeekdaySymbols
        let i = cal.firstWeekday - 1
        return Array(s[i...] + s[..<i])
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                (Text(month.formatted(.dateTime.month(.wide))).foregroundColor(Theme.ink)
                    + Text(" " + month.formatted(.dateTime.year())).foregroundColor(Theme.mute))
                    .font(Theme.serif(compact ? 22 : 34))
                Spacer()
                HStack(spacing: 4) {
                    arrow("chevron.left", -1)
                    arrow("chevron.right", 1)
                }
            }
            .padding(.bottom, compact ? 8 : 14)

            HStack(spacing: 0) {
                ForEach(Array(weekdays.enumerated()), id: \.offset) { _, w in
                    Text(w).font(Theme.sans(11, .medium)).foregroundStyle(Theme.mute).frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 6)

            LazyVGrid(columns: cols, spacing: compact ? 2 : 6) {
                ForEach(Array(cells.enumerated()), id: \.offset) { _, d in
                    if let d { cell(d) } else { Color.clear.frame(height: compact ? 40 : 46) }
                }
            }
            .id(month.formatted(.dateTime.year().month()))
            .transition(.asymmetric(insertion: .opacity.combined(with: .offset(x: forward ? 24 : -24)), removal: .identity))
        }
    }

    private func cell(_ d: Date) -> some View {
        let isSel = d == selected, isToday = cal.isDateInToday(d)
        let day = store.tasks(on: d)
        let open = day.filter { !$0.isDone }.count
        let size: CGFloat = compact ? 30 : 34
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { selected = d }
        } label: {
            VStack(spacing: 4) {
                Text("\(cal.component(.day, from: d))")
                    .font(.system(size: compact ? 14 : 16, weight: isSel ? .semibold : .regular)).monospacedDigit()
                    .foregroundStyle(isSel ? Theme.bg : isToday ? Theme.next : Theme.ink)
                    .frame(width: size, height: size)
                    .background {
                        if isSel {
                            Circle().fill(Theme.ink).matchedGeometryEffect(id: "sel", in: ns)
                        } else if isToday {
                            Circle().stroke(Theme.next, lineWidth: 1.5)
                        }
                    }
                HStack(spacing: 3) {
                    ForEach(0..<min(3, day.count), id: \.self) { i in
                        Circle().fill(i < open ? Theme.next : Theme.mute).frame(width: 4, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .frame(maxWidth: .infinity, minHeight: compact ? 40 : 46)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressStyle())
    }

    private func arrow(_ name: String, _ by: Int) -> some View {
        Button {
            forward = by > 0
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                month = cal.date(byAdding: .month, value: by, to: month) ?? month
            }
        } label: {
            Image(systemName: name).font(.system(size: 14, weight: .medium)).foregroundStyle(Theme.ink)
                .frame(width: compact ? 32 : 40, height: compact ? 32 : 40).background(Theme.soft, in: Circle())
        }
        .buttonStyle(PressStyle())
    }
}

/// Plan tab: pick a day, see and add its tasks.
struct PlanView: View {
    @Environment(Store.self) private var store
    @State private var month = Date.now
    @State private var selected = Calendar.current.startOfDay(for: .now)
    @FocusState private var focused: Bool
    @State private var showVoice = false

    var body: some View {
        let items = store.tasks(on: selected)
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Label12(text: "Plan ahead")
                    Spacer()
                    Button("Today") {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            month = .now
                            selected = store.startOfDay()
                        }
                    }
                    .font(Theme.sans(13, .medium)).foregroundStyle(Theme.next)
                }
                .padding(.bottom, 4)

                MonthGrid(month: $month, selected: $selected)

                Divider().overlay(Theme.line).padding(.vertical, 16)

                HStack {
                    Text(selected.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                        .font(Theme.serif(22)).foregroundStyle(Theme.ink)
                    Spacer()
                    Text(items.isEmpty ? "Nothing planned" : "\(items.filter(\.isDone).count)/\(items.count)")
                        .font(Theme.sans(12, .medium)).monospacedDigit().foregroundStyle(Theme.mute)
                }
                .padding(.bottom, 6)

                VStack(spacing: 0) {
                ForEach(items) { t in
                    VStack(spacing: 0) {
                        SwipeRow(
                            leading: SwipeAction(icon: "archivebox", label: "Archive", color: Theme.archive) { remove(t, archive: true) },
                            trailing: SwipeAction(icon: "trash", label: "Trash", color: Theme.trash) { remove(t, archive: false) }
                        ) {
                            TaskRow(task: t, isNext: t.id == items.first(where: { !$0.isDone })?.id) {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { store.toggle(t.id) }
                            }
                        }
                        Divider().overlay(Theme.line)
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                            removal: .offset(y: 12).combined(with: .opacity)))
                }
                }

                AddBar(placeholder: "Plan something for this day", focus: $focused, onVoice: { showVoice = true }) { store.add($0, on: selected) }
                    .padding(.top, 12)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $showVoice) { VoiceSheet(day: selected) }
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
