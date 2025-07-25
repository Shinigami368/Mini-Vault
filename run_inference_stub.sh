#!/bin/bash

INPUT_FILE="input.json"
OUTPUT_FILE="output.json"
LOG_FILE="inference.log"
JSON_LOG="inference.jsonl"

# 1. Check if input.json exists
if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: $INPUT_FILE not found."
  exit 1
fi

# 2. Prevent Docker from turning missing files into directories
for f in "$OUTPUT_FILE" "$LOG_FILE" "$JSON_LOG"; do
  if [ -d "$f" ]; then
    echo "Error: $f is a directory. Please remove or rename it."
    exit 1
  fi
  if [ ! -f "$f" ]; then
    touch "$f"
  fi
done

# 3. Build the Docker image
docker build -t inference-stub .

# 4. Run the container with all necessary mounts (input, output, logs)
docker run --rm \
  -v "$(pwd)/$INPUT_FILE:/app/input.json" \
  -v "$(pwd)/$OUTPUT_FILE:/app/output.json" \
  -v "$(pwd)/$LOG_FILE:/app/inference.log" \
  -v "$(pwd)/$JSON_LOG:/app/inference.jsonl" \
  inference-stub
