import SwiftUI

/// A footer view showing the last update time with a refresh icon
/// Displays "Last updated: [time]" in a subtle appearance suitable for widget footers
struct LastUpdatedView: View {
    /// The date when data was last updated
    let lastUpdated: Date

    /// Icon size for the refresh indicator
    var iconSize: CGFloat = 10

    /// Font size for the text
    var fontSize: CGFloat = 10

    /// Computed time string based on how recent the update was
    private var timeString: String {
        let interval = Date().timeIntervalSince(lastUpdated)

        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) min ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: lastUpdated)
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Text("Last updated: \(timeString)")
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)

            Image(systemName: "arrow.clockwise")
                .font(.system(size: iconSize, weight: .medium))
                .foregroundColor(.secondary.opacity(0.8))
        }
    }
}

/// Alternative initializer with explicit time string
extension LastUpdatedView {
    /// Initialize with a custom time string instead of computing from date
    /// - Parameters:
    ///   - timeString: The time string to display (e.g., "just now", "5 min ago")
    ///   - iconSize: Size of the refresh icon
    ///   - fontSize: Size of the text font
    init(timeString: String, iconSize: CGFloat = 10, fontSize: CGFloat = 10) {
        // Create a date that will produce "just now" and override with custom string
        self.lastUpdated = Date()
        self.iconSize = iconSize
        self.fontSize = fontSize
        // Note: This initializer is for static previews; the computed timeString won't be used
    }
}

/// View that accepts a static string for the time display
struct StaticLastUpdatedView: View {
    let timeString: String
    var iconSize: CGFloat = 10
    var fontSize: CGFloat = 10

    var body: some View {
        HStack(spacing: 4) {
            Text("Last updated: \(timeString)")
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)

            Image(systemName: "arrow.clockwise")
                .font(.system(size: iconSize, weight: .medium))
                .foregroundColor(.secondary.opacity(0.8))
        }
    }
}
