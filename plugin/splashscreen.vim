" Init
let s:header = ''
let s:entries = {}
let s:proj =get(g:, 'splash_markspath' )

augroup splashscreen
  autocmd VimEnter * nested call s:init()
augroup END

function! s:init()
  if !argc() && (line2byte('$') == -1) && (v:progname =~? '^[-gmnq]\=vim\=x\=\%[\.exe]$')
    call splashscreen#screen()
  endif  
endfunction

function! splashscreen#screen() abort
  if &insertmode
    return
  endif 
  setlocal
    \ bufhidden=wipe
    \ buftype=nofile
    \ nobuflisted
    \ nocursorcolumn
    \ nocursorline
    \ nolist
    \ nonumber
    \ noswapfile
  if empty(&statusline)
    setlocal statusline=\ Welcome
  endif  
  if exists('g:splash_header')
    call append('$', g:splash_header)
    call append('$', '')
  endif    
  call append('$', ['   [+]  <Новый>', ''])
  call s:register(line('$'), '+', 'special', ':enew', '')
  call append('$', ['   [q]  <Выход>', ''])
  call s:register(line('$'), 'q', 'special', ':quit', '')
  call append('$', '') 
  if exists('g:splash_markspath')
    call splashscreen#projects()
  endif
  if exists('g:splash_footer')
    call append('$', g:splash_footer)
  endif	  
  setlocal nomodifiable nomodified

  set filetype=splashscreen
  call s:set_mappings()
  silent! doautocmd <nomodeline> User Startified
endfunction

function! s:register(line, index, type, cmd, path)
  let s:entries[a:line] = {
    \ 'index':  a:index,
    \ 'type':   a:type,
    \ 'cmd':    a:cmd,
    \ 'path':   a:path,
    \ 'marked': 0,
    \ }
endfunction

function! splashscreen#projects() abort
  let l:count = 0
  call append('$', 'Проекты:')
  call append('$', '')  
  for bookmark in readfile(s:proj)
    if strlen(bookmark)>2
      let l:splitstring = split(bookmark)  	    
      call append('$', ['   [' . l:count . ']  ' . bookmark,''])
      call s:register(line('$'), l:count, 'special', ':call splashscreen#launchproject("' . l:splitstring[0] . '")', '')
      let l:count = +1
    endif
  endfor    
endfunction       	

function! splashscreen#launchproject(projname)
  execute ':bd' 
  execute ':NERDTree '. a:projname
endfunction	

function! s:set_mappings() abort
  for k in keys(s:entries)
    execute 'nnoremap <buffer><silent>' s:entries[k].index s:entries[k].cmd '<CR>'
  endfor
endfunction  

command! -nargs=0 -bar Splashscreen enew | call splashscreen#screen()
