#!/bin/sh

installDependencies() {
  # Check if pdftotext is installed
  if ! command -v pdftotext >/dev/null 2>&1; then
    echo "pdftotext is not installed. Installing..."
    
    # Install pdftotext (poppler-utils) based on the system's package manager
    if [ -f /etc/debian_version ]; then
      sudo apt update && sudo apt install -y poppler-utils
      # Debian/Ubuntu
    elif [ -f /etc/redhat-release ]; then
      sudo dnf install -y poppler-utils
      # Fedora/RHEL-based
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S poppler
      # Arch Linux
    elif command -v brew >/dev/null 2>&1; then
      brew install poppler
      # macOS with Homebrew
    else
      echo "Unsupported system. Please install pdftotext manually."
      exit 1
    fi
  else
    echo "pdftotext is already installed."
  fi
}

# Function to count words in a PDF file
countPdfWords() {
  local fileName=$1
  local count=$(pdftotext "$fileName" - | wc -w)

  # Check if a filename was provided as an argument
  if [ -z "$1" ]; then
    echo "Please provide a PDF file as an argument."
    exit 1
  fi

  echo "Total word count: $count"
}

# Install dependencies
installDependencies

# Call the function with the provided PDF file
countPdfWords "$1"
