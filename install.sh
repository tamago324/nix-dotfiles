#!/bin/bash

DOT_FILES_PATH=$HOME/dotfiles

# nix をセットアップ
setup_channel() {
    added=0

    # チャネルが追加されていなければ追加する
    nix-channel --list | grep -e '^nixpkgs https://nixos.org/channels/nixpkgs-unstable$' > /dev/null
    if [ $? ]; then
        nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
        added=1
    fi

    nix-channel --list | grep "^home-manager https://github.com/nix-community/home-manager/archive/master.tar.gz$" > /dev/null
    if [ $? ]; then
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        added=1
    fi

    if [ ${added} -eq 1 ]; then
        nix-channel --update
    fi
}

# home-manager をインストール
install_home_manager() {
    nix-shell '<home-manager>' -A install
}

# nix-dotfiles をダウンロードして、nixpkgs を配置する
fetch_dotfiles() {
    git clone https://github.com/tamago324/nix-dotfiles ${DOT_FILES_PATH}
    cd ${DOT_FILES_PATH}/nixpkgs
    mkdir -p ~/.config
    ln -s $(pwd) ~/.config/nixpkgs
}

setup() {
    if [ -z $(which nix) ]; then
        echo 'Not installed `nix` command.'
        echo
        echo 'Please install:'
        echo
        echo '  https://nix.dev/tutorials/install-nix'
        echo
        exit 1
    fi
    
    setup_channel

    if [ -z $(which home-manager) ]; then
        install_home_manager
    fi

    # dotfiles がなければダウンロードする
    if [ ! -d ${DOT_FILES_PATH} ]; then
        fetch_dotfiles
    fi

    # セットアップを実行
    home-manager switch

    # シェルがzshではない場合、変更する
    #   正規表現のマッチ: https://qiita.com/Linda_pp/items/31fa611766598715a172
    if ! expr ${SHELL} : "zsh$" > /dev/null; then
        # ログインシェルに追加する
        #   https://unix.stackexchange.com/questions/111365/how-to-change-default-shell-to-zsh-chsh-says-invalid-shell
        zshpath=$HOME/.nix-profile/bin/zsh
        sudo cat /etc/shells | grep ${zshpath} > /dev/null
        if [ $? ]; then
            echo ${zshpath} | sudo tee -a /etc/shells
        fi
        chsh -s ${zshpath}
    fi
}

setup

