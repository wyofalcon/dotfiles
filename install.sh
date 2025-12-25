#!/bin/bash
# Personal dotfiles - Auth configs for Gemini CLI & GitHub CLI
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
echo "   ✓ Gemini CLI configured (OAuth mode)"

# Configure GitHub CLI
mkdir -p ~/.config/gh
if [ ! -f ~/.config/gh/hosts.yml ]; then
    echo "📝 GitHub CLI not authenticated - will prompt on first use"
    echo "   Run 'gh auth login' to authenticate"
else
    echo "   ✓ GitHub CLI already configured"
fi

# Set git identity from GitHub if not set
if [ -z "$(git config --global user.email)" ]; then
    if command -v gh &> /dev/null && gh auth status &>/dev/null; then
        GH_USER=$(gh api user --jq '.login' 2>/dev/null)
        if [ -n "$GH_USER" ]; then
            git config --global user.name "$GH_USER"
            git config --global user.email "${GH_USER}@users.noreply.github.com"
            echo "   ✓ Git identity set from GitHub: $GH_USER"
        fi
    fi
fi

echo "✅ Personal dotfiles configured"
