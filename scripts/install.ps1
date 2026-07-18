#Requires -Version 7.0
<#
.SYNOPSIS
  Installs or updates the framework's runtime surface into ~/.claude.

.DESCRIPTION
  - Copies hooks/*.ps1 to ~/.claude/hooks/ (skipped when the repo IS ~/.claude),
    reporting per-script whether it was new, updated, or unchanged.
  - Creates ~/.claude/settings.json from settings.template.json, or merges the
    "hooks" block into an existing settings.json (refuses to overwrite an
    existing hooks block unless -Force is given).
  - Rewrites the "$HOME/.claude/hooks" prefix in hook commands to the resolved
    absolute path (forward slashes) so commands work regardless of which shell
    Claude Code uses to invoke hooks on this platform.
  - Merges the framework's MCP servers (.mcp.json) into the user-scope
    ~/.claude.json "mcpServers" block: missing servers are ADDED, existing
    definitions are NEVER overwritten (yours always wins, even with -Force);
    ${VAR:-default} placeholders are expanded from the environment at install
    time. A timestamped backup is written before any change. -SkipMcp skips
    this step entirely.
  - Reports whether ~/.claude is a git clone of this framework and, if so,
    whether its checkout (commands/, agents/, skills/) is behind this repo —
    the installer does NOT sync those surfaces; `git -C ~/.claude pull` does.
  - Creates the ~/.claude/.state/peer-review/ session-state directory.

.EXAMPLE
  pwsh -NoProfile -File scripts/install.ps1
  pwsh -NoProfile -File scripts/install.ps1 -Force
  pwsh -NoProfile -File scripts/install.ps1 -ClaudeHome C:\sandbox\.claude   # isolated (tests)
#>
param(
    [switch]$Force,
    [switch]$SkipMcp,
    [string]$ClaudeHome = (Join-Path $HOME '.claude')
)

$ErrorActionPreference = 'Stop'
# Native commands (git) signal via exit codes we inspect; never let a future
# PowerShell default promote their non-zero exits to terminating errors.
$PSNativeCommandUseErrorActionPreference = $false

$repoRoot   = Split-Path -Parent $PSScriptRoot
$claudeHome = $ClaudeHome
# User-scope Claude Code config (where `claude mcp add --scope user` writes):
# the .claude.json sibling of the .claude directory.
$claudeJsonPath = Join-Path (Split-Path $claudeHome -Parent) '.claude.json'

Write-Host "Framework repo : $repoRoot"
Write-Host "Claude home    : $claudeHome"

# ── Helpers ────────────────────────────────────────────────────────────────────

# Canonical JSON (sorted object keys, compact) so two definitions can be
# compared semantically regardless of property order.
function Get-CanonJson($node) {
    if ($null -eq $node) { return 'null' }
    if ($node -is [System.Management.Automation.PSCustomObject]) {
        $parts = $node.PSObject.Properties | Sort-Object Name | ForEach-Object {
            (ConvertTo-Json $_.Name -Compress) + ':' + (Get-CanonJson $_.Value)
        }
        return '{' + ($parts -join ',') + '}'
    }
    if ($node -is [System.Collections.IEnumerable] -and $node -isnot [string]) {
        $parts = @($node) | ForEach-Object { Get-CanonJson $_ }
        return '[' + ($parts -join ',') + ']'
    }
    return (ConvertTo-Json $node -Compress -Depth 2)
}

# Expand ${VAR} / ${VAR:-default} from the current environment (the syntax the
# repo's .mcp.json uses). Applied at install time so the merged user-scope
# definition is self-contained.
function Expand-EnvPlaceholder([string]$s) {
    return [regex]::Replace($s, '\$\{(\w+)(?::-([^}]*))?\}', {
        param($m)
        $v = [Environment]::GetEnvironmentVariable($m.Groups[1].Value)
        if ($null -ne $v -and $v -ne '') { $v } else { $m.Groups[2].Value }
    })
}

function Expand-ServerDef($node) {
    if ($node -is [string]) { return (Expand-EnvPlaceholder $node) }
    if ($node -is [System.Management.Automation.PSCustomObject]) {
        $out = [ordered]@{}
        foreach ($p in $node.PSObject.Properties) { $out[$p.Name] = Expand-ServerDef $p.Value }
        return [pscustomobject]$out
    }
    if ($node -is [System.Collections.IEnumerable] -and $node -isnot [string]) {
        return @(@($node) | ForEach-Object { Expand-ServerDef $_ })
    }
    return $node
}

# ── Prerequisites ──────────────────────────────────────────────────────────────
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git is required but was not found on PATH.'
}
foreach ($tool in @('jq', 'node', 'npx')) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Warning "$tool not found on PATH ($tool is needed for the validation scripts / MCP servers)."
    }
}
if (-not (Get-Command uvx -ErrorAction SilentlyContinue)) {
    Write-Warning 'uvx (uv) not found on PATH - the serena and fetch MCP servers will not start without it.'
}

$summary = [ordered]@{}

# ── Hooks ──────────────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '== Hooks =='
$targetHooks = Join-Path $claudeHome 'hooks'
New-Item -ItemType Directory -Force -Path $targetHooks | Out-Null

$repoResolved   = (Resolve-Path $repoRoot).Path.TrimEnd('\', '/')
$claudeResolved = if (Test-Path $claudeHome) { (Resolve-Path $claudeHome).Path.TrimEnd('\', '/') } else { $claudeHome }
if ($repoResolved -ne $claudeResolved) {
    $hookNew = 0; $hookUpd = 0; $hookSame = 0
    foreach ($src in Get-ChildItem (Join-Path $repoRoot 'hooks') -Filter '*.ps1') {
        $dst = Join-Path $targetHooks $src.Name
        if (-not (Test-Path $dst)) {
            Copy-Item $src.FullName $dst -Force
            Write-Host ("  {0,-34} new" -f $src.Name); $hookNew++
        } elseif ((Get-FileHash $dst).Hash -ne (Get-FileHash $src.FullName).Hash) {
            Copy-Item $src.FullName $dst -Force
            Write-Host ("  {0,-34} updated" -f $src.Name); $hookUpd++
        } else {
            Write-Host ("  {0,-34} unchanged" -f $src.Name); $hookSame++
        }
    }
    $summary['hooks'] = "$hookNew new, $hookUpd updated, $hookSame unchanged"
} else {
    Write-Host '  repo is ~/.claude itself - hook scripts already in place.'
    $summary['hooks'] = 'in place (repo is ~/.claude)'
}

# ── settings.json ──────────────────────────────────────────────────────────────
Write-Host ''
Write-Host "== settings.json ($(Join-Path $claudeHome 'settings.json')) =="
$templatePath = Join-Path $repoRoot 'settings.template.json'
$template     = Get-Content $templatePath -Raw

# Hard-wire the hooks directory path so hook commands do not depend on the
# invoking shell expanding $HOME (cmd.exe on Windows would not).
$hooksPathForJson = ($targetHooks -replace '\\', '/')
$template = $template.Replace('$HOME/.claude/hooks', $hooksPathForJson)

$settingsPath = Join-Path $claudeHome 'settings.json'
if (-not (Test-Path $settingsPath)) {
    New-Item -ItemType Directory -Force -Path $claudeHome | Out-Null
    Set-Content -Path $settingsPath -Value $template -NoNewline
    Write-Host '  created from template.'
    $summary['settings'] = 'created'
} else {
    $current = Get-Content $settingsPath -Raw | ConvertFrom-Json
    $tpl     = $template | ConvertFrom-Json
    if ($current.PSObject.Properties['hooks'] -and -not $Force) {
        Write-Warning "A 'hooks' block already exists in $settingsPath - settings NOT modified."
        Write-Warning 'Re-run with -Force to replace the hooks block with the framework version.'
        $summary['settings'] = 'left untouched (hooks block exists; use -Force)'
    } else {
        $had = [bool]$current.PSObject.Properties['hooks']
        if ($had) {
            $current.hooks = $tpl.hooks
        } else {
            $current | Add-Member -NotePropertyName 'hooks' -NotePropertyValue $tpl.hooks
        }
        # -Depth 64: far above any realistic settings nesting, so the
        # round-trip can never silently truncate a user's existing keys.
        $current | ConvertTo-Json -Depth 64 | Set-Content -Path $settingsPath -NoNewline
        $events = ($tpl.hooks.PSObject.Properties.Name | Sort-Object) -join ', '
        Write-Host ("  hooks block {0}; events registered: {1}" -f ($had ? 'replaced (-Force)' : 'merged'), $events)
        $summary['settings'] = $had ? 'hooks block replaced' : 'hooks block merged'
    }
}

# ── MCP servers -> user-scope ~/.claude.json ───────────────────────────────────
Write-Host ''
Write-Host "== MCP servers ($claudeJsonPath) =="
if ($SkipMcp) {
    Write-Host '  skipped (-SkipMcp).'
    $summary['mcp'] = 'skipped'
} else {
    $mcpSourcePath = Join-Path $repoRoot '.mcp.json'
    $frameworkMcp  = (Get-Content $mcpSourcePath -Raw | ConvertFrom-Json).mcpServers

    $userConfig = $null
    $mcpOk = $true
    if (Test-Path $claudeJsonPath) {
        try {
            $userConfig = Get-Content $claudeJsonPath -Raw | ConvertFrom-Json
        } catch {
            Write-Warning "  $claudeJsonPath exists but is not valid JSON - MCP step skipped, file untouched."
            $summary['mcp'] = 'skipped (existing file unparseable)'
            $mcpOk = $false
        }
    } else {
        $userConfig = [pscustomobject]@{}
        Write-Host '  no existing file - a minimal one will be created.'
    }

    if ($mcpOk) {
        # Absent OR present-but-not-an-object (e.g. "mcpServers": null after a
        # config reset) both mean "no usable server map" - re-initialise rather
        # than crash indexing into null. Fail-open, like the malformed-file path.
        if (-not ($userConfig.mcpServers -is [System.Management.Automation.PSCustomObject])) {
            $userConfig | Add-Member -NotePropertyName 'mcpServers' -NotePropertyValue ([pscustomobject]@{}) -Force
        }
        $added = 0; $identical = 0; $kept = 0
        foreach ($p in $frameworkMcp.PSObject.Properties) {
            $name     = $p.Name
            $resolved = Expand-ServerDef $p.Value
            $existing = $userConfig.mcpServers.PSObject.Properties[$name]
            if ($null -eq $existing) {
                $userConfig.mcpServers | Add-Member -NotePropertyName $name -NotePropertyValue $resolved
                Write-Host ("  {0,-22} added" -f $name); $added++
            } elseif ((Get-CanonJson $existing.Value) -eq (Get-CanonJson $resolved)) {
                Write-Host ("  {0,-22} already present (identical)" -f $name); $identical++
            } else {
                Write-Host ("  {0,-22} kept yours (differs from framework definition - never overwritten)" -f $name); $kept++
            }
        }
        if ($added -gt 0) {
            if (Test-Path $claudeJsonPath) {
                $backup = "$claudeJsonPath.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Copy-Item $claudeJsonPath $backup -Force
                Write-Host "  backup: $backup"
            }
            # Atomic replace: serialize to a temp file, verify the round-trip is
            # lossless (catches any silent depth truncation - -Depth 100 is the
            # ConvertTo-Json maximum and ~/.claude.json holds deep Claude Code
            # state), then move into place. The original is untouched until the
            # verified move, so a failure can never corrupt it; the finally
            # guarantees no stray temp file survives any failure path.
            $tmp = "$claudeJsonPath.tmp-$PID"
            try {
                $userConfig | ConvertTo-Json -Depth 100 | Set-Content -Path $tmp -NoNewline
                $reparsed = Get-Content $tmp -Raw | ConvertFrom-Json
                if ((Get-CanonJson $reparsed) -ne (Get-CanonJson $userConfig)) {
                    throw "Round-trip verification failed for $claudeJsonPath - original left untouched."
                }
                Move-Item $tmp $claudeJsonPath -Force
            } finally {
                if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
            }
            Write-Host "  wrote $claudeJsonPath (re-serialized; formatting of untouched content may normalize)"
        } else {
            Write-Host '  nothing to add - file untouched.'
        }
        $summary['mcp'] = "$added added, $identical identical, $kept kept yours"
    }
}

# ── Framework surfaces (commands / agents / skills) ────────────────────────────
Write-Host ''
Write-Host '== Framework surfaces (commands / agents / skills) =='
if ($repoResolved -eq $claudeResolved) {
    Write-Host '  repo is ~/.claude itself - surfaces are this checkout.'
    $summary['surfaces'] = 'this checkout'
} elseif (Test-Path (Join-Path $claudeHome '.git')) {
    $claudeHead = git -C $claudeHome rev-parse --short HEAD 2>$null
    $repoHead   = git -C $repoRoot   rev-parse --short HEAD 2>$null
    if ($claudeHead -and $repoHead) {
        if ($claudeHead -eq $repoHead) {
            Write-Host "  ~/.claude is a git checkout at $claudeHead - in sync with this repo."
            $summary['surfaces'] = 'in sync'
        } else {
            git -C $repoRoot merge-base --is-ancestor $claudeHead HEAD 2>$null
            if ($LASTEXITCODE -eq 0) {
                $behind = git -C $repoRoot rev-list --count "$claudeHead..HEAD" 2>$null
                Write-Warning ("  ~/.claude checkout ($claudeHead) is BEHIND this repo ($repoHead) by $behind commit(s).")
                Write-Warning ("  Its commands/, agents/ and skills/ are stale - this installer does not sync them. Run:")
                Write-Warning ("    git -C `"$claudeHome`" pull")
                $summary['surfaces'] = "BEHIND by $behind commit(s) - run git pull in ~/.claude"
            } else {
                Write-Warning ("  ~/.claude checkout ($claudeHead) differs from this repo ($repoHead) and is not an ancestor - inspect manually.")
                $summary['surfaces'] = 'diverged - inspect manually'
            }
        }
    } else {
        Write-Host '  could not read git state - skipped.'
        $summary['surfaces'] = 'unknown (git state unreadable)'
    }
} else {
    Write-Host '  ~/.claude is not a git clone - commands/agents/skills are not managed by this installer.'
    $summary['surfaces'] = 'not a git clone'
}

# ── Session-state directory ────────────────────────────────────────────────────
$stateDir = Join-Path $claudeHome '.state' 'peer-review'
$stateExisted = Test-Path $stateDir
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
$summary['state dir'] = $stateExisted ? 'exists' : 'created'

# ── Summary ────────────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '== Summary =='
foreach ($k in $summary.Keys) { Write-Host ("  {0,-10} {1}" -f "$($k):", $summary[$k]) }
Write-Host ''
Write-Host 'Reminders:'
Write-Host '  - Best run with no Claude Code session active: ~/.claude.json is Claude Code''s'
Write-Host '    live config, and a session writing it concurrently could lose the merge.'
Write-Host '  - MCP servers merged into the user scope apply everywhere; the project-level'
Write-Host '    .mcp.json still applies to sessions started in the repo directory. Set'
Write-Host '    CONTEXT7_API_KEY / MCP_FS_ROOT per .env.example (placeholders were expanded'
Write-Host '    from the environment at install time).'
Write-Host '  - Restart any running Claude Code session to pick up new hooks and commands.'
