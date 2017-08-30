"==============================================================
"  file: axring.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfyzhong@qq.com
" created: 2017-08-30 09:10:37
"==============================================================

function! s:sync_case(from, to) abort "{{{ sync case from `from` to `to`
  " from    to
  " true    false
  " True    False
  " TRUE    FALSE
  if a:from =~# '\m^[^a-z]*$'
    return toupper(a:to)
  elseif a:from[0] =~# '\m\W*[A-Z][^A-Z]*'
    return substitute(a:to, '\m\(\W*\)\(.*\)', '\1\u\2', '')
  else
    return tolower(a:to)
  endif
endfunction "}}}

function! s:get_word_by_punctuation(content, col) abort "{{{
  let begin_i = a:col-1
  while begin_i >= 0 && a:content[begin_i] !~? '\m\w\|\s\|[;()\[\]{}]'
    let begin_i -= 1
  endwhile
  let begin_i += 1

  let end_i = a:col
  let content_len = len(a:content)
  while end_i < content_len && a:content[end_i] !~? '\m\w\|\s\|[;()\[\]{}]'
    let end_i += 1
  endwhile
  let end_i -= 1

  return [a:content[begin_i : end_i], begin_i+1, end_i-begin_i+1]
endfunction "}}}

function! s:get_word_by_keyword(content, col) abort "{{{
  let begin_i = a:col-1
  while begin_i >= 0 && a:content[begin_i] =~? '\m\k'
    let begin_i -= 1
  endwhile
  let begin_i += 1

  let end_i = a:col
  let content_len = len(a:content)
  while end_i < content_len && a:content[end_i] =~? '\m\k'
    let end_i += 1
  endwhile
  let end_i -= 1

  return [a:content[begin_i : end_i], begin_i+1, end_i-begin_i+1]
endfunction "}}}

function! axring#switch(key, count) abort "{{{
  let global = get(g:, 'axring_rings', [])
  let local = get(b:, 'axring_rings', [])
  let rings = local + global

  let lnum = line('.')
  let content = getline(lnum)
  let col = col('.')
  let word = ''
  let delete_pos = 0
  let delete_len = 0
  if content[col-1] =~? '\m\s'
    let word = ''
  elseif content[col-1] =~? '\m\k'
    " let word = expand('<cword>')
    let [word, delete_pos, delete_len] =
          \<SID>get_word_by_keyword(content, col)
  else
    let [word, delete_pos, delete_len] = 
          \<SID>get_word_by_punctuation(content, col)
  endif
  " echom printf('word: %s, pos: %d, len: %d', word, delete_pos, delete_len)

  let repeat = printf(":silent! call repeat#set(\"%s\", %d)\<cr>",
        \ a:key,
        \ a:count)

  let feedkeys = a:key

  let direction = a:key ==# "\<c-a>" ? 1 : -1

  if word != ''
    for ring in rings
      let i = 0
      let ring_len = len(ring)
      while i < ring_len
        if word ==? ring[i]
          let next_word = ring[(i+ring_len+a:count*direction)%ring_len]
          let next_word = <SID>sync_case(word, next_word)
          call cursor(lnum, delete_pos)
          let feedkeys = printf(
                \ "\"_c%dl%s\<esc>", delete_len, next_word)
          " echom 'keys:'.feedkeys.repeat
          exec 'silent! normal! '.feedkeys.repeat
          return
        endif
        let i += 1
      endwhile
    endfor
  endif

  exec 'silent! normal! '.feedkeys.repeat
endfunction "}}}
