{ config, pkgs, ... }:

{

  home.username = "tamago324";
  home.homeDirectory = "/home/tamago324";

  # home-manager のバージョンを固定する
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    zsh
    neovim
    gh 
    ghq
    fd
    ripgrep
    tealdeer
    universal-ctags
    curl
    wget
    git
    tree
    nodejs-16_x
    yarn
    deno
    fzf
    jq
    bat
    exa
    python3
    neovim-remote
  ];

  programs = {
    home-manager.enable = true;
  };

  home.file = {
  #   ".gitconfig".source = ./.gitconfig;
  #   ".config/nvim".source = ./.config/nvim;
  #   ".config/alacritty.yml".source = ./.config/alacritty.yml;
    ".vim".source = ./../.vim;
    ".gitconfig".source = ./../.gitconfig;
  };
}
