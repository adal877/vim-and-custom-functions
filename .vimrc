" Global mapleader
let g:mapleader=','

" Toggle ctag window
map <silent> <CR> <ESC>:TagbarToggle<CR>

"open the tagbar window to 20 percent of
"the window width with a limit of no less than 25 characters
"let g:tagbar_width = max([25, winwidth(0) / 5])
let g:tagbar_width = max([28, winwidth(0) / 5])

" Start vimwiki at the start of vim
augroup on-vim-startup
    autocmd BufNewFile shnt VimwikiIndex
    autocmd BufNewFile shnt tabnew +e ~/vimwiki/Todo.wiki
augroup END

autocmd BufReadPost ~/vimwiki/Todo.wiki zM

augroup c-cpp-files
    autocmd FileType *.c,*.cpp,*.rs,*.sh Tagbar
augroup END

" keeps the cursor at the middle of the screen while scrolling
"set so=999
augroup VCenterCursor
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
augroup END

"autocmd BufCreate,BufAdd,BufNew,BufUnload * set nu!

" ======================================================
" Install plugins
" ======================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
" Plugins here !!!!
" ======================================================
Plug '~/.vim/plugged/custom-functions'
Plug 'vimwiki/vimwiki'
Plug 'majutsushi/tagbar'
"Plug 'oblitum/youcompleteme'
"Plug 'itchyny/calendar.vim'
" ======================================================
call plug#end()
" ======================================================

