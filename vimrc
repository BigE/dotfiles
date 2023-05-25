set encoding=utf8
set ffs=unix,dos,mac

" Who doesn't use dark backgrounds in their terminals?..
set bg=dark

" Turn off backup since most stuff is version controlled anyway.
set nobackup
set nowb
set noswapfile

" Use tabs, why? because aliens.
set noexpandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Syntax highlighting default can vary by OS/distro.. let's ensure it's enabled
syntax enable

" Auto indent
set ai
set si
" I hate soft wraps
set nowrap
set number
set ruler
" Line numbers are on
set number
" Always show tabs
set showtabline=2

" I like it dark
colorscheme badwolf
let g:badwolf_darkgutter=1
let g:badwolf_tabline=2

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tt :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tn :tabnext<cr>
map <leader>tp :tabprev<cr>

set laststatus=2
set t_Co=256

" Powerline Config
if isdirectory("/usr/local/lib/python3.6/dist-packages/powerline/bindings/vim")
	" OS X - pip3 install powerline-status
	set rtp+=/usr/local/lib/python3.6/dist-packages/powerline/bindings/vim
elseif isdirectory("/usr/local/lib/python3.6/site-packages/powerline/bindings/vim")
	" Ubuntu - apt install powerline
	set rtp+=/usr/local/lib/python3.6/site-packages/powerline/bindings/vim
endif

" IndentGuides
let g:indent_guides_enable_on_vim_startup = 0

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if !empty(glob("~/.vimrc_local"))
	source ~/.vimrc_local
endif
