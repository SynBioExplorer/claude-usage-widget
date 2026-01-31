import SwiftUI

/// Configuration for a glass-style progress bar
struct ProgressBarConfiguration {
    /// Progress value from 0.0 to 1.0
    let progress: Double

    /// Color for the filled portion
    let fillColor: Color

    /// Label text (e.g., "30% used")
    let label: String?

    /// Whether to show the percentage text
    let showPercentage: Bool

    /// Height of the progress bar
    let height: CGFloat

    init(
        progress: Double,
        fillColor: Color,
        label: String? = nil,
        showPercentage: Bool = true,
        height: CGFloat = 8
    ) {
        self.progress = min(max(progress, 0), 1)
        self.fillColor = fillColor
        self.label = label
        self.showPercentage = showPercentage
        self.height = height
    }
}

/// Configuration for a usage metric row in the widget
struct UsageRowConfiguration {
    /// Title of the metric (e.g., "Current session")
    let title: String

    /// Subtitle (e.g., "Resets in 3 hr 59 min")
    let subtitle: String?

    /// Progress value from 0.0 to 1.0
    let progress: Double

    /// Percentage to display
    let percentage: Int

    /// Color for the progress bar
    let color: Color

    init(
        title: String,
        subtitle: String? = nil,
        progress: Double,
        percentage: Int,
        color: Color
    ) {
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        self.percentage = percentage
        self.color = color
    }
}

/// Default colors matching the demo screenshot
enum DefaultColors {
    static let sessionBlue = Color(red: 0.22, green: 0.51, blue: 0.96)
    static let weeklyPurple = Color(red: 0.5, green: 0.2, blue: 0.8)
    static let sonnetOrange = Color(red: 0.95, green: 0.55, blue: 0.2)

    /// Background color for glass effect
    static let glassBackground = Color.white.opacity(0.1)

    /// Border color for glass effect
    static let glassBorder = Color.white.opacity(0.2)
}
