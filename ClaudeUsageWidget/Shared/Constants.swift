import Foundation

/// App Group identifier for sharing data between main app and widget extension
let appGroupIdentifier = "group.com.agf.claudewidget"

/// UserDefaults keys for shared storage
enum SharedStorageKeys {
    static let usageData = "usageData"
    static let userPreferences = "userPreferences"
    static let lastFetchError = "lastFetchError"
}

/// Bundle identifiers
enum BundleIdentifiers {
    static let mainApp = "com.agf.ClaudeUsageWidget"
    static let widgetExtension = "com.agf.ClaudeUsageWidget.ClaudeUsageWidgetExtension"
}
