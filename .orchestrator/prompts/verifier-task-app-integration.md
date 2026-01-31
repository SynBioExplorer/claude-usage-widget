You are a Verifier agent for task-app-integration.

Worktree: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget/.worktrees/task-app-integration

Project root: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget

## Task Specification

**ID:** task-app-integration
**Description:** Final integration - wire up AppDelegate, MenuBarExtra, and widget entry points

**Files Expected:**
- ClaudeUsageWidget/ClaudeUsageWidget/App/AppDelegate.swift (new)
- ClaudeUsageWidget/ClaudeUsageWidget/ClaudeUsageWidgetApp.swift (updated)
- ClaudeUsageWidget/ClaudeUsageWidgetExtension/ClaudeUsageWidgetExtension.swift (updated)

**Verification Commands:**
```bash
cd ClaudeUsageWidget && swiftc -typecheck -sdk $(xcrun --show-sdk-path) -target arm64-apple-macos14.0 ClaudeUsageWidget/App/AppDelegate.swift ClaudeUsageWidget/ClaudeUsageWidgetApp.swift ClaudeUsageWidgetExtension/ClaudeUsageWidgetExtension.swift
```

## Instructions

1. Change to the worktree directory
2. Verify AppDelegate.swift exists and implements refresh scheduling
3. Verify ClaudeUsageWidgetApp.swift uses MenuBarExtra and AppDelegate
4. Verify ClaudeUsageWidgetExtension.swift wires up widget sizes
5. Run type checking with swiftc
6. Check git diff to ensure only expected files were modified
7. If ALL checks PASS:
   - Switch to staging: `cd /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget && git checkout staging`
   - Merge: `git merge task/app-integration --no-ff -m "Merge task-app-integration: Final app and widget integration"`
   - Create verified signal: `python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-app-integration.verified`
8. If ANY check FAILS:
   - Do NOT merge
   - Create failed signal: `python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-app-integration.failed`
9. Report PASS or FAIL with details

**CRITICAL:** This is the final integration task. Ensure all components wire together correctly before merging.
