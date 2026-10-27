import ActivityKit
import WidgetKit
import SwiftUI
import StilldayShared

/// The task you chose to focus on: a ring that fills as its time runs, and the minutes left.
struct FocusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocusAttributes.self) { context in
            HStack(spacing: 14) {
                ring(context.state, size: 46)
                VStack(alignment: .leading, spacing: 2) {
                    Text("FOCUS NOW").font(.system(size: 10, weight: .medium)).tracking(1.2).foregroundStyle(Palette.mute)
                    Text(context.state.title)
                        .font(.system(size: 17, weight: .medium, design: .serif))
                        .foregroundStyle(Palette.next)
                        .lineLimit(2)
                    Text(timerInterval: context.state.range, countsDown: true)
                        .font(.system(size: 13)).monospacedDigit().foregroundStyle(Palette.mute)
                }
                Spacer(minLength: 0)
            }
            .padding(16)
            .activityBackgroundTint(Palette.bg)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { ring(context.state, size: 42) }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FOCUS NOW").font(.system(size: 9, weight: .medium)).tracking(1.2).foregroundStyle(.secondary)
                        Text(context.state.title)
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundStyle(Palette.next)
                            .lineLimit(2)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: context.state.range, countsDown: true)
                        .font(.system(size: 20, weight: .medium)).monospacedDigit()
                        .frame(width: 64, alignment: .trailing)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Stay with this one. Everything else can wait.")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
            } compactLeading: {
                ring(context.state, size: 20)
            } compactTrailing: {
                Text(timerInterval: context.state.range, countsDown: true)
                    .font(.system(size: 13, weight: .medium)).monospacedDigit()
                    .foregroundStyle(Palette.next)
                    .frame(width: 44)
            } minimal: {
                ring(context.state, size: 20)
            }
            .keylineTint(Palette.next)
        }
    }

    private func ring(_ state: FocusAttributes.ContentState, size: CGFloat) -> some View {
        ProgressView(timerInterval: state.range, countsDown: false) {
            EmptyView()
        } currentValueLabel: {
            EmptyView()
        }
        .progressViewStyle(.circular)
        .tint(Palette.next)
        .frame(width: size, height: size)
    }
}
