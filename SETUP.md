# First-time setup

These instructions assume a fresh WSL2 Ubuntu environment and a private GitHub repository.

## 1. Install apt prerequisites

```bash
sudo apt-get update
sudo apt-get install --yes git zsh stow curl build-essential ca-certificates unzip xz-utils socat
```

## 2. Create an SSH key

Create a personal GitHub key inside WSL2:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh

ssh-keygen -t ed25519 \
  -C "your-email@example.com" \
  -f ~/.ssh/id_personal_ed25519
```

Never commit the private key to the repository.

Start an agent and add the key for the current shell:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_personal_ed25519
```

Copy the public key:

```bash
cat ~/.ssh/id_personal_ed25519.pub
```

Add it to **GitHub → Settings → SSH and GPG keys**.

## 3. Clone the repository

```bash
mkdir -p ~
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_personal_ed25519 -o IdentitiesOnly=yes" \
  git clone git@github.com:YOUR_GITHUB_USER/YOUR_REPOSITORY.git \
  ~/.dotfiles
```

Replace the repository URL with the actual GitHub URL.

## 4. Run the bootstrap

```bash
cd ~/.dotfiles
./bootstrap/bootstrap.sh
```

This installs:

- The apt prerequisite set
- Stow links for Git, Lazygit, mise, SSH, Starship, and Zsh
- mise itself, if needed
- Everything listed in `mise/.config/mise/config.toml`

The bootstrap is safe to rerun.

## 5. Verify the setup

Open a new shell, then check:

```bash
command -v zsh
command -v mise
command -v starship
command -v lazygit
command -v pi
command -v codex

ssh -T git@github-second

git config --global --list
mise ls --current
```

The `github-second` SSH alias is installed by the `ssh` Stow package and uses `~/.ssh/id_personal_ed25519`.

## Warp

Warp can provide its own prompt. To use Warp's prompt instead of Starship:

```bash
export DOTFILES_USE_STARSHIP=0
```

If this should be permanent, add it to your local shell environment rather than committing machine-specific preferences immediately.

## Ongoing maintenance

### Add or remove tools

Edit `mise/.config/mise/config.toml`, then install the declared packages:

```bash
mise install
```

Check current and outdated tools:

```bash
mise ls --current
mise outdated
```

### Update dotfiles

Because Stow creates symlinks, normal edits to these files are already edits to the repository:

```bash
cd ~/.dotfiles
git status
git diff
```

After adding a new package or changing layout, refresh the links:

```bash
./bootstrap/20-stow.sh
```

### Update Zsh plugins

Plugins are listed in:

```text
zsh/.zsh_plugins.txt
```

Antidote is optional and loaded only if installed separately.

### SSH maintenance

List loaded keys:

```bash
ssh-add -l
```

Add the key again after starting a new agent:

```bash
ssh-add ~/.ssh/id_personal_ed25519
```

Rotate the key if it is ever exposed. Keep private keys, agent files, and credentials outside the repository.

### Before committing

Check for accidental secrets or machine-specific values:

```bash
git diff --check
git status
rg -n -i 'token|secret|password|private|/mnt/c/|/Users/|CHG|company' .
```
