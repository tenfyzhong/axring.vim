"==============================================================
"    file: axring.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfyzhong@qq.com
" created: 2017-08-30 09:03:33
"==============================================================

if !has('nvim') && version < 701
    echom 'axring needs nvim or vim7.1'
    finish
endif

if exists('g:axring_version')
    finish
endif

let g:axring_version = '0.0.1'
lockvar g:axring_version

nnoremap <silent> <Plug>(axring#ctrl-a) :<c-u> call axring#switch("\<c-a>", v:count1)<cr>
nnoremap <silent> <Plug>(axring#ctrl-x) :<c-u> call axring#switch("\<c-x>", v:count1)<cr>

if !hasmapto("<Plug>(axring#ctrl-a)", 'n')
    silent! nmap <c-a> <Plug>(axring#ctrl-a)
endif
if !hasmapto("<Plug>(axring#ctrl-x)", 'n')
    silent! nmap <c-x> <Plug>(axring#ctrl-x)
endif

if !hlexists('axring_ring')
  highlight axring_ring term=bold cterm=bold ctermfg=Red guifg=Red
endif
