@echo off
echo ============================================
echo   Phishing URL Detector - Starting App
echo ============================================
echo.

REM Check if virtual environment exists
if not exist "phishing-env\Scripts\activate.bat" (
    echo [ERROR] Virtual environment not found!
    echo Please run "setup.bat" first to install dependencies.
    pause
    exit /b 1
)

echo Activating virtual environment...
call phishing-env\Scripts\activate.bat

echo Starting Flask server...
echo.
echo  The app will be available at: http://127.0.0.1:5000
echo  Press Ctrl+C to stop the server.
echo.

cd src
python app.py
pause
