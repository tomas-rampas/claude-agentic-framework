#Requires -Version 7.0
# record-subagent-run.ps1 — recorder for the peer-review final gate.
#
# Fires on two events (both registered in settings.json, see settings.template.json):
#   - PostToolUse (matcher Task|Agent): a peer-review-critic subagent call completed
#     (or, for background launches, started — those carry no report text yet).
#   - SubagentStop: a peer-review-critic subagent finished; last_assistant_message
#     carries its final report.
#
# Writes a per-session marker that hooks/stop-peer-review-gate.ps1 checks:
#   line 1: ISO timestamp (legacy format ends here)
#   line 2: verdict=APPROVED|CHANGES_REQUIRED — present only when the report text
#           contains the standardized "VERDICT:" line (agents/peer-review-critic.md).
# The LAST occurrence in the report wins, so an early quoted verdict cannot spoof
# the real one. A marker without a verdict line keeps the legacy "reviewer ran"
# semantics (the gate treats it as unlocking — fail-open).
#
# Each qualifying run overwrites the marker: the latest review is the one that
# counts, which is what a fix -> re-review loop needs.
# Silent and fail-open; also prunes markers older than 7 days.

try {
    $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json -ErrorAction Stop

    $sessionId = ([string]$payload.session_id) -replace '[^\w-]', ''
    if (-not $sessionId) { exit 0 }

    $reportText = ''
    if ([string]$payload.hook_event_name -eq 'SubagentStop') {
        if ([string]$payload.agent_type -ne 'peer-review-critic') { exit 0 }
        $reportText = [string]$payload.last_assistant_message
    } else {
        # PostToolUse (Task|Agent). The response field is tool_response on current
        # builds and tool_output in the documented schema; the report text is either
        # a plain string or an object carrying a content[] array of text blocks.
        if ([string]$payload.tool_input.subagent_type -ne 'peer-review-critic') { exit 0 }
        $resp = $payload.tool_response
        if ($null -eq $resp) { $resp = $payload.tool_output }
        if ($resp -is [string]) {
            $reportText = $resp
        } elseif ($null -ne $resp -and $null -ne $resp.content) {
            $reportText = (@($resp.content) |
                Where-Object { $null -ne $_ -and $null -ne $_.text } |
                ForEach-Object { [string]$_.text }) -join "`n"
        }
    }

    $verdict = $null
    if ($reportText) {
        $m = [regex]::Matches($reportText, 'VERDICT:\s*(APPROVED|CHANGES_REQUIRED)')
        if ($m.Count -gt 0) { $verdict = $m[$m.Count - 1].Groups[1].Value }
    }

    $stateRoot = $env:CLAUDE_STATE_DIR
    if (-not $stateRoot) { $stateRoot = Join-Path $HOME '.claude/.state' }
    $reviewDir = Join-Path $stateRoot 'peer-review'
    New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null

    $lines = @((Get-Date -Format 'o'))
    if ($verdict) { $lines += "verdict=$verdict" }
    Set-Content -Path (Join-Path $reviewDir $sessionId) -Value ($lines -join "`n") -NoNewline

    Get-ChildItem -Path $reviewDir -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
        Remove-Item -Force -ErrorAction SilentlyContinue

    exit 0
} catch {
    exit 0
}
