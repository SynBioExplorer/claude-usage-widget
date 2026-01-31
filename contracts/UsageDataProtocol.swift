/**
 * Contract: UsageDataProtocol
 * Version: 43677e3 (commit hash when contract was created)
 * Generated: 2025-01-31T18:50:00Z
 *
 * This protocol defines the shared data model between:
 * - Main App (producer): CLIService parses and stores data
 * - Widget Extension (consumer): Reads data for display
 *
 * Consumers: task-widget-views, task-main-app
 */

import Foundation

// MARK: - Core Data Model

/// Represents a single usage metric with percentage and reset time
public struct UsageMetric: Codable, Equatable {
    /// Usage percentage (0-100)
    public let percentage: Int

    /// Human-readable reset time string (e.g., "4:59pm", "Jan 26 at 1:59pm")
    public let resetTimeString: String?

    /// Computed reset date if parseable
    public let resetDate: Date?

    public init(percentage: Int, resetTimeString: String? = nil, resetDate: Date? = nil) {
        self.percentage = percentage
        self.resetTimeString = resetTimeString
        self.resetDate = resetDate
    }
}

/// Complete usage data from Claude CLI
public struct UsageData: Codable, Equatable {
    /// Current session usage
    public let session: UsageMetric

    /// Weekly all models usage
    public let weeklyAll: UsageMetric

    /// Weekly Sonnet-only usage
    public let weeklySonnet: UsageMetric

    /// Timestamp when this data was fetched
    public let lastUpdated: Date

    public init(session: UsageMetric, weeklyAll: UsageMetric, weeklySonnet: UsageMetric, lastUpdated: Date = Date()) {
        self.session = session
        self.weeklyAll = weeklyAll
        self.weeklySonnet = weeklySonnet
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Shared Constants

/// App Group identifier for sharing data between app and widget
public let appGroupIdentifier = "group.com.agf.claudewidget"

/// UserDefaults keys for shared storage
public enum SharedStorageKeys {
    public static let usageData = "usageData"
    public static let userPreferences = "userPreferences"
    public static let lastFetchError = "lastFetchError"
}

// MARK: - User Preferences

/// User-customizable color settings for progress bars
public struct ColorPreference: Codable, Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

/// All user preferences stored in shared UserDefaults
public struct UserPreferences: Codable, Equatable {
    /// Color for session progress bar (default: blue)
    public var sessionColor: ColorPreference

    /// Color for weekly all models progress bar (default: purple)
    public var weeklyAllColor: ColorPreference

    /// Color for weekly Sonnet progress bar (default: orange)
    public var weeklySonnetColor: ColorPreference

    /// Auto-refresh interval in minutes (default: 15)
    public var refreshIntervalMinutes: Int

    public init(
        sessionColor: ColorPreference = ColorPreference(red: 0.0, green: 0.478, blue: 1.0),
        weeklyAllColor: ColorPreference = ColorPreference(red: 0.5, green: 0.0, blue: 0.5),
        weeklySonnetColor: ColorPreference = ColorPreference(red: 1.0, green: 0.5, blue: 0.0),
        refreshIntervalMinutes: Int = 15
    ) {
        self.sessionColor = sessionColor
        self.weeklyAllColor = weeklyAllColor
        self.weeklySonnetColor = weeklySonnetColor
        self.refreshIntervalMinutes = refreshIntervalMinutes
    }
}

// MARK: - Data Sharing Protocol

/// Protocol for services that share data between app and widget
public protocol DataSharingServiceProtocol {
    /// Save usage data to shared storage
    func saveUsageData(_ data: UsageData) throws

    /// Load usage data from shared storage
    func loadUsageData() -> UsageData?

    /// Save user preferences to shared storage
    func savePreferences(_ preferences: UserPreferences) throws

    /// Load user preferences from shared storage
    func loadPreferences() -> UserPreferences

    /// Notify widget to reload its timeline
    func notifyWidgetToReload()
}

// MARK: - CLI Service Protocol

/// Protocol for executing and parsing Claude CLI commands
public protocol CLIServiceProtocol {
    /// Execute `claude /usage` and return parsed data
    func fetchUsage() async throws -> UsageData

    /// Check if Claude CLI is available at expected path
    func isClaudeAvailable() -> Bool

    /// Get the path to Claude CLI executable
    var claudePath: String { get }
}

/// Errors that can occur during CLI operations
public enum CLIServiceError: Error, LocalizedError {
    case claudeNotFound
    case executionFailed(String)
    case parsingFailed(String)
    case timeout

    public var errorDescription: String? {
        switch self {
        case .claudeNotFound:
            return "Claude CLI not found. Please ensure Claude Code is installed."
        case .executionFailed(let message):
            return "Failed to execute Claude CLI: \(message)"
        case .parsingFailed(let message):
            return "Failed to parse usage data: \(message)"
        case .timeout:
            return "Claude CLI command timed out."
        }
    }
}

// MARK: - Usage Parser Protocol

/// Protocol for parsing CLI output into UsageData
public protocol UsageParserProtocol {
    /// Parse the raw CLI output string into UsageData
    func parse(_ output: String) throws -> UsageData
}
