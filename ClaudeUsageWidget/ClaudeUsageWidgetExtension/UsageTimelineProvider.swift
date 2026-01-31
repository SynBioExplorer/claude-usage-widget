import WidgetKit
import SwiftUI

/// Timeline provider for the Claude Usage Widget
/// Reads data from shared UserDefaults via DataSharingService and creates timeline entries
struct UsageTimelineProvider: TimelineProvider {

    /// Shared data service for accessing usage data
    private let dataSharingService = DataSharingService.shared

    /// Default refresh interval in minutes
    private let defaultRefreshInterval: Int = 15

    // MARK: - TimelineProvider Protocol

    /// Provides a placeholder entry for the widget gallery
    /// Shows sample data with redacted appearance
    func placeholder(in context: Context) -> UsageWidgetEntry {
        UsageWidgetEntry.placeholder()
    }

    /// Provides a snapshot for the widget gallery and transient situations
    /// Returns current data if available, otherwise placeholder
    func getSnapshot(in context: Context, completion: @escaping (UsageWidgetEntry) -> Void) {
        let entry = createEntry(for: Date())
        completion(entry)
    }

    /// Provides the timeline of entries for the widget
    /// Schedules refresh based on user preferences (default: 15 minutes)
    func getTimeline(in context: Context, completion: @escaping (Timeline<UsageWidgetEntry>) -> Void) {
        let currentDate = Date()
        let entry = createEntry(for: currentDate)

        // Calculate next refresh time based on preferences
        let preferences = dataSharingService.loadPreferences()
        let refreshInterval = max(preferences.refreshIntervalMinutes, 5) // Minimum 5 minutes
        let nextRefreshDate = Calendar.current.date(
            byAdding: .minute,
            value: refreshInterval,
            to: currentDate
        ) ?? currentDate.addingTimeInterval(TimeInterval(refreshInterval * 60))

        // Create timeline with single entry and refresh policy
        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextRefreshDate)
        )

        completion(timeline)
    }

    // MARK: - Private Helpers

    /// Creates a timeline entry for the given date
    /// - Parameter date: The date for the entry
    /// - Returns: A configured UsageWidgetEntry
    private func createEntry(for date: Date) -> UsageWidgetEntry {
        let usageData = dataSharingService.loadUsageData()
        let preferences = dataSharingService.loadPreferences()

        return UsageWidgetEntry(
            date: date,
            usageData: usageData,
            preferences: preferences,
            isPlaceholder: false
        )
    }
}
