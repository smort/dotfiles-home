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

## Fresh WSL2 setup

Install the small system prerequisite set first. `zsh` and `git` come from apt; user-facing development tools come from mise.

```bash
sudo apt-get update
sudo apt-get install --yes git zsh stow curl build-essential ca-certificates unzip xz-utils socat
```

Clone this repo:

```bash
git clone https://github.com/smort/dotfiles-home.git ~/.dotfiles
cd ~/.dotfiles
```

Run the bootstrap:

```bash
./bootstrap/bootstrap.sh
```

The script is safe to rerun. It refreshes Stow symlinks, installs mise if needed, installs tools from `mise/.config/mise/config.toml`, and installs/updates Antidote for Zsh plugins.

Make apt Zsh your login shell, then restart the terminal:

```bash
chsh -s /usr/bin/zsh
```

After opening a fresh terminal, verify:

```bash
echo "$SHELL"
ps -p $$ -o comm=
command -v mise pi codex gh starship lazygit
```

Set up GitHub HTTPS credentials with GitHub CLI so future `git fetch`/`git push` commands work without SSH keys:

```bash
gh auth login
```

Recommended answers:

- GitHub.com
- HTTPS
- Authenticate Git with your GitHub credentials: Yes
- Login with a web browser

Verify:

```bash
gh auth status
cd ~/.dotfiles
git fetch
git status
```

## Bootstrap helpers

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
