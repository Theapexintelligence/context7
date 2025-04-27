#!/bin/bash
# Elegant Context7 Setup for Claude Desktop
# This script handles the complete setup process with minimal user interaction

# Color definitions for better visual feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print stylized header
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║  ${GREEN}Context7 Intelligent Setup for Claude Desktop${BLUE}            ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Node.js using the appropriate method for the platform
install_nodejs() {
  echo -e "${YELLOW}Installing Node.js...${NC}"
  
  if command_exists brew; then
    echo "Using Homebrew to install Node.js..."
    brew install node
  else
    echo "Homebrew not found. Installing Node.js using the official installer..."
    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download and run the Node.js installer
    curl -o node-installer.pkg "https://nodejs.org/dist/v18.18.2/node-v18.18.2.pkg"
    sudo installer -pkg node-installer.pkg -target /
    
    # Clean up
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
  fi
  
  echo -e "${GREEN}Node.js installed successfully!${NC}"
}

# Check for Node.js
echo -e "${BLUE}Checking for Node.js...${NC}"
if command_exists node; then
  NODE_VERSION=$(node -v | cut -d 'v' -f 2)
  NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)
  
  if [ "$NODE_MAJOR_VERSION" -lt 18 ]; then
    echo -e "${YELLOW}Node.js version $NODE_VERSION is too old. Version 18+ is required.${NC}"
    read -p "Would you like to upgrade Node.js? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      install_nodejs
    else
      echo -e "${RED}Node.js 18+ is required for Context7. Exiting.${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}Node.js version $NODE_VERSION is installed and compatible.${NC}"
  fi
else
  echo -e "${YELLOW}Node.js not found.${NC}"
  read -p "Would you like to install Node.js? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_nodejs
  else
    echo -e "${RED}Node.js is required for Context7. Exiting.${NC}"
    exit 1
  fi
fi

# Check for Claude Desktop configuration directory
echo -e "${BLUE}Checking for Claude Desktop configuration...${NC}"
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"

if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
  echo -e "${YELLOW}Claude Desktop configuration directory not found.${NC}"
  echo -e "${YELLOW}Creating directory structure...${NC}"
  mkdir -p "$CLAUDE_CONFIG_DIR"
  echo -e "${GREEN}Created Claude Desktop configuration directory.${NC}"
fi

# Check for Claude Desktop configuration file
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude-desktop-config.json"

# Create backup if file exists
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
  echo -e "${BLUE}Creating backup of existing configuration...${NC}"
  BACKUP_FILE="$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
  cp "$CLAUDE_CONFIG_FILE" "$BACKUP_FILE"
  echo -e "${GREEN}Backup created at $BACKUP_FILE${NC}"
  
  # Check if Context7 is already configured
  if grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
    echo -e "${GREEN}Context7 is already configured in Claude Desktop.${NC}"
    
    # Ask if user wants to update the configuration
    read -p "Would you like to update the Context7 configuration? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${BLUE}Keeping existing Context7 configuration.${NC}"
      SKIP_CONFIG=true
    fi
  fi
fi

# Update or create configuration file
if [ "$SKIP_CONFIG" != true ]; then
  echo -e "${BLUE}Configuring Context7 for Claude Desktop...${NC}"
  
  # If file exists and has mcpServers
  if [ -f "$CLAUDE_CONFIG_FILE" ] && grep -q "mcpServers" "$CLAUDE_CONFIG_FILE"; then
    # Use jq if available for proper JSON manipulation
    if command_exists jq; then
      echo -e "${BLUE}Using jq for JSON manipulation...${NC}"
      # Create a temporary file with the updated configuration
      jq '.mcpServers.Context7 = {"command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"]}' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp"
      mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
    else
      echo -e "${YELLOW}jq not found, using pattern matching...${NC}"
      # Check if Context7 is already in the file
      if ! grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
        # Insert Context7 configuration before the last closing brace of mcpServers
        sed -i '' -e '/"mcpServers": {/ {
          :a
          n
          /}/ !ba
          s/}/,\n    "Context7": {\n      "command": "npx",\n      "args": ["-y", "@upstash\/context7-mcp@latest"]\n    }\n}/
        }' "$CLAUDE_CONFIG_FILE"
      fi
    fi
  else
    # Create a new configuration file
    echo '{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}' > "$CLAUDE_CONFIG_FILE"
  fi
  
  echo -e "${GREEN}Context7 configuration updated successfully!${NC}"
fi

# Create a helper script for testing Context7
echo -e "${BLUE}Creating helper scripts...${NC}"

# Create a script to test Context7
cat > "test-context7.sh" << 'EOF'
#!/bin/bash
# Simple script to test if Context7 is working

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║  ${GREEN}Context7 Test Tool${BLUE}                                     ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo

echo -e "${YELLOW}This script will test if Context7 is working correctly by running the MCP server directly.${NC}"
echo -e "${YELLOW}If successful, you should see the Context7 server starting up.${NC}"
echo

read -p "Press Enter to start the test..."

