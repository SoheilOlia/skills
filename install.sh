#!/bin/bash
# Install a skill from this repo
# Usage: curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s <skill-path>
# Example: curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s block2.0/jack-officehour

set -e

SKILL_PATH="${1:?Usage: install.sh <skill-path> (e.g. block2.0/jack-officehour)}"
TMP_DIR=$(mktemp -d)

git clone --depth 1 https://github.com/SoheilOlia/skills.git "$TMP_DIR" 2>/dev/null
amp skill add "$TMP_DIR/$SKILL_PATH" --global
rm -rf "$TMP_DIR"

echo "✅ Installed $SKILL_PATH"
