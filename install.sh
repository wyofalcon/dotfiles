#!/bin/bash
# Dotfiles installer for dev containers
# Installs Gemini CLI with OAuth (Gemini Ultra subscription) + dev tools

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

# Create session selector script
mkdir -p ~/bin
cat > ~/bin/gemini-session-select << 'SELECTOR'
#!/bin/bash
# Session Selector - Choose workflow mode

if ! command -v whiptail &> /dev/null; then
    echo "⚠️  whiptail not installed. Run: sudo apt-get install whiptail"
    return 2>/dev/null || exit
fi

CURRENT_DIR=$(pwd)

CHOICE=$(whiptail --title "🚀 Gemini CLI: Session Start" \
--menu "Working in: $CURRENT_DIR\nSelect workflow:" 16 78 4 \
"1" "Builder + 2 Auditors  (🛡️ Strict: Blocking Audits)" \
"2" "Rapid Prototyping     (⚡ Fast: No Blocking)" \
"3" "Maintenance           (🛠️  Manual: No AI enforcement)" \
3>&1 1>&2 2>&3)

EXIT_STATUS=$?

if [ $EXIT_STATUS -eq 0 ]; then
    case $CHOICE in
        1)
            export SKIP_AUDITOR=false
            echo "🛡️  [Mode] Builder + 2 Auditors (Active)"
            ;;
        2)
            export SKIP_AUDITOR=true
            echo "⚡ [Mode] Rapid Prototyping (Auditor Skipped)"
            ;;
        3)
            export SKIP_AUDITOR=true
            echo "🛠️  [Mode] Maintenance"
            ;;
    esac
else
    export SKIP_AUDITOR=false
    echo "🛡️  [Mode] Builder + 2 Auditors (Defaulted)"
fi
SELECTOR
chmod +x ~/bin/gemini-session-select

# Add ~/bin to PATH if not already there
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi

# Add alias for sourcing session selector
if ! grep -q 'alias gss=' ~/.bashrc 2>/dev/null; then
    echo 'alias gss="source ~/bin/gemini-session-select"' >> ~/.bashrc
fi

echo "✅ Dotfiles setup complete!"
echo "   • Gemini CLI configured (OAuth mode for Ultra subscription)"
echo "   • Session selector: run 'gss' or 'source ~/bin/gemini-session-select'"
