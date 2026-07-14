#Requires -Version 7.0
<#
.SYNOPSIS
  Installs or updates the framework's runtime surface into ~/.claude.

.DESCRIPTION
  - Copies hooks/*.ps1 to ~/.claude/hooks/ (skipped when the repo IS ~/.claude).
  - Creates ~/.claude/settings.json from settings.template.json, or merges the
    "hooks" block into an existing settings.json (refuses to overwrite an
    existing hooks block unless -Force is given).
  - Rewrites the "$HOME/.claude/hooks" prefix in hook commands to the resolved
    absolute path (forward slashes) so commands work regardless of which shell
    Claude Code uses to invoke hooks on this platform.
  - Creates the ~/.claude/.state/peer-review/ session-state directory.

.EXAMPLE
  pwsh -NoProfile -File scripts/install.ps1
  pwsh -NoProfile -File scripts/install.ps1 -Force
#>
param([switch]$Force)

$ErrorActionPreference = 'Stop'

$repoRoot   = Split-Path -Parent $PSScriptRoot
$claudeHome = Join-Path $HOME '.claude'

Write-Host "Framework repo : $repoRoot"
Write-Host "Claude home    : $claudeHome"

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
    Write-Warning 'uvx (uv) not found on PATH - the serena MCP server will not start without it.'
}

# ── Hooks ──────────────────────────────────────────────────────────────────────
$targetHooks = Join-Path $claudeHome 'hooks'
New-Item -ItemType Directory -Force -Path $targetHooks | Out-Null

$repoResolved   = (Resolve-Path $repoRoot).Path.TrimEnd('\', '/')
$claudeResolved = if (Test-Path $claudeHome) { (Resolve-Path $claudeHome).Path.TrimEnd('\', '/') } else { $claudeHome }
if ($repoResolved -ne $claudeResolved) {
    Copy-Item -Path (Join-Path $repoRoot 'hooks' '*.ps1') -Destination $targetHooks -Force
    Write-Host "Copied hook scripts to $targetHooks"
} else {
    Write-Host 'Repo is ~/.claude itself - hook scripts already in place.'
}

# ── settings.json ──────────────────────────────────────────────────────────────
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
    Write-Host "Created $settingsPath from template."
} else {
    $current = Get-Content $settingsPath -Raw | ConvertFrom-Json
    $tpl     = $template | ConvertFrom-Json
    if ($current.PSObject.Properties['hooks'] -and -not $Force) {
        Write-Warning "A 'hooks' block already exists in $settingsPath - settings NOT modified."
        Write-Warning 'Re-run with -Force to replace the hooks block with the framework version.'
    } else {
        if ($current.PSObject.Properties['hooks']) {
            $current.hooks = $tpl.hooks
        } else {
            $current | Add-Member -NotePropertyName 'hooks' -NotePropertyValue $tpl.hooks
        }
        # -Depth 64: far above any realistic settings nesting, so the
        # round-trip can never silently truncate a user's existing keys.
        $current | ConvertTo-Json -Depth 64 | Set-Content -Path $settingsPath -NoNewline
        Write-Host "Merged framework hooks block into $settingsPath."
    }
}

# ── Session-state directory ────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path (Join-Path $claudeHome '.state' 'peer-review') | Out-Null

Write-Host ''
Write-Host 'Done. Reminders:'
Write-Host '  - MCP: project-level .mcp.json applies to sessions started in the repo directory.'
Write-Host '    If .claude/settings.local.json lists servers under disabledMcpjsonServers, remove'
Write-Host '    the ones you want active. Set CONTEXT7_API_KEY / MCP_FS_ROOT per .env.example.'
Write-Host '  - Restart any running Claude Code session to pick up the new hooks.'
