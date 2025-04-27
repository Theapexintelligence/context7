#!/bin/bash

# Script to install Context7 for Claude Desktop

echo "Context7 Installation for Claude Desktop"
echo "========================================"
echo

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed."
    echo "Please install Node.js v18.0.0 or higher from https://nodejs.org/"
    echo "After installing Node.js, run this script again."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d 'v' -f 2)
NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)

if [ $NODE_MAJOR_VERSION -lt 18 ]; then
    echo "❌ Node.js version $NODE_VERSION is too old."
    echo "Please upgrade to v18.0.0 or higher from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js version $NODE_VERSION is installed."

# Check if Claude Desktop config directory exists
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo "❌ Claude Desktop configuration directory not found."
    echo "Please make sure Claude Desktop is installed and has been run at least once."
    exit 1
fi

echo "✅ Claude Desktop configuration directory found."

# Check if config file exists
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude-desktop-config.json"
if [ ! -f "$CLAUDE_CONFIG_FILE" ]; then
    echo "Claude Desktop configuration file not found. Creating a new one..."
    echo '{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}' > "$CLAUDE_CONFIG_FILE"
    echo "✅ Created new configuration file with Context7."
else
    # Make a backup of the existing config file
    cp "$CLAUDE_CONFIG_FILE" "$CLAUDE_CONFIG_FILE.backup"
    echo "✅ Created backup of existing configuration file at $CLAUDE_CONFIG_FILE.backup"
    
    # Check if the file already has Context7 configured
    if grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
        echo "✅ Context7 is already configured in Claude Desktop."
    else
        # Check if the file has mcpServers
        if grep -q "mcpServers" "$CLAUDE_CONFIG_FILE"; then
            # This is a simple approach - for a more robust solution, use a JSON parser
            # Insert Context7 before the last closing brace of mcpServers
            sed -i '' -e '/"mcpServers": {/ {
                :a
                n
                /}/ !ba
                s/}/,\n    "Context7": {\n      "command": "npx",\n      "args": ["-y", "@upstash\/context7-mcp@latest"]\n    }\n}/
            }' "$CLAUDE_CONFIG_FILE"
        else
            # Replace the entire file
            echo '{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}' > "$CLAUDE_CONFIG_FILE"
        fi
        echo "✅ Added Context7 to Claude Desktop configuration."
    fi
fi

echo
echo "✅ Context7 installation for Claude Desktop is complete!"
echo
echo "Please restart Claude Desktop if it's currently running."
echo
echo "To use Context7, add 'use context7' at the end of your prompts:"
echo "Example: 'Create a React component that fetches data from an API. use context7'"
echo
echo "For more information, see the CLAUDE_DESKTOP_CONTEXT7_SETUP.md file."
