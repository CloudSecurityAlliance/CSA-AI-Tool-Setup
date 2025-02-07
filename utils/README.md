# CSA AI Tools setup script

The Mac OS script is intentioanlly restricted to only run on Apple Silicon hardware.

## First install the needed applications:

* [Claude Desktop](https://claude.ai/download)
* [Google Drive Desktop](https://dl.google.com/drive-file-stream/GoogleDrive.dmg)
* [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/)
* On Windows you will need [iCloud](https://www.microsoft.com/store/apps/9PKTQ5699M62)

## Optional applications:

* [Obsidian](https://obsidian.md/download)

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
