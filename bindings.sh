#!/bin/bash

bindings=""
echo "Reading .env.local file..."

while IFS= read -r line || [ -n "$line" ]; do
  echo "Processing line: $line"
  if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
    name=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    value=$(echo $value | sed 's/^"\(.*\)"$/\1/')
    bindings+="--binding ${name}=${value} "
    echo "Added binding: --binding ${name}=${value}"
  fi
done < .env.local

if [[ -z "$bindings" ]]; then
  echo "No bindings found in .env.local."
else
  bindings=$(echo $bindings | sed 's/[[:space:]]*$//')
  echo "Final bindings: $bindings"
fi

echo $bindings
