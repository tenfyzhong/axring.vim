#!/bin/bash -
set -e

export VIM_VERSION=7.4


if [[ "$VIM_NAME" == 'nvim' ]]; then
    if [[ "$TRAVIS_OS_NAME" == 'osx'  ]]; then
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
        tar xzf nvim-macos.tar.gz
    else
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update -y
        sudo apt-get install neovim -y
    fi
else
    wget https://codeload.github.com/vim/vim/tar.gz/v$VIM_VERSION
    tar xzf v$VIM_VERSION
    cd vim-$VIM_VERSION
    ./configure --prefix="$HOME/vim" \
        --enable-fail-if-missing \
        --with-features=huge
    make -j 2
    make install
fi

