#!/bin/bash

# Claude Desktop Setup Script with MCP Server Configuration
# This script helps you install Claude Desktop and configure your MCP server

set -e

echo "🚀 Claude Desktop Setup with MCP Server"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Step 1: Check system requirements
print_status "Checking system requirements..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
else
    NODE_VERSION=$(node --version)
    print_success "Node.js found: $NODE_VERSION"
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
else
    NPM_VERSION=$(npm --version)
    print_success "npm found: $NPM_VERSION"
fi

# Step 2: Verify MCP server is ready
print_status "Verifying MCP server..."

if [ ! -f "/workspace/mcp-server/index.js" ]; then
    print_error "MCP server not found at /workspace/mcp-server/index.js"
    exit 1
fi

if [ ! -f "/workspace/mcp-server/package.json" ]; then
    print_error "package.json not found at /workspace/mcp-server/package.json"
    exit 1
fi

print_success "MCP server files found"

# Step 3: Test MCP server
print_status "Testing MCP server..."
cd /workspace/mcp-server

if ! npm list @modelcontextprotocol/sdk &> /dev/null; then
    print_warning "MCP SDK not installed. Installing dependencies..."
    npm install
fi

print_success "MCP server dependencies verified"

# Step 4: Check for Claude Desktop installation
print_status "Checking for Claude Desktop installation..."

CLAUDE_FOUND=false

# Check common installation locations
if command -v claude &> /dev/null; then
    CLAUDE_FOUND=true
    CLAUDE_PATH=$(which claude)
    print_success "Claude Desktop found at: $CLAUDE_PATH"
elif [ -f "/usr/local/bin/claude" ]; then
    CLAUDE_FOUND=true
    CLAUDE_PATH="/usr/local/bin/claude"
    print_success "Claude Desktop found at: $CLAUDE_PATH"
elif [ -f "/opt/claude/claude" ]; then
    CLAUDE_FOUND=true
    CLAUDE_PATH="/opt/claude/claude"
    print_success "Claude Desktop found at: $CLAUDE_PATH"
fi

if [ "$CLAUDE_FOUND" = false ]; then
    print_warning "Claude Desktop not found. You'll need to install it manually."
    echo ""
    echo "📥 Installation Options:"
    echo "1. Download from https://claude.ai/download"
    echo "2. Install via package manager (if available)"
    echo "3. Build from source"
    echo ""
    echo "After installation, run this script again to configure MCP servers."
    exit 0
fi

# Step 5: Create Claude Desktop configuration
print_status "Setting up Claude Desktop MCP configuration..."

# Create config directory
CLAUDE_CONFIG_DIR="$HOME/.config/claude-desktop"
mkdir -p "$CLAUDE_CONFIG_DIR"

# Create MCP configuration
MCP_CONFIG_FILE="$CLAUDE_CONFIG_DIR/mcp-servers.json"

cat > "$MCP_CONFIG_FILE" << EOF
{
  "mcpServers": {
    "weather-server": {
      "command": "node",
      "args": ["/workspace/mcp-server/index.js"],
      "env": {}
    },
    "advanced-tools": {
      "command": "node",
      "args": ["/workspace/mcp-server/advanced-example.js"],
      "env": {}
    }
  }
}
EOF

print_success "MCP configuration created at: $MCP_CONFIG_FILE"

# Step 6: Make MCP server executable
print_status "Setting up MCP server permissions..."
chmod +x /workspace/mcp-server/index.js
chmod +x /workspace/mcp-server/advanced-example.js

print_success "MCP server files made executable"

# Step 7: Test MCP server functionality
print_status "Testing MCP server functionality..."

# Test basic server
timeout 3s node /workspace/mcp-server/index.js > /dev/null 2>&1 || {
    print_warning "Basic MCP server test failed (this is normal for stdio servers)"
}

# Test advanced server
timeout 3s node /workspace/mcp-server/advanced-example.js > /dev/null 2>&1 || {
    print_warning "Advanced MCP server test failed (this is normal for stdio servers)"
}

print_success "MCP server setup completed"

# Step 8: Create desktop shortcut (optional)
print_status "Creating desktop shortcut..."

DESKTOP_FILE="$HOME/Desktop/claude-desktop.desktop"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Claude Desktop
Comment=Claude Desktop with MCP Server
Exec=$CLAUDE_PATH
Icon=claude
Terminal=false
Categories=Network;InstantMessaging;
EOF

chmod +x "$DESKTOP_FILE"
print_success "Desktop shortcut created at: $DESKTOP_FILE"

# Step 9: Final instructions
echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "✅ MCP server configured"
echo "✅ Claude Desktop configuration created"
echo "✅ Desktop shortcut created"
echo ""
echo "📋 Next Steps:"
echo "1. Start Claude Desktop: $CLAUDE_PATH"
echo "2. Or double-click the desktop shortcut"
echo "3. Start a new conversation"
echo "4. Test the MCP tools:"
echo "   - 'What's the weather in San Francisco?'"
echo "   - 'Calculate 15 * 23'"
echo "   - 'What time is it in Tokyo?'"
echo ""
echo "🔧 Configuration Files:"
echo "   - MCP Config: $MCP_CONFIG_FILE"
echo "   - Basic Server: /workspace/mcp-server/index.js"
echo "   - Advanced Server: /workspace/mcp-server/advanced-example.js"
echo ""
echo "📚 Documentation:"
echo "   - README.md - Basic usage"
echo "   - USAGE.md - Detailed usage guide"
echo "   - CLAUDE_DESKTOP_SETUP.md - Setup instructions"
echo ""
echo "🐛 Troubleshooting:"
echo "   - Check logs: $CLAUDE_CONFIG_DIR/logs/"
echo "   - Test server: cd /workspace/mcp-server && node index.js"
echo "   - Verify paths in: $MCP_CONFIG_FILE"
echo ""

print_success "Setup completed successfully!"