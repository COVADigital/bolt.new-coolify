#!/bin/bash

bindings=""
env_file=".env"

# Check if the .env file exists
if [[ ! -f "$env_file" ]]; then
  echo "Error: $env_file not found. Exiting."
  exit 1
fi

echo "Reading $env_file file..."

# Read and process each line in the .env file
while IFS= read -r line || [ -n "$line" ]; do
  echo "Processing line: $line"
  
  # Skip comments and empty lines
  if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
    name=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    value=$(echo "$value" | sed 's/^"\(.*\)"$/\1/') # Remove surrounding quotes if any
    bindings+="--binding ${name}=${value} "
    echo "Added binding: --binding ${name}=${value}"
  fi
done < "$env_file"

# Clean up trailing spaces and output bindings
if [[ -z "$bindings" ]]; then
  echo "No bindings found in $env_file."
else
  bindings=$(echo "$bindings" | sed 's/[[:space:]]*$//')
  echo "Final bindings: $bindings"
fi

# Echo the bindings for usage in the calling process
echo $bindings
