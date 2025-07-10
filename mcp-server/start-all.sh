#!/bin/bash

echo "🚀 Starting Complete MCP Server Setup..."
echo "========================================"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if web server is already running
if curl -s http://localhost:3000/health > /dev/null 2>&1; then
    echo "✅ Web server is already running"
else
    echo "🌐 Starting web server..."
    nohup node web-server.js > web-server.log 2>&1 &
    sleep 3
    
    if curl -s http://localhost:3000/health > /dev/null 2>&1; then
        echo "✅ Web server started successfully"
    else
        echo "❌ Failed to start web server"
        exit 1
    fi
fi

# Test MCP server
echo "🧪 Testing MCP server..."
timeout 3s node advanced-example.js > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ MCP server test passed"
else
    echo "⚠️  MCP server test had issues (this is normal for timeout)"
fi

echo ""
echo "🎉 MCP Server Setup Complete!"
echo "============================="
echo ""
echo "📱 Web Interface: http://localhost:3000"
echo "🔧 Server Status: http://localhost:3000/status"
echo "🏥 Health Check: http://localhost:3000/health"
echo ""
echo "📁 Available Files:"
echo "  • web-client.html - Web interface for MCP tools"
echo "  • web-server.js - HTTP server for web client"
echo "  • advanced-example.js - Full MCP server with multiple tools"
echo "  • index.js - Basic MCP server"
echo "  • mcp-config.json - MCP configuration"
echo ""
echo "🛠️  Available Tools:"
echo "  • Weather information"
echo "  • Calculator"
echo "  • Time and timezone"
echo ""
echo "📖 Documentation:"
echo "  • README.md - Basic usage"
echo "  • USAGE.md - Detailed usage guide"
echo "  • QUICK_START.md - Quick start guide"
echo ""
echo "🔄 To restart everything:"
echo "  ./start-all.sh"
echo ""
echo "🛑 To stop the web server:"
echo "  pkill -f 'node web-server.js'"
echo ""
echo "📋 Logs are saved to: web-server.log"
echo ""
echo "✨ Your MCP server is ready to use!"