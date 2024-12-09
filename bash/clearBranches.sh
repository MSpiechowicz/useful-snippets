#!/bin/sh

# Function to delete all local Git branches except 'dev', 'prod', and 'master'
cleanBranches() {
  # List all local branches and filter out 'dev', 'prod', and 'master'
  local branches_to_delete=$(git branch | grep -v -e "dev$" -e "prod$" -e "master$")
  
  # Check if there are any branches to delete
  if [ -z "$branches_to_delete" ]; then
    echo "No branches to delete. Only 'dev', 'prod', and 'master' branches are present."
    exit 0
  fi
  
  # Delete the branches
  echo "Deleting the following branches:"
  echo "$branches_to_delete"
  
  # Use git branch -D to delete the branches forcefully
  git branch -D $(echo "$branches_to_delete" | sed 's/^[ *]*//')
}

# Call the function to clean branches
cleanBranches
