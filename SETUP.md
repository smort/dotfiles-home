# First-time setup

These instructions assume a fresh WSL2 Ubuntu environment and a private GitHub repository.

## 1. Install Linuxbrew

Install Homebrew/Linuxbrew manually from:

<https://brew.sh>

Restart the WSL shell afterward and verify:

```bash
brew --version
```

## 2. Install Git

Git is managed by Homebrew in this setup, but it is needed before cloning this repository:

```bash
brew install git
```

## 3. Create an SSH key

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

Test it:

```bash
ssh -T -i ~/.ssh/id_personal_ed25519 \
  -o IdentitiesOnly=yes git@github.com
```

## 4. Clone the repository

The repository's SSH config is not installed until after cloning, so use the key explicitly for the first clone:

```bash
mkdir -p ~/src

GIT_SSH_COMMAND="ssh -i ~/.ssh/id_personal_ed25519 -o IdentitiesOnly=yes" \
  git clone git@github.com:YOUR_GITHUB_USER/YOUR_REPOSITORY.git \
  ~/src/dotfiles-home
```

Replace the repository URL with the actual GitHub URL.

## 5. Run the bootstrap

```bash
cd ~/src/dotfiles-home
./bootstrap/bootstrap.sh
```

This installs:

- The small apt prerequisite set
- Everything listed in `Brewfile`
- Stow links for Git, Lazygit, SSH, Starship, and Zsh

The bootstrap is safe to rerun.

## 6. Verify the setup

Open a new shell, then check:

```bash
command -v zsh
command -v mise
command -v starship
command -v lazygit

ssh -T git@github-second

git config --global --list
brew bundle check --file="$HOME/src/dotfiles-home/Brewfile"
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

Edit `Brewfile`, then install the declared packages:

```bash
brew bundle --file="$HOME/src/dotfiles-home/Brewfile"
```

Check whether the machine matches the manifest:

```bash
brew bundle check --file="$HOME/src/dotfiles-home/Brewfile"
```

Do not routinely use `brew bundle dump --force`; it can add transitive dependencies and unrelated experiments. Maintain the Brewfile as a curated list.

### Update dotfiles

Because Stow creates symlinks, normal edits to these files are already edits to the repository:

```bash
cd ~/src/dotfiles-home
git status
git diff
```

After adding a new package or changing layout, refresh the links:

```bash
./bootstrap/20-stow.sh
```

### Update Homebrew packages

Occasionally update Homebrew and declared packages:

```bash
brew update
brew bundle --file="$HOME/src/dotfiles-home/Brewfile"
brew upgrade
```

Review changes before committing any updates to the repository.

### Update Zsh plugins

Plugins are listed in:

```text
zsh/.zsh_plugins.txt
```

After changing that file, restart Zsh or open a new terminal. Antidote rebuilds its cached plugin bundle automatically.

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
