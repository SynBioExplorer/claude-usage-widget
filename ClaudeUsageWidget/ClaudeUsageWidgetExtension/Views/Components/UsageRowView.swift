import SwiftUI

/// A row view displaying a usage metric with title, subtitle, progress bar, and percentage
/// Matches the layout from the demo screenshot: title/subtitle on left, progress bar center, percentage right
struct UsageRowView: View {
    /// Title of the metric (e.g., "Current session")
    let title: String

    /// Subtitle showing reset time (e.g., "Resets in 3 hr 59 min")
    let subtitle: String?

    /// Progress value from 0.0 to 1.0
    let progress: Double

    /// Percentage to display (0-100)
    let percentage: Int

    /// Color for the progress bar fill
    var color: Color = .blue

    /// Height of the progress bar
    var progressBarHeight: CGFloat = 8

    /// Whether to show the subtitle
    var showSubtitle: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            // Title and subtitle section
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)

                if showSubtitle, let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            .frame(minWidth: 100, alignment: .leading)

            // Progress bar section
            GlassProgressBar(
                progress: progress,
                fillColor: color,
                height: progressBarHeight
            )

            // Percentage section
            Text("\(percentage)% used")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .frame(minWidth: 60, alignment: .trailing)
        }
    }
}

/// Convenience initializer using UsageRowConfiguration from contracts
extension UsageRowView {
    /// Initialize from a UsageRowConfiguration
    /// - Parameters:
    ///   - configuration: The configuration object defining row properties
    ///   - showSubtitle: Whether to show the subtitle (default: true)
    init(configuration: UsageRowConfiguration, showSubtitle: Bool = true) {
        self.title = configuration.title
        self.subtitle = configuration.subtitle
        self.progress = configuration.progress
        self.percentage = configuration.percentage
        self.color = configuration.color
        self.progressBarHeight = 8
        self.showSubtitle = showSubtitle
    }

    /// Initialize from a UsageMetric with custom title and color
    /// - Parameters:
    ///   - metric: The usage metric data
    ///   - title: The display title for this metric
    ///   - color: The progress bar fill color
    ///   - showSubtitle: Whether to show the reset time subtitle
    init(metric: UsageMetric, title: String, color: Color, showSubtitle: Bool = true) {
        self.title = title
        self.subtitle = metric.resetTimeString.map { "Resets \($0)" }
        self.progress = metric.progress
        self.percentage = metric.percentage
        self.color = color
        self.progressBarHeight = 8
        self.showSubtitle = showSubtitle
    }
}

#Preview {
    VStack(spacing: 16) {
        UsageRowView(
            title: "Current session",
            subtitle: "Resets in 3 hr 59 min",
            progress: 0.30,
            percentage: 30,
            color: .blue
        )

        UsageRowView(
            title: "All models",
            subtitle: "Resets Mon 1:00 PM",
            progress: 0.53,
            percentage: 53,
            color: .purple
        )

        UsageRowView(
            title: "Sonnet only",
            subtitle: "Resets Tue 5:00 PM",
            progress: 0.23,
            percentage: 23,
            color: .orange
        )

        // Compact version without subtitle
        UsageRowView(
            title: "Session",
            subtitle: nil,
            progress: 0.45,
            percentage: 45,
            color: .green,
            showSubtitle: false
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
