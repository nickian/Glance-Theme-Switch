#!/bin/bash

# Load environment variables from .env file in the same directory
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/.env"

# Check if required variables are set
if [ -z "$DIR" ] || [ -z "$DOCKER_CONTAINER" ] || [ -z "$LIGHT_HOUR" ] || [ -z "$DARK_HOUR" ]; then
    echo "Error: One or more required environment variables are not set in the .env file"
    exit 1
fi

# Check the current hour
HOUR=$(date +"%H")

# Function to append the contents of a file to glance.yml
append_content() {
    local content_file=$1
    local marker="# ADDED CONTENT"

    # Remove previous added content
    sed -i "/$marker/,/^$/d" "$GLANCE_FILE"

    # Append the new content with a marker
    { echo "$marker"; cat "$content_file"; } >> "$GLANCE_FILE"
}

# Function to remove appended content
remove_content() {
    local marker="# ADDED CONTENT"

    # Remove previous added content
    sed -i "/$marker/,/^$/d" "$GLANCE_FILE"
}

# Function to restart Docker container
restart_docker_container() {
    docker restart "$DOCKER_CONTAINER"
}

if [ "$HOUR" -eq "$DARK_HOUR" ]; then
    # Replace light.yml content with dark.yml content
    if [ -f "$DARK_FILE" ]; then
        append_content "$DARK_FILE"
        restart_docker_container
    fi
elif [ "$HOUR" -eq "$LIGHT_HOUR" ]; then
    # Replace dark.yml content with light.yml content
    remove_content
    if [ -f "$LIGHT_FILE" ]; then
        append_content "$LIGHT_FILE"
        restart_docker_container
    fi
fi