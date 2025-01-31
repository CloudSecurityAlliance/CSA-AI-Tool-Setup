#!/bin/bash

# Function to check for the installation of specified apps on macOS
check_and_install_apps_on_macos() {
    # Default list of apps
    local default_apps=(
        "Claude Desktop|Claude|https://claude.ai/download"
        "Google Drive Desktop|Google Drive|https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
        "Docker Desktop|Docker|https://docs.docker.com/desktop/setup/install/mac-install/"
    )

    # Use provided arguments or default list if no arguments are passed
    local apps=("${@:-${default_apps[@]}}")

    echo "Checking for the installation of required applications on macOS..."

    for app in "${apps[@]}"; do
        # Parse the app details
        local app_name=$(echo "$app" | cut -d '|' -f 1)
        local app_display_name=$(echo "$app" | cut -d '|' -f 2)
        local app_url=$(echo "$app" | cut -d '|' -f 3)

        echo "Checking for $app_name..."

        # Check if the app is installed using `mdfind`
        if mdfind "kMDItemKind == 'Application' && kMDItemDisplayName == '$app_display_name'" | grep -q "$app_display_name"; then
            echo "  ✅ $app_name is installed."
        else
            echo "  ❌ $app_name is not installed."
            echo "    ➡️  You can download it here: $app_url"
        fi

        echo
    done

    echo "Check complete."
}

# Example usage of the function
# Call with the default list
check_and_install_apps_on_macos

# Call with custom arguments (provide your own list of apps in the same format)
# check_and_install_apps_on_macos \
#     "Visual Studio Code|Visual Studio Code|https://code.visualstudio.com/download" \
#     "Slack|Slack|https://slack.com/downloads/mac"

