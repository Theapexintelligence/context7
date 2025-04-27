#!/bin/bash
# Nano-sized Context7 setup script - elegant and minimal

# Create Claude Desktop config directory if it doesn't exist
mkdir -p "$HOME/Library/Application Support/Claude"

# Create or update the configuration file
CONFIG_FILE="$HOME/Library/Application Support/Claude/claude-desktop-config.json"

# Backup existing config if it exists
[ -f "$CONFIG_FILE" ] && cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# Check if file exists and has mcpServers
if [ -f "$CONFIG_FILE" ] && grep -q "mcpServers" "$CONFIG_FILE"; then
  # Check if Context7 is already in the file
  if ! grep -q "Context7" "$CONFIG_FILE"; then
    # Add Context7 to existing mcpServers
    sed -i '' -e '/"mcpServers": {/ {
      :a
      n
      /}/ !ba
      s/}/,\n    "Context7": {\n      "command": "npx",\n      "args": ["-y", "@upstash\/context7-mcp@latest"]\n    }\n}/
    }' "$CONFIG_FILE"
  fi
else
  # Create new config file
  echo '{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}' > "$CONFIG_FILE"
fi

# Create a simple usage guide
echo "
✅ Context7 has been set up for Claude Desktop!

To use Context7, add 'use context7' at the end of your prompts:

Example: Create a React component that fetches data from an API. use context7

Please restart Claude Desktop if it's currently running.
"

# Exit with success
exit 0
