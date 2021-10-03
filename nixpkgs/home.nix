{ config, pkgs, ... }:

let
    zshsettings = import ./zsh.nix;

    wsl_pkgs = with pkgs; [
        wslu
    ];
in

{

  home.username = "tamago324";
  home.homeDirectory = "/home/tamago324";

  # home-manager のバージョンを固定する
  home.stateVersion = "21.11";

  programs = {
    home-manager.enable = true;
  };
  programs.zsh = zshsettings pkgs;

  home.packages = with pkgs; [
    zsh
    neovim
    gh 
    ghq
    fd
    ripgrep
    universal-ctags
    git
    nodejs-16_x
    nodePackages.prettier
    yarn
    deno
    fzf
    jq
    bat
    exa
    python3
    python39Packages.pip    # こうしないと pip が入らない
    neovim-remote

    nixpkgs-fmt
    rnix-lsp

    # tree-sitter のため
    gcc

    curl
    wget
    tree
    unzip

    ffmpeg
    tealdeer

    # libffi
    # zlib

    # WSLの場合、うまく行かなかったため、apt でインストールすることにした
    # docker
    # docker-compose
    jdk8
  ] ++ wsl_pkgs;

  home.file = {
  #   ".gitconfig".source = ./.gitconfig;
  #   ".config/nvim".source = ./.config/nvim;
  #   ".config/alacritty.yml".source = ./.config/alacritty.yml;
    ".vim".source = ./../.vim;
    ".gitconfig".source = ./../.gitconfig;
  };
}
