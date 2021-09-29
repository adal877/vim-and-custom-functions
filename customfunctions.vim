"               All my functions!!
" ==================================================
" reload the config
"Reloads vimrc after saving but keep cursor position
if !exists('*ReloadVimrc')
   fun! ReloadVimrc()
       let save_cursor = getcurpos()
       source $MYVIMRC
       echom $MYVIMRC "reloaded!!"
       echom "customfunctions.vim reloaded!!"
       "set nu!
       call setpos('.', save_cursor)
   endfun
endif
autocmd! BufWritePost $MYVIMRC call ReloadVimrc()
autocmd! BufWritePost ~/.vim/plugged/custom-functions/plugin/customfunctions.vim call ReloadVimrc()

" directionals always scroll as in virtual lines
"setlocal wrap linebreak nolist
set virtualedit=
setlocal display+=lastline
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>

" Fix functions return type
function! UpFunc()
    :%s/^\(\(int\|float\|double\|long\)\_s.*\_s\{1,\}.*\_.\)}/\1\r    return 0;\r}/g
    :%s/^\(void\_s.*\_..*\)\_s\+return.*\_./\1\r}/g
endfunction!

function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

" A different :ls
command -bar -bang Ls call s:ls(<bang>0)

function s:ls(bang) abort
    let bufnrs = range(1, bufnr('$'))
    call filter(bufnrs, a:bang ? {_, v -> bufexists(v)} : {_, v -> buflisted(v)})
    let bufnames = copy(bufnrs)
        \ ->map({_, v -> bufname(v)->fnamemodify(':t')})
    let uniq_flags = copy(bufnames)->map({_, v -> count(bufnames, v) == 1})
    let items = map(bufnrs, {i, v -> #{
        \ bufnr: v,
        \ text: s:gettext(v, uniq_flags[i]),
        \ }})
    call setloclist(0, [], ' ', #{
        \ items: items,
        \ title: 'ls' .. (a:bang ? '!' : ''),
        \ quickfixtextfunc: 's:quickfixtextfunc',
        \ })
    lopen
    nmap <buffer><nowait><expr><silent> <cr> <sid>Cr()
endfunction

function s:Cr()
    if w:quickfix_title =~# '^ls!\=$'
        let locid = win_getid()
        return "\<c-w>\<cr>\<plug>(close-location-window)" .. locid .. "\<cr>\<plug>(verticalize)"
    else
        return "\<c-w>\<cr>\<plug>(verticalize)"
    endif
endfunction
nnoremap <plug>(close-location-window) :<c-u>call <sid>CloseLocationWindow()<cr>
nnoremap <plug>(verticalize) :<c-u>wincmd L<cr>
function s:CloseLocationWindow()
    let locid = input('')->str2nr()
    call win_execute(locid, 'close')
endfunction

function s:gettext(v, is_uniq) abort
    let format = ' %*d%s%s%s%s%s %s'
    let bufnr = [bufnr('$')->len(), a:v]
    let buflisted = !buflisted(a:v) ? 'u': ' '
    let cur_or_alt = a:v == bufnr('%') ? '%' : a:v == bufnr('#') ? '#' : ' '
    let active_or_hidden = win_findbuf(a:v)->empty() ? 'h' : 'a'
    let modifiable = getbufvar(a:v, '&ma', 0) ? ' ' : '-'
    let modified = getbufvar(a:v, '&mod', 0) ? '+' : ' '
    let bufname = bufname(a:v)->empty()
        \ ?  '[No Name]'
        \ :   bufname(a:v)->fnamemodify(a:is_uniq ? ':t' : ':p')
    return call('printf', [format]
        \ + bufnr
        \ + [buflisted, cur_or_alt, active_or_hidden, modifiable, modified, bufname])
endfunction

function s:quickfixtextfunc(info) abort
    let items = getloclist(a:info.winid, #{id : a:info.id, items : 1}).items
    let l = []
    for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
        call add(l, items[idx].text)
    endfor
    return l
endfunction

" Delete one or more buffer with the matching file type
function! s:DeleteBufferByExtension(ext)
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && bufname(v:val) =~ "\.'.a:ext.'$"')
  if empty(buffers) |throw "no *.".a:ext." buffer" | endif
  exe 'bd '.join(buffers, ' ')
endfunction

command! -nargs=1 DeleteBufferByExtension :call s:DeleteBufferByExtension(<f-args>)
" usage:
" :DeleteBufferByExtenfion html
" deletes all the buffers with html

"The following lets you type Ngb to jump to buffer number N (a number
"from 1 to 100). For example, typing 12gb would jump to buffer 12
"https://vim.fandom.com/wiki/Easier_buffer_switching#Listing_buffers.
let c = 1
while c <= 100
  execute "nnoremap " "silent" c . "gb :" . c . "b\<CR>"
  let c += 1
endwhile

" Circle between tabs
let t = 1
while t <= 100
  execute "map " "silent" t . "gt :" . t . "tabn\<CR>"
  let t += 1
endwhile

" Autocmd to remember last editing position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Vim statusline config
let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 's'  : 'Select',
       \ 'S'  : 'Sel',
       \ 'V'  : 'V·Line ',
       \ "\<C-V>" : 'V·Block ',
       \ 'i'  : 'INSERT ',
       \ 'R'  : 'Replace',
       \ 't'  : 'Terminal',
       \ 'Rv' : 'V·Replace ',
       \ 'c'  : 'Command ',
       \}

set laststatus=2
set statusline=
set statusline+=%<
" The number of actual buffer
set statusline+=\ [%n]
" take the mode
set statusline+=\ %{toupper(g:currentmode[mode()])}
set statusline+=\ %m\
" I dont know
set statusline+=%#PmenuSel#
" The number of the line
set statusline+=%#LineNr#
" The full path to the file
set statusline+=\ %F
" Switch to the right-aligment
set statusline+=%=
" Number of the cursor column
set statusline+=%#CursorColumn#
" Show the time. Just works while the cursor is moving...
"set statusline+=\ %{strftime('%H:%M:%S')}
set statusline+=\ %y
set statusline+=\ %p%%
set statusline+=\ <<
set statusline+=\ %l:%c
set statusline+=\ >>\%*
