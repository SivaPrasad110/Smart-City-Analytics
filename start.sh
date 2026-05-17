@echo off
REM Smart City Analytics - Windows Startup Script
REM Usage: start.bat [mode]

setlocal enabledelayedexpansion

set "PROJECT_NAME=smart-city-analytics"
set "COMPOSE_FILE=docker-compose.yml"

echo =========================================
echo   Smart City Analytics - Starting Up
echo =========================================
echo.

REM Check if Docker is running
docker version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Docker is not running. Please start Docker Desktop.
    exit /b 1
)

echo [OK] Docker is running

REM Load environment variables from .env if exists
if exist ".env" (
    echo Loading environment variables...
    for /f "usebackq tokens=1,* delims==" %%a in (`.env`) do (
        set "%%a=%%b"
    )
    echo [OK] Environment loaded
)

REM Start services with docker-compose
echo.
echo Starting services...
docker-compose -f %COMPOSE_FILE% up -d

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to start services
    exit /b 1
)

echo.
echo =========================================
echo   Services Started Successfully!
echo =========================================
echo.
echo   Frontend:   http://localhost:3000
echo   Backend:    http://localhost:8000
echo   API Docs:   http://localhost:8000/docs
echo   Health:     http://localhost:8000/health
echo.
echo   View logs:  docker-compose logs -f
echo   Stop:       docker-compose down
echo =========================================
echo.

REM Wait for services to be ready
echo Waiting for services to be ready...

set /a max_wait=60
set /a waited=0

:wait_loop
timeout /t 3 /nobreak >nul
set /a waited+=3

REM Check backend
curl -s http://localhost:8000/health >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] Backend is ready!
    goto :frontend_check
)

if %waited% geq %max_wait% (
    echo [WARN] Backend taking longer than expected
    goto :frontend_check
)

goto :wait_loop

:frontend_check
REM Check frontend
curl -s http://localhost:3000 >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] Frontend is ready!
) else (
    echo [WARN] Frontend may still be starting...
)

echo.
echo Ready to use!

endlocal