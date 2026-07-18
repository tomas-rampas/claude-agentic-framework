#Requires -Version 7.0
# hooks.test.ps1 — plain-pwsh test harness for hooks/*.ps1 (no Pester dependency).
#
# Builds a throwaway git repo + isolated state dir (CLAUDE_STATE_DIR), feeds each
# hook synthetic stdin JSON, and asserts on output/exit codes. Exit 0 = all pass.
#
# Usage: pwsh -NoProfile -File tests/hooks.test.ps1

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$hooksDir = Join-Path $repoRoot 'hooks'
$failures = 0

$workRoot = Join-Path ([IO.Path]::GetTempPath()) ("hooks-test-" + [guid]::NewGuid().ToString('N'))
$stateDir = Join-Path $workRoot 'state'
$scratch  = Join-Path $workRoot 'scratch-repo'
New-Item -ItemType Directory -Force -Path $stateDir, $scratch | Out-Null
$env:CLAUDE_STATE_DIR = $stateDir

function Invoke-Hook {
    param([string]$Script, [string]$StdinJson)
    $out = $StdinJson | pwsh -NoProfile -File (Join-Path $hooksDir $Script) 2>$null
    return [pscustomobject]@{ Out = [string]($out -join "`n"); Code = $LASTEXITCODE }
}

function Assert {
    param([string]$Name, [bool]$Condition)
    if ($Condition) {
        Write-Host "  PASS  $Name"
    } else {
        Write-Host "  FAIL  $Name" -ForegroundColor Red
        $script:failures++
    }
}

function New-Payload([hashtable]$Fields) { $Fields | ConvertTo-Json -Compress -Depth 8 }

# ── Scratch repo: main with 1 commit, feature/x 1 commit ahead, clean tree ──────
git -C $scratch init -q -b main
git -C $scratch config user.email 'test@test.local'
git -C $scratch config user.name  'hooks-test'
Set-Content -Path (Join-Path $scratch 'a.txt') -Value 'one'
git -C $scratch add -A; git -C $scratch commit -qm 'init'
git -C $scratch checkout -qb feature/x
Set-Content -Path (Join-Path $scratch 'b.txt') -Value 'two'
git -C $scratch add -A; git -C $scratch commit -qm 'feature work'

Write-Host "stop-peer-review-gate.ps1"

$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's1'; stop_hook_active = $true; cwd = $scratch })
Assert 'loop-safety: stop_hook_active=true allows' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's2'; stop_hook_active = $false; cwd = $scratch })
Assert 'blocks: feature branch ahead, clean tree, no marker' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"' -and $r.Out -match 'peer-review-critic')

$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's2'; stop_hook_active = $false; cwd = $scratch })
Assert 'fires at most once per session (.fired marker)' ($r.Code -eq 0 -and -not $r.Out)

New-Item -ItemType Directory -Force -Path (Join-Path $stateDir 'peer-review') | Out-Null
Set-Content -Path (Join-Path $stateDir 'peer-review' 's3') -Value 'reviewed'
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's3'; stop_hook_active = $false; cwd = $scratch })
Assert 'allows when peer-review marker exists' ($r.Code -eq 0 -and -not $r.Out)

Set-Content -Path (Join-Path $scratch 'dirty.txt') -Value 'wip'
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's4'; stop_hook_active = $false; cwd = $scratch })
Assert 'allows when working tree is dirty' ($r.Code -eq 0 -and -not $r.Out)
Remove-Item (Join-Path $scratch 'dirty.txt') -Force

git -C $scratch checkout -q main
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's5'; stop_hook_active = $false; cwd = $scratch })
Assert 'allows on base branch (main)' ($r.Code -eq 0 -and -not $r.Out)
git -C $scratch checkout -q feature/x

$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 's6'; stop_hook_active = $false; cwd = $workRoot })
Assert 'allows outside a git worktree' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'stop-peer-review-gate.ps1' 'this is not json'
Assert 'fail-open on malformed stdin' ($r.Code -eq 0 -and -not $r.Out)

Write-Host "record-subagent-run.ps1"

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'r1'; tool_name = 'Task'; tool_input = @{ subagent_type = 'peer-review-critic' } })
$m1 = Get-Content (Join-Path $stateDir 'peer-review' 'r1') -Raw -ErrorAction SilentlyContinue
Assert 'writes marker for peer-review-critic run' ($r.Code -eq 0 -and (Test-Path (Join-Path $stateDir 'peer-review' 'r1')))
Assert 'marker without report text carries no verdict line' ($m1 -notmatch 'verdict=')

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'r2'; tool_name = 'Task'; tool_input = @{ subagent_type = 'rust-expert' } })
Assert 'ignores other subagents' ($r.Code -eq 0 -and -not (Test-Path (Join-Path $stateDir 'peer-review' 'r2')))

