import SwiftUI
import WidgetKit

/// Compact widget view showing only session usage with a circular progress indicator
/// Designed for the small widget size with minimal information density
struct SmallWidgetView: View {
    let entry: UsageWidgetEntry

    /// The session metric to display
    private var sessionMetric: UsageMetric {
        entry.usageData?.session ?? UsageMetric(percentage: 0, resetTimeString: nil)
    }

    /// Color for the session progress
    private var sessionColor: Color {
        entry.preferences.sessionColor.color
    }

    var body: some View {
        VStack(spacing: 8) {
            // Title
            Text("Claude Usage")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)

            Spacer()

            // Circular progress indicator
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        Color.gray.opacity(0.2),
                        lineWidth: 8
                    )

                // Progress circle
                Circle()
                    .trim(from: 0, to: sessionMetric.progress)
                    .stroke(
                        sessionColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                // Percentage text
                VStack(spacing: 2) {
                    Text("\(sessionMetric.percentage)%")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)

                    Text("session")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 70, height: 70)

            Spacer()

            // Reset time if available
            if let resetTime = sessionMetric.resetTimeString {
                Text("Resets \(resetTime)")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassBackground(cornerRadius: 20)
        .redacted(reason: entry.isPlaceholder ? .placeholder : [])
    }
}

/// Timeline entry for widget display
struct UsageWidgetEntry: TimelineEntry {
    let date: Date
    let usageData: UsageData?
    let preferences: UserPreferences
    let isPlaceholder: Bool

    init(
        date: Date,
        usageData: UsageData?,
        preferences: UserPreferences = .default,
        isPlaceholder: Bool = false
    ) {
        self.date = date
        self.usageData = usageData
        self.preferences = preferences
        self.isPlaceholder = isPlaceholder
    }

    /// Create a placeholder entry for widget gallery
    static func placeholder() -> UsageWidgetEntry {
        UsageWidgetEntry(
            date: Date(),
            usageData: .placeholder,
            preferences: .default,
            isPlaceholder: true
        )
    }
}

#Preview("Small Widget") {
    SmallWidgetView(entry: UsageWidgetEntry(
        date: Date(),
        usageData: .placeholder,
        preferences: .default,
        isPlaceholder: false
    ))
    .frame(width: 155, height: 155)
    .background(Color.gray.opacity(0.2))
}

#Preview("Small Widget - Placeholder") {
    SmallWidgetView(entry: .placeholder())
        .frame(width: 155, height: 155)
        .background(Color.gray.opacity(0.2))
}
