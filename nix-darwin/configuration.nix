{ pkgs, ... }: {

  # System packages available to all users
  environment.systemPackages = with pkgs; [
    neovim
    git
    bat
    eza
    fd
    fzf
    ripgrep
    zoxide
    starship
    stow
    tree
    nushell
    carapace
    atuin
    aerospace
    gh
    television
    tmux
  ];

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Enable zsh as default shell
  programs.zsh.enable = true;

  # Enable Touch ID for sudo
  # security.pam.services.sudo_local.touchIdAuth = true;

  # System version tracking
  system.configurationRevision = null;
  system.stateVersion = 6;

  system.primaryUser = "gargimahale";

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User
  users.users.gargimahale = {
    name = "gargimahale";
    home = "/Users/gargimahale";
  };
}