$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'r1'; stop_hook_active = $false; cwd = $scratch })
Assert 'integration: recorded run unlocks the stop gate' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'record-subagent-run.ps1' 'not json either'
Assert 'fail-open on malformed stdin' ($r.Code -eq 0)

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'v1'; hook_event_name = 'PostToolUse'; tool_name = 'Agent'; tool_input = @{ subagent_type = 'peer-review-critic' }; tool_response = "Review done.`nVERDICT: APPROVED" })
$m = Get-Content (Join-Path $stateDir 'peer-review' 'v1') -Raw
Assert 'parses verdict from string tool_response' ($r.Code -eq 0 -and $m -match 'verdict=APPROVED')

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'v2'; hook_event_name = 'PostToolUse'; tool_name = 'Agent'; tool_input = @{ subagent_type = 'peer-review-critic' }; tool_response = @{ status = 'completed'; content = @(@{ type = 'text'; text = "Findings...`nVERDICT: CHANGES_REQUIRED" }) } })
$m = Get-Content (Join-Path $stateDir 'peer-review' 'v2') -Raw
Assert 'parses verdict from content-array tool_response' ($r.Code -eq 0 -and $m -match 'verdict=CHANGES_REQUIRED')

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'v3'; hook_event_name = 'SubagentStop'; agent_type = 'peer-review-critic'; last_assistant_message = "Solid work overall.`nVERDICT: APPROVED" })
$m = Get-Content (Join-Path $stateDir 'peer-review' 'v3') -Raw
Assert 'SubagentStop path records verdict from last_assistant_message' ($r.Code -eq 0 -and $m -match 'verdict=APPROVED')

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'v4'; hook_event_name = 'SubagentStop'; agent_type = 'rust-expert'; last_assistant_message = 'VERDICT: APPROVED' })
Assert 'SubagentStop ignores other agent types' ($r.Code -eq 0 -and -not (Test-Path (Join-Path $stateDir 'peer-review' 'v4')))

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'v5'; hook_event_name = 'SubagentStop'; agent_type = 'peer-review-critic'; last_assistant_message = "The format is `"VERDICT: APPROVED`" normally, but here:`nVERDICT: CHANGES_REQUIRED" })
$m = Get-Content (Join-Path $stateDir 'peer-review' 'v5') -Raw
Assert 'last VERDICT occurrence wins over earlier quoted one' ($r.Code -eq 0 -and $m -match 'verdict=CHANGES_REQUIRED')

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'v5'; hook_event_name = 'SubagentStop'; agent_type = 'peer-review-critic'; last_assistant_message = "Re-review after fixes.`nVERDICT: APPROVED" })
$m = Get-Content (Join-Path $stateDir 'peer-review' 'v5') -Raw
Assert 're-review overwrites marker (latest verdict wins)' ($r.Code -eq 0 -and $m -match 'verdict=APPROVED' -and $m -notmatch 'CHANGES_REQUIRED')

Write-Host "stop-peer-review-gate.ps1 (verdict-aware)"

Set-Content -Path (Join-Path $stateDir 'peer-review' 'g1') -Value "2026-07-18T00:00:00.0000000+02:00`nverdict=APPROVED" -NoNewline
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g1'; stop_hook_active = $false; cwd = $scratch })
Assert 'allows on verdict=APPROVED marker' ($r.Code -eq 0 -and -not $r.Out)

Set-Content -Path (Join-Path $stateDir 'peer-review' 'g2') -Value "2026-07-18T00:00:00.0000000+02:00`nverdict=CHANGES_REQUIRED" -NoNewline
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g2'; stop_hook_active = $false; cwd = $scratch })
Assert 'blocks on verdict=CHANGES_REQUIRED (1st)' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"' -and $r.Out -match 'CHANGES_REQUIRED')
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g2'; stop_hook_active = $false; cwd = $scratch })
Assert 'blocks on verdict=CHANGES_REQUIRED (2nd)' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"')
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g2'; stop_hook_active = $false; cwd = $scratch })
Assert 'blocks on verdict=CHANGES_REQUIRED (3rd)' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"')
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g2'; stop_hook_active = $false; cwd = $scratch })
Assert 'block budget exhausted after 3 blocks -> allows' ($r.Code -eq 0 -and -not $r.Out)

Set-Content -Path (Join-Path $stateDir 'peer-review' 'g2') -Value "2026-07-18T00:00:00.0000000+02:00`nverdict=APPROVED" -NoNewline
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g2'; stop_hook_active = $false; cwd = $scratch })
Assert 'later APPROVED marker allows regardless of block count' ($r.Code -eq 0 -and -not $r.Out)

