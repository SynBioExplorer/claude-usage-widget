import Foundation

// MARK: - CLI Service Protocol

/// Protocol for executing and parsing Claude CLI commands
protocol CLIServiceProtocol {
    /// Execute `claude /usage` and return parsed data
    func fetchUsage() async throws -> UsageData

    /// Check if Claude CLI is available at expected path
    func isClaudeAvailable() -> Bool

    /// Get the path to Claude CLI executable
    var claudePath: String { get }
}

/// Errors that can occur during CLI operations
enum CLIServiceError: Error, LocalizedError {
    case claudeNotFound
    case executionFailed(String)
    case parsingFailed(String)
    case timeout

    var errorDescription: String? {
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
protocol UsageParserProtocol {
    /// Parse the raw CLI output string into UsageData
    func parse(_ output: String) throws -> UsageData
}

