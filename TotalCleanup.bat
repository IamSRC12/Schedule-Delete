@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   ScheduleDelete TOTAL CLEANUP & FRESH START
echo ===================================================
echo.

:: Request Admin Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo 1. Cleaning up Registry...
reg delete "HKCR\*\shell\ScheduleDelete" /f >nul 2>&1
reg delete "HKCR\Directory\shell\ScheduleDelete" /f >nul 2>&1
echo [OK] Registry cleaned.

echo 2. Cleaning up Scheduled Tasks...
powershell -Command "Get-ScheduledTask -TaskName 'DeleteScheduled_*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false" >nul 2>&1
echo [OK] Tasks cleaned.

echo 3. Cleaning up Files...
set "INSTALL_DIR=C:\Program Files\ScheduleDelete"
if exist "!INSTALL_DIR!" (
    rmdir /s /q "!INSTALL_DIR!" >nul 2>&1
)
set "APPDATA_DIR=%APPDATA%\ScheduleDelete"
if exist "!APPDATA_DIR!" (
    rmdir /s /q "!APPDATA_DIR!" >nul 2>&1
)
echo [OK] Files cleaned.

echo.
echo ===================================================
echo   CLEANUP COMPLETE!
echo   Please run the new Setup file (v2.4.0) now.
echo ===================================================
pause
