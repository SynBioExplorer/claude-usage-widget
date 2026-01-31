import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "Claude Usage")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), message: "Loading...")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date(), message: "Claude Usage Widget")
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(900)))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
}

struct ClaudeUsageWidgetExtensionEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.message)
                .font(.headline)
            Text(entry.date, style: .time)
                .font(.caption)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct ClaudeUsageWidgetExtension: Widget {
    let kind: String = "ClaudeUsageWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ClaudeUsageWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Claude Usage")
        .description("Display Claude Code usage statistics")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    ClaudeUsageWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, message: "Preview")
}
