@echo off
echo ========================================
echo Starting Smart City Analytics Backend
echo ========================================

cd /d "%~dp0backend"

REM Check if virtual env exists
if exist venv (
    call venv\Scripts\activate
)

REM Install dependencies if needed
pip install -r requirements.txt > nul 2>&1

REM Start the Flask server
echo Starting Flask server on http://localhost:5000
echo Press Ctrl+C to stop
echo.

python app.py

pause