import SwiftUI

@main
struct ClaudeUsageWidgetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Claude Usage", systemImage: "chart.bar.fill") {
            ContentView()
        }
        .menuBarExtraStyle(.window)

        Settings {
            Text("Settings")
        }
    }
}
