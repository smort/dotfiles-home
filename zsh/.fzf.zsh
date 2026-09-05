# fzf shell integration. Prefer fd for fast, hidden-file-aware searches while
# excluding Git metadata. fzf is installed by mise when configured.
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Only source keybindings/completions in an interactive terminal with ZLE.
if [[ -o interactive && -t 0 && -t 1 ]] && command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi
