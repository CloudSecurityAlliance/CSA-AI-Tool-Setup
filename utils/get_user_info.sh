#!/bin/bash

# Function to get the current username
get_user() {
    whoami_var=$(whoami)
}

# Function to prompt for user inputs
get_user_inputs() {
    read -p "Enter your Google Drive email address (leave blank if not applicable): " google_address

    while true; do
        read -p "Enter your Brave API search key (must start with 'BS', leave blank if not applicable): " brave_api_key

        # Validate the Brave API key if provided
        if [[ -z $brave_api_key || $brave_api_key == BS* ]]; then
            break
        else
            echo "Error: Brave API search key must start with 'BS'. Please try again."
        fi
    done

    # If inputs are blank, set variables to blank
    google_address=${google_address:-""}
    brave_api_key=${brave_api_key:-""}
}

# Main script logic
main() {
    # Get the current username
    get_user

    # Prompt the user for inputs
    get_user_inputs

    # Store values in an array
    user_data=("whoami_var=$whoami_var" "google_address=$google_address" "brave_api_key=$brave_api_key")

    # Display the array content for verification
    echo "User data array:"
    printf "%s\n" "${user_data[@]}"
}

# Run the main function
main

