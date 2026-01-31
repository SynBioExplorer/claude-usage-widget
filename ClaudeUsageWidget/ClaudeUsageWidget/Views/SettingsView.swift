import SwiftUI

/// Settings view for customizing progress bar colors and refresh interval
struct SettingsView: View {
    /// Binding to control sheet presentation
    @Binding var isPresented: Bool

    /// Callback when preferences are saved
    var onSave: ((UserPreferences) -> Void)?

    /// Current session color
    @State private var sessionColor: Color

    /// Current weekly all models color
    @State private var weeklyAllColor: Color

    /// Current weekly Sonnet color
    @State private var weeklySonnetColor: Color

    /// Current refresh interval
    @State private var refreshInterval: RefreshInterval

    /// Data sharing service for persistence
    private let dataSharingService = DataSharingService.shared

    init(isPresented: Binding<Bool>, onSave: ((UserPreferences) -> Void)? = nil) {
        self._isPresented = isPresented
        self.onSave = onSave

        // Load current preferences
        let prefs = DataSharingService.shared.loadPreferences()
        _sessionColor = State(initialValue: prefs.sessionColor.color)
        _weeklyAllColor = State(initialValue: prefs.weeklyAllColor.color)
        _weeklySonnetColor = State(initialValue: prefs.weeklySonnetColor.color)
        _refreshInterval = State(initialValue: RefreshInterval(rawValue: prefs.refreshIntervalMinutes) ?? .fifteenMinutes)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            Divider()

            // Settings content
            ScrollView {
                VStack(spacing: 20) {
                    colorSettings
                    refreshSettings
                }
                .padding()
            }

            Divider()

            // Footer with buttons
            footer
        }
        .frame(width: 300, height: 380)
        .background(Color(NSColor.windowBackgroundColor))
    }

    /// Header with title
    private var header: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 14, weight: .semibold))
            Spacer()
        }
        .padding()
    }

    /// Color picker settings section
    private var colorSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Bar Colors")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            colorPickerRow(
                label: "Session",
                color: $sessionColor,
                preview: 0.3
            )

            colorPickerRow(
                label: "All Models",
                color: $weeklyAllColor,
                preview: 0.53
            )

            colorPickerRow(
                label: "Sonnet",
                color: $weeklySonnetColor,
                preview: 0.23
            )
        }
    }

    /// Individual color picker row
    private func colorPickerRow(label: String, color: Binding<Color>, preview: Double) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .frame(width: 80, alignment: .leading)

            GlassProgressBar(progress: preview, fillColor: color.wrappedValue, height: 8)
                .frame(height: 8)

            ColorPicker("", selection: color, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 30)
        }
    }

    /// Refresh interval settings section
    private var refreshSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Auto Refresh")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            HStack {
                Text("Refresh interval")
                    .font(.system(size: 13))

                Spacer()

                Picker("", selection: $refreshInterval) {
                    ForEach(RefreshInterval.allCases) { interval in
                        Text(interval.displayName).tag(interval)
                    }
                }
                .labelsHidden()
                .frame(width: 120)
            }
        }
    }

    /// Footer with cancel and save buttons
    private var footer: some View {
        HStack {
            Button("Reset to Defaults") {
                resetToDefaults()
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .font(.system(size: 12))

            Spacer()

            Button("Cancel") {
                isPresented = false
            }
            .keyboardShortcut(.escape, modifiers: [])

            Button("Save") {
                savePreferences()
            }
            .keyboardShortcut(.return, modifiers: [])
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    /// Reset all settings to defaults
    private func resetToDefaults() {
        sessionColor = ColorPreference.defaultSession.color
        weeklyAllColor = ColorPreference.defaultWeeklyAll.color
        weeklySonnetColor = ColorPreference.defaultWeeklySonnet.color
        refreshInterval = .fifteenMinutes
    }

    /// Save preferences to storage
    private func savePreferences() {
        let preferences = UserPreferences(
            sessionColor: colorPreferenceFromColor(sessionColor),
            weeklyAllColor: colorPreferenceFromColor(weeklyAllColor),
            weeklySonnetColor: colorPreferenceFromColor(weeklySonnetColor),
            refreshIntervalMinutes: refreshInterval.rawValue
        )

        try? dataSharingService.savePreferences(preferences)
        dataSharingService.notifyWidgetToReload()
        onSave?(preferences)
        isPresented = false
    }
}

/// Helper to create ColorPreference from SwiftUI Color
private func colorPreferenceFromColor(_ color: Color) -> ColorPreference {
    // Convert SwiftUI Color to NSColor to extract components
    let nsColor = NSColor(color).usingColorSpace(.deviceRGB) ?? NSColor.blue
    return ColorPreference(
        red: Double(nsColor.redComponent),
        green: Double(nsColor.greenComponent),
        blue: Double(nsColor.blueComponent),
        alpha: Double(nsColor.alphaComponent)
    )
}
