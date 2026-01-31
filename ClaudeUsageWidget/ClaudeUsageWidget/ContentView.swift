import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Claude Usage Widget")
                .font(.headline)

            Text("Loading usage data...")
                .foregroundColor(.secondary)

            Divider()

            Button("Refresh") {
                // TODO: Implement refresh
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 280)
    }
}

#Preview {
    ContentView()
}
