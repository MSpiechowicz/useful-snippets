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

# Function to count the number of words in a JSON file
countJsonWords() {
  # Check if the file name is provided
  if [ -z "$1" ]; then
    echo "You forgot to provide a JSON file. Please provide one!"
    exit 1
  fi
  
  # Make sure the provided file exists
  if [ ! -f "$1" ]; then
    echo "The file '$1' doesn't exist. Please provide a valid file path."
    exit 1
  fi
  
  # Extract values from the JSON file, clean them up, and count the words
  local fileName=$1
  echo "Processing the file '$fileName' ..."
  
  jq -r '. | to_entries | .[].value' "$fileName" | tr -s '[:space:]' '\n' | wc -w
}

# Check and install jq if necessary
installDependencies

# Call the function to clean branches
countJsonWords "$1"
