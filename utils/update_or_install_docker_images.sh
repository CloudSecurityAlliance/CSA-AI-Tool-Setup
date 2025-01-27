#!/bin/bash

# Function to check, install, or update Docker images
update_or_install_docker_images() {
    # Default list of Docker images
    local default_images=(
	"mcp/brave-search:latest"
	"mcp/fetch:latest"
	"mcp/filesystem:latest"
	"mcp/git:latest"
	"mcp/sequentialthinking:latest"
    )

    # Use provided images or fall back to the default list
    local images=("${@:-${default_images[@]}}")

    echo "Checking and updating/installing Docker images..."

    for image in "${images[@]}"; do
        echo "Processing $image..."
        
        # Check if the image exists locally
        if docker image inspect "$image" > /dev/null 2>&1; then
            echo "  Image exists locally. Checking for updates..."
            # Pull the image to check for updates
            docker pull "$image"
        else
            echo "  Image not found locally. Installing..."
            # Pull the image to install it
            docker pull "$image"
        fi

        # Check the status of the pull operation
        if [ $? -eq 0 ]; then
            echo "  $image is up to date or has been successfully installed."
        else
            echo "  Failed to update/install $image. Please check manually."
        fi

        echo
    done

    echo "All images have been processed."
}

# Example usage of the function
# If no arguments are passed, it uses the default list
update_or_install_docker_images

# Example with a custom list of images
# update_or_install_docker_images "redis:latest" "postgres:13"
