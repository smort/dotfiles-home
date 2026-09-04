# Home Zsh configuration for WSL2 Ubuntu + Warp.

# Keep user-installed commands available, including mise itself.
path=("$HOME/.local/bin" $path)

# mise manages global/project tool versions from ~/.config/mise/config.toml.
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# Plugins are optional. Antidote is loaded when present, but Homebrew is not
# required by this dotfiles setup.
for ANTIDOTE_ZSH in \
    "$HOME/.local/share/antidote/antidote.zsh" \
    "$HOME/.antidote/antidote.zsh" \
    /usr/share/zsh-antidote/antidote.zsh; do
    if [[ -f "$ANTIDOTE_ZSH" ]]; then
        source "$ANTIDOTE_ZSH"
        ZSH_PLUGINS_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_plugins.zsh"
        if [[ ! -f "$ZSH_PLUGINS_CACHE" || "$HOME/.zsh_plugins.txt" -nt "$ZSH_PLUGINS_CACHE" ]]; then
            mkdir -p "$(dirname "$ZSH_PLUGINS_CACHE")"
            antidote bundle < "$HOME/.zsh_plugins.txt" > "$ZSH_PLUGINS_CACHE"
        fi
        source "$ZSH_PLUGINS_CACHE"
        break
    fi
done

# Completion and history.
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={a-zA-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt NO_BANG_HIST INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY
HISTSIZE=50000
SAVEHIST=50000

# Optional modern CLI replacements.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh --cmd cd)"
fi
if command -v fzf >/dev/null 2>&1; then
    source "$HOME/.fzf.zsh"
fi

if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias l='eza -1 --icons --group-directories-first'
    alias ll='eza -lbF --git --icons --time-style=relative'
    alias la='eza -lbhaF --git --icons'
fi
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

# Common navigation and Git shortcuts.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias python='python3'

# Warp can provide its own prompt. Starship remains available when preferred.
if [[ "${DOTFILES_USE_STARSHIP:-1}" == "1" ]] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
