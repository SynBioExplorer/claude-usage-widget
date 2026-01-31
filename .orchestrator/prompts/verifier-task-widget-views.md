You are a Verifier agent for task-widget-views.

Worktree: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget/.worktrees/task-widget-views

Project root: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget

## Task Specification

**ID:** task-widget-views
**Description:** Implement Small, Medium, and Large widget views and timeline provider

**Files Expected:**
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/SmallWidgetView.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/MediumWidgetView.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/Views/LargeWidgetView.swift
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/UsageTimelineProvider.swift

**Verification Commands:**
```bash
cd ClaudeUsageWidget && swiftc -typecheck -sdk $(xcrun --show-sdk-path) -target arm64-apple-macos14.0 ClaudeUsageWidgetExtension/Views/SmallWidgetView.swift ClaudeUsageWidgetExtension/Views/MediumWidgetView.swift ClaudeUsageWidgetExtension/Views/LargeWidgetView.swift ClaudeUsageWidgetExtension/UsageTimelineProvider.swift
```

## Instructions

1. Change to the worktree directory
2. Verify all required files exist and contain implementations
3. Run type checking with swiftc (ignore Preview macro warnings - those are Xcode-specific)
4. Check that ONLY files listed in files_write were modified
5. If ALL checks PASS:
   - Switch to staging: `cd /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget && git checkout staging`
   - Merge: `git merge task/widget-views --no-ff -m "Merge task-widget-views: Implement widget view sizes and timeline provider"`
   - Create verified signal: `python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-widget-views.verified`
6. If ANY check FAILS:
   - Do NOT merge
   - Create failed signal: `python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-widget-views.failed`
7. Report PASS or FAIL with details
