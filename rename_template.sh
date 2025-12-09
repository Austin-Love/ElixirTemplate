#!/usr/bin/env bash



# Script to rename a project template from "ElixirTemplate" to a new application name.
# Usage: ./rename_template.sh MyLongAppName

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: ./rename_template.sh MyLongAppName"
  exit 1
fi

NEW_NAME="$1"

# Convert PascalCase to snake_case
SNAKE_NAME="$(echo "$NEW_NAME" \
  | sed -E 's/([A-Z]+)([A-Z][a-z])/\1_\2/g' \
  | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' \
  | tr '[:upper:]' '[:lower:]')"

OLD_PASCAL="ElixirTemplate"
OLD_SNAKE="elixir_template"

echo "Renaming:"
echo "  $OLD_PASCAL -> $NEW_NAME"
echo "  $OLD_SNAKE  -> $SNAKE_NAME"
echo

# ---------- 1. RENAME FILE CONTENTS ----------
echo "Updating file contents..."

grep -rl "$OLD_PASCAL\|$OLD_SNAKE" . \
  --exclude-dir=.git \
  --exclude-dir=_build \
  --exclude-dir=deps \
  --exclude-dir=node_modules \
  --binary-files=without-match \
| xargs sed -i.bak \
  -e "s/$OLD_PASCAL/$NEW_NAME/g" \
  -e "s/$OLD_SNAKE/$SNAKE_NAME/g"

find . -name "*.bak" -delete

# ---------- 2. RENAME FILES ----------
echo "Renaming files..."

find . -depth \
  -name "*$OLD_PASCAL*" \
  -o -name "*$OLD_SNAKE*" \
| while read -r path; do
  new_path="$path"
  new_path="${new_path//$OLD_PASCAL/$NEW_NAME}"
  new_path="${new_path//$OLD_SNAKE/$SNAKE_NAME}"

  if [ "$path" != "$new_path" ]; then
    mv "$path" "$new_path"
  fi
done

# ---------- 3. RENAME DIRECTORIES ----------
echo "Renaming directories..."

find . -depth -type d \
  \( -name "*$OLD_PASCAL*" -o -name "*$OLD_SNAKE*" \) \
| while read -r dir; do
  new_dir="$dir"
  new_dir="${new_dir//$OLD_PASCAL/$NEW_NAME}"
  new_dir="${new_dir//$OLD_SNAKE/$SNAKE_NAME}"

  if [ "$dir" != "$new_dir" ]; then
    mv "$dir" "$new_dir"
  fi
done

echo
echo "✅ Rename complete."
echo "App Name: $NEW_NAME"
echo "App Snake: $SNAKE_NAME"
