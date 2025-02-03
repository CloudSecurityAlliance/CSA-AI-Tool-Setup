# CSA AI Tools setup script

The Mac OS script is intentioanlly restricted to only run on Apple Silicon hardware.

## First install the needed applications:

* [Claude Desktop](https://claude.ai/download)
* [Google Drive Desktop](https://dl.google.com/drive-file-stream/GoogleDrive.dmg)
* [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/)

## First backup your existing config if you have one:

```
cp "/Users/`whoami`/Library/Application Support/Claude/claude_desktop_config.json" ~
```

## Then make sure you remove the existing config file:

```
rm "/Users/`whoami`/Library/Application Support/Claude/claude_desktop_config.json"
```

## Run the install script: 

```
curl -fsSL https://raw.githubusercontent.com/CloudSecurityAlliance/CSA-AI-Tool-Setup/refs/heads/main/utils/cloudsecurityalliance_ai_tools_configure_claude_desktop.zsh | zsh
```
