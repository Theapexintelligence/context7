#!/bin/bash
# Silent Context7 Setup for Claude Desktop
# This script handles the complete setup process with no user interaction
# Perfect for automated deployments or background installation

# Log file for silent operation
LOG_FILE="$HOME/context7-setup.log"

# Function to log messages
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "Starting silent Context7 setup"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Node.js using the appropriate method for the platform
install_nodejs() {
  log "Installing Node.js..."
  
  if command_exists brew; then
    log "Using Homebrew to install Node.js"
    brew install node >> "$LOG_FILE" 2>&1
  else
    log "Homebrew not found. Installing Node.js using the official installer"
    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download and run the Node.js installer
    curl -s -o node-installer.pkg "https://nodejs.org/dist/v18.18.2/node-v18.18.2.pkg" >> "$LOG_FILE" 2>&1
    sudo installer -pkg node-installer.pkg -target / >> "$LOG_FILE" 2>&1
    
    # Clean up
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
  fi
  
  log "Node.js installation completed"
}

# Check for Node.js
log "Checking for Node.js"
if command_exists node; then
  NODE_VERSION=$(node -v | cut -d 'v' -f 2)
  NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d '.' -f 1)
  
  if [ "$NODE_MAJOR_VERSION" -lt 18 ]; then
    log "Node.js version $NODE_VERSION is too old. Version 18+ is required. Upgrading..."
    install_nodejs
  else
    log "Node.js version $NODE_VERSION is installed and compatible"
  fi
else
  log "Node.js not found. Installing..."
  install_nodejs
fi

# Check for Claude Desktop configuration directory
log "Checking for Claude Desktop configuration"
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"

if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
  log "Claude Desktop configuration directory not found. Creating..."
  mkdir -p "$CLAUDE_CONFIG_DIR"
  log "Created Claude Desktop configuration directory"
fi

# Check for Claude Desktop configuration file
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude-desktop-config.json"

# Create backup if file exists
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
  log "Creating backup of existing configuration"
  BACKUP_FILE="$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
  cp "$CLAUDE_CONFIG_FILE" "$BACKUP_FILE"
  log "Backup created at $BACKUP_FILE"
  
  # Check if Context7 is already configured
  if grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
    log "Context7 is already configured in Claude Desktop"
    
    # Update the configuration anyway
    log "Updating existing Context7 configuration"
  fi
fi

# Update or create configuration file
log "Configuring Context7 for Claude Desktop"

# If file exists and has mcpServers
if [ -f "$CLAUDE_CONFIG_FILE" ] && grep -q "mcpServers" "$CLAUDE_CONFIG_FILE"; then
  # Use jq if available for proper JSON manipulation
  if command_exists jq; then
    log "Using jq for JSON manipulation"
    # Create a temporary file with the updated configuration
    jq '.mcpServers.Context7 = {"command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"]}' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp"
    mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
  else
    log "jq not found, using pattern matching"
    # Check if Context7 is already in the file
    if ! grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
      # Insert Context7 configuration before the last closing brace of mcpServers
      sed -i '' -e '/"mcpServers": {/ {
        :a
        n
        /}/ !ba
        s/}/,\n    "Context7": {\n      "command": "npx",\n      "args": ["-y", "@upstash\/context7-mcp@latest"]\n    }\n}/
      }' "$CLAUDE_CONFIG_FILE"
    else
      # Update the existing Context7 configuration
      sed -i '' -e '/"Context7": {/,/}/ s/"args": \[[^]]*\]/"args": ["-y", "@upstash\/context7-mcp@latest"]/' "$CLAUDE_CONFIG_FILE"
    fi
  fi
else
  # Create a new configuration file
  log "Creating new configuration file"
  echo '{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}' > "$CLAUDE_CONFIG_FILE"
fi

log "Context7 configuration updated successfully"

# Create a hidden marker file to indicate successful installation
MARKER_FILE="$HOME/.context7_installed"
touch "$MARKER_FILE"
log "Created marker file at $MARKER_FILE"

# Create a hidden auto-update script
AUTO_UPDATE_SCRIPT="$HOME/.context7_update.sh"
cat > "$AUTO_UPDATE_SCRIPT" << 'EOF'
#!/bin/bash
# Hidden auto-update script for Context7

LOG_FILE="$HOME/context7-update.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Context7 auto-update" >> "$LOG_FILE"

CLAUDE_CONFIG_FILE="$HOME/Library/Application Support/Claude/claude-desktop-config.json"

