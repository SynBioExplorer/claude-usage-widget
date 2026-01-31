/**
 * Contract: WidgetViewProtocol
 * Version: 43677e3 (commit hash when contract was created)
 * Generated: 2025-01-31T18:50:00Z
 *
 * This protocol defines the view contracts for widget components.
 * Ensures consistent interface between reusable components and widget views.
 *
 * Consumers: task-widget-views
 */

import SwiftUI
import WidgetKit

// MARK: - Progress Bar Contract

/// Configuration for a glass-style progress bar
public struct ProgressBarConfiguration {
    /// Progress value from 0.0 to 1.0
    public let progress: Double

    /// Color for the filled portion
    public let fillColor: Color

    /// Label text (e.g., "30% used")
    public let label: String?

    /// Whether to show the percentage text
    public let showPercentage: Bool

    /// Height of the progress bar
    public let height: CGFloat

    public init(
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

// MARK: - Usage Row Contract

/// Configuration for a usage metric row in the widget
public struct UsageRowConfiguration {
    /// Title of the metric (e.g., "Current session")
    public let title: String

    /// Subtitle (e.g., "Resets in 3 hr 59 min")
    public let subtitle: String?

    /// Progress value from 0.0 to 1.0
    public let progress: Double

    /// Percentage to display
    public let percentage: Int

    /// Color for the progress bar
    public let color: Color

    public init(
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

// MARK: - Widget Entry Contract

/// Timeline entry for the widget
public struct UsageWidgetEntry: TimelineEntry {
    public let date: Date
    public let usageData: UsageData?
    public let preferences: UserPreferences
    public let isPlaceholder: Bool

    public init(
        date: Date,
        usageData: UsageData?,
        preferences: UserPreferences = UserPreferences(),
        isPlaceholder: Bool = false
    ) {
        self.date = date
        self.usageData = usageData
        self.preferences = preferences
        self.isPlaceholder = isPlaceholder
    }

    /// Create a placeholder entry for widget gallery
    public static func placeholder() -> UsageWidgetEntry {
        UsageWidgetEntry(
            date: Date(),
            usageData: UsageData(
                session: UsageMetric(percentage: 30, resetTimeString: "3 hr 59 min"),
                weeklyAll: UsageMetric(percentage: 53, resetTimeString: "Mon 1:00 PM"),
                weeklySonnet: UsageMetric(percentage: 23, resetTimeString: "Tue 5:00 PM"),
                lastUpdated: Date()
            ),
            preferences: UserPreferences(),
            isPlaceholder: true
        )
    }
}

// MARK: - Widget Size Helper

/// Helper enum for widget size-specific layouts
public enum WidgetSizeCategory {
    case small
    case medium
    case large

    /// Number of metrics to show for this size
    public var metricsCount: Int {
        switch self {
        case .small: return 1
        case .medium: return 2
        case .large: return 3
        }
    }

    /// Whether to show detailed subtitles
    public var showSubtitles: Bool {
        switch self {
        case .small: return false
        case .medium: return true
        case .large: return true
        }
    }

    /// Progress bar height for this size
    public var progressBarHeight: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }
}

// MARK: - Color Extension Contract

/// Extension to convert ColorPreference to SwiftUI Color
extension ColorPreference {
    public var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

// MARK: - Default Colors

/// Default colors matching the demo screenshot
public enum DefaultColors {
    public static let sessionBlue = Color(red: 0.22, green: 0.51, blue: 0.96)
    public static let weeklyPurple = Color(red: 0.5, green: 0.2, blue: 0.8)
    public static let sonnetOrange = Color(red: 0.95, green: 0.55, blue: 0.2)

    /// Background color for glass effect
    public static let glassBackground = Color.white.opacity(0.1)

    /// Border color for glass effect
    public static let glassBorder = Color.white.opacity(0.2)
}