" Custom header for startify
" let g:startify_custom_header =
"            \ startify#pad(split(system('fortune | cowsay'), '\n'))
"let g:startify_custom_header = [
    "            \ 'MMP"""""".MM       dP          dP .d888b. d88888P d88888P',
    "            \ 'M` .mmmm  MM       88          88 Y8` `8P     d8`     d8`',
    "            \ 'M         `M .d888b88 .d8888b. 88 d8bad8b    d8`     d8` ',
    "            \ 'M  MMMMM  MM 88`  `88 88`  `88 88 88` `88   d8`     d8`  ',
    "            \ 'M  MMMMM  MM 88.  .88 88.  .88 88 8b. .88  d8`     d8`   ',
    "            \ 'M  MMMMM  MM `88888P8 `88888P8 dP Y88888P d8`     d8`    ',
    "            \ 'MMMMMMMMMMMM                                             ',
    "            \ ]

" Quick mapping to put \(\) in pattern string
cmap ;\ \(\)<Left><Left>

" Editing a protected file as 'sudo'
cmap W w !sudo tee % >/dev/null<CR>

" editing shortcuts

" when press gf vim changes to the new path
nnoremap gf :tabnew +e <cfile><CR>

" daw delete the word under the cursor
" dib delete everything inside the () except the () it self
inoremap <silent> <leader>di <ESC> dibi
" Use this to delete a block of function
" a.k.a:
" function foo() {
"       //code
"  }
inoremap <silent> <leader>da <ESC> dapi

" jump to the closing ) ] } " ' ` and >
map <silent> <leader>f <ESC>/)<CR>i
map <silent> <leader>h <ESC>/]<CR>i
map <silent> <leader>n <ESC>/}<CR>i
map <silent> <leader>t <ESC>/"<CR>i
map <silent> <leader>a <ESC>/'<CR>i
map <silent> <leader>e <ESC>/`<CR>i
map <silent> <leader>i <ESC>/><CR>i

" Insert a blank line below or above current line (do not move the cursor),
" see https://stackoverflow.com/a/16136133/6064933
nnoremap <expr> oo printf('m`%so<ESC>``', v:count1)
nnoremap <expr> OO printf('m`%sO<ESC>``', v:count1)

" :DeleteBufferByExtenfion html
" deletes all the buffers with html
map <C-a> <esc>:DeleteBufferByExtension 

" Opens the Netrw file browser on the current path
nnoremap <silent> <leader>nb :e ./ <CR>
" 'cd' towards the directory in which the current file is edited
" but only change the path for the current window
nnoremap <silent> <leader>cd :lcd %:h<CR>
" Move the current tab to [number] position
nnoremap <leader>tm :tabmove 
" Create a new tab
nnoremap <silent> <leader>tn :tabnew <CR>
" Goes to the next tab (goes to the right)
nnoremap <silent> <leader>n :tabnext <CR>
" Goes to the previus tab (goes to the left)
nnoremap <silent> <leader>p :tabprevious <CR>
" Open files located in the same dir in wich the current file is edited
nnoremap <leader>e :e <C-R>=expand("%:.:h") . "/"<CR>
" The sam as above but open a vertical buffer instead of a whole new tab
nnoremap <leader>ev :vsp +e <C-R>=expand("%:.:h") . "/"<CR>
" next buffer
nnoremap <leader>bn :bnext<CR>
" previous buffer
nnoremap <leader>bp :bprevious<CR>
" open the splited buffer in full[screentab] mode
nnoremap <silent> <leader>f :wincmd o<CR>

" close all the windows except the current one
nnoremap <silent> <leader>o :only<CR>
" close all the tabs exçept the current one
nnoremap <silent> <leader>oy :tabonly<CR>

" Circle between splited screens
" <C-w>[directionals] to switch between splits
" :h wincmd
map <silent> <leader>l <C-W><Left>
map <silent> <leader>d <C-W><Down>
map <silent> <leader>u <C-W><Up>
map <silent> <leader>r <C-W><Right>

" Increase/decrease by 5 the size of the actual buffer
nnoremap <silent> + <esc>:vertical res +5<CR>
nnoremap <silent> - <esc>:vertical res -5<CR>
" by default res works to horizontal buffers
nnoremap <silent> h+ <esc>:res +5<CR>
nnoremap <silent> h- <esc>:res -5<CR>

" Start visual with Shift-[directionals] (or home and end)
noremap <silent> <S-Left> <Left>
noremap <silent> <S-Right> <Right>
noremap <silent> <S-Right> v<Right>
noremap <silent> <S-Left> v<Left>
noremap <silent> <S-home> v^
noremap <silent> <S-end> v$

" For visual
vmap <silent> <S-Left> <Left>
vmap <silent> <S-Right> <Right>

" for insert
imap <silent> <S-Right> <ESC> <Right>
imap <silent> <S-Right> <ESC> v<Right>
imap <silent> <S-Left> <ESC> v<Left>
imap <silent> <S-home> <ESC> v^
imap <silent> <S-end> <ESC> v$

" Enable copy, cut, paste
" copy
nnoremap <silent> y "+y
nnoremap <silent> Y "+Y

" paste
nnoremap <silent> P "+P
nnoremap <silent> p "+p
imap <silent> <C-v> <ESC>"+Pi

" Paste non-linewise text above or below current cursor,
" see https://stackoverflow.com/a/1346777/6064933
nnoremap <silent> <leader> "+p m`o<ESC>p``
nnoremap <silent> <leader> "+P m`O<ESC>p``

" delete the focused buffer or tab (bd to delete the buffer)
map <silent> <C-d> <ESC>:q <CR>

" Keep the cursor centered while scrolling
nnoremap <Down> jzz
nnoremap <Up> kzz

" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv

" Move visual blocks
" (with Up and Down too)
" goes up
vnoremap <silent> <S-h> :m '>+1<CR>gv=gv
" goes down
vnoremap <silent> <S-t> :m '<-2<CR>gv=gv

" Moving text/lines in insert mode
inoremap <silent> <C-j> <ESC>:m .+1<CR>==i
inoremap <silent> <C-k> <ESC>:m .-2<CR>==i
" Move text/lines in normal modes
nnoremap <silent> J :m .+1<CR>==
nnoremap <silent> K :m .-2<CR>==

" Move the cursor based on physical lines, not the actual lines.
" Virtually insert one column at the end of the line and applies 
" this behavier on all modes.
" usefull for visual-block mode selection.
set virtualedit=onemore,block
set display+=lastline
noremap <silent> <Up>   gk
noremap <silent> <Down> gj
noremap <silent> <Home> g<Home>
noremap <silent> <End>  g<End>
inoremap <silent> <Up>   <C-o>gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Home> <C-o>g<Home>
inoremap <silent> <End>  <C-o>g<End>

" Decrease/increase indent level in insert mode with shift+tab and Ctrl-Tab
inoremap <silent> <S-Tab> <ESC><<i
inoremap <silent> <C-Tab> <ESC>>>i

" alternate between buffers from 1 to 10 using [some character]b
nnoremap <silent> (b :b 1<CR>
nnoremap <silent> )b :b 2<CR>
nnoremap <silent> }b :b 3<CR>
nnoremap <silent> $b :b 4<CR>
nnoremap <silent> {b :b 5<CR>
nnoremap <silent> ]b :b 6<CR>
nnoremap <silent> [b :b 7<CR>
nnoremap <silent> !b :b 8<CR>
nnoremap <silent> =b :b 9<CR>
nnoremap <silent> *b :b 10<CR>

nnoremap <silent> 1b :b 1<CR>
nnoremap <silent> 2b :b 2<CR>
nnoremap <silent> 3b :b 3<CR>
nnoremap <silent> 4b :b 4<CR>
nnoremap <silent> 5b :b 5<CR>
nnoremap <silent> 6b :b 6<CR>
nnoremap <silent> 7b :b 7<CR>
nnoremap <silent> 8b :b 8<CR>
nnoremap <silent> 9b :b 9<CR>
nnoremap <silent> 0b :b 10<CR>

" Go to the path with name of the word below the cursor
set path+=**

" General config
colorscheme challenger_deep
"set nu!
"Enable mouse for normal and terminal modes
set mouse=n
" change the size of the number column (just the left side)
set numberwidth=5
" instead of to put the cursor on the first/last line to scroll
" put it on the first 10 and last 10 lines
"set scrolloff=10
set wrap
" disable VI compatibility
set nocompatible
" change the path based on the file path
set autochdir
set list lcs=trail:-,tab:\┊-
set cursorcolumn
set cursorline
set incsearch
set clipboard=unnamedplus
set smartcase
set ignorecase
filetype plugin indent on
syntax enable
set completeopt+=preview
set guioptions-=L
" do not let to close the buffer without confirm
set confirm
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<Tab>
set showmatch
set expandtab
set shiftwidth=4
"a <Tab> in front of a line inserts blanks according to
" 'shiftwidth'.  'tabstop' or 'softtabstop' is used in other places 
set smarttab
set tabstop=4
set autoindent
set smartindent
set nolazyredraw
" Auto close (, [, {
imap { {}<left>
imap [ []<left>
imap ( ()<left>
"set list lcs=tab:\|\|

" Disable swap
set noswapfile

" Fold method
set foldmethod=indent
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>") <CR>
" Unfold all the folds
nnoremap <silent> <leader>s zR
" refold all the folds
nnoremap <silent> <leader>ns zM

" Compile and run C, Cpp, Rust and bash files
map <C-c> <ESC>:! clear && comp % <CR>

" Abbrevs for commands
cab W! <ESC>:w!
cab Wq! <ESC>:wq!
cab wQ! <ESC>:wq!
cab wQ! <ESC>:wq!
cab Q!  <ESC>:q!
" Disabled to use :W to edit the current file as sudo permissinos
"cab W <ESC>:w
cab Wq <ESC>:wq
cab wQ <ESC>:wq
cab WQ <ESC>:wq
cab Q  <ESC>:q
cab WQA <ESC>:wqa
cab Wqa <ESC>:wqa
cab waq <ESC>:wqa
