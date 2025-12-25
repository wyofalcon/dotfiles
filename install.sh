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
    # Check for GH_TOKEN secret (from Codespaces/Dev Container secrets)
    if [ -n "$GH_TOKEN" ]; then
        echo "🔐 Authenticating GitHub CLI from secret..."
        echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null
        if gh auth status &>/dev/null; then
            echo "   ✓ GitHub CLI authenticated from GH_TOKEN secret"
        else
            echo "   ⚠️  GH_TOKEN auth failed - run 'gh auth login' manually"
        fi
    else
        echo "📝 GitHub CLI not authenticated"
        echo "   Run 'gh auth login' or set GH_TOKEN secret"
    fi
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
