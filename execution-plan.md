# Claude Usage Widget - Execution Plan

## Summary

This plan creates a native macOS SwiftUI desktop widget displaying Claude Code usage metrics with a "liquid glass" aesthetic. The widget shows session usage, weekly limits (all models), and weekly limits (Sonnet only) with customizable progress bar colors.

## Architecture Overview

```
┌─────────────────────┐      ┌──────────────────────┐      ┌─────────────────┐
│  Widget Extension   │◄────►│   Main App (Host)    │◄────►│  Claude CLI     │
│    (WidgetKit)      │      │   Menu Bar Utility   │      │  /usage command │
└─────────────────────┘      └──────────────────────┘      └─────────────────┘
          │                            │
          └────────► App Group ◄───────┘
                  (Shared UserDefaults)
```

## Risk Assessment

| Factor | Value | Points |
|--------|-------|--------|
| Number of tasks | 7 | +10 |
| Number of files | 36 | +78 |
| Test coverage | 0% | +20 |
| **Total Risk Score** | | **108** |

**Recommendation**: Human review required due to high complexity of greenfield Xcode project generation.

## Execution Waves

### Wave 1: Xcode Project Setup
**Task**: `task-xcode-setup`
**Parallelism**: None (foundation task)

Creates the complete Xcode project structure:
- Main app target (ClaudeUsageWidget)
- Widget extension target (ClaudeUsageWidgetExtension)
- App Groups capability configuration
- Entitlements and Info.plist files
- Asset catalogs

**Files created**: 18 files
**Verification**: `xcodebuild -list` and `xcodebuild build`

---

### Wave 2: Shared Models
**Task**: `task-shared-models`
**Parallelism**: None (dependency chain)

Implements shared data models:
- `UsageData.swift` - Core data model for CLI output
- `UserPreferences.swift` - Color settings storage
- `DataSharingService.swift` - App Group UserDefaults wrapper

**Files created**: 3 files
**Verification**: Project builds successfully

---

### Wave 3: CLI Service + Widget Components (PARALLEL)
**Tasks**: `task-cli-service`, `task-widget-components`
**Parallelism**: 2 tasks in parallel

#### task-cli-service
- `CLIService.swift` - Execute `claude /usage` via Process()
- `UsageParser.swift` - Parse CLI output with regex

#### task-widget-components
- `GlassProgressBar.swift` - Progress bar with glass effect
- `UsageRowView.swift` - Usage metric row component
- `LastUpdatedView.swift` - Footer timestamp
- `GlassBackground.swift` - Blur/glass background

**Files created**: 6 files (2 + 4)
**Verification**: Both schemes build successfully

---

### Wave 4: Widget Views + Main App Views (PARALLEL)
**Tasks**: `task-widget-views`, `task-main-app-views`
**Parallelism**: 2 tasks in parallel

#### task-widget-views
- `SmallWidgetView.swift` - Session only (circular)
- `MediumWidgetView.swift` - Session + Weekly All
- `LargeWidgetView.swift` - All three metrics
- `UsageTimelineProvider.swift` - WidgetKit provider

#### task-main-app-views
- `MenuBarView.swift` - Popover UI
- `SettingsView.swift` - Color pickers
- `UsageView.swift` - Usage display
- `UsageViewModel.swift` - Refresh logic

**Files created**: 8 files (4 + 4)
**Verification**: Both schemes build successfully

---

### Wave 5: Integration
**Task**: `task-app-integration`
**Parallelism**: None (final integration)

Wires everything together:
- `AppDelegate.swift` - Background scheduling
- Updates `ClaudeUsageWidgetApp.swift` - MenuBarExtra setup
- Updates `ClaudeUsageWidgetExtension.swift` - Timeline provider

**Files created/modified**: 1 new, 2 updated
**Verification**: Full project build, both targets

---

## Contracts

### UsageDataProtocol (contracts/UsageDataProtocol.swift)
Defines shared data models and service protocols:
- `UsageMetric`, `UsageData`, `UserPreferences`, `ColorPreference`
- `DataSharingServiceProtocol`, `CLIServiceProtocol`, `UsageParserProtocol`

### WidgetViewProtocol (contracts/WidgetViewProtocol.swift)
Defines widget view contracts:
- `ProgressBarConfiguration`, `UsageRowConfiguration`
- `UsageWidgetEntry`, `WidgetSizeCategory`, `DefaultColors`

---

## File Ownership Matrix

| Task | Files Written |
|------|---------------|
| task-xcode-setup | 18 files (project structure) |
| task-shared-models | 3 files (Shared/Models, Shared/Services) |
| task-cli-service | 2 files (ClaudeUsageWidget/Services) |
| task-widget-components | 4 files (Extension/Views/Components) |
| task-widget-views | 4 files (Extension/Views, Extension root) |
| task-main-app-views | 4 files (ClaudeUsageWidget/Views, ViewModels) |
| task-app-integration | 1 file (ClaudeUsageWidget/App) |

**Total**: 36 files across 7 tasks

---

## Verification Strategy

Each task has build verification:
```bash
xcodebuild -scheme <target> -destination 'platform=macOS' build CODE_SIGNING_ALLOWED=NO
```

Final integration verifies:
1. Main app builds
2. Widget extension builds
3. All components properly linked

---

## Known Limitations

1. **No unit tests in initial plan** - Test coverage is 0% contributing to risk score
2. **CLI execution in sandbox** - Requires hardened runtime exception for notarization
3. **Widget refresh throttling** - System limits to ~40-70 refreshes/day
4. **Sequential Xcode setup** - Cannot parallelize project creation

---

## Approval Decision

**Risk Score**: 108 (HIGH)
**Threshold for auto-approve**: 25

This plan requires human approval due to:
- Greenfield project complexity (36 files)
- Xcode project generation (complex pbxproj)
- No automated tests included

**Proceed with execution? [Y/n]**
