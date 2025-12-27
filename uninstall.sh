#!/bin/bash
# dotfiles uninstall script
# Removes symbolic links created by install.sh

set -eu

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Remove symlink if it points to dotfiles
remove_symlink() {
    local path="$1"

    if [[ -L "$path" ]]; then
        rm -f "$path"
        log_info "Removed: $path"
    elif [[ -e "$path" ]]; then
        log_error "Not a symlink, skipping: $path"
    fi
}

echo "======================================"
echo "  dotfiles uninstaller"
echo "======================================"
echo ""

# Home directory dotfiles
log_info "Removing home directory dotfiles..."
remove_symlink "$HOME/.zshrc"
remove_symlink "$HOME/.gitconfig"

# XDG Config directory
log_info "Removing .config directory dotfiles..."
remove_symlink "$HOME/.config/fish"
remove_symlink "$HOME/.config/nvim"
remove_symlink "$HOME/.config/ghostty"
remove_symlink "$HOME/.config/zellij"
remove_symlink "$HOME/.config/mise"

# GPG
log_info "Removing GPG settings..."
remove_symlink "$HOME/.gnupg/gpg-agent.conf"

echo ""
log_info "Uninstall complete!"
echo ""
echo "Note: Backup files (*.backup.*) were not removed."
echo "You may want to restore them manually if needed."
