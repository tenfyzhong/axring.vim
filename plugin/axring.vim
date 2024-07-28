"==============================================================
"    file: axring.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-08-30 09:03:33
"==============================================================

if !has('nvim') && version < 701
  echom 'axring needs nvim or vim7.1'
  finish
endif

if exists('g:axring_version')
  finish
endif

let save_cpo = &cpo
set cpo&vim

let g:axring_version = '0.1.0'
lockvar g:axring_version

nnoremap <silent> <Plug>(axring#ctrl-a) 
      \:<c-u> call axring#switch("\<c-a>")<cr>
nnoremap <silent> <Plug>(axring#ctrl-x) 
      \:<c-u> call axring#switch("\<c-x>")<cr>
nnoremap <silent> <Plug>(axring#echo_ring) 
      \:<c-u> call axring#echo_current_ring()<cr>

if !hasmapto("<Plug>(axring#ctrl-a)", 'n')
  silent! nmap <c-a> <Plug>(axring#ctrl-a)
endif
if !hasmapto("<Plug>(axring#ctrl-x)", 'n')
  silent! nmap <c-x> <Plug>(axring#ctrl-x)
endif

if !hlexists('axring_echo_current')
  highlight axring_echo_current term=undercurl ctermfg=Red guifg=Red
endif

let &cpo = save_cpo
