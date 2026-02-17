$cefPath = "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF"
$overlayPath = "C:\Program Files\NVIDIA Corporation\NVIDIA App"

if (Test-Path $cefPath) {
    $files = Get-ChildItem -Path $cefPath -Recurse -Filter *.exe
    foreach ($file in $files) {
        New-NetFirewallRule -DisplayName "NVIDIA-CEF-IN-$($file.BaseName)" -Direction Inbound -Program $file.FullName -Action Block -Profile Any -ErrorAction SilentlyContinue
        New-NetFirewallRule -DisplayName "NVIDIA-CEF-OUT-$($file.BaseName)" -Direction Outbound -Program $file.FullName -Action Block -Profile Any -ErrorAction SilentlyContinue
    }
}

if (Test-Path $overlayPath) {
    $files2 = Get-ChildItem -Path $overlayPath -Recurse -Filter *.exe
    foreach ($file in $files2) {
        New-NetFirewallRule -DisplayName "NVIDIA-OVERLAY-IN-$($file.BaseName)" -Direction Inbound -Program $file.FullName -Action Block -Profile Any -ErrorAction SilentlyContinue
        New-NetFirewallRule -DisplayName "NVIDIA-OVERLAY-OUT-$($file.BaseName)" -Direction Outbound -Program $file.FullName -Action Block -Profile Any -ErrorAction SilentlyContinue
    }
}

Write-Host "Done."
