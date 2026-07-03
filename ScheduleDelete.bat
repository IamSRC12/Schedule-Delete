@echo off
setlocal enabledelayedexpansion

:: Elevation Check & Auto-Elevation
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Admin Required] Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath \"!comspec!\" -ArgumentList \"/c \"\"%~0\"\" %*\" -Verb RunAs"
    exit /b
)

set "SCRIPT_DIR=%~dp0"
set "SCRIPT=%SCRIPT_DIR%ScheduleDelete.ps1"

if not exist "!SCRIPT!" (
    echo Error: ScheduleDelete.ps1 not found in !SCRIPT_DIR!
    pause
    exit /b 1
)

:: Run PowerShell script with all arguments passed
:: Using -WindowStyle Hidden for a clean "app-like" experience
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "!SCRIPT!" %*
