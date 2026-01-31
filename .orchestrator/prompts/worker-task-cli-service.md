You are a Worker agent executing task-cli-service.

Working directory: /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian Genome Foundry - AWS cloud infrastructure/14_Claude_Usage_widget/.worktrees/task-cli-service

## Task Specification

**ID:** task-cli-service
**Description:** Implement CLI execution and parsing service to fetch usage data from 'claude /usage' command

**Files to Write:**
- ClaudeUsageWidget/ClaudeUsageWidget/Services/CLIService.swift
- ClaudeUsageWidget/ClaudeUsageWidget/Services/UsageParser.swift

**Files to Read:**
- contracts/UsageDataProtocol.swift
- ClaudeUsageWidget/Shared/Models/UsageData.swift

**Dependencies:** task-shared-models (COMPLETE)

## Context

Implement the CLI service that:
1. Locates claude CLI (check ~/.local/bin/claude, /usr/local/bin/claude, PATH)
2. Executes 'claude /usage' via Process()
3. Parses output using regex patterns:
   - Session: "Current session: (\d+)% used \(resets (.+)\)"
   - Weekly all: "Current week \(all\): (\d+)% used \(resets (.+)\)"
   - Weekly Sonnet: "Current week \(Sonnet\): (\d+)% used"
4. Returns UsageData model

Note: Requires hardened runtime exception for CLI execution in sandboxed app

## Implementation Requirements

1. **CLIService.swift**:
   - Conform to CLIServiceProtocol from contracts
   - Implement async method to execute claude CLI
   - Handle Process() execution with proper error handling
   - Search for claude binary in multiple locations
   - Return raw CLI output string

2. **UsageParser.swift**:
   - Conform to UsageParserProtocol from contracts
   - Parse CLI output using regex patterns
   - Extract session usage percentage and reset time
   - Extract weekly all usage percentage and reset time
   - Extract weekly Sonnet usage percentage
   - Return UsageData model populated with parsed values
   - Handle parsing errors gracefully (return nil or throw)

## Verification Commands

After implementation, run:
```bash
cd ClaudeUsageWidget && xcodebuild -scheme ClaudeUsageWidget -destination 'platform=macOS' build CODE_SIGNING_ALLOWED=NO 2>&1 | tail -20
```

## Instructions

1. Read the contract files to understand the required protocols and data structures
2. Implement CLIService.swift with Process() execution logic
3. Implement UsageParser.swift with regex parsing logic
4. Ensure both files compile without errors
5. Run verification commands to ensure the build succeeds
6. When complete, create signal file:
   ```bash
   python3 ~/.claude/orchestrator_code/tmux.py create-signal /Users/felix/Library/CloudStorage/OneDrive-SharedLibraries-MacquarieUniversity/Australian\ Genome\ Foundry\ -\ AWS\ cloud\ infrastructure/14_Claude_Usage_widget/.orchestrator/signals/task-cli-service.done
   ```

**IMPORTANT:** You are working in an isolated worktree. Do NOT merge or commit - just implement the files and signal completion.
