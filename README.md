# dotfiles

My personal dotfiles for macOS.

## Contents

- **Shell**: Zsh, Fish
- **Editor**: Neovim
- **Terminal**: Ghostty
- **Multiplexer**: Zellij
- **Runtime Manager**: mise
- **Packages**: Homebrew (Brewfile)

## Installation

```bash
# Clone the repository
git clone https://github.com/axelaspor2/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install dotfiles (creates symlinks)
./install.sh
```

## Uninstallation

```bash
./uninstall.sh
```

## Directory Structure

```
~/dotfiles/
├── .zshrc              # Zsh configuration
├── .gitconfig          # Git configuration
├── .config/
│   ├── fish/           # Fish shell
│   ├── nvim/           # Neovim
│   ├── ghostty/        # Ghostty terminal
│   ├── zellij/         # Zellij multiplexer
│   └── mise/           # mise runtime manager
├── .gnupg/
│   └── gpg-agent.conf  # GPG agent settings
├── Brewfile            # Homebrew packages
├── install.sh          # Installation script
└── uninstall.sh        # Uninstallation script
```

## After Installation

1. Install Homebrew packages:
   ```bash
   brew bundle --file=~/dotfiles/Brewfile
   ```

2. Install Fish plugins (fisher):
   ```bash
   fish -c "fisher update"
   ```

3. Restart GPG agent:
   ```bash
   gpgconf --kill gpg-agent
   ```
