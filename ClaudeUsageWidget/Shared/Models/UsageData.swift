import Foundation

/// Represents a single usage metric with percentage and reset time
struct UsageMetric: Codable, Equatable {
    /// Usage percentage (0-100)
    let percentage: Int

    /// Human-readable reset time string (e.g., "3 hr 59 min", "Mon 1:00 PM")
    let resetTimeString: String?

    /// Computed reset date if parseable
    let resetDate: Date?

    init(percentage: Int, resetTimeString: String? = nil, resetDate: Date? = nil) {
        self.percentage = percentage
        self.resetTimeString = resetTimeString
        self.resetDate = resetDate
    }

    /// Progress value between 0.0 and 1.0
    var progress: Double {
        Double(percentage) / 100.0
    }
}

/// Complete usage data from Claude CLI
struct UsageData: Codable, Equatable {
    /// Current session usage
    let session: UsageMetric

    /// Weekly all models usage
    let weeklyAll: UsageMetric

    /// Weekly Sonnet-only usage
    let weeklySonnet: UsageMetric

    /// Timestamp when this data was fetched
    let lastUpdated: Date

    init(session: UsageMetric, weeklyAll: UsageMetric, weeklySonnet: UsageMetric, lastUpdated: Date = Date()) {
        self.session = session
        self.weeklyAll = weeklyAll
        self.weeklySonnet = weeklySonnet
        self.lastUpdated = lastUpdated
    }

    /// Create sample data for previews and placeholders
    static var placeholder: UsageData {
        UsageData(
            session: UsageMetric(percentage: 30, resetTimeString: "3 hr 59 min"),
            weeklyAll: UsageMetric(percentage: 53, resetTimeString: "Mon 1:00 PM"),
            weeklySonnet: UsageMetric(percentage: 23, resetTimeString: "Tue 5:00 PM"),
            lastUpdated: Date()
        )
    }
}
