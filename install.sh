#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking dotfiles from $DOTFILES_DIR/home..."

symlink() {
    local src="$DOTFILES_DIR/home/$1"
    local dest="$HOME/$1"

    if [ -L "$dest" ]; then
        echo "  already symlinked: $dest"
    elif [ -f "$dest" ]; then
        echo "  backing up existing $dest → $dest.bak"
        mv "$dest" "$dest.bak"
        ln -s "$src" "$dest"
        echo "  linked: $dest"
    else
        ln -s "$src" "$dest"
        echo "  linked: $dest"
    fi
}

symlink .bashrc

echo ""
echo "Done. Open a new terminal (or run: source ~/.bashrc) to apply changes."
