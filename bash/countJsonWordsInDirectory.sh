#!/bin/sh

# Function to check if jq is installed, and install it if necessary
installDependencies() {
  echo "Checking if jq is installed..."

  # Check if jq is available in the system
  if ! command -v jq >/dev/null 2>&1; then
    echo "jq is not installed. Attempting to install jq..."

    # Try to install jq based on the system's package manager
    if [ -f /etc/debian_version ]; then
      # For Debian/Ubuntu-based systems
      sudo apt update && sudo apt install -y jq
    elif [ -f /etc/redhat-release ]; then
      # For Fedora/RHEL-based systems
      sudo dnf install -y jq
    elif command -v pacman >/dev/null 2>&1; then
      # For Arch Linux/Manjaro
      sudo pacman -S jq --noconfirm
    elif command -v brew >/dev/null 2>&1; then
      # For macOS with Homebrew
      brew install jq
    else
      echo "Unable to detect a supported package manager. Please install jq manually."
      exit 1
    fi
  else
    echo "jq is already installed."
  fi
}

# Function to count the number of words in all JSON files in a directory (and subdirectories if needed)
countJsonWordsInDirectory() {
  # Check if a directory name was provided
  if [ -z "$1" ]; then
    echo "Please provide a directory name."
    exit 1
  fi
  
  # Check if the directory exists
  if [ ! -d "$1" ]; then
    echo "The directory '$1' does not exist. Please provide a valid directory path."
    exit 1
  fi
  
  local dirName=$1
  local totalCount=0
  
  # Loop over all JSON files in the directory (including subdirectories if needed)
  for file in "$dirName"/*.json; do
    if [ -f "$file" ]; then
      # Count words in each JSON file and add it to the total count
      count=$(jq -r '. | to_entries | .[].value' "$file" | tr -s '[:space:]' '\n' | wc -w)
      totalCount=$((totalCount + count))
    fi
  done
  
  echo "Total word count for all JSON files in '$dirName': $totalCount"
}

# Check and install jq if necessary
installDependencies

# Call the function with the provided directory
countJsonWordsInDirectory "$1"
