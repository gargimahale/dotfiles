# dotfiles

My macOS development environment on an M4 Max MacBook, managed with [GNU Stow](https://www.gnu.org/software/stow/) and [nix-darwin](https://github.com/nix-darwin/nix-darwin).

## Structure

```
dotfiles/
├── aerospace/            # AeroSpace tiling WM (Stow → ~/.config/aerospace/)
│   └── aerospace/
│       └── aerospace.toml
├── ghostty/              # Ghostty terminal (Stow → ~/.config/ghostty/)
│   └── ghostty/
│       └── config
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
- [Nix](https://nixos.org/download)
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

After the first build, rebuild with:

```bash
darwin-rebuild switch --flake . --impure
```

### 4. Install brew-only packages

Some packages fail to build through nix. Install via brew:

```bash
/opt/homebrew/bin/brew install direnv mise
```

### 5. Stow dotfiles

```bash
cd ~/dotfiles
./setup.sh
```

### 6. Start AeroSpace

```bash
open /Applications/AeroSpace.app
```

Grant accessibility permissions at System Settings → Privacy & Security → Accessibility.

## Stow

The `.stowrc` configures defaults:

```
--target=~/.config
--ignore=.stowrc
--ignore=DS_Store
--ignore=atuin/*
--ignore=.git
--ignore=.gitignore
```

Most packages target `~/.config` via `.stowrc`. Zsh targets `~` directly in `setup.sh`:

```bash
stow -t ~ zshrc
stow ghostty
stow nushell
stow aerospace
```

## nix-darwin

System config in `nix-darwin/` manages system packages, flakes, zsh as default shell, and macOS defaults.

System packages: neovim, git, bat, eza, fd, fzf, ripgrep, zoxide, starship, stow, tree, nushell, carapace, atuin, aerospace.

Home-manager reads `../zshrc/.zshrc` via `builtins.readFile` so zsh config has a single source of truth. The `--impure` flag is required for this.

### Rebuilding

```bash
cd ~/dotfiles/nix-darwin
darwin-rebuild switch --flake . --impure
```

## AeroSpace Shortcuts

AeroSpace is a tiling window manager. Windows automatically arrange into tiles — no dragging.

### Focus (move between windows)

| Shortcut | Action |
|----------|--------|
| Alt + H | Focus left |
| Alt + J | Focus down |
| Alt + K | Focus up |
| Alt + L | Focus right |

### Move windows

| Shortcut | Action |
|----------|--------|
| Alt + Shift + H | Move window left |
| Alt + Shift + J | Move window down |
| Alt + Shift + K | Move window up |
| Alt + Shift + L | Move window right |

### Resize

| Shortcut | Action |
|----------|--------|
| Alt + Shift + - | Shrink by 50px |
| Alt + Shift + = | Grow by 50px |

### Workspaces

| Shortcut | Action |
|----------|--------|
| Alt + 1/2/3/4 | Switch to workspace |
| Alt + Shift + 1/2/3/4 | Move window to workspace |
| Alt + Tab | Toggle last two workspaces |

### Layout

| Shortcut | Action |
|----------|--------|
| Alt + Ctrl + Shift + F | Toggle fullscreen |
| Alt + Ctrl + F | Toggle floating/tiling |
| Alt + / | Toggle horizontal/vertical tiles |
| Alt + , | Toggle accordion layout |

### App launchers

| Shortcut | App |
|----------|-----|
| Alt + G | Ghostty |
| Alt + O | Obsidian |
| Alt + D | Discord |
| Alt + F | Finder |

### Service mode

| Shortcut | Action |
|----------|--------|
| Alt + Shift + ; | Enter service mode |
| R (in service mode) | Reset layout |
| F (in service mode) | Toggle float/tile |
| Backspace (in service mode) | Close all windows except current |
| Esc (in service mode) | Reload config and exit |

### Join windows

| Shortcut | Action |
|----------|--------|
| Alt + Shift + ← | Join with left |
| Alt + Shift + ↓ | Join with down |
| Alt + Shift + ↑ | Join with up |
| Alt + Shift + → | Join with right |

## Nushell

Nushell is a structured data shell. Everything outputs tables instead of plain text.

Useful commands to try:

```
ls | sort-by size          # sort files by size
sys mem                    # memory usage as structured data
ps | where cpu > 5         # processes using more than 5% CPU
open file.json             # parse JSON into a table
```

### Nushell aliases

| Alias | Command |
|-------|---------|
| l | ls --all |
| ll | ls -l |
| lt | eza tree view |
| c | clear |
| v | nvim |
| cx [dir] | cd + list |
| ff | fuzzy-find AeroSpace windows |
| as | aerospace |

### Zsh aliases

| Alias | Command |
|-------|---------|
| .. / ... / .... | cd up directories |
| cat | bat |
| la | tree |
| l | eza -l --icons --git -a |
| v | nvim |
| cl | clear |
| cx [dir] | cd + list |
| fcd | fuzzy-find directory |
| f | fuzzy-find file → clipboard |
| fv | fuzzy-find file → nvim |

## Tools

| Tool | Purpose |
|------|---------|
| Ghostty | GPU-accelerated terminal (Monokai Remastered, JetBrains Mono) |
| Neovim | Editor (lazy.nvim, LSP via vim.lsp.config, treesitter) |
| Nushell | Structured data shell (vi mode, starship prompt) |
| AeroSpace | Tiling window manager |
| Starship | Cross-shell prompt |
| Zoxide | Smart directory jumping (z command) |
| Carapace | Universal tab completions (bridges zsh/fish/bash) |
| Atuin | Shell history search (Ctrl+R) |
| Mise | Tool version manager (replaces nvm/pyenv/rbenv) |
| Direnv | Per-directory environment variables |
| GNU Stow | Dotfile symlink manager |
| Bat | cat with syntax highlighting |
| Eza | ls with icons and git status |
| Fd | Fast find alternative |
| Fzf | Fuzzy finder |
| Ripgrep | Fast grep alternative |

## Known Issues & Gotchas

### Nix daemon dies

```bash
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

### Brew not found after nix-darwin

nix-darwin takes over PATH. Ensure `/opt/homebrew/bin` is in your `.zshrc`, or use `/opt/homebrew/bin/brew` directly.

### /etc file conflicts on first install

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

### system.primaryUser required

Add to `configuration.nix`:

```nix
system.primaryUser = "gargimahale";
```

### Don't use sudo with darwin-rebuild

`sudo darwin-rebuild switch` causes `$HOME` to resolve to `/var/root`. Run without sudo — it prompts for your password when needed.

### macOS defaults need a reboot

Some `system.defaults` settings only apply after a restart. If keyboard shortcuts break after a rebuild, reboot first.

### Direnv and mise fail to build in nix

Install via brew instead:

```bash
/opt/homebrew/bin/brew install direnv mise
```

### AeroSpace keybindings don't work

Make sure AeroSpace is running (`open /Applications/AeroSpace.app`) and has accessibility permissions enabled in System Settings.

### Ghostty intercepts Alt keys

Ghostty's `macos-option-as-alt = left` may intercept Alt before AeroSpace gets it. If AeroSpace keybindings don't work inside Ghostty, this is why. Test keybindings from another app first.

### Dirty git tree warning

`warning: Git tree is dirty` — just a warning, not an error. Commit or stash to silence it.

### nvim-lspconfig deprecation

If you see `require('lspconfig') is deprecated`, update `lsp.lua` to use `vim.lsp.config()` and `vim.lsp.enable()` instead. See the refactored `lsp.lua` in `nvim/lua/ferb/lazy/lsp.lua`.
|
