# Set file descriptor limit to avoid EMFILE errors
ulimit -n 65536

if status is-interactive
    # Ghostty ロゴアニメーション（Ghosttyターミナル内のみ）
    if test "$TERM" = "xterm-ghostty"
        bash ~/.config/ghostty/ghostty_animation.sh
    end

    # ghq + fzf キーバインド (Ctrl+G)
    bind \cg 'ghq-fzf; commandline -f repaint'
end

zoxide init fish --cmd cd | source
git-wt --init fish | source


abbr -a get "ghq get"
abbr -a getl "ghq list"

abbr -a g git
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gpl "git pull"
abbr -a gs "git status"
abbr -a gd "git diff"
abbr -a gco "git checkout"
abbr -a gsw "git switch"
