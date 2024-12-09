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

countPdfWordsInDirectory() {
  local dirName=$1
  local totalCount=0
  local totalFiles=0
  local processedFiles=0

  # Check if a directory was provided as an argument
  if [ -z "$1" ]; then
    echo "Please provide a directory as an argument."
    exit 1
  fi

  # Count the total number of PDF files in the directory
  for file in "$dirName"/*.pdf; do
    if [ -f "$file" ]; then
      totalFiles=$((totalFiles + 1))
    fi
  done

  # Exit if there are no PDFs
  if [ "$totalFiles" -eq 0 ]; then
    echo "No PDF files found in the directory."
    return
  fi

  for file in "$dirName"/*.pdf; do
    if [ -f "$file" ]; then
      count=$(pdftotext "$file" - | wc -w)
      totalCount=$((totalCount + count))
      processedFiles=$((processedFiles + 1))
      generateProgressBar $processedFiles $totalFiles
    fi
  done

  echo "\nTotal word count: $totalCount"
}

# Function to display a progress bar
generateProgressBar() {
    local current=$1
    local total=$2
    local percent=$(( 100 * current / total ))
    local progress=$(( 40 * current / total ))  # 40-character long progress bar

    # Build the progress bar and string
    local bar=""
    for (( i=0; i<$progress; i++ )); do
        bar="${bar}="
    done

    local spaces=""
    for (( i=$progress; i<40; i++ )); do
        spaces="${spaces} "
    done

    # Print the progress bar
    printf "\r[${bar}${spaces}] %3d%% (%d/%d files processed)" "$percent" "$current" "$total"
}

# Install dependencies
installDependencies

# Call the function with the provided directory
countPdfWordsInDirectory "$1"
