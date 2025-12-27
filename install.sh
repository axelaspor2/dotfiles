#!/bin/bash

# dotfiles install script
# Creates symbolic links from dotfiles to home directory

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create symlink with backup
create_symlink() {
    local src="$1"
    local dest="$2"

    # If destination exists and is not a symlink, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        log_warn "Backing up $dest to $BACKUP_DIR/"
        mv "$dest" "$BACKUP_DIR/"
    fi

    # Remove existing symlink if it exists
    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    ln -s "$src" "$dest"
    log_info "Linked $dest -> $src"
}

echo "======================================"
echo "  dotfiles installer"
echo "======================================"
echo ""

# Home directory dotfiles
log_info "Installing home directory dotfiles..."
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# .config directory
log_info "Installing .config directory dotfiles..."
create_symlink "$DOTFILES_DIR/config/fish" "$HOME/.config/fish"
create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/config/zellij" "$HOME/.config/zellij"
create_symlink "$DOTFILES_DIR/config/mise" "$HOME/.config/mise"

echo ""
log_info "Installation complete!"

if [ -d "$BACKUP_DIR" ]; then
    log_warn "Backup files are stored in: $BACKUP_DIR"
fi
