@echo off
title Smart BMI Web Launcher
echo ============================================================
echo                SMART BMI - WEB APP LAUNCHER
echo ============================================================
echo.

:: Check if Python is available to host a local web server
where python >nul 2>nul
if %errorlevel% equ 0 (
    echo [STATUS] Starting local web server on http://localhost:8000...
    echo.
    echo Press Ctrl+C in this window to stop the server.
    echo.
    :: Launch the browser pointing to localhost
    start "" "http://localhost:8000/demo.html"
    :: Start python's lightweight HTTP server
    python -m http.server 8000
) else (
    echo [STATUS] Python not detected. Opening web dashboard directly...
    start demo.html
)
