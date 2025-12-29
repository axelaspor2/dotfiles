#!/usr/bin/env bash
#
# check_xdg.sh - ホームディレクトリの dotfiles の XDG 準拠状況をチェック
#
# 使用方法:
#   check_xdg.sh
#   check_xdg.sh --verbose
#

set -euo pipefail

# カラー出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

VERBOSE=false

# XDG ディレクトリ設定
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# 無視するファイル/ディレクトリ（XDG準拠または移行不可）
IGNORE_LIST=(
    ".cache"
    ".config"
    ".local"
    ".ssh"          # XDG 非対応
    ".gnupg"        # セキュリティ上の理由で移行推奨しない場合も
    ".Trash"        # システム管理
    ".DS_Store"     # macOS システムファイル
    ".CFUserTextEncoding"  # macOS システムファイル
    ".localized"    # macOS
)

# XDG 対応済みアプリケーション（参考情報）
XDG_COMPLIANT=(
    ".config"
    ".local"
    ".cache"
)

# 既知の dotfiles と推奨移行先
declare -A KNOWN_DOTFILES=(
    [".zshrc"]="~/.config/zsh/.zshrc (ZDOTDIR設定後)"
    [".zsh_history"]="~/.local/state/zsh/history"
    [".zshenv"]="ZDOTDIR設定のため残す"
    [".bashrc"]="~/.config/bash/bashrc (sourceで読み込み)"
    [".bash_profile"]="BASH_CONFIG_HOME設定のため残す"
    [".bash_history"]="~/.local/state/bash/history"
    [".vimrc"]="~/.config/vim/vimrc"
    [".vim"]="~/.config/vim"
    [".gitconfig"]="~/.config/git/config"
    [".gitignore_global"]="~/.config/git/ignore"
    [".tmux.conf"]="~/.config/tmux/tmux.conf"
    [".npmrc"]="~/.config/npm/npmrc"
    [".cargo"]="~/.local/share/cargo"
    [".rustup"]="~/.local/share/rustup"
    [".go"]="~/.local/share/go"
    [".node_repl_history"]="~/.local/state/node/repl_history"
    [".python_history"]="~/.local/state/python/history"
    [".lesshst"]="~/.local/state/less/history"
    [".wget-hsts"]="~/.local/share/wget/hsts"
    [".docker"]="~/.config/docker"
)

# 引数解析
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose|-v)
                VERBOSE=true
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

show_help() {
    cat << EOF
使用方法: $(basename "$0") [オプション]

ホームディレクトリの dotfiles の XDG 準拠状況をチェックします。

オプション:
    -v, --verbose  詳細な情報を表示
    -h, --help     このヘルプを表示

EOF
}

# ファイルが無視リストに含まれるか確認
is_ignored() {
    local file="$1"
    for ignore in "${IGNORE_LIST[@]}"; do
        if [[ "$file" == "$ignore" ]]; then
            return 0
        fi
    done
    return 1
}

# メインチェック
main() {
    parse_args "$@"

    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}           XDG Base Directory 準拠状況チェック               ${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""

    # XDG 環境変数の確認
    echo -e "${BLUE}▶ XDG 環境変数の設定状況${NC}"
    echo ""

    check_env_var "XDG_CONFIG_HOME" "$XDG_CONFIG_HOME"
    check_env_var "XDG_DATA_HOME" "$XDG_DATA_HOME"
    check_env_var "XDG_CACHE_HOME" "$XDG_CACHE_HOME"
    check_env_var "XDG_STATE_HOME" "$XDG_STATE_HOME"
    echo ""

    # XDG ディレクトリの存在確認
    echo -e "${BLUE}▶ XDG ディレクトリの存在確認${NC}"
    echo ""

    check_dir_exists "$XDG_CONFIG_HOME"
    check_dir_exists "$XDG_DATA_HOME"
    check_dir_exists "$XDG_CACHE_HOME"
    check_dir_exists "$XDG_STATE_HOME"
    echo ""

    # ホームディレクトリの dotfiles スキャン
    echo -e "${BLUE}▶ ホームディレクトリの dotfiles${NC}"
    echo ""

    local count=0
    local migrable=0

    while IFS= read -r -d '' file; do
        local basename
        basename=$(basename "$file")

        # 無視リストのチェック
        if is_ignored "$basename"; then
            if [[ "$VERBOSE" == true ]]; then
                echo -e "  ${GREEN}[SKIP]${NC} $basename (XDG準拠または移行不可)"
            fi
            continue
        fi

        ((count++))

        # 既知の dotfile かチェック
        if [[ -v "KNOWN_DOTFILES[$basename]" ]]; then
            echo -e "  ${YELLOW}[MIGRATE]${NC} $basename"
            echo -e "           → ${KNOWN_DOTFILES[$basename]}"
            ((migrable++))
        else
            echo -e "  ${RED}[UNKNOWN]${NC} $basename"
            if [[ "$VERBOSE" == true ]]; then
                echo -e "           アプリケーションのドキュメントを確認してください"
            fi
        fi
    done < <(find "$HOME" -maxdepth 1 -name ".*" -print0 2>/dev/null | sort -z)

    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}サマリー${NC}"
    echo -e "  検出された dotfiles: $count"
    echo -e "  移行推奨: $migrable"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"

    if [[ $migrable -gt 0 ]]; then
        echo ""
        echo -e "${YELLOW}ヒント:${NC} migrate_dotfile.sh を使用して移行できます"
        echo "  例: scripts/migrate_dotfile.sh ~/.vimrc ~/.config/vim/vimrc"
    fi
}

check_env_var() {
    local name="$1"
    local value="$2"

    if [[ -n "${!name:-}" ]]; then
        echo -e "  ${GREEN}[SET]${NC} $name = $value"
    else
        echo -e "  ${YELLOW}[DEFAULT]${NC} $name = $value (未設定、デフォルト値を使用)"
    fi
}

check_dir_exists() {
    local dir="$1"

    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}[EXISTS]${NC} $dir"
    else
        echo -e "  ${RED}[MISSING]${NC} $dir"
    fi
}

main "$@"
