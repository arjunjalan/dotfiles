#!/bin/bash

# =============================================================================
# git_config.sh — Git Identity and GitHub Authentication
# Arjun Jalan | Linux Mint 22.3 Zena
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

confirm() {
    echo -e "\n${YELLOW}$1${NC}"
    read -p "Proceed? (y/n): " choice
    [[ "$choice" == "y" ]]
}

echo ""
echo "============================================="
echo " Git Configuration"
echo "============================================="
echo " This script will configure:"
echo " - Git identity (name and email)"
echo " - GitHub authentication"
echo "============================================="
read -p "Start? (y/n): " start
[[ "$start" != "y" ]] && echo "Aborted." && exit 0

# -----------------------------------------------------------------------------
# Step 1 — Git identity
# -----------------------------------------------------------------------------
if confirm "Step 1/2 — Configure Git identity"; then
    CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

    if [ -n "$CURRENT_NAME" ] && [ -n "$CURRENT_EMAIL" ]; then
        echo -e "${BLUE}Git already configured:${NC}"
        echo "  Name:  $CURRENT_NAME"
        echo "  Email: $CURRENT_EMAIL"
        read -p "Overwrite? (y/n): " overwrite
        [[ "$overwrite" != "y" ]] && echo "Skipping." || {
            read -p "Enter your Git name: " git_name
            read -p "Enter your Git email: " git_email
            git config --global user.name "$git_name"
            git config --global user.email "$git_email"
            echo -e "${GREEN}Git identity updated.${NC}"
        }
    else
        read -p "Enter your Git name (e.g. Arjun Jalan): " git_name
        read -p "Enter your Git email (GitHub email): " git_email
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        echo -e "${GREEN}Git identity configured.${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Step 2 — GitHub authentication
# -----------------------------------------------------------------------------
if confirm "Step 2/2 — Authenticate with GitHub"; then
    if gh auth status &> /dev/null; then
        echo -e "${BLUE}Already authenticated with GitHub:${NC}"
        gh auth status
        read -p "Re-authenticate? (y/n): " reauth
        [[ "$reauth" == "y" ]] && gh auth login
    else
        gh auth login
        echo -e "${GREEN}GitHub authenticated.${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo -e "${GREEN} Git configuration complete.${NC}"
echo " Next steps:"
echo " 1. Open VS Code: code"
echo " 2. Install VS Code extensions manually"
echo " 3. Launch Obsidian: ~/Obsidian.AppImage"
echo "============================================="
