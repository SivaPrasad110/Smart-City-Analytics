@echo off
REM Smart City Analytics - Windows Stop Script
REM Usage: stop.bat

setlocal

echo.
echo =========================================
echo   Smart City Analytics - Shutting Down
echo =========================================
echo.

REM Stop and remove containers
docker-compose -f docker-compose.yml down

REM Remove dangling images
docker image prune -f >nul 2>&1

echo.
echo [OK] All services stopped
echo.

REM Ask about data volume removal
set /p remove_volumes="Remove database data volume? (y/N): "
if /i "%remove_volumes%"=="y" (
    docker volume rm smart-city-analytics_postgres_data >nul 2>&1
    echo [OK] Database volume removed
)

echo.
echo =========================================
echo   All Clean!
echo =========================================
echo.

endlocal