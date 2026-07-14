#Requires -Version 7.0
# stop-peer-review-gate.ps1 — blocking Stop hook enforcing the peer-review final gate.
#
# Blocks ending a session when the current feature branch has committed work ahead of
# its base and the peer-review-critic subagent has not run this session.
# Loop-safe (stop_hook_active), fires at most once per session (.fired marker),
# fail-open: any error, parse failure, or non-git context => exit 0 with no output.
#
# Registered in settings.json under hooks.Stop (see settings.template.json).
# Session markers are written by hooks/record-subagent-run.ps1.

try {
    $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json -ErrorAction Stop

    if ($payload.stop_hook_active) { exit 0 }

    $sessionId = ([string]$payload.session_id) -replace '[^\w-]', ''
    if (-not $sessionId) { exit 0 }

    $stateRoot = $env:CLAUDE_STATE_DIR
    if (-not $stateRoot) { $stateRoot = Join-Path $HOME '.claude/.state' }
    $reviewDir = Join-Path $stateRoot 'peer-review'
    $marker    = Join-Path $reviewDir $sessionId
    $fired     = Join-Path $reviewDir "$sessionId.fired"

    if (Test-Path $marker) { exit 0 }   # peer-review-critic already ran this session
    if (Test-Path $fired)  { exit 0 }   # gate already fired once this session

    $cwd = [string]$payload.cwd
    if (-not $cwd -or -not (Test-Path $cwd)) { $cwd = (Get-Location).Path }

    $inTree = git -C $cwd rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $inTree -ne 'true') { exit 0 }

    $branch = git -C $cwd rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $branch -or $branch -eq 'HEAD') { exit 0 }
    if ($branch -in @('main', 'master')) { exit 0 }

    $base = $null
    foreach ($candidate in @('origin/main', 'origin/master', 'main', 'master')) {
        git -C $cwd rev-parse --verify --quiet $candidate *> $null
        if ($LASTEXITCODE -eq 0) { $base = $candidate; break }
    }
    if (-not $base) { exit 0 }

    $ahead = git -C $cwd rev-list --count "$base..HEAD" 2>$null
    if ($LASTEXITCODE -ne 0 -or [int]$ahead -eq 0) { exit 0 }

    # Uncommitted work means the session is mid-flight; the gate only guards
    # "done" states (committed, clean tree, unreviewed).
    $dirty = git -C $cwd status --porcelain 2>$null
    if ($LASTEXITCODE -ne 0 -or $dirty) { exit 0 }

    New-Item -ItemType Directory -Force -Path $reviewDir | Out-Null
    New-Item -ItemType File -Force -Path $fired | Out-Null

    $reason = "Peer-review final gate: branch '$branch' has $ahead commit(s) ahead of $base that have not " +
              'been peer reviewed this session. Launch the peer-review-critic subagent (Task tool, ' +
              "subagent_type: peer-review-critic) to review the branch diff against $base and resolve " +
              'every BLOCKER/MAJOR finding, or ask the user to explicitly waive the gate.'
    @{ decision = 'block'; reason = $reason } | ConvertTo-Json -Compress
    exit 0
} catch {
    exit 0
}
