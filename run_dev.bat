@echo off
TITLE Heavy Rainfall Early Warning and Inundation Prediction System
echo =====================================================================
echo  AI/ML Integrated Heavy Rainfall Early Warning and Inundation System
echo  Local Research Prototype (Delhi-NCR Pilot)
echo =====================================================================
echo.

cd /d "%~dp0"

REM 1. Activate backend virtual environment
if not exist "backend\.venv\Scripts\activate.bat" (
    echo [1/3] Creating Python virtual environment...
    python -m venv backend\.venv
    call backend\.venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    pip install -r backend\requirements.txt
) else (
    echo [1/3] Activating Python virtual environment...
    call backend\.venv\Scripts\activate.bat
)

REM 2. Verify frontend dependencies
if not exist "frontend\node_modules" (
    echo [2/3] Installing frontend dependencies...
    cd frontend
    call npm install
    cd ..
) else (
    echo [2/3] Frontend dependencies verified.
)

REM 3. Launch Backend and Frontend services
echo [3/3] Launching Backend API and Frontend Dashboard...
echo.
echo  - Backend API:    http://127.0.0.1:8000 (Swagger: http://127.0.0.1:8000/docs)
echo  - Frontend UI:    http://127.0.0.1:5173
echo.
echo Press Ctrl+C to stop services.
echo =====================================================================

start "Rainfall AI Backend" cmd /k "cd /d %~dp0backend && call .venv\Scripts\activate.bat && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"
start "Rainfall AI Frontend" cmd /k "cd /d %~dp0frontend && npm run dev -- --host 127.0.0.1 --port 5173"

echo Services launched in separate consoles.
