#!/bin/bash

# =============================================================================
# setup.sh — System Level Bootstrap
# Arjun Jalan | Linux Mint 22.3 Zena
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

confirm() {
    echo -e "\n${YELLOW}$1${NC}"
    read -p "Proceed? (y/n): " choice
    [[ "$choice" == "y" ]]
}

already_installed() {
    echo -e "${BLUE}Already installed, skipping.${NC}"
}

echo ""
echo "============================================="
echo " System Level Bootstrap"
echo "============================================="
echo " This script will install:"
echo " - uv (Python package and env manager)"
echo " - VS Code"
echo " - Node.js + npm"
echo " - GitHub CLI"
echo " - Obsidian"
echo " - Gedit (text editor)"
echo "============================================="

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------
echo -e "\n${YELLOW}Running pre-flight checks...${NC}"

MISSING_DIRS=()
for dir in ~/dotfiles/machine-setup ~/projects; do
    if [ ! -d "$dir" ]; then
        MISSING_DIRS+=("$dir")
    fi
done

if [ ${#MISSING_DIRS[@]} -gt 0 ]; then
    echo -e "${RED}The following expected directories are missing:${NC}"
    for d in "${MISSING_DIRS[@]}"; do
        echo "  - $d"
    done
    echo -e "${RED}Please create them manually before running this script.${NC}"
    echo "Example: mkdir -p ~/dotfiles/machine-setup ~/projects"
    exit 1
else
    echo -e "${GREEN}All expected directories found.${NC}"
fi

read -p "Start? (y/n): " start
[[ "$start" != "y" ]] && echo "Aborted." && exit 0

# -----------------------------------------------------------------------------
# Step 1 — uv
# -----------------------------------------------------------------------------
if confirm "Step 1/6 — Install uv (Python package and env manager)"; then
    if command -v uv &> /dev/null; then
        already_installed
        uv --version
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source $HOME/.local/bin/env
        echo -e "${GREEN}uv installed: $(uv --version)${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Step 2 — VS Code
# -----------------------------------------------------------------------------
if confirm "Step 2/6 — Install VS Code"; then
    if command -v code &> /dev/null; then
        already_installed
        code --version
    else
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
        sudo install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update
        sudo apt install code -y
        echo -e "${GREEN}VS Code installed.${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Step 3 — Node.js + npm
# -----------------------------------------------------------------------------
if confirm "Step 3/6 — Install Node.js and npm"; then
    if command -v node &> /dev/null; then
        already_installed
        echo "Node.js: $(node --version)"
        echo "npm: $(npm --version)"
    else
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install nodejs -y
        echo -e "${GREEN}Node.js installed: $(node --version)${NC}"
        echo -e "${GREEN}npm installed: $(npm --version)${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Step 4 — GitHub CLI
# -----------------------------------------------------------------------------
if confirm "Step 4/6 — Install GitHub CLI"; then
    if command -v gh &> /dev/null; then
        already_installed
        gh --version
    else
        sudo apt install gh -y
        echo -e "${GREEN}GitHub CLI installed: $(gh --version)${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Step 5 — Obsidian
# -----------------------------------------------------------------------------
if confirm "Step 5/6 — Install Obsidian"; then
    if command -v obsidian &> /dev/null || dpkg -l obsidian &> /dev/null; then
        already_installed
    else
        OBSIDIAN_DEB_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
            | grep "browser_download_url.*amd64.deb" \
            | cut -d '"' -f 4)
        echo "Downloading Obsidian from: $OBSIDIAN_DEB_URL"
        wget -O /tmp/obsidian.deb "$OBSIDIAN_DEB_URL"
        sudo dpkg -i /tmp/obsidian.deb
        sudo apt install -f -y
        rm /tmp/obsidian.deb
        echo -e "${GREEN}Obsidian installed.${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Step 6 — Gedit
# -----------------------------------------------------------------------------
if confirm "Step 6/6 — Install Gedit (text editor)"; then
    if command -v gedit &> /dev/null; then
        already_installed
        gedit --version
    else
        sudo apt install gedit -y
        echo -e "${GREEN}Gedit installed.${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo -e "${GREEN} Bootstrap complete.${NC}"
echo " Run git_config.sh next to configure Git"
echo " and authenticate with GitHub."
echo "============================================="
