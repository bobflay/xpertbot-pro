#!/bin/bash
# setup/claude-setup.sh

echo "Setting up Claude integration..."

# Create Claude configuration if it doesn't exist
if [ ! -f .claude/settings.local.json ]; then
    mkdir -p .claude
    cat > .claude/settings.local.json << EOL
{
  "permissions": {
    "allow": [
      "Bash(find:*)",
      "Bash(mkdir:*)",
      "Bash(chmod:*)",
      "Bash(composer:*)",
      "Bash(php:*)",
      "Bash(flutter:*)",
      "Bash(npm:*)"
    ],
    "deny": []
  }
}
EOL
fi

echo "Claude integration setup complete!"