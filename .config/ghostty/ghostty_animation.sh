#!/bin/bash
# Ghostty logo animation script (centered, skippable)

FRAMES_DIR="$HOME/.config/ghostty/animation_frames"
FRAME_DELAY=0.031

# フレームディレクトリが存在しない場合は終了
if [ ! -d "$FRAMES_DIR" ] || [ -z "$(ls -A "$FRAMES_DIR" 2>/dev/null)" ]; then
    exit 0
fi

FRAME_WIDTH=100
FRAME_HEIGHT=41

# ターミナルサイズ取得
TERM_COLS=$(tput cols)
TERM_ROWS=$(tput lines)

# センタリング計算
PAD_LEFT=$(( (TERM_COLS - FRAME_WIDTH) / 2 ))
PAD_TOP=$(( (TERM_ROWS - FRAME_HEIGHT) / 2 ))

[ $PAD_LEFT -lt 0 ] && PAD_LEFT=0
[ $PAD_TOP -lt 0 ] && PAD_TOP=0

# 左パディング
LEFT_PAD=$(printf '%*s' "$PAD_LEFT" '')

# 終了フラグ
SKIP=false

# クリーンアップ
cleanup() {
    tput cnorm
    tput sgr0
    stty sane 2>/dev/null
    clear
}
trap 'cleanup; exit' INT TERM EXIT

# 画面準備
clear
tput civis

# 入力を非ブロッキングに設定
stty -icanon -echo min 0 time 0

# 再生
for i in $(seq 1 235); do
    # キー入力チェック
    if [ -n "$(dd bs=1 count=1 2>/dev/null)" ]; then
        break
    fi

    num=$(printf "%03d" $i)
    tput cup $PAD_TOP 0
    while IFS= read -r line; do
        printf '%s%s\n' "$LEFT_PAD" "$line"
    done < "$FRAMES_DIR/frame_${num}.txt"
    sleep $FRAME_DELAY
done

cleanup
