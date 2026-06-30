@echo off
title Smart BMI App Launcher
echo ============================================================
echo                SMART BMI - APPLICATION LAUNCHER
echo ============================================================
echo.

:: Check if Flutter is on Path
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter SDK was not found on your system PATH.
    echo.
    echo To resolve this:
    echo 1. Download the Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extract the zip and add the 'flutter\bin' folder to your User/System Environment variables.
    echo 3. Restart this terminal and try again.
    echo.
    pause
    exit /b 1
)

echo [STATUS] Flutter SDK detected successfully!
echo.

:: Run pub get to resolve dependencies
echo [STEP 1/2] Resolving project dependencies (flutter pub get)...
call flutter pub get
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to download package dependencies. Please check your internet connection.
    echo.
    pause
    exit /b 1
)
echo.

:: Run the application
echo [STEP 2/2] Launching Smart BMI Application (flutter run)...
echo ============================================================
echo Please select a target device from the list if prompted.
echo.
call flutter run
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Application failed to launch or terminated unexpectedly.
    echo.
)

pause
