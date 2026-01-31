You are a Worker agent executing task-widget-views.

Working directory: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget/.worktrees/task-widget-views

## Task Specification

**ID:** task-widget-views
**Description:** Implement Small, Medium, and Large widget views and timeline provider

**Files to Write:**
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/SmallWidgetView.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/MediumWidgetView.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/LargeWidgetView.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/UsageTimelineProvider.swift

**Files to Read:**
- contracts/WidgetViewProtocol.swift
- contracts/UsageDataProtocol.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/Components/GlassProgressBar.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/Components/UsageRowView.swift
- ClaudeUsageWidget/Shared/Services/DataSharingService.swift
- demo_screenshot.png

**Dependencies:** task-widget-components (COMPLETE)

## Context

Implement the three widget sizes:
1. SmallWidgetView: Session usage only with circular progress
2. MediumWidgetView: Session + Weekly All Models (matches demo screenshot)
3. LargeWidgetView: All three metrics with full details

Also implement UsageTimelineProvider:
- Reads data from shared UserDefaults via DataSharingService
- Creates timeline entries for WidgetKit
- Supports placeholder for widget gallery

## Implementation Requirements

1. **SmallWidgetView.swift**:
   - Compact view showing only session usage
   - Circular progress indicator
   - Percentage display
   - Glass background effect

2. **MediumWidgetView.swift**:
   - Session usage row
   - Weekly all models usage row
   - Last updated footer
   - Matches demo screenshot layout

3. **LargeWidgetView.swift**:
   - All three metrics (session, weekly all, weekly sonnet)
   - Full progress bars with labels
   - Reset time information
   - Last updated footer

4. **UsageTimelineProvider.swift**:
   - Implement TimelineProvider protocol
   - Read from DataSharingService
   - Create placeholder entry
   - Refresh timeline every 15 minutes
   - Handle errors gracefully

## Verification Commands

After implementation, run:
```bash
cd ClaudeUsageWidget && swiftc -typecheck -sdk $(xcrun --show-sdk-path) -target arm64-apple-macos14.0 ClaudeUsageWidgetExtension/Views/SmallWidgetView.swift ClaudeUsageWidgetExtension/Views/MediumWidgetView.swift ClaudeUsageWidgetExtension/Views/LargeWidgetView.swift ClaudeUsageWidgetExtension/UsageTimelineProvider.swift
```

## Instructions

1. Read all contract and component files to understand interfaces
2. Implement SmallWidgetView.swift
3. Implement MediumWidgetView.swift (match demo screenshot)
4. Implement LargeWidgetView.swift
5. Implement UsageTimelineProvider.swift
6. Ensure all files compile and use existing components
7. When complete, create signal file:
   ```bash
   python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-widget-views.done
   ```

**IMPORTANT:** You are working in an isolated worktree. Do NOT merge or commit - just implement the files and signal completion.
