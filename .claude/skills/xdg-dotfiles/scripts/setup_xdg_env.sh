#!/usr/bin/env bash
#
# setup_xdg_env.sh - XDG Base Directory の環境変数を設定
#
# 使用方法:
#   setup_xdg_env.sh              # zsh 用の設定を出力
#   setup_xdg_env.sh --shell bash # bash 用の設定を出力
#   setup_xdg_env.sh --apply      # 自動的にシェル設定ファイルに追加
#
# このスクリプトは設定内容を標準出力に出力します。
# 適用するには、出力をシェルの設定ファイルにコピーしてください。
#

set -euo pipefail

# カラー出力
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

SHELL_TYPE="zsh"
APPLY=false

# ヘルプ表示
show_help() {
    cat << EOF
使用方法: $(basename "$0") [オプション]

XDG Base Directory の環境変数設定を生成します。

オプション:
    --shell <type>  シェルタイプ (zsh, bash, fish) デフォルト: zsh
    --apply         自動的にシェル設定ファイルに追加
    --full          すべてのアプリケーション設定を含む完全版を出力
    -h, --help      このヘルプを表示

例:
    $(basename "$0")                      # zsh 用の基本設定を出力
    $(basename "$0") --shell bash         # bash 用の設定を出力
    $(basename "$0") --full               # 完全版を出力
    $(basename "$0") --apply              # 設定ファイルに追加

EOF
}

FULL_MODE=false

# 引数解析
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --shell)
                SHELL_TYPE="$2"
                shift 2
                ;;
            --apply)
                APPLY=true
                shift
                ;;
            --full)
                FULL_MODE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "不明なオプション: $1"
                exit 1
                ;;
        esac
    done
}

# 基本設定を生成
generate_basic_config() {
    cat << 'EOF'
# ═══════════════════════════════════════════════════════════════
# XDG Base Directory Specification
# ═══════════════════════════════════════════════════════════════

# 基本ディレクトリ
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ディレクトリ作成
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"
EOF
}

# zsh 用設定を生成
generate_zsh_config() {
    generate_basic_config

    cat << 'EOF'

# ─────────────────────────────────────────────────────────────────
# Zsh
# ─────────────────────────────────────────────────────────────────
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
EOF

    if [[ "$FULL_MODE" == true ]]; then
        generate_app_configs
    fi
}

# bash 用設定を生成
generate_bash_config() {
    generate_basic_config

    cat << 'EOF'

# ─────────────────────────────────────────────────────────────────
# Bash
# ─────────────────────────────────────────────────────────────────
export HISTFILE="${XDG_STATE_HOME}/bash/history"
mkdir -p "$(dirname "$HISTFILE")"

# bash 設定ファイルの読み込み
if [[ -f "${XDG_CONFIG_HOME}/bash/bashrc" ]]; then
    source "${XDG_CONFIG_HOME}/bash/bashrc"
fi
EOF

    if [[ "$FULL_MODE" == true ]]; then
        generate_app_configs
    fi
}

# fish 用設定を生成
generate_fish_config() {
    cat << 'EOF'
# ═══════════════════════════════════════════════════════════════
# XDG Base Directory Specification
# fish は標準で XDG に対応しています
# ═══════════════════════════════════════════════════════════════

# 基本ディレクトリ（fish のデフォルト）
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# ディレクトリ作成
mkdir -p $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_STATE_HOME
EOF

    if [[ "$FULL_MODE" == true ]]; then
        echo ""
        echo "# 注意: fish 用のアプリケーション設定は set -gx を使用してください"
    fi
}

# アプリケーション設定を生成
generate_app_configs() {
    cat << 'EOF'

# ─────────────────────────────────────────────────────────────────
# Vim
# ─────────────────────────────────────────────────────────────────
export VIMINIT='source ${XDG_CONFIG_HOME}/vim/vimrc'

# ─────────────────────────────────────────────────────────────────
# Node.js / npm
# ─────────────────────────────────────────────────────────────────
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history"
mkdir -p "$(dirname "$NODE_REPL_HISTORY")"

# ─────────────────────────────────────────────────────────────────
# Python
# ─────────────────────────────────────────────────────────────────
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_STATE_HOME}/pip/pip.log"

# ─────────────────────────────────────────────────────────────────
# Go
# ─────────────────────────────────────────────────────────────────
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"

# ─────────────────────────────────────────────────────────────────
# Rust / Cargo
# ─────────────────────────────────────────────────────────────────
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

# ─────────────────────────────────────────────────────────────────
# Ruby
# ─────────────────────────────────────────────────────────────────
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
export BUNDLE_USER_CONFIG="${XDG_CONFIG_HOME}/bundle"
export BUNDLE_USER_CACHE="${XDG_CACHE_HOME}/bundle"
export BUNDLE_USER_PLUGIN="${XDG_DATA_HOME}/bundle"

# ─────────────────────────────────────────────────────────────────
# その他のツール
# ─────────────────────────────────────────────────────────────────
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export LESSKEY="${XDG_CONFIG_HOME}/less/lesskey"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"

# wget エイリアス（hsts ファイル対応）
alias wget='wget --hsts-file="${XDG_DATA_HOME}/wget/hsts"'
EOF
}

# 設定を適用
apply_config() {
    local config_file
    local config_content

    case "$SHELL_TYPE" in
        zsh)
            config_file="$HOME/.zshenv"
            config_content=$(generate_zsh_config)
            ;;
        bash)
            config_file="$HOME/.bash_profile"
            config_content=$(generate_bash_config)
            ;;
        fish)
            config_file="${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d/xdg.fish"
            mkdir -p "$(dirname "$config_file")"
            config_content=$(generate_fish_config)
            ;;
        *)
            echo "不明なシェルタイプ: $SHELL_TYPE"
            exit 1
            ;;
    esac

    # バックアップ作成
    if [[ -f "$config_file" ]]; then
        cp "$config_file" "${config_file}.backup.$(date +%Y%m%d%H%M%S)"
        echo -e "${BLUE}[INFO]${NC} バックアップを作成しました: ${config_file}.backup.*"
    fi

    # 設定を追加
    echo "" >> "$config_file"
    echo "$config_content" >> "$config_file"

    echo -e "${GREEN}[SUCCESS]${NC} 設定を追加しました: $config_file"
    echo -e "${YELLOW}[INFO]${NC} シェルを再起動するか、以下を実行してください:"
    echo "  source $config_file"
}

# メイン
main() {
    parse_args "$@"

    if [[ "$APPLY" == true ]]; then
        apply_config
    else
        echo -e "${BLUE}# 以下の設定をシェルの設定ファイルに追加してください${NC}"
        echo -e "${BLUE}# または --apply オプションを使用して自動適用${NC}"
        echo ""

        case "$SHELL_TYPE" in
            zsh)
                generate_zsh_config
                ;;
            bash)
                generate_bash_config
                ;;
            fish)
                generate_fish_config
                ;;
            *)
                echo "不明なシェルタイプ: $SHELL_TYPE"
                exit 1
                ;;
        esac
    fi
}

main "$@"
