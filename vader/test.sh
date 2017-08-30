#!/bin/bash -
set -e

if [ -z "$VIM_BUNDLE_PATH" ]; then
    export VIM_BUNDLE_PATH=~/.vim/bundle
fi

vim -Nu <(cat << VIMRC
filetype off
set rtp+=$VIM_BUNDLE_PATH/vader.vim
set rtp+=$VIM_BUNDLE_PATH/axring.vim
filetype plugin indent on
syntax enable
VIMRC) -c "Vader! $VIM_BUNDLE_PATH/axring.vim/vader/*.vader" > /dev/null
