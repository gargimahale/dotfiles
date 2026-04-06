# dotfiles

My macOS development environment on an M4 Max MacBook, managed with [GNU Stow](https://www.gnu.org/software/stow/) and [nix-darwin](https://github.com/nix-darwin/nix-darwin).

## Structure

```
dotfiles/
├── aerospace/            # AeroSpace tiling WM (Stow → ~/.config/aerospace/)
│   └── aerospace.toml
├── gh-dash/              # GitHub dashboard (Stow → ~/.config/gh-dash/)
│   └── config.yml
├── ghostty/              # Ghostty terminal (Stow → ~/.config/ghostty/)
│   └── config
├── nushell/              # Nushell config (Stow → ~/.config/nushell/)
│   ├── config.nu
│   └── env.nu
├── nvim/                 # Neovim config (Stow → ~/.config/nvim/)
│   └── ...
├── television/           # Television fuzzy finder (Stow → ~/.config/television/)
│   └── config.toml
├── tmux/                 # Tmux config (Stow → ~/.config/tmux/)
│   ├── tmux.conf
│   └── tmux.reset.conf
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

### 5. Install tmux plugin manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then open tmux and press `Ctrl+A` then `I` (capital I) to install plugins.

### 6. Install gh-dash

```bash
gh auth login
gh extension install dlvhdr/gh-dash
```

### 7. Install television

```bash
brew install television
```

### 8. Stow dotfiles

```bash
cd ~/dotfiles
./setup.sh
```

### 9. Start AeroSpace

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
stow tmux
stow gh-dash
stow television
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

## Tmux Shortcuts

Tmux is a terminal multiplexer. Prefix is `Ctrl+A` (not the default `Ctrl+B`).

### Panes

| Shortcut | Action |
|----------|--------|
| Ctrl+A, v | Split vertical |
| Ctrl+A, s | Split horizontal |
| Ctrl+A, h/j/k/l | Move between panes (vim-style) |
| Ctrl+A, c | Kill pane |
| Ctrl+A, z | Zoom/unzoom pane |
| Ctrl+A, , | Resize pane left |
| Ctrl+A, . | Resize pane right |
| Ctrl+A, - | Resize pane down |
| Ctrl+A, = | Resize pane up |

### Windows

| Shortcut | Action |
|----------|--------|
| Ctrl+A, Ctrl+C | New window |
| Ctrl+A, H | Previous window |
| Ctrl+A, L | Next window |
| Ctrl+A, Ctrl+A | Last window |
| Ctrl+A, r | Rename window |

### Sessions

| Shortcut | Action |
|----------|--------|
| Ctrl+A, o | Session manager (sessionx) |
| Ctrl+A, S | Choose session |
| Ctrl+A, Ctrl+D | Detach |

### Plugins

| Shortcut | Action |
|----------|--------|
| Ctrl+A, p | Floating pane (floax) |
| Ctrl+A, I | Install plugins (TPM) |
| Ctrl+A, R | Reload config |
| Ctrl+A, K | Clear screen |

### Plugins installed

| Plugin | Purpose |
|--------|---------|
| tpm | Plugin manager |
| tmux-sensible | Sensible defaults |
| tmux-yank | Copy to system clipboard |
| tmux-resurrect | Save/restore sessions |
| tmux-continuum | Auto-save sessions |
| tmux-fzf | Fuzzy finder integration |
| tmux-fzf-url | Open URLs from terminal |
| catppuccin-tmux | Theme |
| tmux-sessionx | Session manager |
| tmux-floax | Floating panes |

## Television

Television is a fast fuzzy finder with "channels" for searching different data sources.

### Usage

```bash
tv                # Search files (default)
tv text           # Search file contents
tv git-repos      # Find git repositories
tv git-log        # Browse git history
tv git-branch     # Switch branches
tv git-diff       # Browse diffs
tv env            # Search environment variables
tv dirs           # Search directories
tv docker-images  # Search docker images
```

## gh-dash

Terminal dashboard for GitHub PRs, issues, and notifications.

### Usage

```bash
gh dash
```

### Navigation

| Key | Action |
|-----|--------|
| ? | Help |
| / | Search |
| j/k | Move up/down |
| Enter | Open in browser |
| Tab | Switch sections (PRs/Issues/Notifications) |
| Ctrl+D | Preview diff |
| c | Comment |
| a | Approve PR |
| m | Merge PR |
| Ctrl+B | Open in browser |

### Sections configured

| Section | Filter |
|---------|--------|
| My Pull Requests | Open PRs authored by you |
| Needs My Review | PRs requesting your review |
| Involved | PRs you're involved in |
| My Issues | Issues you created |
| Assigned | Issues assigned to you |
| Notifications | All, review requested, mentioned, assigned |

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
| z [keyword] | zoxide smart cd |

## Ghostty

GPU-accelerated terminal with Monokai Remastered theme, JetBrains Mono font, and translucent background.

### Config highlights

| Setting | Value |
|---------|-------|
| Theme | Monokai Remastered |
| Font | JetBrains Mono, 15pt |
| Background | #031219, 90% opacity |
| Blur | 20px radius |
| Cursor | Block, blinking |
| Option key | Left Alt sends Alt (for AeroSpace) |

## Tools

| Tool | Purpose |
|------|---------|
| Ghostty | GPU-accelerated terminal (Monokai Remastered, JetBrains Mono) |
| Neovim | Editor (lazy.nvim, LSP via vim.lsp.config, treesitter) |
| Nushell | Structured data shell (vi mode, starship prompt) |
| AeroSpace | Tiling window manager |
| Tmux | Terminal multiplexer (catppuccin, sessionx, floax) |
| gh-dash | GitHub PR/issue dashboard in terminal |
| Television | Fast fuzzy finder with channels |
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

### Stow conflicts with existing files

If Stow says "cannot stow over existing target", either remove the existing file or use `--adopt`:

```bash
rm ~/.config/television/config.toml
stow television
# or
stow --adopt television
```

### Tmux plugins not loading

Install TPM first, then press `Ctrl+A, I` inside tmux:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### nvim-lspconfig deprecation

If you see `require('lspconfig') is deprecated`, update `lsp.lua` to use `vim.lsp.config()` and `vim.lsp.enable()` instead. See the refactored `lsp.lua` in `nvim/lua/ferb/lazy/lsp.lua`.