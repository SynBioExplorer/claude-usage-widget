You are a Worker agent executing task-main-app-views.

Working directory: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget/.worktrees/task-main-app-views

## Task Specification

**ID:** task-main-app-views
**Description:** Implement menu bar app views: MenuBarView, SettingsView, UsageView, UsageViewModel

**Files to Write:**
- ClaudeUsageWidget/ClaudeUsageWidget/Views/MenuBarView.swift
- ClaudeUsageWidget/ClaudeUsageWidget/Views/SettingsView.swift
- ClaudeUsageWidget/ClaudeUsageWidget/Views/UsageView.swift
- ClaudeUsageWidget/ClaudeUsageWidget/ViewModels/UsageViewModel.swift

**Files to Read:**
- contracts/UsageDataProtocol.swift
- ClaudeUsageWidget/ClaudeUsageWidget/Services/CLIService.swift
- ClaudeUsageWidget/Shared/Models/UserPreferences.swift
- ClaudeUsageWidget/Shared/Services/DataSharingService.swift
- demo_screenshot.png

**Dependencies:** task-cli-service (COMPLETE)

## Context

Implement the menu bar app UI:
1. MenuBarView: Popover shown when clicking menu bar icon
   - Shows current usage summary
   - Refresh button
   - Settings button
   - Quit button
2. SettingsView: Color picker for each progress bar
   - Session color picker
   - Weekly all color picker
   - Sonnet color picker
   - Refresh interval setting
3. UsageView: Reusable usage display (similar to widget but for popover)
4. UsageViewModel: ObservableObject managing refresh logic

## Implementation Requirements

1. **MenuBarView.swift**:
   - Main popover content view
   - Display current usage via UsageView
   - Refresh button with loading state
   - Settings sheet presentation
   - Quit application button
   - Glass/modern macOS aesthetic

2. **SettingsView.swift**:
   - Color pickers for session, weekly all, weekly sonnet
   - Refresh interval picker (5min, 15min, 30min, 1hr)
   - Save preferences to DataSharingService
   - Close/Done button

3. **UsageView.swift**:
   - Display usage data similar to widget
   - Progress bars with labels
   - Last updated timestamp
   - Use similar glass aesthetic

4. **UsageViewModel.swift**:
   - @Published properties for usage data
   - Async refresh method using CLIService
   - Loading state management
   - Error handling
   - Timer for auto-refresh

## Verification Commands

After implementation, run:
```bash
cd ClaudeUsageWidget && swiftc -typecheck -sdk $(xcrun --show-sdk-path) -target arm64-apple-macos14.0 ClaudeUsageWidget/Views/MenuBarView.swift ClaudeUsageWidget/Views/SettingsView.swift ClaudeUsageWidget/Views/UsageView.swift ClaudeUsageWidget/ViewModels/UsageViewModel.swift
```

## Instructions

1. Read contract files and existing services
2. Implement UsageViewModel.swift first (data layer)
3. Implement UsageView.swift (display component)
4. Implement SettingsView.swift
5. Implement MenuBarView.swift (main entry point)
6. Ensure all files compile and integrate with services
7. When complete, create signal file:
   ```bash
   python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-main-app-views.done
   ```

**IMPORTANT:** You are working in an isolated worktree. Do NOT merge or commit - just implement the files and signal completion.
