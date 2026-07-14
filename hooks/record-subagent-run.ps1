#Requires -Version 7.0
# record-subagent-run.ps1 — PostToolUse recorder for the peer-review final gate.
#
# When a peer-review-critic subagent run completes (Task/Agent tool), drops a
# per-session marker file that hooks/stop-peer-review-gate.ps1 checks before
# blocking. Silent and fail-open; also prunes markers older than 7 days.
#
# Registered in settings.json under hooks.PostToolUse with matcher "Task|Agent".

try {
    $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json -ErrorAction Stop

    $sessionId = ([string]$payload.session_id) -replace '[^\w\-.]', ''
    if (-not $sessionId) { exit 0 }

    $subagent = [string]$payload.tool_input.subagent_type
    if ($subagent -ne 'peer-review-critic') { exit 0 }

    $stateRoot = $env:CLAUDE_STATE_DIR
    if (-not $stateRoot) { $stateRoot = Join-Path $HOME '.claude/.state' }
    $reviewDir = Join-Path $stateRoot 'peer-review'
    New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null

    Set-Content -Path (Join-Path $reviewDir $sessionId) -Value (Get-Date -Format 'o') -NoNewline

    Get-ChildItem -Path $reviewDir -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
        Remove-Item -Force -ErrorAction SilentlyContinue

    exit 0
} catch {
    exit 0
}
