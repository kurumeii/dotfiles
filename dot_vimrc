set encoding=UTF-8
set nohlsearch
set number
set relativenumber
set breakindent
set smartcase
set ignorecase
set breakindent
set smartcase
set smartindent
set foldlevel=99
set foldlevelstart=99
set splitright
set splitbelow
set signcolumn=yes
set completeopt=menuone,noselect
set tabstop=2
set shiftwidth=2
set cursorline
set confirm
set formatoptions=jcroqlnt
set grepformat=%f:%l:%c:%m
set grepprg=rg
set scrolloff=5
set shortmess+=c " Don't show completion menu messages
set iskeyword+=- " Treat hyphenated words as whole words
set showmatch " show the matching part of pairs [] {} and ()
set laststatus=2 " Show status bar


let mapleader = ' '
let maplocalleader = '\\'

" Disable the spacebar key's default behavior in Normal and Visual modes
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Allow moving the cursor through wrapped lines with j, k
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" clear highlights
nnoremap <Esc> :noh<CR>

" save file
nnoremap <C-s> :w<CR>

" Navigate buffers
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Navigate between splits
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>

" Press jk fast to exit insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" Open file explorer
noremap <silent> <leader>e :Lex<CR>


syntax on
set background=dark
colorscheme retrobox
" Sync clipboard with OS
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

" True colors
set termguicolors

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25 
" Use 'l' instead of <CR> to open files
augroup netrw_setup | au!
    au FileType netrw nmap <buffer> l <CR>
augroup END
