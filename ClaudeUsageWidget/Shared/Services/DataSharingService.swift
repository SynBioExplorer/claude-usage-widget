import Foundation
import WidgetKit

/// Service for sharing data between main app and widget extension via App Groups
final class DataSharingService {
    static let shared = DataSharingService()

    private let userDefaults: UserDefaults?

    private init() {
        self.userDefaults = UserDefaults(suiteName: appGroupIdentifier)
    }

    // MARK: - Usage Data

    /// Save usage data to shared storage
    func saveUsageData(_ data: UsageData) throws {
        guard let userDefaults = userDefaults else {
            throw DataSharingError.appGroupNotConfigured
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encoded = try encoder.encode(data)
        userDefaults.set(encoded, forKey: SharedStorageKeys.usageData)
    }

    /// Load usage data from shared storage
    func loadUsageData() -> UsageData? {
        guard let userDefaults = userDefaults,
              let data = userDefaults.data(forKey: SharedStorageKeys.usageData) else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(UsageData.self, from: data)
    }

    // MARK: - User Preferences

    /// Save user preferences to shared storage
    func savePreferences(_ preferences: UserPreferences) throws {
        guard let userDefaults = userDefaults else {
            throw DataSharingError.appGroupNotConfigured
        }

        let encoder = JSONEncoder()
        let encoded = try encoder.encode(preferences)
        userDefaults.set(encoded, forKey: SharedStorageKeys.userPreferences)
    }

    /// Load user preferences from shared storage
    func loadPreferences() -> UserPreferences {
        guard let userDefaults = userDefaults,
              let data = userDefaults.data(forKey: SharedStorageKeys.userPreferences),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return UserPreferences.default
        }
        return preferences
    }

    // MARK: - Error Storage

    /// Save last fetch error message
    func saveLastError(_ error: String?) {
        userDefaults?.set(error, forKey: SharedStorageKeys.lastFetchError)
    }

    /// Load last fetch error message
    func loadLastError() -> String? {
        userDefaults?.string(forKey: SharedStorageKeys.lastFetchError)
    }

    // MARK: - Widget Notification

    /// Notify widget to reload its timeline
    func notifyWidgetToReload() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

/// Errors that can occur during data sharing operations
enum DataSharingError: Error, LocalizedError {
    case appGroupNotConfigured
    case encodingFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .appGroupNotConfigured:
            return "App Group is not properly configured. Check entitlements."
        case .encodingFailed:
            return "Failed to encode data for storage."
        case .decodingFailed:
            return "Failed to decode stored data."
        }
    }
}
