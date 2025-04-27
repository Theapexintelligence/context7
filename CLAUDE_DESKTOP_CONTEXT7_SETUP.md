# Setting Up Context7 in Claude Desktop

This guide will walk you through the process of adding Context7 to Claude Desktop on macOS.

## Prerequisites

- Claude Desktop installed on your Mac
- Node.js version 18.0.0 or higher

## Step 1: Install Node.js (if not already installed)

1. Visit the [Node.js website](https://nodejs.org/)
2. Download the LTS (Long Term Support) version for macOS
3. Run the installer and follow the instructions
4. After installation, verify by opening a new terminal and running:
   ```
   node -v
   ```
   This should display a version number of 18.0.0 or higher.

## Step 2: Update Claude Desktop Configuration

1. Locate your Claude Desktop configuration file:
   ```
   ~/Library/Application Support/Claude/claude-desktop-config.json
   ```

2. Make a backup of your existing configuration file:
   ```
   cp ~/Library/Application\ Support/Claude/claude-desktop-config.json ~/Library/Application\ Support/Claude/claude-desktop-config.json.backup
   ```

3. Edit the configuration file using a text editor. You can use TextEdit, VS Code, or any other text editor:
   ```
   open -a TextEdit ~/Library/Application\ Support/Claude/claude-desktop-config.json
   ```

4. Update the file to include Context7. If your file already has other MCP servers configured, add the Context7 configuration to the existing `mcpServers` object. The final file should look something like this:

   ```json
   {
     "mcpServers": {
       "playwright": {
         "command": "npx",
         "args": ["-y", "@executeautomation/playwright-mcp-server"]
       },
       "Context7": {
         "command": "npx",
         "args": ["-y", "@upstash/context7-mcp@latest"]
       }
     }
   }
   ```

   If your file is empty or doesn't have an `mcpServers` object, use this configuration:

   ```json
   {
     "mcpServers": {
       "Context7": {
         "command": "npx",
         "args": ["-y", "@upstash/context7-mcp@latest"]
       }
     }
   }
   ```

5. Save the file and close the text editor.

## Step 3: Restart Claude Desktop

1. Quit Claude Desktop if it's running
2. Restart Claude Desktop

## Step 4: Verify Installation

To verify that Context7 is working correctly:

1. Open Claude Desktop
2. Type a prompt that includes `use context7` at the end, for example:
   ```
   Create a basic Express.js server with a route that returns JSON data. use context7
   ```
3. Claude should respond with up-to-date, accurate code examples for Express.js

## Troubleshooting

If Context7 doesn't seem to be working:

1. Check that Node.js is installed correctly by running `node -v` in a terminal
2. Verify that your configuration file is correctly formatted JSON
3. Make sure you've restarted Claude Desktop after making changes
4. Check that you're including `use context7` in your prompts
5. Look for any error messages in Claude's responses

## Using Context7

To use Context7, simply add `use context7` at the end of your prompts in Claude Desktop:

```
Create a React component that fetches data from an API and displays it in a table. use context7
```

```
Write a Python script using FastAPI to create a REST API with authentication. use context7
```

Context7 will fetch up-to-date documentation and code examples for the libraries mentioned in your prompt, ensuring that you get accurate and working code examples.
