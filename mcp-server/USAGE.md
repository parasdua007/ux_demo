# MCP Server Usage Guide

This guide explains how to use your MCP server with different clients and tools.

## What is MCP?

The Model Context Protocol (MCP) is a standard for AI models to interact with external tools and resources. It allows AI assistants to access real-time data, perform calculations, and interact with external services.

## Available Tools

### Basic Server (`index.js`)
- **get_weather**: Returns weather information for a given location

### Advanced Server (`advanced-example.js`)
- **get_weather**: Returns weather information for a given location
- **calculate**: Performs basic mathematical calculations
- **get_time**: Gets current time in a specific timezone

## Using with Different Clients

### 1. Claude Desktop

1. Open Claude Desktop
2. Go to Settings → MCP Servers
3. Add a new server with the following configuration:
   ```json
   {
     "command": "node",
     "args": ["/path/to/your/mcp-server/index.js"]
   }
   ```

### 2. Anthropic Claude Web

1. Install the MCP browser extension
2. Configure the server path in the extension settings
3. The server will be available in your Claude conversations

### 3. Custom MCP Client

You can create your own MCP client using the SDK:

```javascript
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

const client = new Client({
  name: "my-client",
  version: "1.0.0",
});

const transport = new StdioClientTransport("node", ["/path/to/server/index.js"]);
await client.connect(transport);

// List available tools
const tools = await client.listTools();
console.log("Available tools:", tools);

// Call a tool
const result = await client.callTool({
  name: "get_weather",
  arguments: { location: "San Francisco, CA" }
});
console.log("Result:", result);
```

## Configuration Examples

### For Claude Desktop
```json
{
  "mcpServers": {
    "my-weather-server": {
      "command": "node",
      "args": ["/workspace/mcp-server/index.js"],
      "env": {}
    }
  }
}
```

### For Advanced Server
```json
{
  "mcpServers": {
    "advanced-tools": {
      "command": "node",
      "args": ["/workspace/mcp-server/advanced-example.js"],
      "env": {}
    }
  }
}
```

## Testing Your Server

You can test your server manually by running it and sending MCP protocol messages:

```bash
# Start the server
node index.js

# In another terminal, you can test with curl or a custom client
```

## Troubleshooting

### Common Issues

1. **Server won't start**: Make sure Node.js is installed and the path to your server is correct
2. **Permission denied**: Ensure the server file has execute permissions
3. **Module not found**: Verify all dependencies are installed with `npm install`

### Debug Mode

Run the server with debug logging:

```bash
DEBUG=mcp:* node index.js
```

## Next Steps

1. **Add Real APIs**: Replace the mock weather data with real API calls
2. **Add More Tools**: Implement additional tools for your specific use case
3. **Add Resources**: Implement resource providers for file access, databases, etc.
4. **Add Authentication**: Implement proper authentication for your tools

## Resources

- [MCP Documentation](https://modelcontextprotocol.io/)
- [MCP SDK](https://github.com/modelcontextprotocol/js-sdk)
- [MCP Examples](https://github.com/modelcontextprotocol/examples)