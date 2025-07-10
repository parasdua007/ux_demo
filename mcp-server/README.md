# MCP Server Example

This is a simple Model Context Protocol (MCP) server implementation that provides a weather tool.

## Features

- **get_weather**: A tool that returns weather information for a given location

## Examples

### Basic Example (`index.js`)
A simple MCP server with a weather tool.

### Advanced Example (`advanced-example.js`)
A more comprehensive MCP server with multiple tools:
- **get_weather**: Get weather information for a location
- **calculate**: Perform basic mathematical calculations
- **get_time**: Get current time in a specific timezone

## Installation

1. Make sure you have Node.js installed (version 16 or higher)
2. Install dependencies:
   ```bash
   npm install
   ```

## Usage

### Running the Server

To start the basic MCP server:

```bash
npm start
```

To run the advanced example:

```bash
node advanced-example.js
```

The server will start and listen for MCP protocol messages via stdio.

### Testing with MCP Client

You can test this server with any MCP-compatible client. The server provides:

- **Tool**: `get_weather`
  - **Description**: Get the current weather in a given location
  - **Parameters**: 
    - `location` (string, required): The city and state, e.g. "San Francisco, CA"

### Example Usage

When a client calls the `get_weather` tool with location "New York, NY", the server will respond with:
```
The weather in New York, NY is sunny and 72°F.
```

## Configuration

This server is configured to use stdio transport, which means it communicates through standard input/output. This is the standard way MCP servers communicate with clients.

## Development

To modify the server:

1. Edit `index.js` to add new tools or modify existing ones
2. Update the capabilities object if you add new resource types
3. Restart the server to apply changes

## MCP Protocol

This server implements the Model Context Protocol, which allows AI models to interact with external tools and resources. For more information, visit: https://modelcontextprotocol.io/