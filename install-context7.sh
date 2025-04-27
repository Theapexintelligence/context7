#!/bin/bash

# Script to install and set up Context7

echo "Installing Context7 MCP server..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js v18.0.0 or higher."
    echo "Visit https://nodejs.org/ to download and install Node.js."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d 'v' -f 2)
NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)

if [ $NODE_MAJOR_VERSION -lt 18 ]; then
    echo "Node.js version $NODE_VERSION is too old. Please upgrade to v18.0.0 or higher."
    exit 1
fi

# Install Context7 MCP server
echo "Installing Context7 MCP server using npm..."
npm install -g @upstash/context7-mcp

echo "Context7 MCP server installed successfully!"

# Detect the user's editor/IDE
if [ -d "$HOME/.cursor" ]; then
    echo "Cursor detected. Adding Context7 to Cursor..."
    
    # Create mcp.json if it doesn't exist
    CURSOR_MCP_CONFIG="$HOME/.cursor/mcp.json"
    if [ ! -f "$CURSOR_MCP_CONFIG" ]; then
        echo '{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}' > "$CURSOR_MCP_CONFIG"
        echo "Created Cursor MCP configuration at $CURSOR_MCP_CONFIG"
    else
        echo "Cursor MCP configuration already exists at $CURSOR_MCP_CONFIG"
        echo "Please add the following to your Cursor MCP configuration:"
        echo '{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}'
    fi
fi

# Check for Claude Desktop
CLAUDE_CONFIG="$HOME/.config/claude/claude_desktop_config.json"
if [ -f "$CLAUDE_CONFIG" ]; then
    echo "Claude Desktop detected. Please add the following to your Claude Desktop configuration at $CLAUDE_CONFIG:"
    echo '{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}'
fi

echo ""
echo "Context7 is now installed! To use it, simply add 'use context7' to your prompts."
echo "For example: 'Create a basic Next.js project with app router. use context7'"
echo ""
echo "For more information, see the CONTEXT7_GUIDE.md file."