# Pre-verdict on-disk format: .fired existed as an empty file (counts as 1 block)
Set-Content -Path (Join-Path $stateDir 'peer-review' 'g3') -Value "2026-07-18T00:00:00.0000000+02:00`nverdict=CHANGES_REQUIRED" -NoNewline
New-Item -ItemType File -Force -Path (Join-Path $stateDir 'peer-review' 'g3.fired') | Out-Null
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g3'; stop_hook_active = $false; cwd = $scratch })
Assert 'legacy empty .fired counts as 1 (2nd block granted)' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"')
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g3'; stop_hook_active = $false; cwd = $scratch })
Assert 'legacy .fired base: 3rd block granted' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"')
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g3'; stop_hook_active = $false; cwd = $scratch })
Assert 'legacy .fired base: budget exhausted -> allows' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'g4'; hook_event_name = 'SubagentStop'; agent_type = 'peer-review-critic'; last_assistant_message = "Blockers found.`nVERDICT: CHANGES_REQUIRED" })
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g4'; stop_hook_active = $false; cwd = $scratch })
Assert 'integration: recorded CHANGES_REQUIRED blocks the gate' ($r.Code -eq 0 -and $r.Out -match '"decision":"block"' -and $r.Out -match 'CHANGES_REQUIRED')
$r = Invoke-Hook 'record-subagent-run.ps1' (New-Payload @{ session_id = 'g4'; hook_event_name = 'SubagentStop'; agent_type = 'peer-review-critic'; last_assistant_message = "Fixed and re-reviewed.`nVERDICT: APPROVED" })
$r = Invoke-Hook 'stop-peer-review-gate.ps1' (New-Payload @{ session_id = 'g4'; stop_hook_active = $false; cwd = $scratch })
Assert 'integration: recorded APPROVED re-review unlocks the gate' ($r.Code -eq 0 -and -not $r.Out)

Write-Host "session-start-context.ps1"

$r = Invoke-Hook 'session-start-context.ps1' (New-Payload @{ session_id = 'c1'; cwd = $scratch })
Assert 'reports ahead-of-base state on feature branch' ($r.Code -eq 0 -and $r.Out -match 'ahead of' -and $r.Out -match 'feature/x')

git -C $scratch checkout -q main
$r = Invoke-Hook 'session-start-context.ps1' (New-Payload @{ session_id = 'c2'; cwd = $scratch })
Assert 'reports base-branch state on main' ($r.Code -eq 0 -and $r.Out -match "On 'main'")
git -C $scratch checkout -q feature/x

$r = Invoke-Hook 'session-start-context.ps1' (New-Payload @{ session_id = 'c3'; cwd = $workRoot })
Assert 'silent outside a git worktree' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'session-start-context.ps1' '{{{'
Assert 'fail-open on malformed stdin' ($r.Code -eq 0)

Write-Host "pretooluse-delegation-hint.ps1"

$r = Invoke-Hook 'pretooluse-delegation-hint.ps1' (New-Payload @{ session_id = 'd1'; tool_name = 'Write'; tool_input = @{ file_path = 'C:/tmp/lib.rs' } })
Assert 'suggests rust-expert for .rs file' ($r.Code -eq 0 -and $r.Out -match 'rust-expert' -and $r.Out -match '"systemMessage"')

$r = Invoke-Hook 'pretooluse-delegation-hint.ps1' (New-Payload @{ session_id = 'd1'; tool_name = 'Write'; tool_input = @{ file_path = 'C:/tmp/main.rs' } })
Assert 'hints at most once per session per agent' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'pretooluse-delegation-hint.ps1' (New-Payload @{ session_id = 'd2'; tool_name = 'Write'; tool_input = @{ file_path = 'C:/tmp/notes.txt' } })
Assert 'silent for unmapped extensions' ($r.Code -eq 0 -and -not $r.Out)

$r = Invoke-Hook 'pretooluse-delegation-hint.ps1' '[broken'
Assert 'fail-open on malformed stdin' ($r.Code -eq 0)

# ── Teardown ───────────────────────────────────────────────────────────────────
Remove-Item -Recurse -Force $workRoot -ErrorAction SilentlyContinue
Remove-Item Env:\CLAUDE_STATE_DIR -ErrorAction SilentlyContinue

Write-Host ''
if ($failures -gt 0) {
    Write-Host "RESULT: FAIL ($failures assertion(s) failed)" -ForegroundColor Red
    exit 1
}
Write-Host 'RESULT: PASS (all hook assertions passed)'
exit 0
