#!/usr/bin/env node

import { spawn } from 'child_process';

console.log('Starting MCP Server test...');

// Start the server process
const serverProcess = spawn('node', ['index.js'], {
  stdio: ['pipe', 'pipe', 'pipe']
});

// Set a timeout to kill the process after 3 seconds
const timeout = setTimeout(() => {
  console.log('✅ MCP Server started successfully!');
  serverProcess.kill();
  process.exit(0);
}, 3000);

// Handle process events
serverProcess.on('error', (error) => {
  console.error('❌ Failed to start server:', error);
  clearTimeout(timeout);
  process.exit(1);
});

serverProcess.on('exit', (code) => {
  if (code === 0) {
    console.log('✅ Server exited normally');
  } else {
    console.error(`❌ Server exited with code ${code}`);
  }
  clearTimeout(timeout);
});

// Handle stderr
serverProcess.stderr.on('data', (data) => {
  console.error('Server stderr:', data.toString());
});