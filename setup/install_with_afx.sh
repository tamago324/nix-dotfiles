#!/bin/bash

GHQ_ROOT=$HOME/ghq
VIMFILES_PATH=${GHQ_ROOT}/github.com/tamago324/vimfiles
DOT_FILES_PATH=$HOME/dotfiles
ZSH_COMPLETION_DIR=${HOME}/.config/zsh/comp

# nix-dotfiles をダウンロードして、nixpkgs を配置する
fetch_dotfiles() {
    git clone https://github.com/tamago324/nix-dotfiles ${DOT_FILES_PATH}
    cd ${DOT_FILES_PATH}/nixpkgs
    mkdir -p ~/.config
    # 強制的に作成する (home-manager をインストールすると、~/.config/nixpkgs が作成されてしまうため)
    rm -rf $HOME/.config/nixpkgs
    ln -s $(pwd) $HOME/.config/nixpkgs
}

setup_vimfiles() {
    git clone https://github.com/tamago324/vimfiles ${VIMFILES_PATH}
    ln -s ${VIMFILES_PATH} $HOME/.config/nvim
}

# neovim でクリップボードを使えるようにする
# https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
setup_win32yank() {
    curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
    unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
    chmod +x /tmp/win32yank.exe
    mkdir -p $HOME/.local/bin
    mv /tmp/win32yank.exe ~/.local/bin
}

# setup_completion() {
#   echo '補完スクリプトを生成'
#   mkdir -p ${ZSH_COMPLETION_DIR}
# 
#   # 連想配列
#   # キーがコマンドのチェックで、値がスクリプトを生成するためのコマンド
#   # なんかうまくできなかった
#   declare -A commands=(
#     [pip]='pip completion --zsh > ${ZSH_COMPLETION_DIR}/_pip'
#     [cht.sh]='curl https://cheat.sh/:zsh > ${ZSH_COMPLETION_DIR}/_cht'
#   )
# 
#   # キーでループする
#   for cmd in ${!commands[@]}
#   do
#     # 実行できるなら、生成する
#     if [[ -n `which ${cmd}` ]]; then
#       echo "${cmd} : ${commands[${cmd}]}"
#       # eval を使うと、文字列のコマンドを実行できる
#       eval ${commands[${cmd}]}
#     else
#       echo "Not found ${cmd}"
#     fi
#   done
# }

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

    # dotfiles がなければダウンロードする
    if [ ! -d ${DOT_FILES_PATH} ]; then
        fetch_dotfiles
    fi

    if [ ! -d ${VIMFILES_PATH} ]; then
        setup_vimfiles
    fi

    # WSLなら、win32yank.exeをダウンロードする
    if [ -d /run/WSL ]; then
      if [ -e $HOME/.local/bin/win32yank.exe ]; then
          setup_win32yank
      fi
    fi

    # setup_completion

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
        sudo chsh -s ${zshpath} $USER
    fi
}

setup

