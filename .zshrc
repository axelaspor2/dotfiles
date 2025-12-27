# mise の設定
if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
  eval "$(mise activate --shims)"
fi

# GPG_TTY の設定
export GPG_TTY=$(tty)
