# Home dotfiles

WSL2 Ubuntu dotfiles and workstation dependencies managed with [mise](https://mise.jdx.dev/). The repository is public and is checked out to `~/.dotfiles` by mise bootstrap.

## What mise manages

- Ubuntu system packages: Git, Zsh, curl, build tools, CA certificates, unzip, xz-utils, and socat
- This repository at `~/.dotfiles`
- Antidote at `~/.local/share/antidote`
- Dotfile symlinks for Git, Lazygit, mise, SSH, Starship, and Zsh
- Zsh as the login shell
- Development tools and CLIs declared in [`mise.toml`](mise.toml), including Hunk, Herdr, Gitleaks, and Lefthook
- A Lefthook pre-commit secret scan using Gitleaks

GNU Stow is no longer used.

## Fresh WSL2 setup

Install mise once, then let it provision the machine. The initial installer must run outside mise because mise has to exist before it can bootstrap itself.

```bash
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

mise bootstrap --from https://github.com/smort/dotfiles-home.git --yes
```

The bootstrap process may prompt for your `sudo` password while installing apt packages and configuring the login shell. Start a new terminal when it completes.

Verify:

```bash
echo "$SHELL"
ps -p $$ -o comm=
command -v mise pi codex gh starship lazygit
mise bootstrap status --missing
```

## Local machine overlays

Keep machine-specific or sensitive settings out of this public repository:

- Put Git identity overrides, signing configuration, or work-only settings in `~/.gitconfig.local`.
- Put private SSH hosts, identity-file paths, and work-only settings in `~/.ssh/config.local`.

The tracked Git and SSH configs include those files when they exist. They are ignored if accidentally created inside this repository.

## GitHub authentication

The repository checkout requires no authentication. Authenticate GitHub CLI separately when you need to interact with GitHub:

```bash
gh auth login
gh auth status
```

Choose the authentication method appropriate for the machine; this flow is intentionally not part of bootstrap because it requires interactive user input.

## Ongoing maintenance

From the checked-out repository:

```bash
cd ~/.dotfiles
git pull --ff-only
mise bootstrap --yes
```

Preview or inspect changes without modifying files:

```bash
mise bootstrap --dry-run
mise bootstrap status --missing
mise bootstrap dotfiles diff
```

## Git hooks

Bootstrap installs the repository's Lefthook hook. Before each commit, Gitleaks scans staged content for likely secrets. Do not bypass it; remove secrets from the change instead.

## Tracking installed tools

Tools are declared in [`mise.toml`](mise.toml). After intentionally changing the tool list, run:

```bash
mise install
mise ls --current
mise outdated
```

## Warp and Zsh

Warp can provide its own prompt. Starship remains enabled by default; disable it with:

```bash
export DOTFILES_USE_STARSHIP=0
```

The Zsh configuration handles aliases, environment setup, mise, completion, and optional tools such as fzf, zoxide, eza, and bat.
