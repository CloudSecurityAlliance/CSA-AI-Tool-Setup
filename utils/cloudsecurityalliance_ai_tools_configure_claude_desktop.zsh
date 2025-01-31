#!/usr/bin/env zsh
setopt ERR_EXIT NO_UNSET PIPE_FAIL

# Configuration
USER_NAME="$(whoami)"

{

echo 'Cloud Security Alliance - Claude Desktop Configuration Script'
echo '--------------------------------------------------------'

check_if_running_on_macos_and_apple_silicon() {
    local os_name=$(uname)
    local architecture=$(uname -m)

    if [[ "$os_name" != 'Darwin' ]]; then
        echo "❌ This script is designed to run on macOS only. Detected OS: $os_name"
        exit 1
    fi

    if [[ "$architecture" != 'arm64' ]]; then
        echo "❌ This script is designed to run on Apple Silicon (ARM64) only. Detected architecture: $architecture"
        exit 1
    fi

    echo '✅ Running on macOS and Apple Silicon (ARM64). Proceeding...'
}

check_and_install_apps_on_macos() {
    local -a default_apps
    default_apps=(
        'Claude Desktop|Claude|https://claude.ai/download'
        'Google Drive Desktop|Google Drive|https://dl.google.com/drive-file-stream/GoogleDrive.dmg'
        'Docker Desktop|Docker|https://docs.docker.com/desktop/setup/install/mac-install/'
    )

    local -a apps
    apps=("${@:-${default_apps[@]}}")

    echo 'Checking for the installation of required applications on macOS...'

    for app in "${apps[@]}"; do
        local app_name="${app%%|*}"
        local app_display_name="${${app#*|}%%|*}"
        local app_url="${app##*|}"

        echo "Checking for $app_name..."

        if mdfind kMDItemKind=Application | grep -i "$app_display_name" > /dev/null 2>&1; then
            echo "  ✅ $app_name is installed."
        else
            if [[ "$app_display_name" = 'Claude' || "$app_display_name" = 'Docker' ]]; then
                echo "  ❌ $app_name is required but not installed."
                echo "    ➡️  You can download it here: $app_url"
                exit 1
            else
                echo "  ⚠️  $app_name is not installed but optional."
                echo "    ➡️  You can download it here: $app_url"
            fi
        fi
        echo ''
    done

    echo 'Required applications check complete.'
}

update_or_install_docker_images() {
    local -a default_images
    default_images=(
        'mcp/brave-search:latest'
        'mcp/fetch:latest'
        'mcp/filesystem:latest'
        'mcp/git:latest'
	'mcp/puppeteer:latest'
        'mcp/sequentialthinking:latest'
    )

    local -a images
    images=("${@:-${default_images[@]}}")

    echo 'Checking and updating/installing Docker images...'

    if ! docker info >/dev/null 2>&1; then
        echo '❌ Docker is not running. Please start Docker Desktop and try again.'
        exit 1
    fi

    for image in "${images[@]}"; do
        echo "Processing $image..."
        
        if docker image inspect "$image" > /dev/null 2>&1; then
            echo '  Image exists locally. Checking for updates...'
            if ! docker pull "$image"; then
                echo "  ❌ Failed to update $image. Please check your internet connection and try again."
                exit 1
            fi
        else
            echo '  Image not found locally. Installing...'
            if ! docker pull "$image"; then
                echo "  ❌ Failed to install $image. Please check your internet connection and try again."
                exit 1
            fi
        fi

        echo "  ✅ $image is up to date."
        echo ''
    done

    echo '✅ All Docker images have been processed.'
}

get_user_info() {
    # Get current username
    whoami_var=$(whoami)
    if [[ -z "$whoami_var" ]]; then
        echo '❌ Failed to get current username.'
        exit 1
    fi

    # Read config file
    local config_file="/Users/${whoami_var}/Downloads/claude_desktop_userinfo.txt"
    if [[ ! -f "$config_file" ]]; then
        echo "❌ Configuration file not found at: $config_file"
        echo "Please create a file at $config_file with contents like:"
        echo '{"google_email":"email@address","brave_search_api_key":"BS2487yr92y34t"}'
        exit 1
    fi

    # Parse JSON - using grep/sed since we know the exact format
    local content=$(<"$config_file")
    google_address=$(echo "$content" | sed -n 's/.*"google_email":"\([^"]*\)".*/\1/p')
    brave_api_key=$(echo "$content" | sed -n 's/.*"brave_search_api_key":"\([^"]*\)".*/\1/p')

    # Validate Brave API key if provided
    if [[ -n "$brave_api_key" && ! "$brave_api_key" = BS* ]]; then
        echo "❌ Brave API search key must start with 'BS'. Found: $brave_api_key"
        exit 1
    fi

    echo '✅ User information collected from config file.'
}

check_claude_config_dir() {
    local whoami_var="$1"
    local config_dir="/Users/${whoami_var}/Library/Application Support/Claude"
    
    if [[ ! -d "$config_dir" ]]; then
        echo "❌ Claude configuration directory not found at: $config_dir"
        echo '   Please launch Claude Desktop at least once to create the directory.'
        exit 1
    fi
}

create_config_file() {
    local whoami_var="$1"
    local google_address="$2"
    local brave_api_key="$3"
    local template_url='https://raw.githubusercontent.com/CloudSecurityAlliance/CSA-AI-Tool-Setup/refs/heads/main/utils/claude_desktop_config.json'
    local target_path="/Users/${whoami_var}/Library/Application Support/Claude/claude_desktop_config.json"

    if [[ -f "$target_path" ]]; then
        echo "❌ Configuration file already exists at: $target_path"
        echo '   Please backup and remove the existing file if you want to reconfigure.'
        exit 1
    fi

    # Fetch template from GitHub
    echo 'Fetching template configuration...'
    local config_content
    config_content=$(curl -fsSL "$template_url") || {
        echo '❌ Failed to download template configuration.'
        exit 1
    }

    config_content=${config_content//\[WHOAMI_VALUE\]/$whoami_var}
    config_content=${config_content//\[GOOGLE_EMAIL_VALUE\]/$google_address}
    config_content=${config_content//\[BRAVE_SEARCH_API_KEY_VALUE\]/$brave_api_key}

    if ! print -r -- "$config_content" > "$target_path"; then
        echo '❌ Failed to write configuration file.'
        exit 1
    fi

    echo "✅ Successfully created configuration file at: $target_path"
    echo '   Please quit and restart Claude Desktop for the changes to take effect.'
}

main() {
    echo 'Starting Cloud Security Alliance AI Tools Configuration...'
    echo ''

    check_if_running_on_macos_and_apple_silicon
    echo ''

    check_and_install_apps_on_macos
    echo ''

    update_or_install_docker_images
    echo ''

    get_user_info
    echo ''

    check_claude_config_dir "$whoami_var"
    echo ''

    # Create GitHub directory
    local github_dir="/Users/${whoami_var}/GitHub"
    if [[ ! -d "$github_dir" ]]; then
        echo "Creating GitHub directory at: $github_dir"
        mkdir -p "$github_dir" || {
            echo "❌ Failed to create GitHub directory"
            exit 1
        }
        echo "✅ GitHub directory created successfully"
    else
        echo "✅ GitHub directory already exists at: $github_dir"
    fi
    echo ''

    create_config_file "$whoami_var" "$google_address" "$brave_api_key"
}

main

}
