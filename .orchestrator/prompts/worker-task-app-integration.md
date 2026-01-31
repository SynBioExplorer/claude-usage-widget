You are a Worker agent executing task-app-integration.

Working directory: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget/.worktrees/task-app-integration

## Task Specification

**ID:** task-app-integration
**Description:** Integrate all components: update main app entry point, add AppDelegate for scheduling, wire up widget entry point

**Files to Write:**
- ClaudeUsageWidget/ClaudeUsageWidget/App/AppDelegate.swift

**Files to Read (for patching):**
- ClaudeUsageWidget/ClaudeUsageWidget/ClaudeUsageWidgetApp.swift
- ClaudeUsageWidget/ClaudeUsageWidget/Views/MenuBarView.swift
- ClaudeUsageWidget/ClaudeUsageWidget/Services/CLIService.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/ClaudeUsageWidgetExtension.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/UsageTimelineProvider.swift

**Dependencies:** task-main-app-views AND task-widget-views (BOTH COMPLETE)

## Context

Final integration:
1. AppDelegate: Background refresh scheduling with Timer
   - Fetch usage every N minutes
   - Store to shared UserDefaults
   - Trigger widget timeline reload
2. Update ClaudeUsageWidgetApp.swift:
   - Add @NSApplicationDelegateAdaptor
   - Configure MenuBarExtra
   - Set up as LSUIElement (no dock icon)
3. Update widget extension entry point to use timeline provider

## Implementation Requirements

1. **AppDelegate.swift** (NEW FILE):
   - NSApplicationDelegate implementation
   - Background Timer for periodic refresh
   - Uses CLIService to fetch usage data
   - Saves to DataSharingService
   - Triggers WidgetCenter.shared.reloadAllTimelines()
   - Respects refresh interval from UserPreferences

2. **Patch ClaudeUsageWidgetApp.swift**:
   - Add `@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate`
   - Replace ContentView with MenuBarExtra
   - Configure MenuBarExtra with icon and popover
   - Ensure no dock icon (Info.plist already has LSUIElement)

3. **Patch ClaudeUsageWidgetExtension.swift**:
   - Update to use UsageTimelineProvider
   - Add widget configuration (small, medium, large)
   - Ensure proper WidgetBundle setup

## Patch Intent Details

**ClaudeUsageWidgetApp.swift**:
```swift
import SwiftUI

@main
struct ClaudeUsageWidgetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Claude Usage", systemImage: "gauge.medium") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
    }
}
```

**ClaudeUsageWidgetExtension.swift**:
```swift
import WidgetKit
import SwiftUI

@main
struct ClaudeUsageWidgetExtension: Widget {
    let kind: String = "ClaudeUsageWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UsageTimelineProvider()) { entry in
            ClaudeUsageWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Claude Usage")
        .description("Monitor your Claude Code usage limits")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClaudeUsageWidgetExtensionEntryView: View {
    var entry: UsageTimelineProvider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            MediumWidgetView(entry: entry)
        }
    }
}
```

## Verification Commands

After implementation:
```bash
cd ClaudeUsageWidget && swiftc -typecheck -sdk $(xcrun --show-sdk-path) -target arm64-apple-macos14.0 ClaudeUsageWidget/App/AppDelegate.swift ClaudeUsageWidget/ClaudeUsageWidgetApp.swift ClaudeUsageWidgetExtension/ClaudeUsageWidgetExtension.swift
```

## Instructions

1. Read all referenced files to understand current state
2. Create ClaudeUsageWidget/App/ directory if needed
3. Implement AppDelegate.swift with refresh scheduling
4. Update ClaudeUsageWidgetApp.swift to use MenuBarExtra and AppDelegate
5. Update ClaudeUsageWidgetExtension.swift to use timeline provider and widget sizes
6. Verify all files compile together
7. When complete, create signal file:
   ```bash
   python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-app-integration.done
   ```

**IMPORTANT:** You are working in an isolated worktree. Do NOT merge or commit - just implement the files and signal completion.
