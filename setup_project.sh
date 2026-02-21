#!/usr/bin/env bash
# This script sets up the project by creating the workspace and configuring the environment.

# ask for user input for the name of the attendance tracker
read -p "Enter the name of your attendance  tracker (default: v1): " NAME
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