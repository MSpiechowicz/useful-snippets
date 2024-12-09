#!/bin/sh

# Function to kill the process listening on a specified TCP port
killPort() {
  # Check if a port number was provided as an argument
  if [ -z "$1" ]; then
    echo "Please provide a port number."
    exit 1
  fi
  
  # Find the process ID (PID) of the process using the specified port
  PID=$(echo $(lsof -n -i4TCP:$1) | awk 'NR==1{print $11}')
  
  # Check if a PID was found and kill it
  if [ -n "$PID" ]; then
    echo "Killing process with PID $PID using port $1"
    kill -9 $PID
  else
    echo "No process found using port $1."
  fi
}

# Call the function with the provided port number
killPort "$1"
