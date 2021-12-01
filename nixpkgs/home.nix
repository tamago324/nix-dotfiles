{ config, pkgs, ... }:

let
  zshsettings = import ./zsh.nix;

  wsl_pkgs = with pkgs; [
    wslu
  ];

  # TODO: jidoude hanndannsuru
  laptop_pkgs = with pkgs; [
    #intel-graphics-compiler # for alacritty
    # alacritty
    # google-chrome
    alttab
    peek
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

  /* # https://nixos.wiki/wiki/Visual_Studio_Code */
  /* programs.vscode = {                          */
  /*   enable = true;                             */
  /*   package = pkgs.vscodium;                   */
  /* };                                           */

  home.packages = with pkgs; [
    zsh
    gh
    ghq
    universal-ctags
    git
    nodejs-16_x
    nodePackages.prettier
    nodePackages.typescript
    # SQL フォーマットツール (nvim の formatter.nvim で使う)
    nodePackages.sql-formatter
    # nodePackages.typescript-language-server
    yarn
    deno
    fzf
    exa
    neofetch

    python3
    python39Packages.pip # こうしないと pip が入らない
    neovim-remote

    lua53Packages.luacheck
    lua53Packages.luarocks

    # nightly をダウンロードするため、ここではインストールしない
    neovim
    stylua
    fd
    ripgrep
    bat
    jq

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

    php
    php80Packages.composer
    php80Packages.php-cs-fixer

    mysql80

    # ];
  ] ++ laptop_pkgs;

  home.file = {
    #   ".gitconfig".source = ./.gitconfig;
    #   ".config/nvim".source = ./.config/nvim;
    ".config/alacritty.yml".source = ../.config/alacritty.yml;
    ".vim".source = ./../.vim;
    ".gitconfig".source = ./../.gitconfig;
    ".local/bin".source = ../bin;

    # fcitx5 用の設定ファイル
    ".pam_environment".source = ./../.pam_environment;
    ".local/share/fcitx5/addon/hotkey-extension.conf".source = ./../fcitx5/addon/hotkey-extension.conf;
    ".local/share/fcitx5/lua/hotkey-extension/main.lua".source = ./../fcitx5/lua/hotkey-extension/main.lua;

    # xfce 用
    ".xinitrc".source = ./../.xinitrc;
    ".xprofile".source = ./../.xprofile;
  };
}
