# Claude Desktop Setup with MCP Server

This guide will help you install Claude Desktop and configure it to use your MCP server.

## Step 1: Install Claude Desktop

### Option 1: Download from Official Website
1. Visit [https://claude.ai/download](https://claude.ai/download)
2. Download the Linux version (.deb file)
3. Install using:
   ```bash
   sudo dpkg -i claude-desktop_*.deb
   sudo apt-get install -f  # Fix any dependency issues
   ```

### Option 2: Using Snap (if available)
```bash
sudo snap install claude-desktop
```

### Option 3: Using Flatpak (if available)
```bash
flatpak install flathub com.anthropic.Claude
```

## Step 2: Verify Installation

After installation, verify Claude Desktop is working:
```bash
claude --version
# or
which claude
```

## Step 3: Configure MCP Server in Claude Desktop

### Method 1: Using Settings UI
1. Open Claude Desktop
2. Go to **Settings** (gear icon)
3. Navigate to **MCP Servers** section
4. Click **Add Server**
5. Configure with these settings:
   - **Name**: `my-mcp-server`
   - **Command**: `node`
   - **Arguments**: `/workspace/mcp-server/index.js`
   - **Environment Variables**: (leave empty)

### Method 2: Using Configuration File
1. Find Claude Desktop's config directory:
   ```bash
   # Usually located at:
   ~/.config/claude-desktop/
   # or
   ~/.claude-desktop/
   ```

2. Create or edit the MCP configuration file:
   ```bash
   mkdir -p ~/.config/claude-desktop
   ```

3. Create `mcp-servers.json`:
   ```json
   {
     "mcpServers": {
       "my-weather-server": {
         "command": "node",
         "args": ["/workspace/mcp-server/index.js"],
         "env": {}
       },
       "my-advanced-server": {
         "command": "node",
         "args": ["/workspace/mcp-server/advanced-example.js"],
         "env": {}
       }
     }
   }
   ```

## Step 4: Test the Setup

1. Restart Claude Desktop
2. Start a new conversation
3. Try using the MCP tools:
   - "What's the weather in San Francisco?"
   - "Calculate 15 * 23"
   - "What time is it in Tokyo?"

## Step 5: Troubleshooting

### Common Issues:

1. **Server not found**:
   ```bash
   # Verify the server path
   ls -la /workspace/mcp-server/index.js
   
   # Test the server manually
   cd /workspace/mcp-server
   node index.js
   ```

2. **Permission denied**:
   ```bash
   # Make sure the file is executable
   chmod +x /workspace/mcp-server/index.js
   ```

3. **Node.js not found**:
   ```bash
   # Verify Node.js installation
   node --version
   npm --version
   ```

4. **Dependencies missing**:
   ```bash
   # Reinstall dependencies
   cd /workspace/mcp-server
   npm install
   ```

### Debug Mode:
```bash
# Run Claude Desktop with debug logging
claude --debug

# Or run the MCP server with debug logging
DEBUG=mcp:* node /workspace/mcp-server/index.js
```

## Step 6: Advanced Configuration

### Multiple Servers:
You can configure multiple MCP servers:

```json
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
    },
    "custom-server": {
      "command": "python3",
      "args": ["/path/to/your/python/mcp/server.py"],
      "env": {"PYTHONPATH": "/path/to/your/python"}
    }
  }
}
```

### Environment Variables:
```json
{
  "mcpServers": {
    "api-server": {
      "command": "node",
      "args": ["/workspace/mcp-server/api-server.js"],
      "env": {
        "API_KEY": "your-api-key-here",
        "DEBUG": "true"
      }
    }
  }
}
```

## Step 7: Verify Everything Works

1. **Test basic functionality**:
   - Ask Claude: "What tools do you have available?"
   - Try: "Get the weather in New York"

2. **Test advanced functionality**:
   - Try: "Calculate 2^10"
   - Try: "What time is it in London?"

3. **Check server logs**:
   - Look for any error messages in Claude Desktop
   - Check the terminal where you started Claude Desktop

## Next Steps

Once everything is working:

1. **Customize your tools**: Edit the server files to add your own functionality
2. **Add real APIs**: Replace mock data with real API calls
3. **Add more tools**: Implement additional tools for your specific needs
4. **Add authentication**: Implement proper security for your tools

## Support

If you encounter issues:
1. Check the Claude Desktop logs
2. Verify your MCP server works independently
3. Check the MCP protocol documentation
4. Look for error messages in the console

## Resources

- [Claude Desktop Documentation](https://docs.anthropic.com/claude/docs/claude-desktop)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [MCP JavaScript SDK](https://github.com/modelcontextprotocol/js-sdk)