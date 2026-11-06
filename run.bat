@echo off
setlocal enabledelayedexpansion

echo =====================================================================
echo    Cloud Voyage & Inventory Auditing System - Unified Runner
echo =====================================================================
echo.

:: 1. Set default database password if not set
if "%DB_PASSWORD%"=="" (
    set DB_PASSWORD=Password123
    echo [INFO] Using default DB_PASSWORD: Password123
)

:: 2. Build the React frontend
echo.
echo [1/3] Building frontend production bundle...
cd /d "%~dp0frontend"
call npm.cmd run build

:: 3. Bundle frontend into Spring Boot static resources
echo.
echo [2/3] Syncing frontend into Spring Boot static resources...
if not exist "%~dp0backend\src\main\resources\static" (
    mkdir "%~dp0backend\src\main\resources\static"
)
xcopy /E /I /Y "%~dp0frontend\dist\*" "%~dp0backend\src\main\resources\static\" >nul
echo [OK] Unified package ready!

:: 4. Start the unified Spring Boot backend (serves both React UI and REST API)
echo.
echo [3/3] Launching Full-Stack Application...
echo.
echo =====================================================================
echo    Application is starting up!
echo    Unified App URL: http://localhost:8080
echo    Press Ctrl+C to stop the application.
echo =====================================================================
echo.

cd /d "%~dp0backend"
call mvnw.cmd spring-boot:run

