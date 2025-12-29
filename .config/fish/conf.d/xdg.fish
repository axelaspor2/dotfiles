# ═══════════════════════════════════════════════════════════════
# XDG Base Directory Specification
# ═══════════════════════════════════════════════════════════════

# 基本ディレクトリ
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# ディレクトリ作成
mkdir -p $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME

# ─────────────────────────────────────────────────────────────────
# 履歴ファイル
# ─────────────────────────────────────────────────────────────────
set -gx LESSHISTFILE "$XDG_STATE_HOME/less/history"
set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python/history"
mkdir -p (dirname $LESSHISTFILE)
mkdir -p (dirname $PYTHON_HISTORY)

# ─────────────────────────────────────────────────────────────────
# Rust (cargo, rustup)
# ─────────────────────────────────────────────────────────────────
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"

# ─────────────────────────────────────────────────────────────────
# Node.js / npm / Bun
# ─────────────────────────────────────────────────────────────────
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NODE_REPL_HISTORY "$XDG_STATE_HOME/node/repl_history"
set -gx BUN_INSTALL "$XDG_DATA_HOME/bun"
mkdir -p (dirname $NODE_REPL_HISTORY)

# ─────────────────────────────────────────────────────────────────
# Docker
# ─────────────────────────────────────────────────────────────────
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

# ─────────────────────────────────────────────────────────────────
# GnuPG
# ─────────────────────────────────────────────────────────────────
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"

# ─────────────────────────────────────────────────────────────────
# Go
# ─────────────────────────────────────────────────────────────────
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOMODCACHE "$XDG_CACHE_HOME/go/mod"

# ─────────────────────────────────────────────────────────────────
# PATH 追加
# ─────────────────────────────────────────────────────────────────
fish_add_path $CARGO_HOME/bin
fish_add_path $BUN_INSTALL/bin
fish_add_path $GOPATH/bin
