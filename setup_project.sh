#!/usr/bin/env bash
# This script sets up the project by creating the workspace and configuring the environment.
# It performs the following tasks:
# 1. Creates a workspace directory with the name provided by the user.
# 2. Creates subdirectories for helpers and reports.
# 3. Copies necessary files from the source_files directory to the workspace.
# 4. Prompts the user to update the attendance threshold in the config.json file.
# 5. Provides feedback on the setup process and any updates made to the configuration.
# 6. Implements a Signal Trap to handle interruptions gracefully.
# If the user interrupts the script (e.g., by pressing Ctrl+C), it will execute the cleanup function to remove any partially created workspace and exit cleanly.
# Before exiting, it must bundle the current state of the project directory into an archive named "attendance_tracker_{input}_archive
# where {input} is the name of the attendance tracker provided by the user.

cleanup() {
    echo "Cleaning up the workspace..."
    if [[ -d "$WORKSPACE_DIR" ]]; then
        tar -czf "attendance_tracker_${NAME}_archive.tar.gz" "$WORKSPACE_DIR"
        rm -rf "$WORKSPACE_DIR"
        echo "Workspace archived as attendance_tracker_${NAME}_archive.tar.gz"
    fi
    exit 1
}

# Initialize variables
NAME=""
WORKSPACE_DIR=""

trap cleanup SIGINT SIGTERM

# ask for user input for the name of the attendance tracker
read -p "Enter the name of your attendance  tracker (default: v1): " NAME
if [[ -z "$NAME" ]]; then
    NAME="v1"
fi
WORKSPACE_DIR="$PWD/attendance_tracker_$NAME"

# create the workspace directory and subdirectories
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR/Helpers"
mkdir -p "$WORKSPACE_DIR/reports"

# List of required files
REQUIRED_FILES=("attendance_checker.py" "assets.csv" "config.json" "reports.log")

# Check if the required files exist in the source_files directory
for FILE in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$PWD/source_files/$FILE" ]]; then
        echo "Error: Required file '$FILE' not found in the source_files directory."
        exit 1
    fi
done

# copy files from the source_files directory to the workspace
cp "$PWD/source_files/attendance_checker.py" "$WORKSPACE_DIR/"
cp "$PWD/source_files/assets.csv" "$WORKSPACE_DIR/Helpers"
cp "$PWD/source_files/config.json" "$WORKSPACE_DIR/Helpers"
cp "$PWD/source_files/reports.log" "$WORKSPACE_DIR/reports"
echo "Project setup completed successfully. Workspace created at: $WORKSPACE_DIR"

# prompt the user to decide whether to update the attendance threshold
read -p "Do you want to update the attendance threshold? (y/n): " UPDATE_THRESHOLD
if [[ "$UPDATE_THRESHOLD" == "y" ]]; then
    read -p "Enter the new warning threshold (default: 75): " NEW_WARNING_THRESHOLD
    read -p "Enter the new failure threshold (default: 50): " NEW_FAILURE_THRESHOLD
    if [[ -z "$NEW_WARNING_THRESHOLD" ]]; then
        NEW_WARNING_THRESHOLD=75
    fi
    if [[ -z "$NEW_FAILURE_THRESHOLD" ]]; then
        NEW_FAILURE_THRESHOLD=50
    fi
    
    # Update the attendance threshold. Structure -> thresholds: {"warning: 75, "failure": 50}
    sed -i "s/\"warning\": [0-9]\+/\\"warning\\": $NEW_WARNING_THRESHOLD/" "$WORKSPACE_DIR/Helpers/config.json"
    sed -i "s/\"failure\": [0-9]\+/\\"failure\\": $NEW_FAILURE_THRESHOLD/" "$WORKSPACE_DIR/Helpers/config.json"

    if [[ $? -eq 0 ]]; then
        echo "Attendance threshold updated to warning: $NEW_WARNING_THRESHOLD, failure: $NEW_FAILURE_THRESHOLD in config.json."
    else
        echo "Error updating attendance threshold in config.json." >&2
        exit 1
    fi
else
    echo "Attendance threshold remains unchanged in config.json."
fi