echo -e "${BLUE}Starting Context7 MCP server...${NC}"
echo -e "${YELLOW}(Press Ctrl+C to exit when you've confirmed it's working)${NC}"
echo

npx -y @upstash/context7-mcp@latest

echo -e "${GREEN}Test complete!${NC}"
EOF

chmod +x "test-context7.sh"

# Create a script to update Context7
cat > "update-context7.sh" << 'EOF'
#!/bin/bash
# Script to update Context7 configuration

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║  ${GREEN}Context7 Update Tool${BLUE}                                   ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo

CLAUDE_CONFIG_FILE="$HOME/Library/Application Support/Claude/claude-desktop-config.json"

if [ ! -f "$CLAUDE_CONFIG_FILE" ]; then
  echo -e "${RED}Claude Desktop configuration file not found.${NC}"
  echo -e "${RED}Please run the context7-setup.sh script first.${NC}"
  exit 1
fi

# Create backup
BACKUP_FILE="$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
cp "$CLAUDE_CONFIG_FILE" "$BACKUP_FILE"
echo -e "${GREEN}Backup created at $BACKUP_FILE${NC}"

# Update configuration
echo -e "${BLUE}Updating Context7 configuration...${NC}"

# Use jq if available
if command -v jq >/dev/null 2>&1; then
  echo -e "${BLUE}Using jq for JSON manipulation...${NC}"
  # Create a temporary file with the updated configuration
  jq '.mcpServers.Context7 = {"command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"]}' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp"
  mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
else
  echo -e "${YELLOW}jq not found, using pattern matching...${NC}"
  # Check if Context7 is in the file
  if grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
    # Update the existing Context7 configuration
    sed -i '' -e '/"Context7": {/,/}/ s/"args": \[[^]]*\]/"args": ["-y", "@upstash\/context7-mcp@latest"]/' "$CLAUDE_CONFIG_FILE"
  else
    echo -e "${RED}Context7 configuration not found in the file.${NC}"
    echo -e "${RED}Please run the context7-setup.sh script first.${NC}"
    exit 1
  fi
fi

echo -e "${GREEN}Context7 configuration updated successfully!${NC}"
echo -e "${YELLOW}Please restart Claude Desktop for the changes to take effect.${NC}"
EOF

chmod +x "update-context7.sh"

# Create a quick reference guide
cat > "context7-guide.md" << 'EOF'
# Context7 Quick Reference Guide

## What is Context7?

Context7 is a Model Context Protocol (MCP) server that provides up-to-date documentation and code examples for various libraries directly in your AI assistant's context.

## How to Use Context7 in Claude Desktop

Simply add `use context7` at the end of your prompts:

```
Create a basic Next.js project with app router. use context7
```

```
Create a script to delete rows where the city is empty in PostgreSQL. use context7
```

## Example Prompts

### Web Development

- `Create a React component that fetches data from an API and displays it in a table. use context7`
- `Show me how to implement authentication in Express.js with JWT. use context7`
- `Create a Next.js API route that connects to a database. use context7`

### Databases

- `Write a MongoDB aggregation pipeline to group documents by date. use context7`
- `Create a PostgreSQL query to find duplicate records based on multiple columns. use context7`
- `Show me how to use Prisma with TypeScript for CRUD operations. use context7`

### Mobile Development

- `Create a React Native screen with navigation and state management. use context7`
- `Show me how to implement push notifications in a Flutter app. use context7`

### DevOps

- `Create a Docker Compose file for a Node.js application with MongoDB. use context7`
- `Write a GitHub Actions workflow for testing and deploying a Node.js app. use context7`

## Troubleshooting

If Context7 doesn't seem to be working:

1. Make sure you've added `use context7` at the end of your prompt
2. Restart Claude Desktop
3. Run the `test-context7.sh` script to verify the MCP server is working
4. Run the `update-context7.sh` script to update the configuration

## Updating Context7

To update Context7 to the latest version, run the `update-context7.sh` script.
EOF

echo -e "${GREEN}Helper scripts created:${NC}"
echo -e "  ${YELLOW}test-context7.sh${NC} - Test if Context7 is working"
echo -e "  ${YELLOW}update-context7.sh${NC} - Update Context7 configuration"
echo -e "  ${YELLOW}context7-guide.md${NC} - Quick reference guide for using Context7"

# Final instructions
echo
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║  ${GREEN}Context7 Setup Complete!${BLUE}                                ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${GREEN}Context7 has been successfully configured for Claude Desktop.${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. ${BLUE}Restart Claude Desktop${NC} if it's currently running"
echo -e "2. ${BLUE}Test Context7${NC} by adding 'use context7' to your prompts"
echo -e "   Example: ${YELLOW}Create a basic Express.js server. use context7${NC}"
echo
echo -e "${BLUE}For more information, see the context7-guide.md file.${NC}"
echo -e "${BLUE}If you encounter any issues, run the test-context7.sh script to verify the setup.${NC}"
echo

# Exit with success
exit 0
