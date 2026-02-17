@echo off
SETLOCAL

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator.
    echo Restarting with elevated rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

chcp 65001 >nul
mode con cols=70 lines=28
color 0D
set "SCRIPT_DIR=%~dp0"

:menu
cls
echo.
echo    ╔════════════════════════════════════════════════════════╗
echo    ║                                                        ║
echo    ║      ██╗   ██╗██╗  ██╗███╗   ██╗██╗████████╗██╗   ██╗  ║
echo    ║      ██║   ██║╚██╗██╔╝████╗  ██║██║╚══██╔══╝╚██╗ ██╔╝  ║
echo    ║      ██║   ██║ ╚███╔╝ ██╔██╗ ██║██║   ██║    ╚████╔╝   ║
echo    ║      ╚██╗ ██╔╝ ██╔██╗ ██║╚██╗██║██║   ██║     ╚██╔╝    ║
echo    ║       ╚████╔╝ ██╔╝ ██╗██║ ╚████║██║   ██║      ██║     ║
echo    ║        ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝      ╚═╝     ║
echo    ║                                                        ║
echo    ║                   F I L T E R S   F I X                ║
echo    ║                                                        ║
echo    ╠════════════════════════════════════════════════════════╣
echo    ║                                                        ║
echo    ║   [1]  Block NVIDIA (permanent)                        ║
echo    ║        └─ firewall block                               ║
echo    ║                                                        ║
echo    ║   [2]  Restore connection (undo)                       ║
echo    ║        └─ removes firewall                             ║
echo    ║                                                        ║
echo    ║   [3]  Temp fix                                        ║
echo    ║        └─ temporary block, redo after restart          ║
echo    ║                                                        ║
echo    ║   [0]  Exit                                            ║
echo    ║                                                        ║
echo    ╚════════════════════════════════════════════════════════╝
echo.
set /p choice="        Choose option: "

if /i "%choice%"=="0" goto :eof
if /i "%choice%"=="1" goto block_perm
if /i "%choice%"=="2" goto ctrlz
if /i "%choice%"=="3" goto tempfix

echo.
echo        Invalid option. Try again...
timeout /t 3 > nul
goto :menu

:block_perm
cls
echo.
echo    ════════════════════════════════════════════════
echo      Block NVIDIA (permanent)
echo    ════════════════════════════════════════════════
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%block_nvidia_perm.ps1"
echo.
echo    ════════════════════════════════════════════════
pause
goto :menu

:ctrlz
cls
echo.
echo    ════════════════════════════════════════════════
echo      Restore connection
echo    ════════════════════════════════════════════════
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%block_nvidia_ctrlz.ps1"
echo.
echo    ════════════════════════════════════════════════
pause
goto :menu

:tempfix
cls
echo.
echo    ════════════════════════════════════════════════
echo      Temp fix
echo    ════════════════════════════════════════════════
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%temp_fix.ps1"
echo.
echo    ════════════════════════════════════════════════
pause
goto :menu
