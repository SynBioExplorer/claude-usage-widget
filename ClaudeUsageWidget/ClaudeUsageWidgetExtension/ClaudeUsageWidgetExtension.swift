import WidgetKit
import SwiftUI

struct ClaudeUsageWidgetExtension: Widget {
    let kind: String = "ClaudeUsageWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UsageTimelineProvider()) { entry in
            ClaudeUsageWidgetExtensionEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("Claude Usage")
        .description("Monitor your Claude Code usage limits")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClaudeUsageWidgetExtensionEntryView: View {
    var entry: UsageTimelineProvider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            MediumWidgetView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    ClaudeUsageWidgetExtension()
} timeline: {
    UsageWidgetEntry.placeholder()
}

#Preview(as: .systemMedium) {
    ClaudeUsageWidgetExtension()
} timeline: {
    UsageWidgetEntry.placeholder()
}

#Preview(as: .systemLarge) {
    ClaudeUsageWidgetExtension()
} timeline: {
    UsageWidgetEntry.placeholder()
}
