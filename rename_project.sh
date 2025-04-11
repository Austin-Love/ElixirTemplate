#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a project name as an argument."
    echo "Usage: $0 YourProjectName"
    exit 1
fi

# Get the user input
USER_INPUT="$1"

# Convert to PascalCase (for module names)
to_pascal_case() {
    # Split by non-alphanumeric characters, capitalize first letter of each word, remove spaces
    echo "$1" | sed -r 's/(^|[^a-zA-Z0-9])([a-zA-Z0-9])/\1\u\2/g' | sed 's/[^a-zA-Z0-9]//g'
}

# Convert to snake_case (for file names and configs)
to_snake_case() {
    # Convert to lowercase, replace non-alphanumeric with underscore
    echo "$1" | sed 's/\([A-Z]\)/_\1/g' | sed 's/^_//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g' | sed 's/__*/_/g'
}

# Generate the PascalCase and snake_case versions
PASCAL_CASE=$(to_pascal_case "$USER_INPUT")
SNAKE_CASE=$(to_snake_case "$USER_INPUT")

echo "Converting 'ElixirTemplate' to '$PASCAL_CASE'"
echo "Converting 'elixir_template' to '$SNAKE_CASE'"

# Check if the directories exist before attempting to rename
if [ ! -d "/app/lib/elixir_template" ] || [ ! -d "/app/lib/elixir_template_web" ]; then
    echo "Error: Required directories not found. Make sure you're running this script from the project root."
    exit 1
fi

# 1. Replace all instances of ElixirTemplate with pascal cased version
find /app -type f -not -path "*/\.*" -not -path "*/deps/*" -not -path "*/node_modules/*" -not -path "*/_build/*" -exec grep -l "ElixirTemplate" {} \; | xargs -I{} sed -i "s/ElixirTemplate/$PASCAL_CASE/g" {}

# 2. Replace all instances of elixir_template with snake cased version
find /app -type f -not -path "*/\.*" -not -path "*/deps/*" -not -path "*/node_modules/*" -not -path "*/_build/*" -exec grep -l "elixir_template" {} \; | xargs -I{} sed -i "s/elixir_template/$SNAKE_CASE/g" {}

# 3. Rename the elixir_template_web folder and elixir_template_web.ex file
if [ -d "/app/lib/elixir_template_web" ]; then
    mv "/app/lib/elixir_template_web" "/app/lib/${SNAKE_CASE}_web"
    echo "Renamed directory: /app/lib/elixir_template_web -> /app/lib/${SNAKE_CASE}_web"
fi

if [ -f "/app/lib/elixir_template_web.ex" ]; then
    mv "/app/lib/elixir_template_web.ex" "/app/lib/${SNAKE_CASE}_web.ex"
    echo "Renamed file: /app/lib/elixir_template_web.ex -> /app/lib/${SNAKE_CASE}_web.ex"
fi

# 4. Rename the elixir_template folder and elixir_template.ex file
if [ -d "/app/lib/elixir_template" ]; then
    mv "/app/lib/elixir_template" "/app/lib/${SNAKE_CASE}"
    echo "Renamed directory: /app/lib/elixir_template -> /app/lib/${SNAKE_CASE}"
fi

if [ -f "/app/lib/elixir_template.ex" ]; then
    mv "/app/lib/elixir_template.ex" "/app/lib/${SNAKE_CASE}.ex"
    echo "Renamed file: /app/lib/elixir_template.ex -> /app/lib/${SNAKE_CASE}.ex"
fi

# Also handle test directory if it exists
if [ -d "/app/test/elixir_template" ]; then
    mv "/app/test/elixir_template" "/app/test/${SNAKE_CASE}"
    echo "Renamed directory: /app/test/elixir_template -> /app/test/${SNAKE_CASE}"
fi

if [ -d "/app/test/elixir_template_web" ]; then
    mv "/app/test/elixir_template_web" "/app/test/${SNAKE_CASE}_web"
    echo "Renamed directory: /app/test/elixir_template_web -> /app/test/${SNAKE_CASE}_web"
fi

echo "Project successfully renamed from ElixirTemplate to $PASCAL_CASE!"
echo "You may need to restart your Phoenix server for changes to take effect."
