import AppKit
import WidgetKit
import Combine

/// Application delegate handling background refresh scheduling for the menu bar app
/// Periodically fetches usage data and triggers widget timeline reloads
class AppDelegate: NSObject, NSApplicationDelegate {
    /// Timer for periodic background refresh
    private var refreshTimer: Timer?

    /// CLI service for fetching usage data
    private let cliService: CLIServiceProtocol = CLIService()

    /// Data sharing service for persisting data to widget
    private let dataSharingService = DataSharingService.shared

    /// Cancellables for async operations
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon (LSUIElement is already set in Info.plist)
        NSApp.setActivationPolicy(.accessory)

        // Start background refresh timer
        setupRefreshTimer()

        // Perform initial fetch
        Task {
            await fetchAndUpdateUsage()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup timer
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    // MARK: - Background Refresh

    /// Set up the periodic refresh timer based on user preferences
    private func setupRefreshTimer() {
        refreshTimer?.invalidate()

        let preferences = dataSharingService.loadPreferences()
        let intervalMinutes = max(preferences.refreshIntervalMinutes, 5) // Minimum 5 minutes
        let intervalSeconds = TimeInterval(intervalMinutes * 60)

        refreshTimer = Timer.scheduledTimer(withTimeInterval: intervalSeconds, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.fetchAndUpdateUsage()
            }
        }

        // Ensure timer runs in common mode for background operation
        if let timer = refreshTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    /// Fetch usage data from CLI and update shared storage
    private func fetchAndUpdateUsage() async {
        guard cliService.isClaudeAvailable() else {
            dataSharingService.saveLastError("Claude CLI not found")
            return
        }

        do {
            let usageData = try await cliService.fetchUsage()

            // Save to shared storage for widget access
            try dataSharingService.saveUsageData(usageData)
            dataSharingService.saveLastError(nil)

            // Trigger widget timeline reload
            dataSharingService.notifyWidgetToReload()

        } catch {
            dataSharingService.saveLastError(error.localizedDescription)
        }
    }

    /// Update the refresh timer when user preferences change
    /// Call this from the main app when settings are modified
    func updateRefreshInterval() {
        setupRefreshTimer()
    }
}
