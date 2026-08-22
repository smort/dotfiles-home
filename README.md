# Home dotfiles

WSL2 Ubuntu dotfiles managed with GNU Stow.

## Packages

- `git`
- `lazygit`
- `ssh`
- `starship`
- `zsh`

Pi, Zed, npm registry configuration, AWS, Kubernetes, Jira, Salesforce, and work-specific integrations are intentionally excluded.

See [SETUP.md](SETUP.md) for first-time installation and ongoing maintenance instructions.

## Prerequisites

Install Linuxbrew/Homebrew manually first. It is the source of truth for user-facing development tools:

- https://brew.sh

The bootstrap scripts install only these Ubuntu/apt prerequisites:

- `stow`
- `curl`
- `build-essential`
- `ca-certificates`
- `unzip`

## Bootstrap from scratch

From WSL2 Ubuntu:

```bash
cd ~/src/dotfiles-home
./bootstrap/bootstrap.sh
```

The script is safe to rerun. It installs apt prerequisites, installs the curated `Brewfile`, and creates/refreshes Stow symlinks.

Run individual stages when needed:

```bash
./bootstrap/00-apt.sh
./bootstrap/10-brew-bundle.sh
./bootstrap/20-stow.sh
```

Or skip stages:

```bash
./bootstrap/bootstrap.sh --skip-apt
./bootstrap/bootstrap.sh --skip-brew
./bootstrap/bootstrap.sh --skip-stow
```

## Tracking installed tools

Check whether the machine matches the manifest:

```bash
brew bundle check --file="$HOME/src/dotfiles-home/Brewfile"
```

After intentionally adding or removing tools, edit `Brewfile` and commit it. Avoid blindly dumping the entire machine with `brew bundle dump`; that can include transitive dependencies and unrelated experiments.

## Warp and Zsh

Warp can provide its own prompt. Starship remains enabled by default; disable it with:

```bash
export DOTFILES_USE_STARSHIP=0
```

The Zsh configuration still handles aliases, environment setup, mise, completion, plugins, and optional tools such as fzf, zoxide, eza, and bat.
