# Claude Desktop Installation Guide

Claude Desktop provides a native application experience for interacting with Claude, Anthropic's AI assistant. This guide will walk you through the installation process.

## Account Requirements

- A paid Claude Pro subscription is reccomended so you don't run out of tokens constantly
- Visit [claude.ai](https://claude.ai) to create an account and subscribe
- Current pricing and subscription options are available on the signup page
- Free trial may be available for new users (check website for current offers)

## Installation Steps

1. Visit [Claude Desktop](https://claude.ai/desktop) on the Anthropic website
2. Click the "Download" button for your operating system (Windows or macOS)
3. Once downloaded:
   - **Windows**: Run the `.exe` installer and follow the prompts
   - **macOS**: Open the `.dmg` file and drag Claude to your Applications folder

## Docker containers

```bash
docker pull mcp/filesystem
docker pull mcp/brave-search
docker pull mcp/sequentialthinking
docker pull mcp/git
docker pull mcp/fetch
docker pull mcp/puppeteer
```

## Configuration File Setup

Claude Desktop uses a JSON configuration file that can be customized for advanced settings:
      
### Location
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **macOS**: `~/Library/Application\ Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--mount",
        "type=bind,src=/Users/[YOUR LOCAL NAME]/Library/CloudStorage/GoogleDrive-[YOUR GOOGLE NAME]@cloudsecurityalliance.org,dst=/GoogleDrive",
        "mcp/filesystem",
        "/GoogleDrive"
      ]
    },
    "brave-search": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "BRAVE_API_KEY",
        "mcp/brave-search"
      ],
      "env": {
        "BRAVE_API_KEY": "[BRAVE_API_KEY_HERE]"
      }
    },
    "sequentialthinking": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "mcp/sequentialthinking"
      ]
    },
    "git": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "--mount",
        "type=bind,src=/Users/[USERNAME]/GitHub,dst=/GitHub",
        "mcp/git"
      ]
    },
    "fetch": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "mcp/fetch"
      ]
    }
  }
}
```

### Installation

First download the file:

```bash
curl https://raw.githubusercontent.com/CloudSecurityAlliance/CSA-AI-Tool-Setup/refs/heads/main/setup-guides/Anthropic/claude_desktop_config.json > claude_desktop_config.json
```

Then move the file:

```bash
mv claude_desktop_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### TODO INSTAL SCRIPT

1. curl blah | sh
2. Can it check for claude desktop install and docker? Yes. Files and command
3. Prompt the user for which MCP servers they want, and what config they want, e.g. "Do you want... and then ask for any config. Automate where possible, e.g. `whoai`
4. Interactive prompt for e.g. brave-search setup, provide URL and instructions (e.g. credit card needed).
5. Support updates/additions? "You currently have..."
6. Do supporting actions like docker pull, restrict ourselves to the mcp/ and cloudsecurityallianceorg/

## Additional Resources

- [Claude Documentation](https://docs.anthropic.com)
- [Anthropic Support](https://support.anthropic.com)
- [Claude Web Interface](https://claude.ai)
- [Claude Pro Subscription](https://claude.ai/pricing)
