# dotfiles

My macOS development environment, managed with [GNU Stow](https://www.gnu.org/software/stow/) and [nix-darwin](https://github.com/nix-darwin/nix-darwin).

## Structure

```
dotfiles/
├── ghostty/              # Ghostty terminal config (Stow → ~/.config/ghostty/)
│   └── config
├── nushell/              # Nushell config (Stow → ~/.config/nushell/)
│   └── nushell/
│       ├── config.nu
│       └── env.nu
├── nvim/                 # Neovim config (Stow → ~/.config/nvim/)
│   └── ...
├── zshrc/                # Zsh config (Stow → ~/.zshrc)
│   └── .zshrc
├── nix-darwin/           # nix-darwin system config (NOT managed by Stow)
│   ├── flake.nix
│   ├── configuration.nix
│   └── home.nix
├── .stowrc
├── .gitignore
└── setup.sh
```

## Prerequisites

- macOS (Apple Silicon)
- [Nix](https://nixos.org/download) installed
- [Homebrew](https://brew.sh) for packages not in nixpkgs

## Setup

### 1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh
```

Close and reopen your terminal, then enable flakes:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

### 2. Clone dotfiles

```bash
git clone git@github.com:gargimahale/dotfiles.git ~/dotfiles
```

### 3. Bootstrap nix-darwin

```bash
cd ~/dotfiles/nix-darwin
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake . --impure
```

After the first build, you can rebuild with:

```bash
darwin-rebuild switch --flake . --impure
```

### 4. Stow dotfiles

```bash
cd ~/dotfiles
./setup.sh
```

This symlinks config files to their expected locations. The `.stowrc` targets `~/.config` by default. Packages that need a different target (like `zshrc` → `~`) are handled explicitly in `setup.sh`.

## Stow

The `.stowrc` file configures Stow defaults:

```
--target=~/.config
--ignore=.stowrc
--ignore=DS_Store
--ignore=atuin/*
--ignore=.git
--ignore=.gitignore
```

Most packages (ghostty, nushell, nvim) target `~/.config` via `.stowrc`. Zsh targets `~` directly and is stowed separately in `setup.sh`:

```bash
stow -t ~ zshrc
stow ghostty
stow nushell
```

## nix-darwin

System-level configuration lives in `nix-darwin/`. This manages:

- System packages (neovim, git, bat, eza, fd, fzf, ripgrep, zoxide, starship, stow, tree, nushell, carapace, atuin, aerospace)
- Flakes enabled by default
- Zsh as default shell
- Touch ID for sudo (optional)
- macOS system defaults (Dock, Finder, key repeat)

Home-manager is integrated via `home.nix`, which reads `../zshrc/.zshrc` using `builtins.readFile` so zsh config has a single source of truth.

### Rebuilding

```bash
cd ~/dotfiles/nix-darwin
darwin-rebuild switch --flake . --impure
```

The `--impure` flag is required because `home.nix` reads a file outside the Nix store.

## Known Issues & Gotchas

### Nix daemon dies

If you see `cannot connect to socket at '/nix/var/nix/daemon-socket/socket': Connection refused`, restart the daemon:

```bash
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

### Brew not found after nix-darwin

nix-darwin takes over PATH management. Make sure `/opt/homebrew/bin` is in your `.zshrc`:

```bash
export PATH=/opt/homebrew/bin:$PATH
```

Or use the full path: `/opt/homebrew/bin/brew`.

### `/etc/bashrc` or `/etc/zshrc` conflicts

On first nix-darwin install, you may see `Unexpected files in /etc, aborting activation`. Back up and rename:

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

### `system.primaryUser` required

Recent nix-darwin versions require `system.primaryUser` in `configuration.nix`:

```nix
system.primaryUser = "gargimahale";
```

### Dirty git tree warning

`warning: Git tree '/Users/gargimahale/dotfiles' is dirty` — this is just a warning, not an error. Commit or stash your changes to silence it.

### Don't use `sudo` with `darwin-rebuild`

Running `sudo darwin-rebuild switch` causes `$HOME` to resolve to `/var/root` instead of your home directory. Run without `sudo` — nix-darwin will prompt for your password when needed.

### macOS defaults need a reboot

Some `system.defaults` settings (Dock, Finder, keyboard) only apply cleanly after a restart. If keyboard shortcuts stop working after a rebuild, reboot first.

## Tools

| Tool | Purpose |
|------|---------|
| Ghostty | GPU-accelerated terminal |
| Neovim | Editor |
| Nushell | Structured data shell |
| Starship | Cross-shell prompt |
| Zoxide | Smart directory jumping |
| Carapace | Universal tab completions |
| Atuin | Shell history search |
| Mise | Tool version manager |
| AeroSpace | Tiling window manager |
| GNU Stow | Dotfile symlink manager |
