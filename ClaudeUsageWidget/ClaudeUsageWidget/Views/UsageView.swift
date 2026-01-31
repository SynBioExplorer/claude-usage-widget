import SwiftUI

/// A view displaying Claude usage metrics with progress bars
/// Reusable component for both menu bar popover and potential future uses
struct UsageView: View {
    /// The usage data to display
    let usageData: UsageData?

    /// User preferences for colors
    let preferences: UserPreferences

    /// Whether to show the last updated timestamp
    var showLastUpdated: Bool = true

    /// Whether data is currently loading
    var isLoading: Bool = false

    /// Error message to display
    var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            if let data = usageData {
                usageContent(data: data)
            } else if isLoading {
                loadingContent
            } else if let error = errorMessage {
                errorContent(message: error)
            } else {
                noDataContent
            }
        }
    }

    /// Main content displaying usage metrics
    @ViewBuilder
    private func usageContent(data: UsageData) -> some View {
        VStack(spacing: 12) {
            // Section header
            sectionHeader("Plan usage limits")

            // Session usage
            UsageRowView(
                metric: data.session,
                title: "Current session",
                color: preferences.sessionColor.color,
                showSubtitle: true
            )

            Divider()
                .opacity(0.5)

            // Weekly limits section
            sectionHeader("Weekly limits")

            // All models
            UsageRowView(
                metric: data.weeklyAll,
                title: "All models",
                color: preferences.weeklyAllColor.color,
                showSubtitle: true
            )

            // Sonnet only
            UsageRowView(
                metric: data.weeklySonnet,
                title: "Sonnet only",
                color: preferences.weeklySonnetColor.color,
                showSubtitle: true
            )

            // Last updated timestamp
            if showLastUpdated {
                Divider()
                    .opacity(0.3)

                LastUpdatedView(lastUpdated: data.lastUpdated, iconSize: 11, fontSize: 11)
            }
        }
    }

    /// Section header with subtle styling
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary.opacity(0.8))
            Spacer()
        }
    }

    /// Loading state content
    private var loadingContent: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading usage data...")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    /// Error state content
    private func errorContent(message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 24))
                .foregroundColor(.orange)

            Text("Unable to load usage")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)

            Text(message)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    /// No data state content
    private var noDataContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 24))
                .foregroundColor(.secondary)

            Text("No usage data")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)

            Text("Click refresh to load data")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}
