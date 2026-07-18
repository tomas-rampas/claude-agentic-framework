#Requires -Version 7.0
# install.test.ps1 — plain-pwsh test harness for scripts/install.ps1 (no Pester).
#
# Runs the real installer against an isolated -ClaudeHome sandbox (its sibling
# .claude.json is the user-scope MCP target) and asserts on the report output,
# the deployed files, and — critically — that the MCP merge never overwrites a
# user's existing server definition. Exit 0 = all pass.
#
# Usage: pwsh -NoProfile -File tests/install.test.ps1

$ErrorActionPreference = 'Stop'

$repoRoot  = Split-Path -Parent $PSScriptRoot
$installer = Join-Path $repoRoot 'scripts' 'install.ps1'
$failures  = 0

$workRoot   = Join-Path ([IO.Path]::GetTempPath()) ("install-test-" + [guid]::NewGuid().ToString('N'))
$sandboxDir = Join-Path $workRoot 'home'
$claudeHome = Join-Path $sandboxDir '.claude'
$claudeJson = Join-Path $sandboxDir '.claude.json'
New-Item -ItemType Directory -Force -Path $sandboxDir | Out-Null

function Invoke-Installer {
    param([string[]]$ExtraArgs = @())
    $out = pwsh -NoProfile -File $installer -ClaudeHome $claudeHome @ExtraArgs 2>&1
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

$repoHookCount = (Get-ChildItem (Join-Path $repoRoot 'hooks') -Filter '*.ps1').Count
$repoMcpNames  = ((Get-Content (Join-Path $repoRoot '.mcp.json') -Raw | ConvertFrom-Json).mcpServers.PSObject.Properties.Name)

Write-Host "fresh install"

$r = Invoke-Installer
Assert 'exits 0' ($r.Code -eq 0)
Assert 'copies every hook as new' ((Get-ChildItem (Join-Path $claudeHome 'hooks') -Filter '*.ps1').Count -eq $repoHookCount -and ([regex]::Matches($r.Out, '(?m)\.ps1\s+new$')).Count -eq $repoHookCount)
Assert 'creates settings.json from template' ((Test-Path (Join-Path $claudeHome 'settings.json')) -and $r.Out -match 'created from template')
Assert 'creates state dir' (Test-Path (Join-Path $claudeHome '.state' 'peer-review'))
$cfg = Get-Content $claudeJson -Raw | ConvertFrom-Json
Assert 'creates .claude.json with all framework servers' (@($cfg.mcpServers.PSObject.Properties.Name | Where-Object { $_ -in $repoMcpNames }).Count -eq $repoMcpNames.Count)
Assert 'expands ${VAR:-default} placeholders' (($cfg.mcpServers.filesystem | ConvertTo-Json -Depth 8 -Compress) -notmatch '\$\{')
Assert 'reports surfaces not a git clone' ($r.Out -match 'not a git clone')

Write-Host "idempotent re-run"

$r = Invoke-Installer -ExtraArgs @('-Force')
Assert 'exits 0' ($r.Code -eq 0)
Assert 'all hooks unchanged' (([regex]::Matches($r.Out, '(?m)\.ps1\s+unchanged$')).Count -eq $repoHookCount)
Assert 'all servers already present (identical)' (([regex]::Matches($r.Out, 'already present \(identical\)')).Count -eq $repoMcpNames.Count)
Assert 'does not rewrite .claude.json' ($r.Out -match 'nothing to add' -and -not (Get-ChildItem $sandboxDir -Filter '.claude.json.bak-*'))

Write-Host "MCP merge never clobbers user definitions"

# A user config with a personal server plus a conflicting definition for a
# framework server name.
$userCfg = [pscustomobject]@{
    someUserState = [pscustomobject]@{ keep = $true }
    mcpServers    = [pscustomobject]@{
        github = [pscustomobject]@{ command = 'my-github-mcp'; args = @('--token', 'SECRET') }
        fetch  = [pscustomobject]@{ command = 'my-custom-fetch'; args = @() }
    }
}
$userCfg | ConvertTo-Json -Depth 16 | Set-Content $claudeJson -NoNewline

$r = Invoke-Installer
$cfg = Get-Content $claudeJson -Raw | ConvertFrom-Json
Assert 'exits 0' ($r.Code -eq 0)
Assert 'adds the missing framework servers' (@($cfg.mcpServers.PSObject.Properties.Name | Where-Object { $_ -in $repoMcpNames }).Count -eq $repoMcpNames.Count)
Assert 'reports the conflicting server as kept' ($r.Out -match 'fetch\s+kept yours')
Assert 'user definition of conflicting server survives' ($cfg.mcpServers.fetch.command -eq 'my-custom-fetch')
Assert 'personal (non-framework) server survives' ($cfg.mcpServers.github.command -eq 'my-github-mcp')
Assert 'unrelated user state survives the round-trip' ($cfg.someUserState.keep -eq $true)
Assert 'backup written before modifying an existing file' ((Get-ChildItem $sandboxDir -Filter '.claude.json.bak-*').Count -ge 1)

# The headline guarantee: existing definitions are never overwritten EVEN WITH
# -Force. Seed a config that is simultaneously MISSING one framework server and
# CONFLICTING on another, so the -Force run performs a real write (add) while
# the conflict must survive it — a future -Force branch in the MCP path cannot
# silently break the promise without failing here.
$cfg = Get-Content $claudeJson -Raw | ConvertFrom-Json
$cfg.mcpServers.PSObject.Properties.Remove('serena')
$cfg | ConvertTo-Json -Depth 32 | Set-Content $claudeJson -NoNewline
$r = Invoke-Installer -ExtraArgs @('-Force')
$cfg = Get-Content $claudeJson -Raw | ConvertFrom-Json
Assert '-Force run performs a real add (missing server restored)' ($r.Out -match 'serena\s+added' -and $null -ne $cfg.mcpServers.serena)
Assert '-Force still reports conflicting server as kept' ($r.Out -match 'fetch\s+kept yours')
Assert '-Force write never clobbers the user definition' ($cfg.mcpServers.fetch.command -eq 'my-custom-fetch')

Write-Host "mcpServers present but null (post-reset shape)"

[pscustomobject]@{ userKey = 42; mcpServers = $null } | ConvertTo-Json -Depth 4 | Set-Content $claudeJson -NoNewline
$r = Invoke-Installer
$cfg = Get-Content $claudeJson -Raw | ConvertFrom-Json
Assert 'null mcpServers: exit 0, no crash' ($r.Code -eq 0)
Assert 'null mcpServers: re-initialized and servers added' (@($cfg.mcpServers.PSObject.Properties.Name | Where-Object { $_ -in $repoMcpNames }).Count -eq $repoMcpNames.Count)
Assert 'null mcpServers: unrelated user state survives' ($cfg.userKey -eq 42)

Write-Host "case-colliding keys (real-world Windows projects map)"

# Claude Code's own config can hold keys differing only by case; the default
# (case-insensitive) ConvertFrom-Json rejects the whole file. The installer
# must parse case-sensitively, merge, and preserve both keys byte-faithfully.
Set-Content $claudeJson -Value '{"projects":{"d:/repo":{"n":1},"D:/repo":{"n":2}},"mcpServers":{}}' -NoNewline
$r = Invoke-Installer
$rawOut = Get-Content $claudeJson -Raw
$cfgHt = $rawOut | ConvertFrom-Json -AsHashtable
Assert 'case-colliding keys: exit 0 and merge performed' ($r.Code -eq 0 -and $r.Out -match 'filesystem\s+added')
Assert 'case-colliding keys: all framework servers added' (@($repoMcpNames | Where-Object { $cfgHt['mcpServers'].Contains($_) }).Count -eq $repoMcpNames.Count)
Assert 'both case-variant keys survive with their values' ($cfgHt['projects']['d:/repo']['n'] -eq 1 -and $cfgHt['projects']['D:/repo']['n'] -eq 2)

# Server-name matching is case-INSENSITIVE: a user's "Fetch" counts as the
# framework's "fetch" - kept, never duplicated as a case-variant sibling.
Set-Content $claudeJson -Value '{"mcpServers":{"Fetch":{"command":"my-cased-fetch"}}}' -NoNewline
$r = Invoke-Installer
$cfgHt = Get-Content $claudeJson -Raw | ConvertFrom-Json -AsHashtable
Assert 'case-variant server name reported kept' ($r.Out -match 'fetch\s+kept yours')
Assert 'no case-variant duplicate added' (-not $cfgHt['mcpServers'].Contains('fetch') -and $cfgHt['mcpServers']['Fetch'].command -eq 'my-cased-fetch')

Write-Host "settings.json hooks-block safety"

$s = Get-Content (Join-Path $claudeHome 'settings.json') -Raw | ConvertFrom-Json
$s | Add-Member -NotePropertyName 'userKey' -NotePropertyValue 'keep-me' -Force
$s.hooks = [pscustomobject]@{ Stop = @() }   # user-customized hooks block
$s | ConvertTo-Json -Depth 32 | Set-Content (Join-Path $claudeHome 'settings.json') -NoNewline

$r = Invoke-Installer
$s = Get-Content (Join-Path $claudeHome 'settings.json') -Raw | ConvertFrom-Json
Assert 'without -Force: existing hooks block untouched' ($r.Out -match 'NOT modified' -and @($s.hooks.PSObject.Properties.Name).Count -eq 1)

$r = Invoke-Installer -ExtraArgs @('-Force')
$s = Get-Content (Join-Path $claudeHome 'settings.json') -Raw | ConvertFrom-Json
Assert 'with -Force: hooks block replaced' ($r.Out -match 'replaced \(-Force\)' -and $null -ne $s.hooks.SubagentStop)
Assert 'with -Force: user keys preserved' ($s.userKey -eq 'keep-me')

Write-Host "resilience"

Set-Content $claudeJson -Value '{ not valid json' -NoNewline
$r = Invoke-Installer
Assert 'malformed .claude.json: MCP skipped, exit 0' ($r.Code -eq 0 -and $r.Out -match 'not valid JSON')
Assert 'malformed .claude.json left untouched' ((Get-Content $claudeJson -Raw) -eq '{ not valid json')

$r = Invoke-Installer -ExtraArgs @('-SkipMcp')
Assert '-SkipMcp skips the MCP step' ($r.Code -eq 0 -and $r.Out -match 'skipped \(-SkipMcp\)')

# ── Teardown ───────────────────────────────────────────────────────────────────
Remove-Item -Recurse -Force $workRoot -ErrorAction SilentlyContinue

Write-Host ''
if ($failures -gt 0) {
    Write-Host "RESULT: FAIL ($failures assertion(s) failed)" -ForegroundColor Red
    exit 1
}
Write-Host 'RESULT: PASS (all installer assertions passed)'
exit 0
