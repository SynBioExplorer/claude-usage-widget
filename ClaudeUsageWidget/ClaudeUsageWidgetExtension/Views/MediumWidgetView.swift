import SwiftUI
import WidgetKit

/// Medium widget view showing session and weekly all models usage
/// Layout matches the demo screenshot with two usage rows and last updated footer
struct MediumWidgetView: View {
    let entry: UsageWidgetEntry

    /// The usage data to display
    private var usageData: UsageData {
        entry.usageData ?? .placeholder
    }

    /// Session color from preferences
    private var sessionColor: Color {
        entry.preferences.sessionColor.color
    }

    /// Weekly all models color from preferences
    private var weeklyAllColor: Color {
        entry.preferences.weeklyAllColor.color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Plan usage limits")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.bottom, 10)

            // Session usage row
            UsageRowView(
                title: "Current session",
                subtitle: usageData.session.resetTimeString.map { "Resets in \($0)" },
                progress: usageData.session.progress,
                percentage: usageData.session.percentage,
                color: sessionColor
            )
            .padding(.bottom, 12)

            // Weekly limits section header
            VStack(alignment: .leading, spacing: 6) {
                Text("Weekly limits")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)

                // Weekly all models usage row
                UsageRowView(
                    title: "All models",
                    subtitle: usageData.weeklyAll.resetTimeString.map { "Resets \($0)" },
                    progress: usageData.weeklyAll.progress,
                    percentage: usageData.weeklyAll.percentage,
                    color: weeklyAllColor
                )
            }

            Spacer()

            // Last updated footer
            if let lastUpdated = entry.usageData?.lastUpdated {
                LastUpdatedView(lastUpdated: lastUpdated)
            } else {
                StaticLastUpdatedView(timeString: "never")
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .redacted(reason: entry.isPlaceholder ? .placeholder : [])
        .containerBackground(for: .widget) {
            GlassBackgroundView()
        }
    }
}

#Preview("Medium Widget") {
    MediumWidgetView(entry: UsageWidgetEntry(
        date: Date(),
        usageData: .placeholder,
        preferences: .default,
        isPlaceholder: false
    ))
    .frame(width: 329, height: 155)
    .background(Color.gray.opacity(0.2))
}

#Preview("Medium Widget - No Data") {
    MediumWidgetView(entry: UsageWidgetEntry(
        date: Date(),
        usageData: nil,
        preferences: .default,
        isPlaceholder: false
    ))
    .frame(width: 329, height: 155)
    .background(Color.gray.opacity(0.2))
}

#Preview("Medium Widget - Placeholder") {
    MediumWidgetView(entry: .placeholder())
        .frame(width: 329, height: 155)
        .background(Color.gray.opacity(0.2))
}
