@echo off
echo ============================================
echo   Phishing URL Detector - Setup
echo ============================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python 3.8+ from https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

echo [1/3] Python found. Creating virtual environment...
python -m venv phishing-env
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create virtual environment.
    pause
    exit /b 1
)

echo [2/3] Activating environment and installing dependencies...
call phishing-env\Scripts\activate.bat
pip install --upgrade pip --quiet
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

echo [3/3] Setup complete!
echo.
echo ============================================
echo   Setup finished successfully!
echo   Run "run.bat" to start the application.
echo ============================================
echo.
pause
