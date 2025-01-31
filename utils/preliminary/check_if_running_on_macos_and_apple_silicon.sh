#!/bin/bash

# Function to check if running on macOS and Apple Silicon
check_if_running_on_macos_and_apple_silicon() {
    local os_name=$(uname)
    local architecture=$(uname -m)

    if [[ "$os_name" != "Darwin" ]]; then
        echo "❌ This script is designed to run on macOS only. Detected OS: $os_name"
        exit 1
    fi

    if [[ "$architecture" != "arm64" ]]; then
        echo "❌ This script is designed to run on Apple Silicon (ARM64) only. Detected architecture: $architecture"
        exit 1
    fi

    echo "✅ Running on macOS and Apple Silicon (ARM64). Proceeding..."
}

# Example usage of the function
check_if_running_on_macos_and_apple_silicon

# Rest of the script logic goes here
echo "Script continues..."

