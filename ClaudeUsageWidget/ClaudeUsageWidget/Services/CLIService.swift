import Foundation

/// Service for executing Claude CLI commands
final class CLIService: CLIServiceProtocol {
    /// Possible locations for the Claude CLI executable
    private static let searchPaths = [
        NSHomeDirectory() + "/.local/bin/claude",
        "/usr/local/bin/claude",
        "/opt/homebrew/bin/claude"
    ]

    /// Timeout for CLI execution in seconds
    private let timeoutSeconds: TimeInterval = 30

    /// Parser for CLI output
    private let parser: UsageParserProtocol

    /// Cached path to Claude CLI executable
    private var cachedClaudePath: String?

    /// The path to Claude CLI executable
    var claudePath: String {
        if let cached = cachedClaudePath {
            return cached
        }
        let path = findClaudePath() ?? ""
        cachedClaudePath = path
        return path
    }

    init(parser: UsageParserProtocol = UsageParser()) {
        self.parser = parser
    }

    /// Check if Claude CLI is available at expected path
    func isClaudeAvailable() -> Bool {
        let path = claudePath
        guard !path.isEmpty else { return false }
        return FileManager.default.isExecutableFile(atPath: path)
    }

    /// Execute `claude /usage` and return parsed data
    func fetchUsage() async throws -> UsageData {
        guard isClaudeAvailable() else {
            throw CLIServiceError.claudeNotFound
        }

        let output = try await executeClaudeUsage()

        do {
            return try parser.parse(output)
        } catch {
            throw CLIServiceError.parsingFailed(error.localizedDescription)
        }
    }

    /// Find the Claude CLI executable in search paths or PATH
    private func findClaudePath() -> String? {
        // Check known paths first
        for path in Self.searchPaths {
            if FileManager.default.isExecutableFile(atPath: path) {
                return path
            }
        }

        // Try to find in PATH using which
        if let pathFromWhich = findClaudeInPath() {
            return pathFromWhich
        }

        return nil
    }

    /// Search for claude in the system PATH using /usr/bin/which
    private func findClaudeInPath() -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = ["claude"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
            process.waitUntilExit()

            if process.terminationStatus == 0 {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !path.isEmpty {
                    return path
                }
            }
        } catch {
            // Silently fail and return nil
        }

        return nil
    }

    /// Execute the claude /usage command and return the output
    private func executeClaudeUsage() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: claudePath)
            process.arguments = ["/usage"]

            // Set up pipes for stdout and stderr
            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe

            // Set up environment with PATH to ensure subprocesses can find dependencies
            var environment = ProcessInfo.processInfo.environment
            let additionalPaths = [
                NSHomeDirectory() + "/.local/bin",
                "/usr/local/bin",
                "/opt/homebrew/bin"
            ]
            let currentPath = environment["PATH"] ?? "/usr/bin:/bin"
            environment["PATH"] = additionalPaths.joined(separator: ":") + ":" + currentPath
            process.environment = environment

            // Set up timeout
            let timeoutWorkItem = DispatchWorkItem {
                if process.isRunning {
                    process.terminate()
                }
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + self.timeoutSeconds, execute: timeoutWorkItem)

            // Handle process termination
            process.terminationHandler = { process in
                timeoutWorkItem.cancel()

                let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
                let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

                let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
                let stderr = String(data: stderrData, encoding: .utf8) ?? ""

                if process.terminationStatus != 0 {
                    let errorMessage = stderr.isEmpty ? "Exit code: \(process.terminationStatus)" : stderr
                    continuation.resume(throwing: CLIServiceError.executionFailed(errorMessage))
                    return
                }

                // Return stdout, or stderr if stdout is empty (some tools output to stderr)
                let output = stdout.isEmpty ? stderr : stdout
                continuation.resume(returning: output)
            }

            do {
                try process.run()
            } catch {
                timeoutWorkItem.cancel()
                continuation.resume(throwing: CLIServiceError.executionFailed(error.localizedDescription))
            }
        }
    }
}
