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
# The verdict line must occupy a whole line; of qualifying lines the LAST wins, so
# quoted mentions cannot spoof the real one. A marker without a verdict line keeps
# the legacy "reviewer ran" semantics (the gate treats it as unlocking — fail-open).
#
# A run that parsed a verdict overwrites the marker: the latest review is the one
# that counts, which is what a fix -> re-review loop needs. A run with NO parseable
# verdict never downgrades an existing verdict-bearing marker — both events fire for
# the same run (and a background launch's PostToolUse has no report text), so an
# unconditional overwrite would erase a real CHANGES_REQUIRED and unlock the gate.
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
        # builds and tool_output in the documented schema; the report text is a
        # plain string, an object carrying a content[] array of text blocks, or a
        # bare array of such blocks.
        if ([string]$payload.tool_input.subagent_type -ne 'peer-review-critic') { exit 0 }
        $resp = $payload.tool_response
        if ($null -eq $resp) { $resp = $payload.tool_output }
        $blocks = $null
        if ($resp -is [string]) {
            $reportText = $resp
        } elseif ($resp -is [System.Collections.IEnumerable]) {
            $blocks = @($resp)
        } elseif ($null -ne $resp -and $null -ne $resp.content) {
            $blocks = @($resp.content)
        }
        if ($null -ne $blocks) {
            $reportText = ($blocks | ForEach-Object {
                if ($_ -is [string]) { $_ }
                elseif ($null -ne $_ -and $null -ne $_.text) { [string]$_.text }
            }) -join "`n"
        }
    }

    $verdict = $null
    if ($reportText) {
        # Whole-line match only: quoted or mid-line mentions never count. Last wins.
        $m = [regex]::Matches($reportText, '(?m)^\s*VERDICT:[ \t]*(APPROVED|CHANGES_REQUIRED)[ \t]*\r?$')
        if ($m.Count -gt 0) { $verdict = $m[$m.Count - 1].Groups[1].Value }
    }

    $stateRoot = $env:CLAUDE_STATE_DIR
    if (-not $stateRoot) { $stateRoot = Join-Path $HOME '.claude/.state' }
    $reviewDir = Join-Path $stateRoot 'peer-review'
    New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null
    $marker = Join-Path $reviewDir $sessionId

    # No-downgrade guard: a verdict-less event must not erase a recorded verdict.
    if ($null -eq $verdict -and (Test-Path $marker)) {
        $existing = Get-Content -Path $marker -Raw -ErrorAction SilentlyContinue
        if ($existing -match 'verdict=') { exit 0 }
    }

    $lines = @((Get-Date -Format 'o'))
    if ($verdict) { $lines += "verdict=$verdict" }
    Set-Content -Path $marker -Value ($lines -join "`n") -NoNewline

    Get-ChildItem -Path $reviewDir -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
        Remove-Item -Force -ErrorAction SilentlyContinue

    exit 0
} catch {
    exit 0
}
