#!/usr/bin/env bash
#
# migrate_dotfile.sh - dotfile を XDG ディレクトリに移行するスクリプト
#
# 使用方法:
#   migrate_dotfile.sh <source> <destination>
#   migrate_dotfile.sh --dry-run <source> <destination>
#
# オプション:
#   --dry-run    実際には移行せず、実行内容を表示
#   --no-backup  バックアップを作成しない
#   --force      既存ファイルを上書き
#
# 例:
#   migrate_dotfile.sh ~/.vimrc ~/.config/vim/vimrc
#   migrate_dotfile.sh ~/.vim ~/.config/vim
#

set -euo pipefail

# カラー出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デフォルト設定
DRY_RUN=false
NO_BACKUP=false
FORCE=false

# ヘルプ表示
show_help() {
    cat << EOF
使用方法: $(basename "$0") [オプション] <source> <destination>

dotfile を XDG ディレクトリに移行します。

オプション:
    --dry-run    実際には移行せず、実行内容を表示
    --no-backup  バックアップを作成しない
    --force      既存ファイルを上書き
    -h, --help   このヘルプを表示

例:
    $(basename "$0") ~/.vimrc ~/.config/vim/vimrc
    $(basename "$0") ~/.vim ~/.config/vim
    $(basename "$0") --dry-run ~/.gitconfig ~/.config/git/config

EOF
}

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# 引数解析
parse_args() {
    local positional_args=()

    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --no-backup)
                NO_BACKUP=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                log_error "不明なオプション: $1"
                show_help
                exit 1
                ;;
            *)
                positional_args+=("$1")
                shift
                ;;
        esac
    done

    if [[ ${#positional_args[@]} -ne 2 ]]; then
        log_error "source と destination を指定してください"
        show_help
        exit 1
    fi

    SOURCE="${positional_args[0]}"
    DESTINATION="${positional_args[1]}"
}

# 移行実行
migrate() {
    local source="$1"
    local dest="$2"
    local dest_dir
    dest_dir=$(dirname "$dest")

    # ソースの存在確認
    if [[ ! -e "$source" ]]; then
        log_error "ソースが存在しません: $source"
        exit 1
    fi

    # 既存ファイルの確認
    if [[ -e "$dest" ]] && [[ "$FORCE" != true ]]; then
        log_error "移行先が既に存在します: $dest"
        log_info "上書きするには --force オプションを使用してください"
        exit 1
    fi

    # dry-run モード
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] 以下の操作を実行します:"
        echo "  1. ディレクトリ作成: $dest_dir"
        if [[ "$NO_BACKUP" != true ]]; then
            echo "  2. バックアップ作成: ${source}.backup.$(date +%Y%m%d)"
        fi
        echo "  3. 移動: $source -> $dest"
        echo "  4. シンボリックリンク作成: $source -> $dest"
        return
    fi

    # ディレクトリ作成
    log_info "ディレクトリを作成: $dest_dir"
    mkdir -p "$dest_dir"

    # バックアップ作成
    if [[ "$NO_BACKUP" != true ]]; then
        local backup="${source}.backup.$(date +%Y%m%d)"
        log_info "バックアップを作成: $backup"
        cp -r "$source" "$backup"
    fi

    # 移動
    log_info "移動: $source -> $dest"
    mv "$source" "$dest"

    # シンボリックリンク作成（互換性のため）
    log_info "シンボリックリンクを作成: $source -> $dest"
    ln -s "$dest" "$source"

    log_success "移行が完了しました！"
    echo ""
    echo "次のステップ:"
    echo "  1. アプリケーションが正常に動作することを確認"
    echo "  2. 問題なければシンボリックリンクを削除: rm '$source'"
    echo "  3. 環境変数の設定を追加（必要に応じて）"
}

# メイン
main() {
    parse_args "$@"

    # パスを展開
    SOURCE=$(eval echo "$SOURCE")
    DESTINATION=$(eval echo "$DESTINATION")

    log_info "dotfile の移行を開始します"
    log_info "  Source: $SOURCE"
    log_info "  Destination: $DESTINATION"
    echo ""

    migrate "$SOURCE" "$DESTINATION"
}

main "$@"
