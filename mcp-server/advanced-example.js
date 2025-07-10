#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  {
    name: "advanced-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define available tools
const tools = [
  {
    name: "get_weather",
    description: "Get the current weather in a given location",
    inputSchema: {
      type: "object",
      properties: {
        location: {
          type: "string",
          description: "The city and state, e.g. San Francisco, CA",
        },
      },
      required: ["location"],
    },
  },
  {
    name: "calculate",
    description: "Perform basic mathematical calculations",
    inputSchema: {
      type: "object",
      properties: {
        expression: {
          type: "string",
          description: "Mathematical expression to evaluate, e.g. '2 + 2 * 3'",
        },
      },
      required: ["expression"],
    },
  },
  {
    name: "get_time",
    description: "Get the current time in a specific timezone",
    inputSchema: {
      type: "object",
      properties: {
        timezone: {
          type: "string",
          description: "Timezone (optional, defaults to UTC)",
        },
      },
      required: [],
    },
  },
];

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case "get_weather":
        const location = args.location;
        if (!location) {
          throw new Error("Location is required");
        }
        return {
          content: [
            {
              type: "text",
              text: `The weather in ${location} is sunny and 72°F.`,
            },
          ],
        };

      case "calculate":
        const expression = args.expression;
        if (!expression) {
          throw new Error("Expression is required");
        }
        
        // Simple and safe evaluation (in production, use a proper math library)
        try {
          // Only allow basic math operations for safety
          const sanitized = expression.replace(/[^0-9+\-*/().\s]/g, '');
          const result = eval(sanitized);
          return {
            content: [
              {
                type: "text",
                text: `${expression} = ${result}`,
              },
            ],
          };
        } catch (evalError) {
          throw new Error(`Invalid mathematical expression: ${expression}`);
        }

      case "get_time":
        const timezone = args.timezone || "UTC";
        const now = new Date();
        const timeString = now.toLocaleString("en-US", {
          timeZone: timezone,
          year: "numeric",
          month: "long",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
        });
        
        return {
          content: [
            {
              type: "text",
              text: `Current time in ${timezone}: ${timeString}`,
            },
          ],
        };

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);