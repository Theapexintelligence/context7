# Context7 Guide

Context7 is a Model Context Protocol (MCP) server that provides up-to-date documentation and code examples for various libraries directly in your AI assistant's context.

## What is Context7?

Context7 MCP pulls up-to-date, version-specific documentation and code examples straight from the source and places them directly into your prompt. This helps you get accurate, working code examples instead of outdated or hallucinated APIs.

## How to Use Context7

Simply add `use context7` to your prompt when asking for help with a library or framework:

```
Create a basic Next.js project with app router. use context7
```

```
Create a script to delete the rows where the city is "" given PostgreSQL credentials. use context7
```

## Installation Options

### Prerequisites

- Node.js >= v18.0.0

### Install in Cursor

Go to: `Settings` -> `Cursor Settings` -> `MCP` -> `Add new global MCP server`

Or add this to your Cursor `~/.cursor/mcp.json` file:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Install in Zed

Install via [Zed Extensions](https://zed.dev/extensions?query=Context7) or add this to your Zed `settings.json`:

```json
{
  "context_servers": {
    "Context7": {
      "command": {
        "path": "npx",
        "args": ["-y", "@upstash/context7-mcp@latest"]
      },
      "settings": {}
    }
  }
}
```

### Install in Claude Code

Run this command:

```sh
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

### Install in Claude Desktop

Add this to your Claude Desktop `claude_desktop_config.json` file:

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

## Building from Source

If you want to build Context7 from source:

1. Clone the repository
2. Install dependencies: `npm install` or `bun install`
3. Build the project: `npm run build` or `bun run build`
4. The compiled output will be in the `dist` directory

## Available Tools

Context7 provides two main tools:

1. `resolve-library-id`: Resolves a general library name into a Context7-compatible library ID.
2. `get-library-docs`: Fetches documentation for a library using a Context7-compatible library ID.

## Benefits of Using Context7

- ✅ Get up-to-date code examples based on current documentation
- ✅ Access accurate APIs that actually exist
- ✅ Receive version-specific answers for packages
- ✅ No need to switch tabs to look up documentation