if [ ! -f "$CLAUDE_CONFIG_FILE" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Claude Desktop configuration file not found" >> "$LOG_FILE"
  exit 1
fi

# Create backup
BACKUP_FILE="$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
cp "$CLAUDE_CONFIG_FILE" "$BACKUP_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup created at $BACKUP_FILE" >> "$LOG_FILE"

# Update configuration
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Updating Context7 configuration" >> "$LOG_FILE"

# Use jq if available
if command -v jq >/dev/null 2>&1; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Using jq for JSON manipulation" >> "$LOG_FILE"
  # Create a temporary file with the updated configuration
  jq '.mcpServers.Context7 = {"command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"]}' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp"
  mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] jq not found, using pattern matching" >> "$LOG_FILE"
  # Check if Context7 is in the file
  if grep -q "Context7" "$CLAUDE_CONFIG_FILE"; then
    # Update the existing Context7 configuration
    sed -i '' -e '/"Context7": {/,/}/ s/"args": \[[^]]*\]/"args": ["-y", "@upstash\/context7-mcp@latest"]/' "$CLAUDE_CONFIG_FILE"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Context7 configuration not found in the file" >> "$LOG_FILE"
    exit 1
  fi
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Context7 configuration updated successfully" >> "$LOG_FILE"
EOF

chmod +x "$AUTO_UPDATE_SCRIPT"
log "Created auto-update script at $AUTO_UPDATE_SCRIPT"

# Create a LaunchAgent for auto-updates if it doesn't exist
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
LAUNCH_AGENT_FILE="$LAUNCH_AGENT_DIR/com.context7.autoupdate.plist"

if [ ! -d "$LAUNCH_AGENT_DIR" ]; then
  mkdir -p "$LAUNCH_AGENT_DIR"
  log "Created LaunchAgents directory"
fi

# Only create the LaunchAgent if it doesn't exist
if [ ! -f "$LAUNCH_AGENT_FILE" ]; then
  cat > "$LAUNCH_AGENT_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.context7.autoupdate</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$AUTO_UPDATE_SCRIPT</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>3</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
EOF

  log "Created LaunchAgent for auto-updates at $LAUNCH_AGENT_FILE"
  
  # Load the LaunchAgent
  launchctl load "$LAUNCH_AGENT_FILE" >> "$LOG_FILE" 2>&1
  log "Loaded LaunchAgent for auto-updates"
fi

# Create a hidden cleanup script that can be used to remove all traces of Context7
CLEANUP_SCRIPT="$HOME/.context7_cleanup.sh"
cat > "$CLEANUP_SCRIPT" << 'EOF'
#!/bin/bash
# Hidden cleanup script for Context7

LOG_FILE="$HOME/context7-cleanup.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting Context7 cleanup" >> "$LOG_FILE"

# Unload and remove LaunchAgent
LAUNCH_AGENT_FILE="$HOME/Library/LaunchAgents/com.context7.autoupdate.plist"
if [ -f "$LAUNCH_AGENT_FILE" ]; then
  launchctl unload "$LAUNCH_AGENT_FILE" >> "$LOG_FILE" 2>&1
  rm "$LAUNCH_AGENT_FILE"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed LaunchAgent" >> "$LOG_FILE"
fi

# Remove auto-update script
AUTO_UPDATE_SCRIPT="$HOME/.context7_update.sh"
if [ -f "$AUTO_UPDATE_SCRIPT" ]; then
  rm "$AUTO_UPDATE_SCRIPT"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed auto-update script" >> "$LOG_FILE"
fi

# Remove marker file
MARKER_FILE="$HOME/.context7_installed"
if [ -f "$MARKER_FILE" ]; then
  rm "$MARKER_FILE"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed marker file" >> "$LOG_FILE"
fi

# Remove Context7 from Claude Desktop configuration
CLAUDE_CONFIG_FILE="$HOME/Library/Application Support/Claude/claude-desktop-config.json"
if [ -f "$CLAUDE_CONFIG_FILE" ]; then
  # Create backup
  BACKUP_FILE="$CLAUDE_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
  cp "$CLAUDE_CONFIG_FILE" "$BACKUP_FILE"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup created at $BACKUP_FILE" >> "$LOG_FILE"
  
  # Use jq if available
  if command -v jq >/dev/null 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Using jq for JSON manipulation" >> "$LOG_FILE"
    # Create a temporary file with Context7 removed
    jq 'del(.mcpServers.Context7)' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp"
    mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] jq not found, using pattern matching" >> "$LOG_FILE"
    # Remove Context7 configuration
    sed -i '' -e '/"Context7": {/,/}/d' "$CLAUDE_CONFIG_FILE"
    # Clean up any trailing commas
    sed -i '' -e 's/,\s*}/}/g' "$CLAUDE_CONFIG_FILE"
  fi
  
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed Context7 from Claude Desktop configuration" >> "$LOG_FILE"
fi

# Remove this cleanup script
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removing cleanup script" >> "$LOG_FILE"
rm "$0"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Context7 cleanup completed" >> "$LOG_FILE"
EOF

chmod +x "$CLEANUP_SCRIPT"
log "Created cleanup script at $CLEANUP_SCRIPT"

log "Context7 silent setup completed successfully"

# Exit with success
exit 0
