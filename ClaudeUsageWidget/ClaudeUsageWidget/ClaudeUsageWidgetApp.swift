import SwiftUI

@main
struct ClaudeUsageWidgetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Claude Usage", systemImage: "gauge.medium") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(isPresented: .constant(true)) { _ in
                // Notify app delegate to update refresh timer
                appDelegate.updateRefreshInterval()
            }
        }
    }
}
