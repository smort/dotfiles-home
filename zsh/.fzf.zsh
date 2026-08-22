# fzf shell integration. Homebrew's Linux prefix is /home/linuxbrew/.linuxbrew.
if command -v brew >/dev/null 2>&1; then
    FZF_PREFIX="$(brew --prefix fzf 2>/dev/null || true)"
    if [[ -n "$FZF_PREFIX" && -d "$FZF_PREFIX/bin" ]]; then
        path+=("$FZF_PREFIX/bin")
    fi
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi
