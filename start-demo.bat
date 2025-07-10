@echo off
echo 🚀 Starting Reltio Console UX Demo...
echo.

REM Check if Python 3 is available
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Using Python to start the server...
    echo 📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html
    echo 🛑 Press Ctrl+C to stop the server
    echo.
    python -m http.server 8000
    goto :eof
)

REM Check if PHP is available
php --version >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Using PHP to start the server...
    echo 📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html
    echo 🛑 Press Ctrl+C to stop the server
    echo.
    php -S localhost:8000
    goto :eof
)

REM Check if Node.js is available
node --version >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ Using Node.js to start the server...
    echo 📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html
    echo 🛑 Press Ctrl+C to stop the server
    echo.
    npx http-server -p 8000
    goto :eof
)

echo ❌ No suitable server found.
echo.
echo 📋 Alternative options:
echo 1. Install Python: https://www.python.org/downloads/
echo 2. Install Node.js: https://nodejs.org/
echo 3. Install PHP: https://www.php.net/downloads.php
echo 4. Or simply open final-entitlement-summary.html directly in your browser
echo.
echo 💡 The demo will work by opening the HTML file directly in any modern browser!
pause