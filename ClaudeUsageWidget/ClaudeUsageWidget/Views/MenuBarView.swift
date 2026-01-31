import SwiftUI

/// Main popover view displayed when clicking the menu bar icon
struct MenuBarView: View {
    /// ViewModel managing usage data
    @StateObject private var viewModel = UsageViewModel()

    /// Whether settings sheet is presented
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // Header with title and buttons
            header

            Divider()
                .opacity(0.5)

            // Usage content
            UsageView(
                usageData: viewModel.usageData,
                preferences: viewModel.preferences,
                showLastUpdated: true,
                isLoading: viewModel.isLoading,
                errorMessage: viewModel.error?.localizedDescription
            )
            .padding()

            Divider()
                .opacity(0.5)

            // Footer with action buttons
            footer
        }
        .frame(width: 320)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $showSettings) {
            SettingsView(isPresented: $showSettings) { _ in
                // Update refresh timer when preferences change
                viewModel.updateRefreshInterval()
            }
        }
        .task {
            // Fetch data on appear if no data or data is stale
            if viewModel.usageData == nil {
                await viewModel.refresh()
            }
        }
    }

    /// Header section with title and settings button
    private var header: some View {
        HStack {
            // App icon or logo placeholder
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 16))
                .foregroundColor(.accentColor)

            Text("Claude Usage")
                .font(.system(size: 14, weight: .semibold))

            Spacer()

            // Settings button
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .help("Settings")
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    /// Footer section with refresh and quit buttons
    private var footer: some View {
        HStack {
            // Refresh button
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                HStack(spacing: 4) {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.6)
                            .frame(width: 14, height: 14)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12))
                    }
                    Text("Refresh")
                        .font(.system(size: 12))
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
            .disabled(viewModel.isLoading)

            Spacer()

            // CLI status indicator
            if !viewModel.isClaudeAvailable {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 10))
                    Text("CLI not found")
                        .font(.system(size: 10))
                }
                .foregroundColor(.orange)
            }

            Spacer()

            // Quit button
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
                    .font(.system(size: 12))
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
