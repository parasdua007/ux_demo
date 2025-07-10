#!/usr/bin/env node

import express from 'express';
import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3000;

// Middleware
app.use(express.json());
app.use(express.static(__dirname));

// Global variables
let mcpServerProcess = null;
let serverRunning = false;

// Helper function to send MCP request
async function sendMCPRequest(toolName, args) {
    return new Promise((resolve, reject) => {
        if (!mcpServerProcess) {
            reject(new Error('MCP server not running'));
            return;
        }

        // Create a simple MCP request
        const request = {
            jsonrpc: "2.0",
            id: Date.now(),
            method: "tools/call",
            params: {
                name: toolName,
                arguments: args
            }
        };

        // Send the request to the MCP server
        mcpServerProcess.stdin.write(JSON.stringify(request) + '\n');

        // Set up a timeout for the response
        const timeout = setTimeout(() => {
            reject(new Error('Request timeout'));
        }, 5000);

        // Listen for response
        const responseHandler = (data) => {
            try {
                const response = JSON.parse(data.toString());
                clearTimeout(timeout);
                mcpServerProcess.stdout.removeListener('data', responseHandler);
                
                if (response.error) {
                    reject(new Error(response.error.message));
                } else {
                    resolve(response.result);
                }
            } catch (error) {
                // Ignore parsing errors for non-JSON data
            }
        };

        mcpServerProcess.stdout.on('data', responseHandler);
    });
}

// Start MCP server
function startMCPServer() {
    return new Promise((resolve, reject) => {
        if (mcpServerProcess) {
            resolve('Server already running');
            return;
        }

        mcpServerProcess = spawn('node', ['advanced-example.js'], {
            cwd: __dirname,
            stdio: ['pipe', 'pipe', 'pipe']
        });

        mcpServerProcess.on('error', (error) => {
            reject(error);
        });

        mcpServerProcess.on('exit', (code) => {
            serverRunning = false;
            mcpServerProcess = null;
            console.log(`MCP server exited with code ${code}`);
        });

        // Wait a moment for the server to start
        setTimeout(() => {
            serverRunning = true;
            resolve('MCP server started successfully');
        }, 1000);
    });
}

// Stop MCP server
function stopMCPServer() {
    return new Promise((resolve) => {
        if (!mcpServerProcess) {
            resolve('Server not running');
            return;
        }

        mcpServerProcess.kill();
        mcpServerProcess = null;
        serverRunning = false;
        resolve('MCP server stopped');
    });
}

// Routes
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'web-client.html'));
});

app.get('/status', (req, res) => {
    res.json({
        running: serverRunning,
        message: serverRunning ? 'Server is running' : 'Server is not running'
    });
});

app.post('/start-server', async (req, res) => {
    try {
        const message = await startMCPServer();
        res.json({ success: true, message });
    } catch (error) {
        res.json({ success: false, message: error.message });
    }
});

app.post('/stop-server', async (req, res) => {
    try {
        const message = await stopMCPServer();
        res.json({ success: true, message });
    } catch (error) {
        res.json({ success: false, message: error.message });
    }
});

// Weather endpoint
app.post('/weather', async (req, res) => {
    try {
        const { location } = req.body;
        if (!location) {
            return res.status(400).json({ error: 'Location is required' });
        }

        // For now, return mock data since direct MCP communication is complex
        const result = `The weather in ${location} is sunny and 72°F.`;
        res.json({ result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Calculator endpoint
app.post('/calculate', async (req, res) => {
    try {
        const { expression } = req.body;
        if (!expression) {
            return res.status(400).json({ error: 'Expression is required' });
        }

        // Simple and safe evaluation
        const sanitized = expression.replace(/[^0-9+\-*/().\s]/g, '');
        const result = eval(sanitized);
        res.json({ result: `${expression} = ${result}` });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Time endpoint
app.post('/time', async (req, res) => {
    try {
        const { timezone } = req.body;
        const now = new Date();
        const timeString = now.toLocaleString("en-US", {
            timeZone: timezone || "UTC",
            year: "numeric",
            month: "long",
            day: "numeric",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
        });
        
        res.json({ result: `Current time in ${timezone || 'UTC'}: ${timeString}` });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start the server
app.listen(PORT, () => {
    console.log(`🚀 MCP Web Server running at http://localhost:${PORT}`);
    console.log(`📱 Open your browser and go to: http://localhost:${PORT}`);
    console.log(`🔧 Server controls available at: http://localhost:${PORT}`);
});

// Graceful shutdown
process.on('SIGINT', async () => {
    console.log('\n🛑 Shutting down...');
    await stopMCPServer();
    process.exit(0);
});

process.on('SIGTERM', async () => {
    console.log('\n🛑 Shutting down...');
    await stopMCPServer();
    process.exit(0);
});