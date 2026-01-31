import Foundation

/// Parser for Claude CLI usage output
final class UsageParser: UsageParserProtocol {

    // MARK: - Regex Patterns

    /// Pattern for session usage: "Current session: 30% used (resets 4:59pm)" or similar
    private static let sessionPattern = #"Current session:\s*(\d+)%\s*used(?:\s*\(resets\s+(.+?)\))?"#

    /// Pattern for weekly all models: "Current week (all): 53% used (resets Mon 1:00 PM)"
    private static let weeklyAllPattern = #"Current week \(all\):\s*(\d+)%\s*used(?:\s*\(resets\s+(.+?)\))?"#

    /// Pattern for weekly Sonnet: "Current week (Sonnet): 23% used"
    private static let weeklySonnetPattern = #"Current week \(Sonnet\):\s*(\d+)%\s*used(?:\s*\(resets\s+(.+?)\))?"#

    // MARK: - Parsing

    /// Parse the raw CLI output string into UsageData
    func parse(_ output: String) throws -> UsageData {
        // Parse each metric type
        let session = try parseMetric(pattern: Self.sessionPattern, fieldName: "session", from: output)
        let weeklyAll = try parseMetric(pattern: Self.weeklyAllPattern, fieldName: "weekly all", from: output)
        let weeklySonnet = try parseMetric(pattern: Self.weeklySonnetPattern, fieldName: "weekly Sonnet", from: output)

        return UsageData(
            session: session,
            weeklyAll: weeklyAll,
            weeklySonnet: weeklySonnet,
            lastUpdated: Date()
        )
    }

    // MARK: - Private Parsing Methods

    /// Parse a single metric from the output using the given pattern
    private func parseMetric(pattern: String, fieldName: String, from output: String) throws -> UsageMetric {
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let range = NSRange(output.startIndex..., in: output)

        guard let match = regex.firstMatch(in: output, options: [], range: range) else {
            throw ParsingError.missingField(fieldName)
        }

        // Extract percentage (required, group 1)
        guard let percentageRange = Range(match.range(at: 1), in: output),
              let percentage = Int(output[percentageRange]) else {
            throw ParsingError.invalidFormat("Could not parse percentage for \(fieldName)")
        }

        // Extract reset time string (optional, group 2)
        var resetTimeString: String?
        if match.numberOfRanges > 2 {
            let resetRange = match.range(at: 2)
            if resetRange.location != NSNotFound,
               let range = Range(resetRange, in: output) {
                resetTimeString = String(output[range])
            }
        }

        // Try to parse reset date from the reset time string
        let resetDate = resetTimeString.flatMap { parseResetDate(from: $0) }

        return UsageMetric(
            percentage: percentage,
            resetTimeString: resetTimeString,
            resetDate: resetDate
        )
    }

    /// Attempt to parse a Date from a reset time string
    private func parseResetDate(from timeString: String) -> Date? {
        let calendar = Calendar.current
        let now = Date()

        // Try common formats
        let formatters: [DateFormatter] = [
            createFormatter("h:mma"),       // "4:59pm"
            createFormatter("h:mm a"),      // "4:59 PM"
            createFormatter("EEE h:mm a"),  // "Mon 1:00 PM"
            createFormatter("EEEE h:mm a"), // "Monday 1:00 PM"
            createFormatter("MMM d 'at' h:mma"),    // "Jan 26 at 1:59pm"
            createFormatter("MMM d 'at' h:mm a"),   // "Jan 26 at 1:59 PM"
        ]

        for formatter in formatters {
            if let date = formatter.date(from: timeString) {
                // Adjust to be relative to today/this week
                return adjustDateToFuture(date, relativeTo: now, using: calendar)
            }
        }

        // Try to handle relative time formats like "3 hr 59 min"
        if let relativeDate = parseRelativeTime(from: timeString) {
            return relativeDate
        }

        return nil
    }

    /// Create a date formatter with the given format
    private func createFormatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }

    /// Adjust a parsed date to be in the future relative to now
    private func adjustDateToFuture(_ date: Date, relativeTo now: Date, using calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.hour, .minute, .weekday, .month, .day], from: date)
        let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)

        // If we only have time, set it for today or tomorrow
        if components.month == nil && components.day == nil && components.weekday == nil {
            components.year = nowComponents.year
            components.month = nowComponents.month
            components.day = nowComponents.day

            if let adjustedDate = calendar.date(from: components), adjustedDate <= now {
                // Move to tomorrow if the time has passed
                return calendar.date(byAdding: .day, value: 1, to: adjustedDate) ?? adjustedDate
            }
        }

        // If we have a weekday, find the next occurrence
        if let weekday = components.weekday {
            var dateComponents = DateComponents()
            dateComponents.weekday = weekday
            dateComponents.hour = components.hour
            dateComponents.minute = components.minute

            if let nextDate = calendar.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime) {
                return nextDate
            }
        }

        return calendar.date(from: components) ?? date
    }

    /// Parse relative time strings like "3 hr 59 min" into a future Date
    private func parseRelativeTime(from timeString: String) -> Date? {
        let hourPattern = #"(\d+)\s*(?:hr|hour)"#
        let minPattern = #"(\d+)\s*(?:min|minute)"#

        var totalSeconds: TimeInterval = 0

        if let hourMatch = try? NSRegularExpression(pattern: hourPattern, options: .caseInsensitive)
            .firstMatch(in: timeString, range: NSRange(timeString.startIndex..., in: timeString)),
           let hourRange = Range(hourMatch.range(at: 1), in: timeString),
           let hours = Double(timeString[hourRange]) {
            totalSeconds += hours * 3600
        }

        if let minMatch = try? NSRegularExpression(pattern: minPattern, options: .caseInsensitive)
            .firstMatch(in: timeString, range: NSRange(timeString.startIndex..., in: timeString)),
           let minRange = Range(minMatch.range(at: 1), in: timeString),
           let minutes = Double(timeString[minRange]) {
            totalSeconds += minutes * 60
        }

        if totalSeconds > 0 {
            return Date().addingTimeInterval(totalSeconds)
        }

        return nil
    }
}

// MARK: - Parsing Errors

enum ParsingError: Error, LocalizedError {
    case missingField(String)
    case invalidFormat(String)

    var errorDescription: String? {
        switch self {
        case .missingField(let field):
            return "Could not find \(field) in CLI output"
        case .invalidFormat(let details):
            return "Invalid format: \(details)"
        }
    }
}
