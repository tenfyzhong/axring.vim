"==============================================================
"  file: axring.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
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
  let border = '\m\w\|\s\|[;()\[\]{}"''`]'
  while begin_i >= 0 && a:content[begin_i] !~? border
    let begin_i -= 1
  endwhile
  let begin_i += 1

  let end_i = a:col
  let content_len = len(a:content)
  while end_i < content_len && a:content[end_i] !~? border
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

function! s:echo_ring(ring, current) abort "{{{
  let [echos, highlight_i] = 
        \axring#echo_ring_items(a:ring, a:current, winwidth(winnr()))
  echon '['
  let i = 0
  for item in echos
    if i != 0
      echon ', '
    endif
    if i == highlight_i
      echohl axring_echo_current
      echon echos[i]
      echohl None
    else
      echon echos[i]
    endif
    let i += 1
  endfor
  echon ']'
endfunction "}}}

function! axring#get_word() abort "{{{
  let lnum = line('.')
  let content = getline(lnum)

  let word_pos = 0
  let word_len = 0
  let col = col('.')
  if content[col-1] =~? '\m\s'
    let word = ''
  elseif content[col-1] =~? '\m\k'
    let [word, word_pos, word_len] =
          \<SID>get_word_by_keyword(content, col)
  else
    let [word, word_pos, word_len] = 
          \<SID>get_word_by_punctuation(content, col)
  endif
  return [word, word_pos, word_len]
  " echom printf('word: %s, pos: %d, len: %d', word, word_pos, word_len)
endfunction "}}}

function! axring#get_ring(word, filetype) abort "{{{
  let global = get(g:, 'axring_rings', [])
  let local = get(g:, 'axring_rings_'.a:filetype, [])
  let rings = local + global

  if a:word != ''
    for ring in rings
      let i = 0
      let ring_len = len(ring)
      while i < ring_len
        if a:word ==? ring[i]
          return [ring, i]
        endif
        let i += 1
      endwhile
    endfor
  endif
  return [[], -1]
endfunction "}}}

function! axring#echo_current_ring() abort "{{{
  let [word, _, _] = axring#get_word()
  let [ring, current] = axring#get_ring(word, &filetype)
  if !empty(ring) && current != -1
    call <SID>echo_ring(ring, current)
  endif
endfunction "}}}

function! axring#echo_ring_items(ring, current, max_width) abort "{{{
  " echom string(a:ring)
  let ring_len = len(a:ring)
  if a:current >= ring_len
    return []
  endif

  let add_index = get(g:, 'axring_echo_index', 1)


  let text = a:ring[a:current]
  if add_index
    let text = '0:' . text
  endif

  let prefix = '['
  let postfix = ']'

  let wrap_prefix = '..'
  let wrap_postfix = '..'

  let max_len = a:max_width - 
        \len(prefix) - 
        \len(postfix) -  
        \len(wrap_prefix . ', ') - 
        \len(', ' . wrap_postfix)
  let right_i = a:current + 1
  let left_i = a:current - 1
  let highlight_i = 0

  let current_len = len(text)
  if current_len >= max_len
    return [[], -1]
  endif

  let result = [text]


  while right_i < ring_len && left_i >= 0 && current_len < max_len
    let text = a:ring[right_i]
    if add_index 
        let text = printf('%d:%s', right_i-a:current, text)
    endif
    let right_len = len(text)
    if current_len + right_len + 2 > max_len
      break
    endif
    let current_len += right_len + 2
    call add(result, text)
    let right_i += 1

    let text = a:ring[left_i]
    if add_index
        let text = printf('%d:%s', a:current-left_i, text)
    endif
    let left_len = len(text)
    if current_len + left_len + 2 > max_len
      break
    endif
    let current_len += left_len + 2
    call insert(result, text)
    let left_i -= 1
    let highlight_i += 1
  endwhile

  while current_len < max_len && right_i < ring_len
    let text = a:ring[right_i]
    if add_index
      let text = printf('%d:%s', right_i-a:current, text)
    endif
    let right_len = len(text)
    if current_len + right_len + 2 > max_len
      break
    endif
    let current_len += right_len + 2
    call add(result, text)
    let right_i += 1
  endwhile

  while current_len < max_len && left_i >= 0
    let text = a:ring[left_i]
    if add_index
      let text = printf('%d:%s', a:current-left_i, text)
    endif
    let left_len = len(text)
    if current_len + left_len + 2 > max_len
      break
    endif
    let current_len += left_len + 2
    call insert(result, text)
    let left_i -= 1
    let highlight_i += 1
  endwhile

  if right_i < ring_len
    call add(result, wrap_postfix)
  endif

  if left_i >= 0
    call insert(result, wrap_prefix)
    let highlight_i += 1
  endif

  return [result, highlight_i]
endfunction "}}} 

function! axring#switch(key, count) abort "{{{
  let t1 = reltimefloat(reltime())
  let feedkeys = a:key

  let [word, word_pos, word_len] = axring#get_word()

  let [ring, current] = axring#get_ring(word, &filetype)

  if !empty(ring) && current != -1
    let direction = a:key ==# "\<c-a>" ? 1 : -1

    let ring_len = len(ring)

    let next_i = (current+ring_len+a:count*direction)%ring_len
    let next_word = ring[next_i]
    let next_word = <SID>sync_case(word, next_word)
    let lnum = line('.')
    call cursor(lnum, word_pos)
    let store_a = @a
    let @a = next_word
    let cmd = printf('silent! normal! "_d%dl"aP', word_len)
    exec cmd
    let @a = store_a
    let t2 = reltimefloat(reltime())
    echom printf('time cost %f', t2 - t1)
    if get(g:, 'axring_echo', 1)
      call <SID>echo_ring(ring, next_i)
    endif
  else
    exec 'silent! normal! '.a:count.feedkeys
  endif

endfunction "}}}
