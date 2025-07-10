# Quick Start Guide: Claude Desktop + MCP Server

## Current Status ✅

Your MCP server is **ready and configured**! Here's what we've accomplished:

- ✅ MCP server created at `/workspace/mcp-server/`
- ✅ Basic server with weather tool (`index.js`)
- ✅ Advanced server with multiple tools (`advanced-example.js`)
- ✅ All dependencies installed
- ✅ Configuration files created
- ✅ Setup scripts prepared

## Next Step: Install Claude Desktop

Since automatic installation didn't work, you need to install Claude Desktop manually:

### Option 1: Official Website (Recommended)
1. Open your web browser
2. Go to [https://claude.ai/download](https://claude.ai/download)
3. Download the Linux version (.deb file)
4. Install it:
   ```bash
   cd ~/Downloads
   sudo dpkg -i claude-desktop_*.deb
   sudo apt-get install -f
   ```

### Option 2: Package Manager
```bash
sudo apt update
sudo apt install claude-desktop
```

### Option 3: Alternative Sources
- Check if it's available in your distribution's repositories
- Look for community packages
- Consider using the web version with MCP browser extensions

## After Installing Claude Desktop

Once Claude Desktop is installed, run this command to configure MCP:

```bash
cd /workspace/mcp-server
./setup-claude-desktop.sh
```

This will:
- ✅ Configure Claude Desktop to use your MCP server
- ✅ Create the necessary configuration files
- ✅ Set up desktop shortcuts
- ✅ Test the integration

## Test Your Setup

After installation and configuration:

1. **Start Claude Desktop**:
   ```bash
   claude
   ```

2. **Test the MCP tools**:
   - Ask: "What tools do you have available?"
   - Try: "Get the weather in San Francisco"
   - Try: "Calculate 15 * 23"
   - Try: "What time is it in Tokyo?"

## Available Tools

### Basic Server (`index.js`)
- `get_weather` - Get weather information for a location

### Advanced Server (`advanced-example.js`)
- `get_weather` - Get weather information for a location
- `calculate` - Perform mathematical calculations
- `get_time` - Get current time in a timezone

## Files in Your Setup

```
/workspace/mcp-server/
├── index.js                    # Basic MCP server
├── advanced-example.js         # Advanced MCP server
├── package.json               # Node.js configuration
├── setup-claude-desktop.sh    # Claude Desktop setup script
├── install-claude.sh          # Claude Desktop installer
├── mcp-config.json           # MCP configuration
├── README.md                 # Basic documentation
├── USAGE.md                  # Detailed usage guide
├── CLAUDE_DESKTOP_SETUP.md   # Setup instructions
├── INSTALL_CLAUDE.md         # Installation guide
└── QUICK_START.md           # This file
```

## Troubleshooting

### If Claude Desktop won't start:
```bash
# Check if it's installed
which claude

# Check version
claude --version

# Run with debug
claude --debug
```

### If MCP tools don't work:
```bash
# Test the server manually
cd /workspace/mcp-server
node index.js

# Check configuration
cat ~/.config/claude-desktop/mcp-servers.json
```

### If you get permission errors:
```bash
# Make files executable
chmod +x /workspace/mcp-server/*.js
chmod +x /workspace/mcp-server/*.sh
```

## Quick Commands

```bash
# Install Claude Desktop (after downloading)
sudo dpkg -i claude-desktop_*.deb && sudo apt-get install -f

# Configure MCP (after installing Claude Desktop)
cd /workspace/mcp-server && ./setup-claude-desktop.sh

# Start Claude Desktop
claude

# Test MCP server
cd /workspace/mcp-server && node index.js

# View configuration
cat ~/.config/claude-desktop/mcp-servers.json
```

## Support

If you need help:
1. Check the documentation files in `/workspace/mcp-server/`
2. Look for error messages in the terminal
3. Verify all paths and permissions
4. Test the MCP server independently

## Next Steps After Setup

1. **Customize your tools**: Edit the server files to add your own functionality
2. **Add real APIs**: Replace mock data with real API calls
3. **Add more tools**: Implement additional tools for your specific needs
4. **Add authentication**: Implement proper security for your tools

---

**Your MCP server is ready! Just install Claude Desktop and run the setup script.**