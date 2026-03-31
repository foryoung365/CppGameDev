@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "REPO_ROOT=%%~fI"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
	"$ErrorActionPreference = 'Stop';" ^
	"$repo = (Resolve-Path '%REPO_ROOT%').Path;" ^
	"$pluginJson = Join-Path $repo '.claude-plugin\plugin.json';" ^
	"$marketplaceJson = Join-Path $repo '.claude-plugin\marketplace.json';" ^
	"if (-not (Test-Path -LiteralPath $pluginJson)) { throw 'Missing plugin manifest: ' + $pluginJson };" ^
	"if (-not (Test-Path -LiteralPath $marketplaceJson)) { throw 'Missing marketplace manifest: ' + $marketplaceJson };" ^
	"$plugin = Get-Content -Raw -LiteralPath $pluginJson | ConvertFrom-Json;" ^
	"$marketplace = Get-Content -Raw -LiteralPath $marketplaceJson | ConvertFrom-Json;" ^
	"$originalVersion = [string]$plugin.version;" ^
	"$versionPattern = '^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$';" ^
	"if ($originalVersion -notmatch $versionPattern) { throw 'Unsupported version format in plugin.json: ' + $originalVersion };" ^
	"$nextVersion = '{0}.{1}.{2}' -f $Matches.major, $Matches.minor, ([int]$Matches.patch + 1);" ^
	"$plugin.version = $nextVersion;" ^
	"$marketplace.metadata.version = $nextVersion;" ^
	"$pluginEntry = @($marketplace.plugins | Where-Object name -eq $plugin.name);" ^
	"if ($pluginEntry.Count -ne 1) { throw 'marketplace.json must contain exactly one plugin entry named ' + $plugin.name };" ^
	"$pluginEntry[0].version = $nextVersion;" ^
	"$utf8NoBom = New-Object System.Text.UTF8Encoding($false);" ^
	"[System.IO.File]::WriteAllText($pluginJson, ($plugin | ConvertTo-Json -Depth 10), $utf8NoBom);" ^
	"[System.IO.File]::WriteAllText($marketplaceJson, ($marketplace | ConvertTo-Json -Depth 10), $utf8NoBom);" ^
	"$rollbackNeeded = $true;" ^
	"try {" ^
	"$dist = Join-Path $repo 'dist';" ^
	"$stage = Join-Path $dist $plugin.name;" ^
	"$zip = Join-Path $dist ($plugin.name + '-' + $plugin.version + '.zip');" ^
	"$paths = @('.claude-plugin','agents','commands','skills','docs\operator','docs\workflow','docs\gameplay','docs\svn');" ^
	"Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue;" ^
	"Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue;" ^
	"New-Item -ItemType Directory -Force -Path $stage | Out-Null;" ^
	"foreach ($relative in $paths) {" ^
	"  $source = Join-Path $repo $relative;" ^
	"  if (-not (Test-Path -LiteralPath $source)) { throw 'Missing source path: ' + $source };" ^
	"  $destination = Join-Path $stage $relative;" ^
	"  $parent = Split-Path -Path $destination -Parent;" ^
	"  New-Item -ItemType Directory -Force -Path $parent | Out-Null;" ^
	"  Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force;" ^
	"}" ^
	"Copy-Item -LiteralPath (Join-Path $repo 'README.md') -Destination (Join-Path $stage 'README.md') -Force;" ^
	"Copy-Item -LiteralPath (Join-Path $repo 'settings.json') -Destination (Join-Path $stage 'settings.json') -Force;" ^
	"$expected = @(" ^
	"  'agents\gameplay-learnings-researcher.md'," ^
	"  'commands\gp-compound.md'," ^
	"  'commands\gp-compound-refresh.md'," ^
	"  'skills\gp-compound\SKILL.md'," ^
	"  'skills\gp-compound-refresh\SKILL.md'," ^
	"  'skills\gp-experience-check\SKILL.md'," ^
	"  'skills\gp-task-stage-discipline\SKILL.md'," ^
	"  'skills\gp-task-stage-discipline\references\task-stage-templates.md'" ^
	");" ^
	"foreach ($relative in $expected) {" ^
	"  $target = Join-Path $stage $relative;" ^
	"  if (-not (Test-Path -LiteralPath $target)) { throw 'Missing packaged runtime file: ' + $target };" ^
	"}" ^
	"$forbidden = @(" ^
	"  'docs\superpowers'," ^
	"  'docs\upstream-mapping.md'," ^
	"  'tests'," ^
	"  '.tmp'," ^
	"  'docs\cpp-mmorpg-gameplay'," ^
	"  'docs\solutions'" ^
	");" ^
	"foreach ($relative in $forbidden) {" ^
	"  $target = Join-Path $stage $relative;" ^
	"  if (Test-Path -LiteralPath $target) { throw 'Forbidden packaged path present: ' + $target };" ^
	"}" ^
	"Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -Force;" ^
	"if (Test-Path -LiteralPath $stage) { [System.IO.Directory]::Delete($stage, $true) };" ^
	"$rollbackNeeded = $false;" ^
	"Write-Host '[OK] Version bumped to:' $nextVersion;" ^
	"Write-Host '[OK] Package created:' $zip;" ^
	"} finally {" ^
	"  if ($rollbackNeeded) {" ^
	"    $plugin.version = $originalVersion;" ^
	"    $marketplace.metadata.version = $originalVersion;" ^
	"    $pluginEntry[0].version = $originalVersion;" ^
	"    [System.IO.File]::WriteAllText($pluginJson, ($plugin | ConvertTo-Json -Depth 10), $utf8NoBom);" ^
	"    [System.IO.File]::WriteAllText($marketplaceJson, ($marketplace | ConvertTo-Json -Depth 10), $utf8NoBom);" ^
	"  }" ^
	"}"

if errorlevel 1 exit /b %errorlevel%
exit /b 0
