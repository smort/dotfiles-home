# First-time setup

These instructions provision a fresh WSL2 Ubuntu environment from this public repository. Mise clones the repository to `~/.dotfiles`, applies dotfiles, installs the declared system and development packages, installs Antidote, and sets Zsh as the login shell.

## 1. Install mise

Mise must be installed once before it can run its own bootstrap configuration:

```bash
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
```

Optionally add `~/.local/bin` to the current shell PATH before continuing if your shell setup does not already do so.

## 2. Bootstrap the machine

```bash
mise bootstrap --from https://github.com/smort/dotfiles-home.git --yes
```

This public checkout requires no GitHub credentials. Mise may ask for your `sudo` password to install apt packages and set the login shell to `/bin/zsh`.

Open a new terminal, then verify:

```bash
command -v zsh
command -v mise
command -v starship
command -v lazygit
command -v pi
command -v codex
mise bootstrap status --missing
```

## 3. Authenticate GitHub CLI when needed

GitHub CLI authentication is deliberately separate from bootstrap because it is interactive:

```bash
gh auth login
gh auth status
```

## Ongoing maintenance

Update the configuration and reconcile the machine:

```bash
cd ~/.dotfiles
git pull --ff-only
mise bootstrap --yes
```

Preview changes before applying them:

```bash
mise bootstrap --dry-run
mise bootstrap dotfiles diff
```

## Dotfile behavior

Mise creates symlinks, so changes to managed dotfiles are changes in `~/.dotfiles`:

```bash
cd ~/.dotfiles
git status
git diff
```

Mise refuses to overwrite conflicting local files by default. Inspect the conflict, preserve anything needed, and rerun with `mise bootstrap --force-dotfiles --yes` only when replacement is intentional.

## Warp

Warp can provide its own prompt. To use Warp's prompt instead of Starship:

```bash
export DOTFILES_USE_STARSHIP=0
```
