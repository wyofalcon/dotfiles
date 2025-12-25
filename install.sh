#!/bin/bash
# Personal dotfiles - Gemini CLI OAuth setup only
# (Shared tools are in the project's devcontainer)

echo "🔧 Setting up personal dotfiles..."

# Configure Gemini CLI for OAuth (uses Gemini Ultra subscription)
mkdir -p ~/.gemini
cat > ~/.gemini/settings.json << 'SETTINGS'
{
  "ide": {
    "hasSeenNudge": true,
    "enabled": true
  },
  "security": {
    "auth": {
      "selectedType": "oauth"
    }
  },
  "general": {
    "previewFeatures": true
  }
}
SETTINGS

echo "✅ Gemini CLI configured (OAuth mode for Ultra subscription)"
