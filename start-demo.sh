#!/bin/bash

# Reltio Console UX Demo - Startup Script
# This script automatically starts a local server to run the UX demo

echo "🚀 Starting Reltio Console UX Demo..."
echo ""

# Check if Python 3 is available
if command -v python3 &> /dev/null; then
    echo "✅ Using Python 3 to start the server..."
    echo "📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html"
    echo "🛑 Press Ctrl+C to stop the server"
    echo ""
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    echo "✅ Using Python to start the server..."
    echo "📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html"
    echo "🛑 Press Ctrl+C to stop the server"
    echo ""
    python -m http.server 8000
elif command -v php &> /dev/null; then
    echo "✅ Using PHP to start the server..."
    echo "📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html"
    echo "🛑 Press Ctrl+C to stop the server"
    echo ""
    php -S localhost:8000
elif command -v node &> /dev/null; then
    echo "✅ Using Node.js to start the server..."
    echo "📱 Open your browser and go to: http://localhost:8000/final-entitlement-summary.html"
    echo "🛑 Press Ctrl+C to stop the server"
    echo ""
    npx http-server -p 8000
else
    echo "❌ No suitable server found."
    echo ""
    echo "📋 Alternative options:"
    echo "1. Install Python: https://www.python.org/downloads/"
    echo "2. Install Node.js: https://nodejs.org/"
    echo "3. Install PHP: https://www.php.net/downloads.php"
    echo "4. Or simply open final-entitlement-summary.html directly in your browser"
    echo ""
    echo "💡 The demo will work by opening the HTML file directly in any modern browser!"
    exit 1
fi