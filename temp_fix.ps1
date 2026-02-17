$script:content = $null
$script:patchesApplied = 0

function Apply-Patch {
    param(
        [string]$Name,
        [string]$Pattern,
        [string]$Replacement
    )
    
    Write-Host "[$Name] " -NoNewline
    
    if ($script:content -match $Pattern) {
        $script:content = $script:content -replace $Pattern, $Replacement
        Write-Host "Applied" -ForegroundColor Green
        $script:patchesApplied++
    } else {
        Write-Host "Patch failed (file already patched or pattern changed)" -ForegroundColor Yellow
    }
}

$entries = Get-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\Global\NvApp" -ErrorAction SilentlyContinue
if ($entries.Installed -ne 1) {
    Write-Host "NVIDIA App is not installed" -ForegroundColor Red
    exit 1
}

$nvidiaApp = (Get-Item -Path $entries.FullPath).Directory.Parent.FullName
$mainJs = Get-ChildItem -Path "$nvidiaApp\osc" -Filter "main.*.js" -File | Select-Object -First 1

if (-not $mainJs) {
    Write-Host "Could not find main.js in $nvidiaApp\osc" -ForegroundColor Red
    exit 1
}

Write-Host "Found main.js @ $($mainJs.FullName)" -ForegroundColor Green
$script:content = Get-Content -Path $mainJs.FullName -Raw -Encoding UTF8

$backupPath = "$($mainJs.FullName).bak"
if (-not (Test-Path $backupPath)) {
    Copy-Item -Path $mainJs.FullName -Destination $backupPath
    Write-Host "Backup created @ $backupPath" -ForegroundColor Green
}

Apply-Patch `
    -Name "ChromaDB" `
    -Pattern 'this\.currentGameChromaInfo=(\w+),this\.currentGameChromaInfo\?\.nvidiaTech\?\.FREESTYLE' `
    -Replacement 'this.currentGameChromaInfo=$1,$1?.nvidiaTech&&($1.nvidiaTech.FREESTYLE=!0),this.currentGameChromaInfo?.nvidiaTech?.FREESTYLE'

if ($script:patchesApplied -gt 0) {
    Set-Content -Path $mainJs.FullName -Value $script:content -NoNewline -Encoding UTF8
    Write-Host "$script:patchesApplied patch(es) written to file." -ForegroundColor Green
}

Get-Process -Name "NVIDIA Overlay*" -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "Restart the overlay from NVIDIA App by toggling it on and off" -Foreground Yellow
Write-Host "If you want to revert the patches, replace main.js with the .bak file" -Foreground Yellow
$null = Read-Host "Press ENTER to exit this script"
