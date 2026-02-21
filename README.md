# Student Attendance Tracker

## Description

A script that automates creation of the workspace, configures settings via the command line, and handles signals gracefully.

## How it works

1. Directory Architecture

Creates a parent directory named `attendance_tracker_{input}` where `{input}` is a user provided string. Inside the directory:
    - `attendance_checker.py` (The main logic)
    - `Helpers/` (Containing `assets.csv` and `config.json`)
    - `reports/` (Containing `reports.log`)

2. Dynamic Configuration (Stream Editing)

The script must prompt the user to decide if they want to update the attendance thresholds.
    - Use the `read` command to capture new values for Warning (default 75%) and Failure (default 50%).
    - Use the `sed` command to perform an "in-place" edit of the `config.json` file to reflect these new values.

3. Process Management (The Trap)

Implement a Signal Trap to handle user interrupts (SIGINT/Ctrl+C).
    - If the user cancels the script mid-execution, the script must catch the signal.
    - Before exiting, it must bundle the current state of the project directory into an archive and named `attendance_tracker_{input}_archive`
    - The incomplete directory should then be deleted to keep the workspace clean.

4. Environment Validation

Before completing the setup, the script must perform a "Health Check":
    - Verify if `python3` is installed on the local system.
    - To check you should use `python3 --version` command
    - Print a success message if found, or a warning if missing
    - Ensure the application directory structure is followed.