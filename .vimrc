syn on
set smartindent
filetype plugin indent on

set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set tabstop=2
set shiftwidth=2

set background=dark
colorscheme gruvbox

set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let s:has_fugitive = exists('*fugitive#head')

set wildmode=longest:list
set wildmenu

set hlsearch
set incsearch

nnoremap <space>b :Unite buffer<cr>

" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

ALEEnable
