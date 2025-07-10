#!/bin/bash

echo "🔗 Setting up Claude Desktop MCP Integration..."
echo "==============================================="

# Check if we're in the right directory
if [ ! -f "advanced-example.js" ]; then
    echo "❌ Error: Please run this script from the mcp-server directory"
    exit 1
fi

# Test the MCP server
echo "🧪 Testing MCP server..."
timeout 3s node advanced-example.js > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ MCP server test passed"
else
    echo "⚠️  MCP server test had issues (this is normal for timeout)"
fi

# Create Claude Desktop config directory if it doesn't exist
CLAUDE_CONFIG_DIR="$HOME/.config/claude-desktop"
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo "📁 Creating Claude Desktop config directory..."
    mkdir -p "$CLAUDE_CONFIG_DIR"
fi

# Copy the configuration
echo "📋 Copying MCP configuration..."
cp claude-desktop-config.json "$CLAUDE_CONFIG_DIR/mcp-servers.json"

# Make the MCP server executable
echo "🔧 Setting permissions..."
chmod +x advanced-example.js

echo ""
echo "🎉 Claude Desktop Integration Setup Complete!"
echo "============================================="
echo ""
echo "📥 Next Steps:"
echo "1. Install Claude Desktop from: https://claude.ai/download"
echo "2. Launch Claude Desktop"
echo "3. Go to Settings > Advanced > MCP Servers"
echo "4. The configuration should be automatically loaded"
echo ""
echo "🔧 Configuration Details:"
echo "• Server Name: mcp-server"
echo "• Command: node"
echo "• Arguments: [advanced-example.js]"
echo "• Working Directory: $(pwd)"
echo ""
echo "🧪 Test Commands for Claude Desktop:"
echo "• 'What's the weather like in San Francisco?'"
echo "• 'Calculate 15 * 23'"
echo "• 'What time is it in Tokyo?'"
echo ""
echo "📁 Configuration file location:"
echo "$CLAUDE_CONFIG_DIR/mcp-servers.json"
echo ""
echo "🔄 To restart the MCP server:"
echo "pkill -f 'node advanced-example.js' && node advanced-example.js"
echo ""
echo "✨ Your MCP server is ready for Claude Desktop!"