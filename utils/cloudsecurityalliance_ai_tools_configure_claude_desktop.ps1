# Cloud Security Alliance - Claude Desktop Configuration Script
#
# curl -sSL https://raw.githubusercontent.com/CloudSecurityAlliance/CSA-AI-Tool-Setup/refs/heads/main/utils/cloudsecurityalliance_ai_tools_configure_claude_desktop.ps1 | powershell.exe -NoProfile -ExecutionPolicy Bypass
#
Write-Host "--------------------------------------------------------"
Write-Host "Cloud Security Alliance - Claude Desktop Configuration Script"
Write-Host "--------------------------------------------------------"

# Define application installation links
$apps = @(
    @{ Name = "Claude Desktop"; Path = "C:\Program Files\Claude"; URL = "https://claude.ai/download" }
    @{ Name = "Google Drive Desktop"; Path = "C:\Program Files\Google\Drive"; URL = "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe" }
    @{ Name = "Docker Desktop"; Path = "C:\Program Files\Docker\Docker"; URL = "https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe" }
)

function Check-And-Install-Apps {
    Write-Host "Checking for required applications..."

    foreach ($app in $apps) {
        $appPath = $app["Path"]
        $appName = $app["Name"]
        $appURL = $app["URL"]

        if (Test-Path $appPath) {
            Write-Host "✅ $appName is installed."
        } else {
            Write-Host "❌ $appName is required but not installed."
            Write-Host "    ➡️  You can download it here: $appURL"
            Start-Process $appURL
            exit 1
        }
    }

    Write-Host "✅ All required applications are installed."
}

function Update-Or-Install-Docker-Images {
    $images = @(
        "mcp/brave-search:latest",
        "mcp/fetch:latest",
        "mcp/filesystem:latest",
        "mcp/git:latest",
        "mcp/puppeteer:latest",
        "mcp/sequentialthinking:latest"
    )

    Write-Host "Checking and updating/installing Docker images..."

    if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Docker is not installed or not in PATH. Please start Docker Desktop and try again."
        exit 1
    }

    foreach ($image in $images) {
        Write-Host "Processing $image..."
        $imageExists = docker image inspect $image 2>&1 | Out-String
        if ($imageExists -match "No such image") {
            Write-Host "  Image not found locally. Installing..."
            docker pull $image
        } else {
            Write-Host "  Image exists locally. Checking for updates..."
            docker pull $image
        }
        Write-Host "  ✅ $image is up to date."
    }

    Write-Host "✅ All Docker images have been processed."
}

function Get-User-Info {
    $configFile = "$env:USERPROFILE\Downloads\claude_desktop_userinfo.txt"

    if (-not (Test-Path $configFile)) {
        Write-Host "❌ Configuration file not found at: $configFile"
        Write-Host "Please create a file at $configFile with contents like:"
        Write-Host '{
  "GOOGLE_EMAIL_VALUE": "username@cloudsecurityalliance.org",
  "BRAVE_SEARCH_API_KEY_VALUE": "BS1234567890ABCDEFGHIJKLMNO"
}'
        exit 1
    }

    $content = Get-Content -Raw -Path $configFile | ConvertFrom-Json
    $googleAddress = $content.GOOGLE_EMAIL_VALUE
    $braveApiKey = $content.BRAVE_SEARCH_API_KEY_VALUE

    if ($braveApiKey -and $braveApiKey -notmatch "^BS") {
        Write-Host "❌ Brave API search key must start with 'BS'. Found: $braveApiKey"
        exit 1
    }

    Write-Host "✅ User information collected from config file."
    return @{ "GoogleAddress" = $googleAddress; "BraveApiKey" = $braveApiKey }
}

function Check-Claude-Config-Dir {
    $configDir = "$env:APPDATA\Claude"

    if (-not (Test-Path $configDir)) {
        Write-Host "❌ Claude configuration directory not found at: $configDir"
        Write-Host "   Please launch Claude Desktop at least once to create the directory."
        exit 1
    }
}

function Create-Config-File {
    param (
        [string]$googleAddress,
        [string]$braveApiKey
    )

    $templateURL = "https://raw.githubusercontent.com/CloudSecurityAlliance/CSA-AI-Tool-Setup/refs/heads/main/utils/claude_desktop_config.json"
    $targetPath = "$env:APPDATA\Claude\claude_desktop_config.json"

    if (Test-Path $targetPath) {
        Write-Host "❌ Configuration file already exists at: $targetPath"
        Write-Host "   Please backup and remove the existing file if you want to reconfigure."
        exit 1
    }

    Write-Host "Fetching template configuration..."
    try {
        $configContent = Invoke-RestMethod -Uri $templateURL
        $configContent = $configContent -replace "\[GOOGLE_EMAIL_VALUE\]", $googleAddress
        $configContent = $configContent -replace "\[BRAVE_SEARCH_API_KEY_VALUE\]", $braveApiKey

        $configContent | Out-File -Encoding utf8 -FilePath $targetPath
        Write-Host "✅ Successfully created configuration file at: $targetPath"
        Write-Host "   Please restart Claude Desktop for the changes to take effect."
    } catch {
        Write-Host "❌ Failed to download or create the configuration file."
        exit 1
    }
}

function Main {
    Write-Host "Starting Cloud Security Alliance AI Tools Configuration..."
    Write-Host ""

    Check-And-Install-Apps
    Write-Host ""

    Update-Or-Install-Docker-Images
    Write-Host ""

    $userInfo = Get-User-Info
    Write-Host ""

    Check-Claude-Config-Dir
    Write-Host ""

    # Create GitHub directory
    $githubDir = "$env:USERPROFILE\GitHub"
    if (-not (Test-Path $githubDir)) {
        Write-Host "Creating GitHub directory at: $githubDir"
        New-Item -ItemType Directory -Path $githubDir | Out-Null
        Write-Host "✅ GitHub directory created successfully"
    } else {
        Write-Host "✅ GitHub directory already exists at: $githubDir"
    }
    Write-Host ""

    Create-Config-File -googleAddress $userInfo.GoogleAddress -braveApiKey $userInfo.BraveApiKey
}

Main

