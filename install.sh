#!/bin/bash
# dotfiles install script
# Creates symbolic links from dotfiles to home directory
# Idempotent: safe to run multiple times

set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Idempotent symlink creation
symlink() {
    local src="$1"
    local dst="$2"

    # Remove existing symlink
    [[ -L "$dst" ]] && rm -f "$dst"

    # Backup existing file/directory
    if [[ -e "$dst" ]]; then
        local backup="$dst.backup.$(date +%s)"
        log_warn "Backing up $dst -> $backup"
        mv "$dst" "$backup"
    fi

    # Create parent directory
    mkdir -p "$(dirname "$dst")"

    # Create symlink
    ln -sf "$src" "$dst"
    log_info "Linked: $dst -> $src"
}

echo "======================================"
echo "  dotfiles installer"
echo "======================================"
echo ""

# Home directory dotfiles
log_info "Installing home directory dotfiles..."
symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/.claude" "$HOME/.claude"

# XDG Config directory
log_info "Installing .config directory dotfiles..."
symlink "$DOTFILES_DIR/.config/fish" "$HOME/.config/fish"
symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
symlink "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"
symlink "$DOTFILES_DIR/.config/zellij" "$HOME/.config/zellij"
symlink "$DOTFILES_DIR/.config/mise" "$HOME/.config/mise"

# GPG
log_info "Installing GPG settings..."
symlink "$DOTFILES_DIR/.gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

# Homebrew packages
if [[ -f "$DOTFILES_DIR/Brewfile" ]] && command -v brew &>/dev/null; then
    log_info "Installing Homebrew packages..."
    brew bundle --file="$DOTFILES_DIR/Brewfile" || true
fi

# Fisher plugins
if command -v fish &>/dev/null; then
    log_info "Installing Fisher plugins..."
    fish -c "fisher update" 2>/dev/null || true
fi

echo ""
log_info "Installation complete!"
