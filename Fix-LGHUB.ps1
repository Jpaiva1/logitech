# Fix-LGHUB.ps1
# Stops LGHUB Agent and starts LGHUB components as admin

$ErrorActionPreference = "SilentlyContinue"

Write-Host "Stopping Logitech G HUB processes..."

$processes = @(
    "lghub_agent",
    "lghub_updater",
    "lghub"
)

foreach ($p in $processes) {
    Get-Process $p -ErrorAction SilentlyContinue | Stop-Process -Force
}

Start-Sleep -Seconds 2

$possiblePaths = @(
    "$env:ProgramFiles\LGHUB",
    "${env:ProgramFiles(x86)}\LGHUB"
)

$lghubPath = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $lghubPath) {
    Write-Host "LGHUB folder not found in Program Files."
    Pause
    exit
}

Write-Host "Found LGHUB at: $lghubPath"

$files = @(
    "lghub_agent.exe",
    "lghub_updater.exe",
    "lghub.exe"
)

foreach ($file in $files) {
    $fullPath = Join-Path $lghubPath $file

    if (Test-Path $fullPath) {
        Write-Host "Starting $file as admin..."
        Start-Process -FilePath $fullPath -Verb RunAs
        Start-Sleep -Seconds 2
    } else {
        Write-Host "Missing: $fullPath"
    }
}

Write-Host "Done."
Pause
