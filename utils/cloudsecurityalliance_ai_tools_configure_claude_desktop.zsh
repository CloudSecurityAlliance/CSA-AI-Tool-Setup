#!/usr/bin/env zsh
setopt ERR_EXIT NO_UNSET PIPE_FAIL

{

# Print banner
echo 'Cloud Security Alliance - Claude Desktop Configuration Script'
echo '--------------------------------------------------------'
echo 'This script will:'
echo '- Check your system compatibility'
echo '- Install/update Docker images'
echo '- Create a Claude Desktop configuration file'
echo ''
echo 'Review the source at:'
echo 'https://github.com/cloudsecurityalliance/CSA-AI-Tool-Setup'
echo '--------------------------------------------------------'
echo ''

# Always read from /dev/tty for interactive input
read "REPLY?Would you like to proceed? (y/N) " < /dev/tty
echo ''
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo '❌ Setup cancelled.'
    exit 1
fi

trap 'echo ""; echo "❌ Setup cancelled."; exit 1' INT

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
    whoami_var=$(whoami)
    if [[ -z "$whoami_var" ]]; then
        echo '❌ Failed to get current username.'
        exit 1
    fi
    
    read "google_address?Enter your Google Drive email address (leave blank if not applicable): " < /dev/tty
    
    while true; do
        read "brave_api_key?Enter your Brave API search key (must start with BS, leave blank if not applicable): " < /dev/tty
        if [[ -z "$brave_api_key" || "$brave_api_key" = BS* ]]; then
            break
        else
            echo 'Error: Brave API search key must start with BS. Please try again.'
        fi
    done

    : ${google_address:=''}
    : ${brave_api_key:=''}

    echo '✅ User information collected.'
}

check_claude_config_dir() {
    local whoami_var="$1"
    local config_dir="/Users/$whoami_var/Library/Application Support/Claude"
    
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
    local template_path='/projects/GitHub/CSA-AI-Tool-Setup/setup-guides/Anthropic/claude_desktop_config.json'
    local target_path="/Users/$whoami_var/Library/Application Support/Claude/claude_desktop_config.json"

    if [[ -f "$target_path" ]]; then
        echo "❌ Configuration file already exists at: $target_path"
        echo '   Please backup and remove the existing file if you want to reconfigure.'
        exit 1
    fi

    if [[ ! -f "$template_path" ]]; then
        echo "❌ Template configuration file not found at: $template_path"
        exit 1
    fi

    local config_content
    config_content=$(<"$template_path") || {
        echo '❌ Failed to read template configuration file.'
        exit 1
    }

    config_content=${config_content//\[WHOAMI RESULT GOES HERE\]/$whoami_var}
    config_content=${config_content//\[EMAIL_ADDRESS_GOES_HERE\]/$google_address}
    config_content=${config_content//\[BRAVE_API_KEY\]/$brave_api_key}

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

    create_config_file "$whoami_var" "$google_address" "$brave_api_key"
}

main

}