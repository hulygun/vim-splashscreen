if exists('g:autoloaded_splashscreen') || &compatible
    finish
endif
let g:autoloaded_splashscreen = 1

"Init values
let s:header = get(g:, 'splashscreen_header', '')
let s:bookmarks_path = get(g:, 'splashscreen_bookmarks_path', '')

function! s:register(line, index, type, cmd, path)
    let s:entries[a:line] = {
      \ 'index':  a:index,
      \ 'type':   a:type,
      \ 'cmd':    a:cmd,
      \ 'path':   a:path,
      \ 'marked': 0,
  \ }
endfunction

function! s:get_header()
    if exists('s:header')
        call append('$', g:splashscreen_header)
endfunction
