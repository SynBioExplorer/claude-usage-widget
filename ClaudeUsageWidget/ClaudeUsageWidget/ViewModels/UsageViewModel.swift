import Foundation
import Combine

/// ViewModel managing usage data fetching, caching, and auto-refresh for the menu bar app
@MainActor
final class UsageViewModel: ObservableObject {
    /// Current usage data, nil if not yet fetched
    @Published private(set) var usageData: UsageData?

    /// Whether a fetch is currently in progress
    @Published private(set) var isLoading: Bool = false

    /// Last error that occurred during fetch, nil if successful
    @Published private(set) var error: Error?

    /// Whether Claude CLI is available
    @Published private(set) var isClaudeAvailable: Bool = true

    /// The CLI service for executing commands
    private let cliService: CLIServiceProtocol

    /// The data sharing service for persisting data
    private let dataSharingService: DataSharingService

    /// Timer for auto-refresh
    private var refreshTimer: Timer?

    /// Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()

    init(
        cliService: CLIServiceProtocol = CLIService(),
        dataSharingService: DataSharingService = .shared
    ) {
        self.cliService = cliService
        self.dataSharingService = dataSharingService

        // Load cached data on init
        loadCachedData()

        // Check CLI availability
        isClaudeAvailable = cliService.isClaudeAvailable()

        // Set up auto-refresh timer
        setupRefreshTimer()
    }

    deinit {
        refreshTimer?.invalidate()
    }

    /// Refresh usage data from the CLI
    func refresh() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            let data = try await cliService.fetchUsage()
            usageData = data

            // Save to shared storage for widget
            try? dataSharingService.saveUsageData(data)
            dataSharingService.saveLastError(nil)
            dataSharingService.notifyWidgetToReload()

        } catch {
            self.error = error
            dataSharingService.saveLastError(error.localizedDescription)
        }

        isLoading = false
    }

    /// Load any cached data from shared storage
    func loadCachedData() {
        if let cached = dataSharingService.loadUsageData() {
            usageData = cached
        }
    }

    /// Set up the auto-refresh timer based on user preferences
    func setupRefreshTimer() {
        refreshTimer?.invalidate()

        let preferences = dataSharingService.loadPreferences()
        let interval = TimeInterval(preferences.refreshIntervalMinutes * 60)

        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.refresh()
            }
        }
    }

    /// Update the refresh timer when preferences change
    func updateRefreshInterval() {
        setupRefreshTimer()
    }

    /// Get current user preferences
    var preferences: UserPreferences {
        dataSharingService.loadPreferences()
    }
}

/// Refresh interval options for the settings picker
enum RefreshInterval: Int, CaseIterable, Identifiable {
    case fiveMinutes = 5
    case fifteenMinutes = 15
    case thirtyMinutes = 30
    case oneHour = 60

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .fiveMinutes: return "5 minutes"
        case .fifteenMinutes: return "15 minutes"
        case .thirtyMinutes: return "30 minutes"
        case .oneHour: return "1 hour"
        }
    }
}
