param(
    [string]$SourceScript
)

$ErrorActionPreference = "Stop"

$skillDir = Split-Path -Parent $PSCommandPath
$SourceScript = if ([string]::IsNullOrWhiteSpace($SourceScript)) {
    Join-Path $skillDir "pdf_to_annotated_markdown.py"
} else {
    $SourceScript
}
$venvDir = Join-Path $skillDir ".build\pdf-tool-pack-venv"
$workDir = Join-Path $skillDir ".build\pyinstaller"
$distDir = Join-Path $skillDir "bin"

if (-not (Test-Path -LiteralPath $SourceScript)) {
    throw "Source script not found: $SourceScript"
}

if (-not (Test-Path -LiteralPath $venvDir)) {
    py -3 -m venv $venvDir
}

$pythonExe = Join-Path $venvDir "Scripts\python.exe"
if (-not (Test-Path -LiteralPath $pythonExe)) {
    throw "Python executable not found in venv: $pythonExe"
}

& $pythonExe -m pip install --upgrade pip | Out-Null
& $pythonExe -m pip install pyinstaller pymupdf | Out-Null

New-Item -ItemType Directory -Force -Path $distDir | Out-Null
New-Item -ItemType Directory -Force -Path $workDir | Out-Null

& $pythonExe -m PyInstaller `
    --onefile `
    --console `
    --clean `
    --name pdf-to-annotated-markdown `
    --distpath $distDir `
    --workpath $workDir `
    --specpath $workDir `
    $SourceScript

Write-Output (Join-Path $distDir "pdf-to-annotated-markdown.exe")
