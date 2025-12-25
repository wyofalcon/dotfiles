#!/bin/bash
# Dotfiles installer for dev containers
# Installs Gemini CLI with OAuth (Gemini Ultra subscription)

echo "🔧 Setting up dev container dotfiles..."

# Install Gemini CLI if not present
if ! command -v gemini &> /dev/null; then
    echo "📦 Installing Gemini CLI..."
    npm install -g @google/gemini-cli 2>/dev/null || true
fi

# Install whiptail for terminal GUIs
if ! command -v whiptail &> /dev/null; then
    echo "📦 Installing whiptail..."
    sudo apt-get update -qq && sudo apt-get install -y -qq whiptail > /dev/null 2>&1 || true
fi

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
