{ pkgs, ... }: {

  home.username = "gargimahale";
  home.homeDirectory = "/Users/gargimahale";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    initContent = builtins.readFile /Users/gargimahale/dotfiles/zshrc/.zshrc;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    XDG_CONFIG_HOME = "$HOME/.config";
  };
}
