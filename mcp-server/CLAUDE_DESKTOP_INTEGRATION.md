# 🔗 Claude Desktop MCP Integration Guide

Your MCP server is ready to work with Claude Desktop! Follow these steps to connect them.

## ✅ Prerequisites

Your MCP server is already set up and running. Now you need to:

1. **Install Claude Desktop**
2. **Configure MCP Integration**
3. **Test the Connection**

## 📥 Step 1: Install Claude Desktop

### Option A: Download from Official Site (Recommended)
1. Go to https://claude.ai/download
2. Download Claude Desktop for your operating system
3. Install the application
4. Launch Claude Desktop

### Option B: Try Alternative Installation Methods

#### On Ubuntu/Debian:
```bash
# Try snap (if available)
sudo snap install claude-desktop

# Or try flatpak
flatpak install flathub com.anthropic.claude-desktop
```

#### On macOS:
```bash
# Using Homebrew (if available)
brew install --cask claude-desktop
```

## ⚙️ Step 2: Configure MCP Integration

### Method 1: Using Claude Desktop UI (Recommended)

1. **Open Claude Desktop**
2. **Go to Settings** (gear icon or Preferences)
3. **Find MCP Settings** (usually under "Advanced" or "Integrations")
4. **Add New MCP Server** with these settings:
   - **Name:** `mcp-server`
   - **Command:** `node`
   - **Arguments:** `["advanced-example.js"]`
   - **Working Directory:** `/workspace/mcp-server`
   - **Environment Variables:** `NODE_ENV=production`

### Method 2: Using Configuration File

1. **Find Claude Desktop Config Directory:**
   - **macOS:** `~/Library/Application Support/Claude Desktop/`
   - **Linux:** `~/.config/claude-desktop/`
   - **Windows:** `%APPDATA%\Claude Desktop\`

2. **Copy the configuration:**
   ```bash
   # Copy our config to Claude Desktop directory
   cp /workspace/mcp-server/claude-desktop-config.json ~/.config/claude-desktop/mcp-servers.json
   ```

3. **Restart Claude Desktop**

## 🧪 Step 3: Test the Integration

### Test 1: Check Server Status
```bash
# Verify MCP server is working
cd /workspace/mcp-server
node advanced-example.js
```

### Test 2: Test in Claude Desktop
Once connected, try asking Claude:

```
Can you get the weather for San Francisco?
```

```
What's 15 * 23?
```

```
What time is it in Tokyo?
```

## 🔧 Step 4: Troubleshooting

### If Claude Desktop Can't Find the Server:

1. **Check Path:**
   ```bash
   # Verify the path exists
   ls -la /workspace/mcp-server/advanced-example.js
   ```

2. **Test Server Manually:**
   ```bash
   cd /workspace/mcp-server
   node advanced-example.js
   ```

3. **Check Permissions:**
   ```bash
   # Make sure the file is executable
   chmod +x /workspace/mcp-server/advanced-example.js
   ```

### If Tools Don't Work:

1. **Verify MCP Protocol:**
   ```bash
   # Test the server directly
   cd /workspace/mcp-server
   timeout 5s node advanced-example.js
   ```

2. **Check Logs:**
   ```bash
   # Look for any error messages
   tail -f /workspace/mcp-server/web-server.log
   ```

### Alternative Configuration

If the above doesn't work, try this simpler configuration:

```json
{
  "mcpServers": {
    "mcp-server": {
      "command": "/usr/bin/node",
      "args": ["/workspace/mcp-server/advanced-example.js"]
    }
  }
}
```

## 🎯 Available Tools

Once connected, Claude Desktop will have access to:

### 🌤️ Weather Tool
- **Function:** Get weather information
- **Usage:** Ask for weather in any location
- **Example:** "What's the weather like in Tokyo?"

### 🧮 Calculator Tool
- **Function:** Perform mathematical calculations
- **Usage:** Ask Claude to calculate expressions
- **Example:** "Calculate 15 * 23"

### 🕐 Time Tool
- **Function:** Get current time in timezones
- **Usage:** Ask for time in different locations
- **Example:** "What time is it in London?"

## 🔄 Restarting the Integration

If you make changes to the MCP server:

1. **Restart Claude Desktop**
2. **Or restart the MCP server:**
   ```bash
   cd /workspace/mcp-server
   pkill -f "node advanced-example.js"
   node advanced-example.js
   ```

## 📞 Support

If you're still having issues:

1. **Check Claude Desktop logs** (usually in the app's data directory)
2. **Verify Node.js version:** `node --version`
3. **Test MCP server directly:** `node advanced-example.js`
4. **Check file permissions and paths**

## 🎉 Success!

Once connected, you'll be able to:
- Ask Claude for weather information
- Have Claude perform calculations
- Get time information from Claude
- Use any custom tools you add to the MCP server

The integration will make Claude much more powerful by giving it access to real-time data and computational tools!