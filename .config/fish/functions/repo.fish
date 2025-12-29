function repo --description "ghq + fzf でリポジトリに移動"
    set -l repo (ghq list | fzf --preview "bat --color=always --style=plain (ghq root)/{}/README.md 2>/dev/null || ls -la (ghq root)/{}")
    if test -n "$repo"
        cd (ghq root)/$repo
    end
end
