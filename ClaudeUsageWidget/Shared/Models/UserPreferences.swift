import Foundation
import SwiftUI

/// User-customizable color settings for progress bars
struct ColorPreference: Codable, Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(color: Color) {
        // Note: This is a simplified conversion; in production you'd want to use CGColor
        self.red = 0.22
        self.green = 0.51
        self.blue = 0.96
        self.alpha = 1.0
    }

    /// Convert to SwiftUI Color
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }

    // MARK: - Default Colors

    /// Default blue for session progress bar
    static let defaultSession = ColorPreference(red: 0.22, green: 0.51, blue: 0.96)

    /// Default purple for weekly all models progress bar
    static let defaultWeeklyAll = ColorPreference(red: 0.5, green: 0.2, blue: 0.8)

    /// Default orange for weekly Sonnet progress bar
    static let defaultWeeklySonnet = ColorPreference(red: 0.95, green: 0.55, blue: 0.2)
}

/// All user preferences stored in shared UserDefaults
struct UserPreferences: Codable, Equatable {
    /// Color for session progress bar (default: blue)
    var sessionColor: ColorPreference

    /// Color for weekly all models progress bar (default: purple)
    var weeklyAllColor: ColorPreference

    /// Color for weekly Sonnet progress bar (default: orange)
    var weeklySonnetColor: ColorPreference

    /// Auto-refresh interval in minutes (default: 15)
    var refreshIntervalMinutes: Int

    init(
        sessionColor: ColorPreference = .defaultSession,
        weeklyAllColor: ColorPreference = .defaultWeeklyAll,
        weeklySonnetColor: ColorPreference = .defaultWeeklySonnet,
        refreshIntervalMinutes: Int = 15
    ) {
        self.sessionColor = sessionColor
        self.weeklyAllColor = weeklyAllColor
        self.weeklySonnetColor = weeklySonnetColor
        self.refreshIntervalMinutes = refreshIntervalMinutes
    }

    /// Default preferences
    static let `default` = UserPreferences()
}
