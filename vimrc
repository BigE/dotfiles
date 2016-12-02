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

set ai
set si
set nowrap
set number
set ruler

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext
