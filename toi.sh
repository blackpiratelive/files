#!/bin/bash

# Define the recipe file and the output file name
RECIPE_FILE="TOI Print Edition.recipe"
OUTPUT_PROFILE="kindle"
OUTPUT_FILE="Times Of India $(date '+%B %d, %Y').mobi"

# Create a temporary file to capture the output
TEMP_OUTPUT=$(mktemp)

# Run the ebook-convert command and tee the output to both console and the temp file
ebook-convert "$RECIPE_FILE" "$OUTPUT_FILE" --output-profile "$OUTPUT_PROFILE" 2>&1 | tee "$TEMP_OUTPUT"

# Check if the ebook-convert command was successful
if [ ${PIPESTATUS[0]} -ne 0 ]; then
  echo "Error: ebook-convert command failed."
  cat "$TEMP_OUTPUT"
  rm -f "$TEMP_OUTPUT"
  exit 1
fi

# Extract the output file path from the command output
OUTPUT_PATH=$(grep -oP 'Output saved to\s+\K.*' "$TEMP_OUTPUT")

# Check if the output path was found
if [ -z "$OUTPUT_PATH" ]; then
  echo "Error: Could not find the output file path in the command output."
  rm -f "$TEMP_OUTPUT"
  exit 1
fi

# Define the target directory
TARGET_DIR="/root/files/news/toi"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory $TARGET_DIR does not exist."
  rm -f "$TEMP_OUTPUT"
  exit 1
fi

# Move the output file to the target directory
mv "$OUTPUT_PATH" "$TARGET_DIR"

# Check if the move was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to move the file to $TARGET_DIR."
  rm -f "$TEMP_OUTPUT"
  exit 1
fi

# Clean up temporary file
rm -f "$TEMP_OUTPUT"

echo "File successfully moved to $TARGET_DIR"

