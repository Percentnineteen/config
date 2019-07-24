" Airline requires laststatus=2 to show the statusbar when there is only a single buffer open
set laststatus=2
" relativenumber shows linenumbers away from the current line
set relativenumber
" vim 7.4 and after, number+relativenumber shows the current line number instead of just 0
set number

" autoindent and smartindent handle rough indenting for formats which don't have syntax support
set autoindent
set smartindent

" showmatch shows the matching bracket briefly
set showmatch

" hlsearch highlights all matches
set hlsearch

" incsearch highlights as you type
set incsearch

" turn on filetype support
filetype plugin indent on
syntax enable
syntax on

" airline configuration of the tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#center_active = 1
let g:airline#extensions#tabline#show_splits = 0
"let g:airline#extensions#tabline#fnamemod = ':t'
" air-line
"let g:airline_powerline_fonts = 1

let s:has_fugitive = exists('*fugitive#head')

" xml syntax folding (as opposed to the default folding in the plugin)
let g:xml_syntax_folding=1
augroup xml
	autocmd!
	au FileType xml setlocal foldmethod=syntax
	au FileType xml let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
	" unmap the \F binding (collapse TagName)
	au FileType xml silent! nunmap <buffer> <LocalLeader>F
	" map \F to set foldlevel equal to that of the current line (fold lines which are under current line
	au FileType xml nmap <LocalLeader>F :let &foldlevel=foldlevel(line('.'))+0<CR>
	" similar but to fold current line
	au FileType xml silent! nunmap <buffer> <LocalLeader>f
	au FileType xml nmap <LocalLeader>f :let &foldlevel=foldlevel(line('.'))-1<CR>

	" Modifying the xml syntax support to match the closing comment issue
	au FileType xml syn clear xmlRegion
	au FileType xml syn region xmlRegion start=+<\z([^ /!?<>"']\+\)+ skip=+<!--\_.\{-}-->+ end=+</\z1\_\s\{-}>+ matchgroup=xmlEndTag end=+/>+ fold contains=xmlTag,xmlEndTag,xmlCdata,xmlRegion,xmlComment,xmlEntity,xmlProcessing,xmlRegionError,@xmlRegionHook,@Spell keepend extend
	au FileType xml syn match xmlRegionError "-->"
	au FileType xml hi link xmlRegionError Error
augroup END

" F2 will toggle paste, relative number, number - useful for mouse-select
map <F2> :set paste! norelativenumber! nonumber!<CR>

"map <F7> :set background=light<CR>
"map <S-F7> :set background=dark<CR>

"map ctrl+h/j/k/l to move left, down, up, right across splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"kj and jk will map to escape from insert mode (avoid stretching to <ESC> key)
imap jk <ESC>
imap kj <ESC>

" color scheme setup
let g:molokai_original = 1
let g:rehash256 = 1
"set t_Co=256
set background=dark
colorscheme gruvbox

" tab display changed to 2 spaces
set tabstop=2
set shiftwidth=2

" max number of files to open in tabs
set tabpagemax=800

" tell vimdiff to ignore whitespace
"set diffopt+=iwhite

" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" when we reload, tell vim to restore the cursor to the saved position
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

" Works like sort(), optionally taking in a comparator (just like the
" original), except that duplicate entries will be removed.
function! SortUnique( list, ... )
  let dictionary = {}
  for i in a:list
    execute "let dictionary[ '" . i . "' ] = ''"
  endfor
  let result = []
  if ( exists( 'a:1' ) )
    let result = sort( keys( dictionary ), a:1 )
  else
    let result = sort( keys( dictionary ) )
  endif
  return result
endfunction

"select math equation in visual mode and type ;bc<CR> to compute the result
vnoremap ;bc "ey:call CalcBC()
function! CalcBC()
  let has_equal = 0
  " remove newlines and trailing spaces
  let @e = substitute (@e, "\n", "", "g")
  let @e = substitute (@e, '\s*$', "", "g")
  " if we end with an equal, strip, and remember for output
  if @e =~ "=$"
    let @e = substitute (@e, '=$', "", "")
    let has_equal = 1
  endif
  " sub common func names for bc equivalent
  let @e = substitute (@e, '\csin\s*(', "s (", "")
  let @e = substitute (@e, '\ccos\s*(', "c (", "")
  let @e = substitute (@e, '\catan\s*(', "a (", "")
  let @e = substitute (@e, "\cln\s*(", "l (", "")
  " escape chars for shell
  let @e = escape (@e, '*()')
  " run bc, strip newline
  let answer = substitute (system ("echo " . @e . " \| bc -l"), "\n", "", "")
  " append answer or echo
  if has_equal == 1
    normal `>
    exec "normal a" . answer
  else
    echo "answer = " . answer
  endif
endfunction

" <F10> will show the highlight style in the syntax
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

set list
set listchars=tab:»\ ,trail:·

set wildmode=longest:list
set wildmenu

nnoremap <space>b :Unite buffer<cr>
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

ALEEnable
