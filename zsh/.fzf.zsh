# fzf shell integration. fzf is installed by mise when configured.
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi
