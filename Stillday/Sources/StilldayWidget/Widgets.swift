import WidgetKit
import SwiftUI
import StilldayShared

@main
struct StilldayBundle: WidgetBundle {
    var body: some Widget {
        StilldayWidget()
        FocusLiveActivity()
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let snap: WidgetSnapshot
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry { Entry(date: .now, snap: .sample) }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: .now, snap: context.isPreview ? .sample : Shared.read()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        // The app reloads this whenever a task changes; the refresh is only a safety net.
        completion(Timeline(entries: [Entry(date: .now, snap: Shared.read())], policy: .after(.now.addingTimeInterval(900))))
    }
}

struct StilldayWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "StilldayWidget", provider: Provider()) { entry in
            StilldayWidgetView(snap: entry.snap)
                .containerBackground(Palette.bg, for: .widget)
                .widgetURL(URL(string: "stillday://today"))
        }
        .configurationDisplayName("Stillday")
        .description("Your next task and today's progress.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct StilldayWidgetView: View {
    let snap: WidgetSnapshot
    @Environment(\.widgetFamily) private var family

    private var fresh: Bool { snap.isToday }
    private var title: String { fresh ? (snap.next ?? "All clear") : "Open Stillday" }
    private var counts: String { fresh ? "\(snap.done)/\(snap.total)" : "–" }
    private var progress: Double { fresh ? snap.progress : 0 }
    private var meta: String? {
        guard fresh, snap.next != nil else { return nil }
        let time = snap.plannedAt.map { $0.formatted(date: .omitted, time: .shortened) }
        let mins = snap.nextMinutes.map { "\($0) min" }
        return [time, mins].compactMap { $0 }.joined(separator: " · ")
    }

    var body: some View {
        switch family {
        case .systemSmall: small
        case .systemMedium: medium
        case .accessoryCircular: circular
        case .accessoryRectangular: rectangular
        case .accessoryInline: Text("Next: \(title)")
        default: small
        }
    }

    private var small: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("NEXT").font(.system(size: 10, weight: .medium)).tracking(1.2).foregroundStyle(Palette.mute)
                Spacer()
                Text(counts).font(.system(size: 11, weight: .medium)).monospacedDigit().foregroundStyle(Palette.mute)
            }
            Text(title)
                .font(.system(size: 17, weight: .medium, design: .serif))
                .foregroundStyle(Palette.next)
                .lineLimit(3)
                .minimumScaleFactor(0.85)
            if let meta, !meta.isEmpty {
                Text(meta).font(.system(size: 11)).foregroundStyle(Palette.mute)
            }
            Spacer(minLength: 0)
            ProgressView(value: progress).tint(Palette.next)
        }
    }

    private var medium: some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                Gauge(value: progress) {
                    EmptyView()
                } currentValueLabel: {
                    Text(counts).font(.system(size: 16, design: .serif)).monospacedDigit()
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(Palette.next)
                .scaleEffect(1.15)
                .frame(width: 64, height: 64)
                if fresh {
                    Text("Streak \(snap.streak)").font(.system(size: 11)).foregroundStyle(Palette.mute)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("NEXT").font(.system(size: 10, weight: .medium)).tracking(1.2).foregroundStyle(Palette.mute)
                Text(title)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundStyle(Palette.next)
                    .lineLimit(2)
                ForEach(fresh ? Array(snap.upcoming.prefix(2)) : [], id: \.self) { t in
                    HStack(spacing: 8) {
                        Circle().stroke(Palette.ink, lineWidth: 1.4).frame(width: 11, height: 11)
                        Text(t).font(.system(size: 12)).lineLimit(1).foregroundStyle(Palette.ink)
                    }
                }
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }
    }

    private var circular: some View {
        Gauge(value: progress) {
            EmptyView()
        } currentValueLabel: {
            Text(fresh ? "\(snap.done)" : "–").monospacedDigit()
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }

    private var rectangular: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("NEXT · \(counts)").font(.system(size: 10, weight: .medium)).tracking(1)
            Text(title).font(.system(size: 14, weight: .semibold)).lineLimit(2)
            ProgressView(value: progress)
        }
    }
}
