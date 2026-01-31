import SwiftUI
import WidgetKit

/// Large widget view showing all three metrics with full details
/// Displays session, weekly all models, and weekly Sonnet usage with progress bars
struct LargeWidgetView: View {
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

    /// Weekly Sonnet color from preferences
    private var weeklySonnetColor: Color {
        entry.preferences.weeklySonnetColor.color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Plan usage limits")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.bottom, 14)

            // Session usage row
            UsageRowView(
                title: "Current session",
                subtitle: usageData.session.resetTimeString.map { "Resets in \($0)" },
                progress: usageData.session.progress,
                percentage: usageData.session.percentage,
                color: sessionColor,
                progressBarHeight: 10
            )
            .padding(.bottom, 16)

            // Weekly limits section
            VStack(alignment: .leading, spacing: 12) {
                Text("Weekly limits")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)

                // Weekly all models usage row
                UsageRowView(
                    title: "All models",
                    subtitle: usageData.weeklyAll.resetTimeString.map { "Resets \($0)" },
                    progress: usageData.weeklyAll.progress,
                    percentage: usageData.weeklyAll.percentage,
                    color: weeklyAllColor,
                    progressBarHeight: 10
                )

                // Weekly Sonnet usage row
                UsageRowView(
                    title: "Sonnet only",
                    subtitle: usageData.weeklySonnet.resetTimeString.map { "Resets \($0)" },
                    progress: usageData.weeklySonnet.progress,
                    percentage: usageData.weeklySonnet.percentage,
                    color: weeklySonnetColor,
                    progressBarHeight: 10
                )
            }

            Spacer()

            // Summary section
            HStack {
                // Usage summary
                VStack(alignment: .leading, spacing: 4) {
                    Text("Summary")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        UsageBadge(
                            label: "Session",
                            percentage: usageData.session.percentage,
                            color: sessionColor
                        )
                        UsageBadge(
                            label: "Weekly",
                            percentage: usageData.weeklyAll.percentage,
                            color: weeklyAllColor
                        )
                        UsageBadge(
                            label: "Sonnet",
                            percentage: usageData.weeklySonnet.percentage,
                            color: weeklySonnetColor
                        )
                    }
                }

                Spacer()

                // Last updated
                if let lastUpdated = entry.usageData?.lastUpdated {
                    LastUpdatedView(lastUpdated: lastUpdated, iconSize: 11, fontSize: 11)
                } else {
                    StaticLastUpdatedView(timeString: "never", iconSize: 11, fontSize: 11)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .redacted(reason: entry.isPlaceholder ? .placeholder : [])
    }
}

/// Small badge showing a usage percentage
private struct UsageBadge: View {
    let label: String
    let percentage: Int
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)

            Text("\(percentage)%")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview("Large Widget") {
    LargeWidgetView(entry: UsageWidgetEntry(
        date: Date(),
        usageData: .placeholder,
        preferences: .default,
        isPlaceholder: false
    ))
    .frame(width: 329, height: 345)
    .background(Color.gray.opacity(0.2))
}

#Preview("Large Widget - High Usage") {
    LargeWidgetView(entry: UsageWidgetEntry(
        date: Date(),
        usageData: UsageData(
            session: UsageMetric(percentage: 85, resetTimeString: "45 min"),
            weeklyAll: UsageMetric(percentage: 92, resetTimeString: "Fri 3:00 PM"),
            weeklySonnet: UsageMetric(percentage: 78, resetTimeString: "Sat 10:00 AM"),
            lastUpdated: Date()
        ),
        preferences: .default,
        isPlaceholder: false
    ))
    .frame(width: 329, height: 345)
    .background(Color.gray.opacity(0.2))
}

#Preview("Large Widget - Placeholder") {
    LargeWidgetView(entry: .placeholder())
        .frame(width: 329, height: 345)
        .background(Color.gray.opacity(0.2))
}
