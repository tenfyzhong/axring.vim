# axring.vim
[![Build Status](https://travis-ci.org/tenfyzhong/axring.vim.svg?branch=master)](https://travis-ci.org/tenfyzhong/axring.vim)
[![GitHub tag](https://img.shields.io/github/tag/tenfyzhong/axring.vim.svg)](https://github.com/tenfyzhong/axring.vim/tags)
[![doc](https://img.shields.io/badge/doc-%3Ah%20axring-yellow.svg?style=flat)](https://github.com/tenfyzhong/axring.vim/blob/master/doc/axring.txt)
![Vim Version](https://img.shields.io/badge/support-Vim%207.4%E2%86%91or%20NVIM-yellowgreen.svg?style=flat)


:ring: Enhance `<c-a>`, `<c-x>` ability to switch keywords. 


# Feature
1. `<c-a>` to select next word on the ring. 
1. `<c-x>` to select previous word on the ring. 
1. Echo the ring when select a word. 
1. Support [repeat.vim][]


# Screenshot
![axring](http://wx4.sinaimg.cn/mw690/69472223gy1fj2v43pj2cg20hs0a012m.gif)


# Install
I suggest you to use a plugin manager, such vim-plug or others.
- [vim-plug][]
```viml
Plug 'tenfyzhong/axring.vim'
```
- Manual
```
git clone https://github.com/tenfyzhong/axring.vim.git ~/.vim/bundle/axring.vim
echo 'set rtp+=~/.vim/bundle/axring.vim' >> ~/.vimrc
vim -c 'helptag ~/.vim/bundle/axring.vim/doc' -c qa!
```


# Example Configruation
```viml
let g:axring_rings = [
      \ ['&&', '||'],
      \ ['&', '|', '^'],
      \ ['&=', '|=', '^='],
      \ ['>>', '<<'],
      \ ['>>=', '<<='],
      \ ['==', '!='],
      \ ['>', '<', '>=', '<='],
      \ ['++', '--'],
      \ ['true', 'false'],
      \ ['verbose', 'debug', 'info', 'warn', 'error', 'fatal'], 
      \ ]

let g:axring_rings_go = [
      \ [':=', '='],
      \ ['byte', 'rune'],
      \ ['complex64', 'complex128'],
      \ ['int', 'int8', 'int16', 'int32', 'int64'],
      \ ['uint', 'uint8', 'uint16', 'uint32', 'uint64'],
      \ ['float32', 'float64'],
      \ ['interface', 'struct'],
      \ ]
```

# Usage
1. Configure option *g:axring_ring*
1. Edit a file.
1. Place you cursor on a word which is in the *g:axring_ring*
1. type `<c-a>` or `<c-x>`


[vim-plug]: https://github.com/junegunn/vim-plug
[repeat.vim]: https://github.com/tpope/vim-repeat
