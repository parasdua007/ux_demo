#!/usr/bin/env node

import { spawn } from 'child_process';
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

// Test the server by creating a client that connects to it
async function testServer() {
  console.log('Testing MCP Server...');
  
  // Start the server process
  const serverProcess = spawn('node', ['index.js'], {
    stdio: ['pipe', 'pipe', 'pipe']
  });

  // Create a client to test the server
  const client = new Server(
    {
      name: "test-client",
      version: "1.0.0",
    },
    {
      capabilities: {
        tools: {},
      },
    }
  );

  const transport = new StdioServerTransport();
  
  try {
    await client.connect(transport);
    
    // Test listing tools
    console.log('Testing listTools...');
    const tools = await client.listTools();
    console.log('Available tools:', tools);
    
    // Test calling the weather tool
    console.log('Testing get_weather tool...');
    const result = await client.callTool({
      name: "get_weather",
      arguments: {
        location: "San Francisco, CA"
      }
    });
    console.log('Weather result:', result);
    
    console.log('✅ MCP Server test completed successfully!');
  } catch (error) {
    console.error('❌ Test failed:', error);
  } finally {
    serverProcess.kill();
  }
}

testServer();