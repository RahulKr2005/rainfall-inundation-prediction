# PowerShell Startup Script for Heavy Rainfall Early Warning & Inundation System
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " AI/ML Integrated Heavy Rainfall Early Warning & Inundation System" -ForegroundColor Green
Write-Host " Local Research Prototype (Delhi-NCR Pilot)" -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Cyan

$RootDir = $PSScriptRoot
Set-Location $RootDir

# 1. Activate Python Environment
$VenvPython = Join-Path $RootDir "backend\.venv\Scripts\python.exe"
if (-not (Test-Path $VenvPython)) {
    Write-Host "[1/3] Setting up Python virtual environment..." -ForegroundColor Yellow
    python -m venv (Join-Path $RootDir "backend\.venv")
    & (Join-Path $RootDir "backend\.venv\Scripts\pip.exe") install --upgrade pip
    & (Join-Path $RootDir "backend\.venv\Scripts\pip.exe") install -r (Join-Path $RootDir "backend\requirements.txt")
} else {
    Write-Host "[1/3] Python environment verified." -ForegroundColor Green
}

# 2. Frontend node_modules check
$NodeModules = Join-Path $RootDir "frontend\node_modules"
if (-not (Test-Path $NodeModules)) {
    Write-Host "[2/3] Installing frontend dependencies..." -ForegroundColor Yellow
    Set-Location (Join-Path $RootDir "frontend")
    cmd.exe /c "npm install"
    Set-Location $RootDir
} else {
    Write-Host "[2/3] Frontend dependencies verified." -ForegroundColor Green
}

# 3. Launch Services
Write-Host "`n[3/3] Launching Backend and Frontend services..." -ForegroundColor Cyan
Write-Host " - Backend API: http://127.0.0.1:8000 (Swagger: http://127.0.0.1:8000/docs)" -ForegroundColor White
Write-Host " - Frontend UI: http://127.0.0.1:5173" -ForegroundColor White
Write-Host "`nPress Ctrl+C to exit launcher." -ForegroundColor Gray

Start-Process -FilePath "cmd.exe" -ArgumentList "/k cd /d `"$RootDir\backend`" && .\.venv\Scripts\activate.bat && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"
Start-Process -FilePath "cmd.exe" -ArgumentList "/k cd /d `"$RootDir\frontend`" && npm run dev -- --host 127.0.0.1 --port 5173"

Write-Host "Services started successfully." -ForegroundColor Green
