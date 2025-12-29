# アプリケーション別 XDG 設定ガイド

各アプリケーションの XDG Base Directory 対応方法。

## 目次

1. [シェル](#シェル)
2. [エディタ](#エディタ)
3. [バージョン管理](#バージョン管理)
4. [ターミナルマルチプレクサ](#ターミナルマルチプレクサ)
5. [プログラミング言語/ツール](#プログラミング言語ツール)
6. [その他のツール](#その他のツール)

---

## シェル

### Zsh

**ネイティブ対応**: 部分的（環境変数で設定可能）

```bash
# .zshenv に追加（最初に読み込まれるため）
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
```

**ディレクトリ構成**:
```
~/.config/zsh/
├── .zshrc
├── .zshenv      # ZDOTDIR 設定後は不要
├── .zprofile
├── .zlogin
└── .zlogout
```

**履歴ファイル**（.zshrc に追加）:
```bash
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
```

### Bash

**ネイティブ対応**: なし（シンボリックリンクまたは環境変数で対応）

```bash
# .bash_profile に追加
export BASH_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/bash"
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
mkdir -p "$(dirname "$HISTFILE")"

# bashrc を読み込む
if [[ -f "$BASH_CONFIG_HOME/bashrc" ]]; then
    source "$BASH_CONFIG_HOME/bashrc"
fi
```

**注意**: `.bash_profile` と `.bashrc` 自体は `$HOME` に残す必要あり。

### Fish

**ネイティブ対応**: 完全対応

```
~/.config/fish/
├── config.fish
├── functions/
└── completions/
```

---

## エディタ

### Neovim

**ネイティブ対応**: 完全対応

```
~/.config/nvim/
├── init.lua (または init.vim)
├── lua/
└── plugin/

~/.local/share/nvim/     # プラグイン、undo ファイル等
~/.local/state/nvim/     # shada、ログ等
~/.cache/nvim/           # キャッシュ
```

### Vim

**ネイティブ対応**: Vim 8.1+ で部分対応

```bash
# .vimrc の代わりに以下を使用
export VIMINIT='source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc'
```

**vimrc に追加**:
```vim
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p')

set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p')
set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p')
set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir, 'p')
set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir, 'p')

if !has('nvim') | set viminfofile=$XDG_STATE_HOME/vim/viminfo | endif
```

### Emacs

**ネイティブ対応**: Emacs 27+ で対応

```bash
# 環境変数（任意）
export EMACS_USER_DIRECTORY="${XDG_CONFIG_HOME:-$HOME/.config}/emacs"
```

```
~/.config/emacs/
├── init.el
├── early-init.el
└── lisp/
```

---

## バージョン管理

### Git

**ネイティブ対応**: 完全対応

```bash
# 環境変数（明示的に設定する場合）
export GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME:-$HOME/.config}/git/config"
```

```
~/.config/git/
├── config
├── ignore      # グローバル .gitignore
└── attributes  # グローバル .gitattributes
```

### GitHub CLI (gh)

**ネイティブ対応**: 完全対応

```
~/.config/gh/
├── config.yml
└── hosts.yml
```

---

## ターミナルマルチプレクサ

### tmux

**ネイティブ対応**: tmux 3.1+ で対応

```
~/.config/tmux/
└── tmux.conf
```

**古いバージョン向け**:
```bash
alias tmux='tmux -f "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"'
```

### screen

**ネイティブ対応**: なし

```bash
export SCREENRC="${XDG_CONFIG_HOME:-$HOME/.config}/screen/screenrc"
```

---

## プログラミング言語/ツール

### Node.js / npm

```bash
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/npm"
export NODE_REPL_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/node/repl_history"
```

### Python

```bash
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/pythonrc"
export PYTHON_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/python/history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME:-$HOME/.cache}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME:-$HOME/.local/share}/python"

# pip
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/pip/pip.log"

# mypy
export MYPY_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mypy"
```

### Go

```bash
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOMODCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go/mod"
```

### Rust / Cargo

```bash
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
```

### Ruby

```bash
export GEM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/gem"
export BUNDLE_USER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/bundle"
export BUNDLE_USER_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/bundle"
export BUNDLE_USER_PLUGIN="${XDG_DATA_HOME:-$HOME/.local/share}/bundle"

# irb
export IRBRC="${XDG_CONFIG_HOME:-$HOME/.config}/irb/irbrc"
```

---

## その他のツール

### Docker

```bash
export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/docker"
```

### wget

```bash
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
alias wget='wget --hsts-file="${XDG_DATA_HOME:-$HOME/.local/share}/wget/hsts"'
```

### less

```bash
export LESSHISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/less/history"
export LESSKEY="${XDG_CONFIG_HOME:-$HOME/.config}/less/lesskey"
```

### GnuPG

```bash
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
```

### SSH

**注意**: SSH は XDG に対応していないため、シンボリックリンクを使用

```bash
# ~/.ssh を維持するか、以下のようにエイリアス設定
alias ssh='ssh -F "${XDG_CONFIG_HOME:-$HOME/.config}/ssh/config"'
```

### AWS CLI

```bash
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/aws/credentials"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/aws/config"
```

### ripgrep

```bash
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/config"
```

### starship

**ネイティブ対応**: 完全対応

```
~/.config/starship.toml
```

---

## XDG 対応状況の凡例

| 対応状況 | 説明 |
|---------|------|
| 完全対応 | 環境変数なしで XDG に準拠 |
| 部分対応 | 環境変数の設定で対応可能 |
| 非対応 | シンボリックリンクやエイリアスが必要 |
