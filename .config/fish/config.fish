# Set file descriptor limit to avoid EMFILE errors
ulimit -n 65536

if status is-interactive
    # Ghostty ロゴアニメーション（Ghosttyターミナル内のみ）
    if test "$TERM" = "xterm-ghostty"
        bash ~/.config/ghostty/ghostty_animation.sh
    end
end

# Added by Antigravity
fish_add_path /Users/axelaspor2/.antigravity/antigravity/bin
