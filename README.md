# Home dotfiles

WSL2 Ubuntu dotfiles managed with GNU Stow. Tool versions are managed by mise.

## Packages

Stow packages:

- `git`
- `lazygit`
- `mise`
- `ssh`
- `starship`
- `zsh`

User-facing CLIs and runtimes live in `mise/.config/mise/config.toml`. Homebrew/Brewfile is intentionally not used; where possible, mise installs tools from its registry/aqua backends.

Pi, Zed, npm registry configuration, AWS, Kubernetes, Jira, Salesforce, and work-specific integrations are intentionally excluded.

See [SETUP.md](SETUP.md) for first-time installation and ongoing maintenance instructions.

## Bootstrap from scratch

From WSL2 Ubuntu:

```bash
cd ~/.dotfiles
./bootstrap/bootstrap.sh
```

The script is safe to rerun. It installs apt prerequisites, creates/refreshes Stow symlinks, installs mise if needed, and runs `mise install`.

Run individual stages when needed:

```bash
./bootstrap/00-apt.sh
./bootstrap/20-stow.sh
./bootstrap/10-mise-install.sh
```

Or skip stages:

```bash
./bootstrap/bootstrap.sh --skip-apt
./bootstrap/bootstrap.sh --skip-stow
./bootstrap/bootstrap.sh --skip-mise
```

## Tracking installed tools

Check whether the machine matches the manifest:

```bash
mise ls --current
mise outdated
```

After intentionally adding or removing tools, edit `mise/.config/mise/config.toml` and rerun:

```bash
mise install
```

## Warp and Zsh

Warp can provide its own prompt. Starship remains enabled by default; disable it with:

```bash
export DOTFILES_USE_STARSHIP=0
```

The Zsh configuration handles aliases, environment setup, mise, completion, and optional tools such as fzf, zoxide, eza, and bat.
